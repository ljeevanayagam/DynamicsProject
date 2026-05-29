codeunit 60001 "Work Order Posting Mgt"
{
    procedure PostWorkOrder(var WorkOrder: Record "Work Order Header")
    var
        ItemJnlLine: Record "Item Journal Line";
        MaterialLine: Record "Work Order Material Line";
        SupplyLine: Record "Work Order Supply Line";
        Complete: Record "Completed Work Order";
        ProRelForm: Record "Product Release Item";
        LineNo: Integer;
        PostQty: Decimal;
        ItemRec: Record Item;
        VendorRec: Record Vendor;
        OutputBin: Code[20];
    begin
        if (WorkOrder."Routing No." = 'PRINTLABEL') then begin
            WorkOrder."Print Label Status" :=
                WorkOrder."Print Label Status"::Completed;

            WorkOrder."Submitted" := true;
            WorkOrder.Modify(true);
            exit;
        end;
        // 🔒 Basic validations
        if WorkOrder."No." = '' then
            Error('Work Order No. is required.');

        if WorkOrder."Lot Quantity" <= 0 then
            Error('Lot Quantity must be greater than 0.');

        if WorkOrder."Product Part Number" = '' then
            Error('Finished good Item No. is required.');

        // 🔥 Determine output quantity (ONLY rule source)
        if WorkOrder."Requires Product Release" then
            PostQty := ValidateQA(WorkOrder)
        else
            PostQty := WorkOrder."Quantity for Processing";
        if Complete.Get(WorkOrder."No.") then
            Error('Completed Work Order already exists.');
        LineNo := 10000;
        if WorkOrder."Requires Product Release" then
            OutputBin := 'FG-01'
        else
            OutputBin := 'PROD-01';
        // -------------------------
        // CONSUMPTION - MATERIALS
        // -------------------------

        MaterialLine.SetRange("Work Order No.", WorkOrder."No.");
        if MaterialLine.FindSet() then
            repeat
                CreateJournalLine(
                    ItemJnlLine,
                    LineNo,
                    MaterialLine."Item No.",
                    -MaterialLine."Calculated Quantity",
                    'PROD-01',
                    WorkOrder);

                LineNo += 10000;
            until MaterialLine.Next() = 0;

        // -------------------------
        // CONSUMPTION - SUPPLIES
        // -------------------------
        SupplyLine.SetRange("Work Order No.", WorkOrder."No.");
        if SupplyLine.FindSet() then
            repeat
                CreateJournalLine(
                    ItemJnlLine,
                    LineNo,
                    SupplyLine."Item No.",
                    -SupplyLine."Unit Quantity",
                    'PROD-01',
                    WorkOrder);

                LineNo += 10000;
            until SupplyLine.Next() = 0;

        // -------------------------
        // OUTPUT - FINISHED GOODS
        // -------------------------
        CreateJournalLine(
            ItemJnlLine,
            LineNo,
            WorkOrder."Product Part Number",
            PostQty,
            OutputBin,
            WorkOrder);

        // 🚀 POST JOURNAL
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
        ItemJnlLine.SetRange("Journal Batch Name", 'WORKORDER');
        Codeunit.Run(Codeunit::"Item Jnl.-Post", ItemJnlLine);

        // ===============================
        // ✅ CREATE COMPLETED WORK ORDER
        // ===============================

        // ===============================
        // ✅ CREATE COMPLETED WORK ORDER (HEADER ONLY)
        // ===============================
        if not Complete.Get(WorkOrder."No.") then begin
            Complete.Init();
            Complete."No." := WorkOrder."No.";
            Complete."Work Order No." := WorkOrder."No.";
            Complete.Status := Complete.Status::Completed;
            Complete."Completed Date" := DT2Date(CurrentDateTime);

            Complete."Requires Product Release" := WorkOrder."Requires Product Release";
            Complete."Product Part Number" := WorkOrder."Product Part Number";
            Complete."Product Description" := WorkOrder."Product Description";
            Complete.Revision := WorkOrder.Revision;
            Complete."Storage Condition" := WorkOrder."Storage Condition";
            Complete."Date of Manufacture" := WorkOrder."Date of Manufacture";
            Complete."Expiration Date" := WorkOrder."Expiration Date";
            Complete."Data Entered By" := WorkOrder."Data Entered By";
            Complete."GTIN-14, Container" := WorkOrder."GTIN-14, Container";
            Complete."GTIN-14, Carton" := WorkOrder."GTIN-14, Carton";
            Complete."Lot Quantity" := WorkOrder."Lot Quantity";

            Complete."Quantity Actually Used" := 0; // 🔥 will be updated by runs

            Complete.Insert(true);
        end;

        // ===============================
        // ❌ REMOVE FROM ACTIVE WORK ORDERS
        // ===============================
        if (WorkOrder."Product Part Number" <> 'PL-0002-09') then
            WorkOrder."Work Order Status" := WorkOrder."Work Order Status"::Completed
        else
            WorkOrder."Print Label Status" := WorkOrder."Print Label Status"::Completed;
        WorkOrder."Submitted" := true;
        WorkOrder.Modify(true);
    end;

    local procedure CreateJournalLine(
    var ItemJnlLine: Record "Item Journal Line";
    LineNo: Integer;
    ItemNo: Code[20];
    Quantity: Decimal;
    BinCode: Code[20];
    WorkOrder: Record "Work Order Header")
    var
        ItemRec: Record Item;
    begin
        ItemJnlLine.Init();

        ItemJnlLine.Validate("Journal Template Name", 'ITEM');
        ItemJnlLine.Validate("Journal Batch Name", 'WORKORDER');

        ItemJnlLine."Line No." := LineNo;

        ItemJnlLine.Validate("Item No.", ItemNo);
        ItemJnlLine.Validate("Location Code", 'MAIN');
        ItemJnlLine.Validate("Bin Code", BinCode);

        // 🔥 LOT TRACKING
        if WorkOrder."Lot Number" <> '' then
            ItemJnlLine.Validate("Lot No.", WorkOrder."Lot Number");

        // 🔥 REQUIRED POSTING FIELDS (THIS WAS YOUR BUG)
        if ItemRec.Get(ItemNo) then begin
            ItemJnlLine.Validate("Gen. Prod. Posting Group", ItemRec."Gen. Prod. Posting Group");
        end;
        ItemJnlLine.Validate("Gen. Bus. Posting Group", GetDefaultGenBusPostingGroup());

        // Quantity LAST (important)
        ItemJnlLine.Validate(Quantity, Quantity);

        // Entry type
        if Quantity < 0 then
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt."
        else
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";

        ItemJnlLine."Document No." := WorkOrder."No.";
        ItemJnlLine."Posting Date" := WorkDate();

        ItemJnlLine.Insert(true);
    end;

    local procedure ValidateQA(WorkOrder: Record "Work Order Header"): Decimal
    var
        ReleaseItem: Record "Product Release Item";
        CalculatedQty: Decimal;
    begin
        ReleaseItem.SetRange("Work Order No.", WorkOrder."No.");

        if not ReleaseItem.FindFirst() then
            Error('Product Release checklist is missing.');

        CalculatedQty := WorkOrder."Quantity for Processing";

        repeat
            if ReleaseItem.Status = ReleaseItem.Status::Open then
                Error('Checklist item "%1" is still Open.', ReleaseItem."Checklist Item");

            // ONLY VALIDATE — DO NOT MODIFY DATA
            if ReleaseItem."QA Released QTY" <= 0 then
                Error('QA Released QTY is missing or invalid.');

        until ReleaseItem.Next() = 0;

        if CalculatedQty <= 0 then
            Error('Quantity for Processing must be greater than 0.');

        exit(CalculatedQty);
    end;

    local procedure GetDefaultGenBusPostingGroup(): Code[20]
    begin
        exit('DOMESTIC');
    end;
}