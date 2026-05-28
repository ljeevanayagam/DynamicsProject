codeunit 60011 "Work Order Label Mgt"
{
    procedure GeneratePLLabels(var WorkOrder: Record "Work Order Header")
    var
        MaterialLine: Record "Work Order Material Line";
        PedgaLine: Record "Pedga Materials Header";
        ThiocureLine: Record "Thiocure Materials Header";
    begin
        if WorkOrder."PL Labels Locked" then
            exit;

        if WorkOrder."No." = '' then
            exit;

        ClearObsoleteUnpostedLabels(WorkOrder);

        if IsPTSetup(WorkOrder) then begin
            ProcessPedgaAndThiocure(WorkOrder);
        end else begin
            ProcessStandardMaterials(WorkOrder);
        end;
    end;

    // =====================================================
    // STANDARD MATERIAL PROCESSING
    // =====================================================
    local procedure ProcessStandardMaterials(WorkOrder: Record "Work Order Header")
    var
        MaterialLine: Record "Work Order Material Line";
        ItemRec: Record Item;
    begin
        MaterialLine.SetRange("Work Order No.", WorkOrder."No.");

        if MaterialLine.FindSet() then
            repeat
                if CopyStr(MaterialLine."Item No.", 1, 3) <> 'PL-' then
                    continue;

                Clear(ItemRec);
                if ItemRec.Get(MaterialLine."Item No.") then begin
                    ProcessLine(
                        MaterialLine."Item No.",
                        ItemRec."Description 2",
                        MaterialLine."Item Description",
                        WorkOrder,
                        MaterialLine."Line No.",
                        "PL Label Source Type"::Material);
                end else begin
                    ProcessLine(
                        MaterialLine."Item No.",
                        '',
                        MaterialLine."Item Description",
                        WorkOrder,
                        MaterialLine."Line No.",
                        "PL Label Source Type"::Material);
                end;

            until MaterialLine.Next() = 0;
    end;

    // =====================================================
    // PT PROCESSING (PEDGA + THIOCURE)
    // =====================================================
    local procedure ProcessPedgaAndThiocure(WorkOrder: Record "Work Order Header")
    var
        PedgaLine: Record "Pedga Materials Header";
        ThiocureLine: Record "Thiocure Materials Header";
        ItemRec: Record Item;
    begin
        PedgaLine.SetRange("Work Order No.", WorkOrder."No.");

        if PedgaLine.FindSet() then
            repeat
                if CopyStr(PedgaLine."Item No.", 1, 3) <> 'PL-' then
                    continue;

                Clear(ItemRec);
                if ItemRec.Get(PedgaLine."Item No.") then begin
                    ProcessLine(
                        PedgaLine."Item No.",
                        ItemRec."Description 2",
                        PedgaLine."Item Description",
                        WorkOrder,
                        PedgaLine."Line No.",
                        "PL Label Source Type"::Pedga);
                end;

            until PedgaLine.Next() = 0;

        ThiocureLine.SetRange("Work Order No.", WorkOrder."No.");

        if ThiocureLine.FindSet() then
            repeat
                if CopyStr(ThiocureLine."Item No.", 1, 3) <> 'PL-' then
                    continue;

                Clear(ItemRec);
                if ItemRec.Get(ThiocureLine."Item No.") then begin
                    ProcessLine(
                        ThiocureLine."Item No.",
                        ItemRec."Description 2",
                        ThiocureLine."Item Description",
                        WorkOrder,
                        ThiocureLine."Line No.",
                        "PL Label Source Type"::Thiocure);
                end;

            until ThiocureLine.Next() = 0;
    end;

    // =====================================================
    // CORE PROCESSOR
    // =====================================================
    local procedure ProcessLine(
        ItemNo: Code[20];
        ItemRevision: Code[50];
        Description: Text;
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        SourceType: Enum "PL Label Source Type")
    var
        PLLabel: Record "Work Order PL Label";
        ItemRec: Record Item;
        BOMHeader: Record "Production BOM Header";
        BOMLine: Record "Production BOM Line";
        BOMItem: Record Item;
        DescText: Text;
    begin
        if CopyStr(ItemNo, 1, 3) <> 'PL-' then
            exit;

        if ItemNo = 'PL-0002-09' then
            if WorkOrder."Routing No." <> 'PRINTLABEL' then
                exit;

        if PLLabel.Get(WorkOrder."No.", ItemNo, SourceType) then
            exit;

        PLLabel.Init();
        PLLabel."Work Order No." := WorkOrder."No.";
        PLLabel."PL Item No." := ItemNo;
        PLLabel."Material Line No." := LineNo;
        PLLabel."Source Type" := SourceType;

        if ItemNo = 'PL-0002-09' then
            PLLabel.Revision := WorkOrder.Revision
        else
            PLLabel.Revision := ItemRevision;

        PLLabel.Description := Description;

        if ItemRec.Get(ItemNo) then
            if ItemRec."Production BOM No." <> '' then
                if BOMHeader.Get(ItemRec."Production BOM No.") then begin
                    BOMLine.SetRange("Production BOM No.", BOMHeader."No.");

                    if BOMLine.FindSet() then
                        repeat
                            if BOMItem.Get(BOMLine."No.") then begin
                                DescText := UpperCase(BOMItem.Description);

                                if StrPos(DescText, 'RIBBON') > 0 then
                                    PLLabel."Ribbon Item No." := BOMItem."No.";

                                if StrPos(DescText, 'BLANK STOCK') > 0 then
                                    PLLabel."Label Blank Item No." := BOMItem."No.";
                            end;
                        until BOMLine.Next() = 0;
                end;

        PLLabel.Insert(true);
    end;

    // =====================================================
    // HELPERS
    // =====================================================
    local procedure IsPTSetup(WorkOrder: Record "Work Order Header"): Boolean
    begin
        exit(
            (WorkOrder."PEDGA Part Number" = 'PN-0446') and
            (WorkOrder."Thiocure Part Number" = 'PN-0447')
        );
    end;

    // =====================================================
    // CLEARING LOGIC (FIXED ORDER + SAFETY)
    // =====================================================
    local procedure ClearObsoleteUnpostedLabels(var WorkOrder: Record "Work Order Header")
    var
        PLLabel: Record "Work Order PL Label";
        ValidItemNos: List of [Code[20]];
        MaterialLine: Record "Work Order Material Line";
        PedgaLine: Record "Pedga Materials Header";
        ThiocureLine: Record "Thiocure Materials Header";
    begin
        // =====================================================
        // BUILD VALID LIST (explicit + safe)
        // =====================================================

        MaterialLine.SetRange("Work Order No.", WorkOrder."No.");
        if MaterialLine.FindSet() then
            repeat
                if CopyStr(MaterialLine."Item No.", 1, 3) = 'PL-' then
                    ValidItemNos.Add(MaterialLine."Item No.");
            until MaterialLine.Next() = 0;

        PedgaLine.SetRange("Work Order No.", WorkOrder."No.");
        if PedgaLine.FindSet() then
            repeat
                if CopyStr(PedgaLine."Item No.", 1, 3) = 'PL-' then
                    ValidItemNos.Add(PedgaLine."Item No.");
            until PedgaLine.Next() = 0;

        ThiocureLine.SetRange("Work Order No.", WorkOrder."No.");
        if ThiocureLine.FindSet() then
            repeat
                if CopyStr(ThiocureLine."Item No.", 1, 3) = 'PL-' then
                    ValidItemNos.Add(ThiocureLine."Item No.");
            until ThiocureLine.Next() = 0;

        // =====================================================
        // DELETE INVALID LABELS
        // =====================================================
        PLLabel.SetRange("Work Order No.", WorkOrder."No.");
        PLLabel.SetRange(Posted, false);

        if PLLabel.FindSet() then
            repeat
                if not ValidItemNos.Contains(PLLabel."PL Item No.") then
                    PLLabel.Delete();
            until PLLabel.Next() = 0;
    end;

    procedure ClearPLLabels(WorkOrderNo: Code[50]; KeepPosted: Boolean)
    var
        PLLabel: Record "Work Order PL Label";
    begin
        PLLabel.SetRange("Work Order No.", WorkOrderNo);

        if KeepPosted then
            PLLabel.SetRange(Posted, false);

        if PLLabel.FindSet() then
            repeat
                PLLabel.Delete();
            until PLLabel.Next() = 0;
    end;

    procedure RefreshLabels(var WorkOrder: Record "Work Order Header")
    begin
        ClearPLLabels(WorkOrder."No.", true);
        GeneratePLLabels(WorkOrder);
    end;
}