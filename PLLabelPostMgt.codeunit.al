codeunit 60010 "PL Label Posting Mgt"
{
    procedure PostPLLabels(var WorkOrder: Record "Work Order Header")
    var
        PLLabel: Record "Work Order PL Label";
        ItemRec: Record Item;
        ItemJnlLine: Record "Item Journal Line";
        NextLineNo: Integer;
    begin
        Message('🔵 START PL POSTING | Work Order %1', WorkOrder."No.");

        PLLabel.SetRange("Work Order No.", WorkOrder."No.");

        if not PLLabel.FindSet() then
            Error('No PL Labels found.');

        // Clean batch
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
        ItemJnlLine.SetRange("Journal Batch Name", 'PRINTLABEL');
        ItemJnlLine.DeleteAll();

        NextLineNo := 10000;

        repeat
            if PLLabel.Posted then
                continue;

            ValidatePLLabel(PLLabel);

            if not ItemRec.Get(PLLabel."PL Item No.") then
                Error('Item missing %1', PLLabel."PL Item No.");

            // RIBBON (NEGATIVE)
            CreateLineSafe(
                WorkOrder,
                NextLineNo,
                PLLabel."Ribbon Item No.",
                PLLabel."Ribbon Lot No.",
                PLLabel."Quantity Used",
                ItemJnlLine."Entry Type"::"Negative Adjmt.");

            NextLineNo += 10000;

            // LABEL BLANK (NEGATIVE)
            CreateLineSafe(
                WorkOrder,
                NextLineNo,
                PLLabel."Label Blank Item No.",
                PLLabel."Label Blank Lot No.",
                PLLabel."Quantity Used",
                ItemJnlLine."Entry Type"::"Negative Adjmt.");

            NextLineNo += 10000;

            // OUTPUT (POSITIVE)
            CreateLineSafe(
                WorkOrder,
                NextLineNo,
                PLLabel."PL Item No.",
                '',
                PLLabel."Quantity Used",
                ItemJnlLine."Entry Type"::"Positive Adjmt.");

            NextLineNo += 10000;

        until PLLabel.Next() = 0;

        // Ensure lines exist
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", 'ITEM');
        ItemJnlLine.SetRange("Journal Batch Name", 'PRINTLABEL');

        if not ItemJnlLine.FindSet() then
            Error('No journal lines found to post.');

        // LOCK BEFORE POST
        WorkOrder."PL Labels Locked" := true;
        WorkOrder.Modify(true);

        // POST
        if not Codeunit.Run(Codeunit::"Item Jnl.-Post Batch", ItemJnlLine) then
            Error('Posting failed.');

        // MARK POSTED AFTER SUCCESS
        PLLabel.Reset();
        PLLabel.SetRange("Work Order No.", WorkOrder."No.");

        if PLLabel.FindSet() then
            repeat
                PLLabel.Posted := true;
                PLLabel.Modify(true);
            until PLLabel.Next() = 0;

        Message('🏁 DONE');
    end;

    local procedure ValidatePLLabel(PLLabel: Record "Work Order PL Label")
    begin
        if PLLabel."Ribbon Item No." = '' then
            Error('Missing Ribbon Item');

        if PLLabel."Ribbon Lot No." = '' then
            Error('Missing Ribbon Lot');

        if PLLabel."Label Blank Item No." = '' then
            Error('Missing Label Item');

        if PLLabel."Label Blank Lot No." = '' then
            Error('Missing Label Lot');
    end;

    local procedure CreateLineSafe(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        ItemNo: Code[20];
        LotNo: Code[50];
        Qty: Decimal;
        EntryType: Enum "Item Ledger Entry Type")
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemRec: Record Item;
        GenBus: Code[20];
        GenProd: Code[20];
    begin
        if ItemNo = '' then
            exit;

        if not ItemRec.Get(ItemNo) then
            Error('Item %1 not found', ItemNo);

        ItemJnlLine.Init();

        ItemJnlLine.Validate("Journal Template Name", 'ITEM');
        ItemJnlLine.Validate("Journal Batch Name", 'PRINTLABEL');
        ItemJnlLine.Validate("Line No.", LineNo);

        ItemJnlLine.Validate("Posting Date", WorkDate());
        ItemJnlLine.Validate("Document No.", WorkOrder."No.");

        ItemJnlLine.Validate("Item No.", ItemNo);
        ItemJnlLine.Validate(Quantity, Qty);

        ItemJnlLine.Validate("Location Code", 'MAIN');
        ItemJnlLine.Validate("Bin Code", 'PROD-01');

        GenBus := 'DOMESTIC';
        GenProd := ItemRec."Gen. Prod. Posting Group";

        if GenBus = '' then
            Error('Missing Gen Bus Posting Group');

        if GenProd = '' then
            Error('Item %1 missing Gen Prod Posting Group', ItemNo);

        ItemJnlLine.Validate("Gen. Bus. Posting Group", GenBus);
        ItemJnlLine.Validate("Gen. Prod. Posting Group", GenProd);

        ItemJnlLine.Validate("Entry Type", EntryType);

        if LotNo <> '' then
            ItemJnlLine.Validate("Lot No.", LotNo);

        ItemJnlLine.Insert(true);
    end;
}