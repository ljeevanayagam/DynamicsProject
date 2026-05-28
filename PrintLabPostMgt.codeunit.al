codeunit 60002 "Print Label Post Mgt"
{
    procedure PostRun(var RunLine: Record "Print Label Line")
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlPost: Codeunit "Item Jnl.-Post";
        PrintHeader: Record "Print Label Header";
        ItemRec: Record Item;
        CompletedWO: Record "Completed Work Order";
        WorkOrderHeader: Record "Work Order Header";
    begin
        RunLine.TestField(Submitted, false);
        RunLine.TestField("Accepted Quantity");

        if not PrintHeader.Get(RunLine."Work Order No.") then
            Error('Print Label Header not found.');

        ValidateLots(PrintHeader);

        if not ItemRec.Get(PrintHeader."Label Part No.") then
            Error('Item not found.');

        if not CompletedWO.Get(RunLine."Work Order No.") then
            Error('You must post the Work Order before posting runs.');

        // -----------------------------
        // Journal
        // -----------------------------
        ItemJnlLine.Init();
        ItemJnlLine.Validate("Journal Template Name", 'ITEM');
        ItemJnlLine.Validate("Journal Batch Name", 'PRINTLABEL');
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Positive Adjmt.");
        ItemJnlLine.Validate("Item No.", ItemRec."No.");
        ItemJnlLine.Validate("Quantity", RunLine."Accepted Quantity");
        ItemJnlLine.Validate("Posting Date", RunLine."Labels Verified Date");
        ItemJnlLine.Validate("Document No.", RunLine."Work Order No.");
        ItemJnlLine.Validate("Location Code", PrintHeader."Location Code");
        ItemJnlLine.Validate("Bin Code", PrintHeader."Bin Code");
        ItemJnlLine.Validate("Gen. Prod. Posting Group", ItemRec."Gen. Prod. Posting Group");
        ItemJnlLine.Validate("Inventory Posting Group", ItemRec."Inventory Posting Group");
        ItemJnlLine.Validate("Gen. Bus. Posting Group", 'DOMESTIC');
        ItemJnlLine.Insert(true);

        ItemJnlPost.Run(ItemJnlLine);
        EnsureCompletedWOExists(RunLine);
        InsertCompletedRun(RunLine);
        UpdateCompletedWorkOrderSummary(RunLine);
        if WorkOrderHeader.Get(RunLine."Work Order No.") then
            WorkOrderHeader.SyncHeaderStatus();
        RunLine.Submitted := true;
        RunLine.Modify(true);
    end;

    local procedure EnsureCompletedWOExists(RunLine: Record "Print Label Line")
    var
        CompletedWO: Record "Completed Work Order";
        WO: Record "Work Order Header";
    begin
        if CompletedWO.Get(RunLine."Work Order No.") then
            exit;

        if not WO.Get(RunLine."Work Order No.") then
            Error('Work Order not found.');

        CompletedWO.Init();
        CompletedWO."Work Order No." := WO."No.";

        CompletedWO."Product Part Number" := WO."Product Part Number";
        CompletedWO."Product Description" := WO."Product Description";
        CompletedWO."Lot Number" := WO."Lot Number";
        CompletedWO."Routing No." := WO."Routing No.";
        CompletedWO.Revision := WO.Revision;
        CompletedWO."Lot Quantity" := WO."Lot Quantity";

        CompletedWO.Status := CompletedWO.Status::Completed;
        CompletedWO."Completed Date" := Today;
        CompletedWO."Completed By" := UserId;

        CompletedWO.Insert(true);
    end;

    local procedure UpdateCompletedWorkOrderSummary(RunLine: Record "Print Label Line")
    var
        CompletedWO: Record "Completed Work Order";
    begin
        if not CompletedWO.Get(RunLine."Work Order No.") then
            exit;

        CompletedWO.UpdateFromRuns(); // 🔥 centralized logic
    end;

    local procedure InsertCompletedRun(RunLine: Record "Print Label Line")
    var
        CompletedRun: Record "Completed Work Order Run";
    begin
        if CompletedRun.Get(RunLine."Work Order No.", RunLine."Run No.") then
            exit;
        CompletedRun.Init();
        CompletedRun."Work Order No." := RunLine."Work Order No.";
        CompletedRun."Run No." := RunLine."Run No.";
        CompletedRun."Accepted Quantity" := RunLine."Accepted Quantity";
        CompletedRun."Posted Date" := RunLine."Labels Verified Date";
        CompletedRun.Insert(true);
    end;

    local procedure HasLedgerEntry(RunLine: Record "Print Label Line"): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.SetRange("Document No.", RunLine."Work Order No.");
        exit(ItemLedgEntry.FindFirst());
    end;

    local procedure ValidateLots(PrintHeader: Record "Print Label Header")
    var
        LotInfo: Record "Lot No. Information";
    begin
        LotInfo.SetRange("Item No.", PrintHeader."Label Stock Part No.");
        LotInfo.SetRange("Lot No.", PrintHeader."Label Stock Lot No.");
        if not LotInfo.FindFirst() then
            Error('Invalid Label Stock Lot No.');

        LotInfo.Reset();
        LotInfo.SetRange("Item No.", PrintHeader."Ribbon Part No.");
        LotInfo.SetRange("Lot No.", PrintHeader."Ribbon Lot No.");
        if not LotInfo.FindFirst() then
            Error('Invalid Ribbon Lot No.');
    end;

    local procedure GetTotalAcceptedQty(WorkOrderNo: Code[20]): Integer
    var
        RunLine: Record "Print Label Line";
        Total: Integer;
    begin
        RunLine.SetRange("Work Order No.", WorkOrderNo);

        if RunLine.FindSet() then
            repeat
                Total += RunLine."Accepted Quantity";
            until RunLine.Next() = 0;

        exit(Total);
    end;

    procedure AllRunsSubmitted(WorkOrderNo: Code[20]): Boolean
    var
        Run: Record "Print Label Line";
    begin
        Run.SetRange("Work Order No.", WorkOrderNo);

        if not Run.FindSet() then
            exit(false);

        repeat
            if not Run.Submitted then
                exit(false);
        until Run.Next() = 0;

        exit(true);
    end;

    procedure CalculatePrintLabelStatus(WO: Record "Work Order Header"): Enum "Print Label Status"
    begin
        if not HasRuns(WO."No.") then
            exit(Enum::"Print Label Status"::Open);

        if AllRunsSubmitted(WO."No.") then
            exit(Enum::"Print Label Status"::Completed);

        exit(Enum::"Print Label Status"::"In Progress");
    end;

    procedure ApplyPrintLabelStatus(var WO: Record "Work Order Header")
    begin
        WO."Print Label Status" := CalculatePrintLabelStatus(WO);
        WO.Modify(true);
    end;

    local procedure HasRuns(WorkOrderNo: Code[20]): Boolean
    var
        RunLine: Record "Print Label Line";
    begin
        RunLine.SetRange("Work Order No.", WorkOrderNo);
        exit(RunLine.FindFirst());
    end;

    procedure UpdateWorkOrderPrintLabelStatus(WorkOrderNo: Code[20])
    var
        WorkOrder: Record "Work Order Header";
        Header: Record "Print Label Header";
        Line: Record "Print Label Line";
        AnyStarted: Boolean;
        AllComplete: Boolean;
        HasLines: Boolean;
    begin
        if not WorkOrder.Get(WorkOrderNo) then
            exit;
        // Default state
        AnyStarted := false;
        AllComplete := true;
        HasLines := false;
        // -----------------------------
        // Header checks
        // -----------------------------
        if Header.Get(WorkOrderNo) then begin
            // Any input entered?
            if Header.HasAnyInput() then
                AnyStarted := true;
            // Required fields complete?
            if not Header.IsComplete() then
                AllComplete := false;
        end
        else
            AllComplete := false;
        // -----------------------------
        // Line checks
        // -----------------------------
        Line.SetRange("Work Order No.", WorkOrderNo);
        if Line.FindSet() then begin
            HasLines := true;
            repeat
                // Any activity in fast tab?
                if
                    (Line."Labels Printed By" <> '') or
                    (Line."Labels Printed Date" <> 0D) or
                    (Line."Retain Verified By" <> '') or
                    (Line."Retain Verified Date" <> 0D) or
                    (Line."Quantity of Labels Printed" <> 0) or
                    (Line."Retain Quantity" <> 0) or
                    (Line."Rejected Quantity" <> 0) or
                    (Line."Labels Verified By" <> '') or
                    (Line."Labels Verified Date" <> 0D)
                then
                    AnyStarted := true;
                // Completed requires all runs submitted
                if not Line.IsComplete() then
                    AllComplete := false;
            until Line.Next() = 0;
        end
        else
            AllComplete := false;
        // Cannot be complete without lines
        if not HasLines then
            AllComplete := false;
        // -----------------------------
        // Final status
        // -----------------------------
        if AllComplete then
            WorkOrder."Print Label Status" :=
                WorkOrder."Print Label Status"::Completed
        else
            if AnyStarted then
                WorkOrder."Print Label Status" :=
                    WorkOrder."Print Label Status"::"In Progress"
            else
                WorkOrder."Print Label Status" :=
                    WorkOrder."Print Label Status"::Open;
        WorkOrder.Modify(true);
    end;
}