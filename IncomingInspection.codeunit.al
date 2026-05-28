codeunit 50101 "Inspection Mgt"
{
    Access = Internal;
    Subtype = Normal;

    procedure PostPassedQuantity(InspectionRec: Record "Inspection Header")
    var
        ItemRec: Record Item;
        VendorRec: Record Vendor;
        ItemJnlLine: Record "Item Journal Line";
        NextLineNo: Integer;
        QtyToMove: Decimal;
        TrackingCode: Code[20];
    begin
        if InspectionRec.Status <> InspectionRec.Status::Pass then
            exit;

        QtyToMove := InspectionRec.Quantity;
        if QtyToMove <= 0 then
            Error('Quantity must be greater than zero.');

        if not ItemRec.Get(InspectionRec."Item No.") then
            Error('Item %1 does not exist', InspectionRec."Item No.");

        if not VendorRec.Get(InspectionRec."Vendor No.") then
            Error('Vendor %1 does not exist', InspectionRec."Vendor No.");

        TrackingCode := ItemRec."Item Tracking Code";

        if (TrackingCode = 'LOTALL') or (TrackingCode = 'SN') then
            if InspectionRec."Lot No." = '' then
                Error('Tracking No. required for item %1', ItemRec."No.");

        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
        ItemJnlLine.SetRange("Journal Batch Name", 'INSPECTION');
        if ItemJnlLine.FindLast() then
            NextLineNo := ItemJnlLine."Line No." + 10000
        else
            NextLineNo := 10000;

        ItemJnlLine.Init();
        ItemJnlLine.Validate("Journal Template Name", 'ITEM');
        ItemJnlLine.Validate("Journal Batch Name", 'INSPECTION');
        ItemJnlLine.Validate("Line No.", NextLineNo);
        ItemJnlLine.Validate("Document No.", InspectionRec."Inspection No.");

        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::Transfer);

        ItemJnlLine.Validate("Item No.", ItemRec."No.");
        ItemJnlLine.Validate("Posting Date", WorkDate());

        ItemJnlLine.Validate("Location Code", 'MAIN');
        ItemJnlLine.Validate("Bin Code", 'RCV-01');

        ItemJnlLine.Validate("New Location Code", 'MAIN');
        ItemJnlLine.Validate("New Bin Code", 'PROD-01');

        ItemJnlLine.Validate("Quantity", QtyToMove);

        ItemJnlLine.Validate("Gen. Bus. Posting Group", VendorRec."Gen. Bus. Posting Group");
        ItemJnlLine.Validate("Gen. Prod. Posting Group", ItemRec."Gen. Prod. Posting Group");

        if TrackingCode = 'LOTALL' then
            ItemJnlLine.Validate("Lot No.", InspectionRec."Lot No.");

        if TrackingCode = 'SN' then
            ItemJnlLine.Validate("Serial No.", InspectionRec."Serial No.");

        ItemJnlLine.Insert(true);

        Codeunit.Run(Codeunit::"Item Jnl.-Post", ItemJnlLine);
    end;


    procedure PostFailedQuantity(InspectionRec: Record "Inspection Header")
    var
        ItemRec: Record Item;
        VendorRec: Record Vendor;
        ItemJnlLine: Record "Item Journal Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservEntry: Record "Reservation Entry";
        NextLineNo: Integer;
    begin

        // Only process failed inspections
        if InspectionRec.Status <> InspectionRec.Status::Fail then
            exit;

        if InspectionRec.Quantity <= 0 then
            Error('Quantity must be greater than zero.');

        // Get master data
        if not ItemRec.Get(InspectionRec."Item No.") then
            Error('Item %1 does not exist', InspectionRec."Item No.");

        if not VendorRec.Get(InspectionRec."Vendor No.") then
            Error('Vendor %1 does not exist', InspectionRec."Vendor No.");

        // Require Lot No. if tracking is enabled
        if ItemRec."Item Tracking Code" = 'LOTALL' then
            if InspectionRec."Lot No." = '' then
                Error('Lot No. required for item %1', ItemRec."No.");

        // Get next line number
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
        ItemJnlLine.SetRange("Journal Batch Name", 'INSPECTION');
        if ItemJnlLine.FindLast() then
            NextLineNo := ItemJnlLine."Line No." + 10000
        else
            NextLineNo := 10000;

        // -----------------------------
        // CREATE ITEM JOURNAL LINE
        // -----------------------------
        ItemJnlLine.Init();
        ItemJnlLine.Validate("Journal Template Name", 'ITEM');
        ItemJnlLine.Validate("Journal Batch Name", 'INSPECTION');
        ItemJnlLine.Validate("Line No.", NextLineNo);
        ItemJnlLine.Validate("Document No.", InspectionRec."Inspection No.");
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Negative Adjmt.");
        ItemJnlLine.Validate("Item No.", ItemRec."No.");
        ItemJnlLine.Validate("Posting Date", WorkDate());
        ItemJnlLine.Validate("Location Code", 'MAIN');
        ItemJnlLine.Validate("Bin Code", 'RCV-01');
        ItemJnlLine.Validate("Quantity", InspectionRec.Quantity);
        ItemJnlLine.Validate("Gen. Bus. Posting Group", VendorRec."Gen. Bus. Posting Group");
        ItemJnlLine.Validate("Gen. Prod. Posting Group", ItemRec."Gen. Prod. Posting Group");

        ItemJnlLine.Insert(true);

        // -----------------------------
        // CREATE VALID TRACKING (CRITICAL FIX)
        // -----------------------------
        if ItemRec."Item Tracking Code" <> '' then begin

            ReservEntry.Init();

            // ✅ CORE FIELDS (REQUIRED)
            ReservEntry."Item No." := ItemJnlLine."Item No.";
            ReservEntry."Location Code" := ItemJnlLine."Location Code";
            ReservEntry."Lot No." := InspectionRec."Lot No.";

            // ✅ SOURCE LINKING (THIS WAS MISSING BEFORE)
            ReservEntry."Source Type" := DATABASE::"Item Journal Line";
            ReservEntry."Source Subtype" := ItemJnlLine."Entry Type".AsInteger();
            ReservEntry."Source ID" := ItemJnlLine."Journal Template Name";
            ReservEntry."Source Batch Name" := ItemJnlLine."Journal Batch Name";
            ReservEntry."Source Ref. No." := ItemJnlLine."Line No.";

            // ✅ QUANTITIES
            ReservEntry.Quantity := ItemJnlLine.Quantity;
            ReservEntry."Quantity (Base)" := ItemJnlLine."Quantity (Base)";

            // Create reservation
            CreateReservEntry.CreateReservEntryFor(
                DATABASE::"Item Journal Line",
                ItemJnlLine."Entry Type".AsInteger(),
                ItemJnlLine."Journal Template Name",
                ItemJnlLine."Journal Batch Name",
                0,
                ItemJnlLine."Line No.",
                ItemJnlLine."Qty. per Unit of Measure",
                ItemJnlLine.Quantity,
                ItemJnlLine."Quantity (Base)",
                ReservEntry
            );

            // Finalize entry
            CreateReservEntry.CreateEntry(
                ItemJnlLine."Item No.",
                ItemJnlLine."Variant Code",
                ItemJnlLine."Location Code",
                ItemJnlLine.Description,
                ItemJnlLine."Posting Date",
                ItemJnlLine."Posting Date",
                0,
                Enum::"Reservation Status"::Prospect
            );

        end;

        // -----------------------------
        // POST JOURNAL LINE
        // -----------------------------
        Codeunit.Run(Codeunit::"Item Jnl.-Post", ItemJnlLine);
    end;

    // ================================================
    // Add Inspection Record to Completed
    // ================================================
    procedure AddToCompleted(InspectionRec: Record "Inspection Header")
    var
        CompletedRec: Record "Inspection Header Completed";
    begin
        CompletedRec.Init();

        CompletedRec."Inspection No." := InspectionRec."Inspection No.";
        CompletedRec."Date Received" := InspectionRec."Date Received";
        CompletedRec."Purchase Order No." := InspectionRec."Purchase Order No.";
        CompletedRec."Vendor Name" := InspectionRec."Vendor Name";

        CompletedRec."Item No." := InspectionRec."Item No.";
        CompletedRec."Item Description" := InspectionRec."Item Description";

        CompletedRec."Lot No." := InspectionRec."Lot No.";

        CompletedRec.Quantity := InspectionRec.Quantity;
        CompletedRec.Status := InspectionRec.Status;

        CompletedRec."Received By" := InspectionRec."Received By";
        CompletedRec.Notes := InspectionRec.Notes;

        CompletedRec.Insert(true);
        InspectionRec.Delete(true);
    end;
}