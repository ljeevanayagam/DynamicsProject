codeunit 60004 "Work Order BOM Mgt"
{
    // =========================================================
    // MAIN STANDARD MATERIAL LINES (NON-PT)
    // =========================================================
    procedure GenerateMaterialLines(var WorkOrder: Record "Work Order Header")
    var
        ItemRec: Record Item;
        MaterialLine: Record "Work Order Material Line";
    begin
        if WorkOrder."No." = '' then
            exit;
        if WorkOrder."Product Part Number" = '' then
            exit;
        if not IsStandardRouting(WorkOrder."Routing No.") then
            exit;
        ClearMaterialLines(MaterialLine, WorkOrder."No.");
        ValidateItemHasBOM(WorkOrder."Product Part Number", ItemRec);
        InsertStandardBOMLines(WorkOrder, ItemRec."Production BOM No.");
    end;
    // =========================================================
    // PEDGA + THIOCURE (PT LOGIC)
    // =========================================================
    procedure GeneratePTMaterialLines(var WorkOrder: Record "Work Order Header")
    var
        PItem, TItem : Record Item;

    begin
        if WorkOrder."No." = '' then
            exit;
        if (WorkOrder."PEDGA Part Number" = '') or (WorkOrder."Thiocure Part Number" = '') then
            exit;
        // Only generate lines if none exist
        if not PTLinesExist(WorkOrder."No.") then begin
            // PEDGA
            if WorkOrder."PEDGA Part Number" <> '' then begin
                ValidateItemHasBOM(WorkOrder."PEDGA Part Number", PItem);
                InsertPTBOMLines(WorkOrder, PItem."Production BOM No.", true);
            end;
            // THIOCURE
            if WorkOrder."Thiocure Part Number" <> '' then begin
                ValidateItemHasBOM(WorkOrder."Thiocure Part Number", TItem);
                InsertPTBOMLines(WorkOrder, TItem."Production BOM No.", false);
            end;
        end;
    end;

    local procedure PTLinesExist(WorkOrderNo: Code[20]): Boolean
    var
        PLine: Record "Pedga Materials Header";
        TLine: Record "Thiocure Materials Header";
    begin
        PLine.SetRange("Work Order No.", WorkOrderNo);

        if not PLine.IsEmpty() then
            exit(true);

        TLine.SetRange("Work Order No.", WorkOrderNo);

        exit(not TLine.IsEmpty());
    end;

    // =========================================================
    // STANDARD BOM INSERT
    // =========================================================

    local procedure InsertStandardBOMLines(WorkOrder: Record "Work Order Header"; BOMNo: Code[20])
    var
        BOMLine: Record "Production BOM Line";
        SequenceNo: Integer;
    begin
        BOMLine.SetRange("Production BOM No.", BOMNo);

        if BOMLine.FindSet() then begin
            SequenceNo := 1;

            repeat
                InsertStandardMaterialLines(
                    WorkOrder,
                    BOMLine,
                    SequenceNo);

                SequenceNo += 1;
            until BOMLine.Next() = 0;
        end;
    end;

    local procedure InsertStandardMaterialLines(WorkOrder: Record "Work Order Header"; BOMLine: Record "Production BOM Line"; SequenceNo: Integer)
    var
        MaterialLine: Record "Work Order Material Line";
        BaseLineNo: Integer;
        NumberOfLines: Integer;
        i: Integer;
    begin
        BaseLineNo :=
            GetStandardBaseLineNo(
                WorkOrder."Product Part Number",
                BOMLine."No.");

        // Fallback for unmapped products
        if BaseLineNo = 0 then
            BaseLineNo := SequenceNo * 10000;

        NumberOfLines :=
            GetStandardLineCount(
                WorkOrder."Product Part Number",
                BOMLine."No.");

        for i := 1 to NumberOfLines do begin
            MaterialLine.Init();
            MaterialLine."Work Order No." := WorkOrder."No.";
            MaterialLine."Line No." := BaseLineNo + i;
            MaterialLine."Display Order" := MaterialLine."Line No.";
            MaterialLine."Item No." := BOMLine."No.";
            MaterialLine."Item Description" := BOMLine.Description;
            MaterialLine."Unit of Measure" := BOMLine."Unit of Measure Code";
            MaterialLine."Unit Quantity" := BOMLine."Quantity per";
            MaterialLine.Insert();
        end;
    end;

    local procedure GetStandardBaseLineNo(
    ProductPartNo: Code[20];
    ItemNo: Code[20]): Integer
    begin
        case ProductPartNo of
            'PRT-0492-01':
                exit(GetPRT049201BaseLineNo(ItemNo));

            'PRT-0492-02':
                exit(GetPRT049202BaseLineNo(ItemNo));

            'PRT-0492-03':
                exit(GetPRT049203BaseLineNo(ItemNo));

            'PRT-0492-04':
                exit(GetPRT049204BaseLineNo(ItemNo));

            'PRT-0492-05':
                exit(GetPRT049205BaseLineNo(ItemNo));

            'PRT-0492-06':
                exit(GetPRT049206BaseLineNo(ItemNo));

            'PRT-0492-07':
                exit(GetPRT049207BaseLineNo(ItemNo));

            'SA-1001-02':
                exit(GetSA100102BaseLineNo(ItemNo));

            'SA-1001-03':
                exit(GetSA100103BaseLineNo(ItemNo));
            else
                exit(0);
        end;
    end;

    local procedure GetStandardLineCount(
        ProductPartNo: Code[20];
        ItemNo: Code[20]): Integer
    begin
        case ProductPartNo of
            'PRT-0492-01':
                exit(GetPRT049201LineCount(ItemNo));

            'PRT-0492-02':
                exit(GetPRT049202LineCount(ItemNo));

            'PRT-0492-03':
                exit(GetPRT049203LineCount(ItemNo));

            'PRT-0492-04':
                exit(GetPRT049204LineCount(ItemNo));

            'PRT-0492-05':
                exit(GetPRT049205LineCount(ItemNo));

            'PRT-0492-06':
                exit(GetPRT049206LineCount(ItemNo));

            'PRT-0492-07':
                exit(GetPRT049207LineCount(ItemNo));

            'SA-1001-02':
                exit(GetSA100102LineCount(ItemNo));

            'SA-1001-03':
                exit(GetSA100103LineCount(ItemNo));
            else
                exit(1);
        end;
    end;
    // =========================================================
    // PT BOM INSERT (PEDGA / THIOCURE SHARED ENGINE)
    // =========================================================
    local procedure InsertPTBOMLines(
        WorkOrder: Record "Work Order Header";
        BOMNo: Code[20];
        IsPedga: Boolean)
    var
        BOMLine: Record "Production BOM Line";
    begin
        BOMLine.SetRange("Production BOM No.", BOMNo);
        if BOMLine.FindSet() then
            repeat
                if IsPedga then
                    InsertPedgaMaterialLines(WorkOrder, BOMLine)
                else
                    InsertThiocureMaterialLines(WorkOrder, BOMLine);
            until BOMLine.Next() = 0;
    end;

    // =========================================================
    // PEDGA INSERT
    // =========================================================
    local procedure InsertPedgaMaterialLines(
        WorkOrder: Record "Work Order Header";
        PBOMLine: Record "Production BOM Line")
    var
        PMaterialLine: Record "Pedga Materials Header";
        i: Integer;
        NumberOfLines: Integer;
        BaseLineNo: Integer;
    begin
        NumberOfLines := GetPedgaLineCount(PBOMLine."No.");
        BaseLineNo := GetPedgaBaseLineNo(PBOMLine."No.");

        for i := 1 to NumberOfLines do begin
            if PMaterialLine.Get(WorkOrder."No.", BaseLineNo + i) then
                exit;
            PMaterialLine.Init();
            PMaterialLine."Work Order No." := WorkOrder."No.";
            PMaterialLine."Line No." := BaseLineNo + i;
            PMaterialLine."Display Order" := PMaterialLine."Line No.";
            PMaterialLine."Item No." := PBOMLine."No.";
            PMaterialLine."Item Description" := PBOMLine.Description;
            PMaterialLine."Unit of Measure" := PBOMLine."Unit of Measure Code";
            PMaterialLine."Unit Quantity" := PBOMLine."Quantity per";
            if (PMaterialLine."Line No." = 80001) or (PMaterialLine."Line No." = 90001) then
                PMaterialLine.Verification := PMaterialLine.Verification::NA;
            PMaterialLine.Insert();
        end;
    end;

    // =========================================================
    // THIOCURE INSERT
    // =========================================================
    local procedure InsertThiocureMaterialLines(
        WorkOrder: Record "Work Order Header";
        TBOMLine: Record "Production BOM Line")
    var
        TMaterialLine: Record "Thiocure Materials Header";
        i: Integer;
        NumberOfLines: Integer;
        BaseLineNo: Integer;
    begin
        NumberOfLines := GetThiocureLineCount(TBOMLine."No.");
        BaseLineNo := GetThiocureBaseLineNo(TBOMLine."No.");

        for i := 1 to NumberOfLines do begin
            if TMaterialLine.Get(WorkOrder."No.", BaseLineNo + i) then
                exit;
            TMaterialLine.Init();
            TMaterialLine."Work Order No." := WorkOrder."No.";
            TMaterialLine."Line No." := BaseLineNo + i;
            TMaterialLine."Display Order" := TMaterialLine."Line No.";
            TMaterialLine."Item No." := TBOMLine."No.";
            TMaterialLine."Item Description" := TBOMLine.Description;
            TMaterialLine."Unit of Measure" := TBOMLine."Unit of Measure Code";
            TMaterialLine."Unit Quantity" := TBOMLine."Quantity per";
            if (TMaterialLine."Line No." = 90001) or (TMaterialLine."Line No." = 100001) then
                TMaterialLine.Verification := TMaterialLine.Verification::NA;
            TMaterialLine.Insert();
        end;
    end;
    // =========================================================
    // HELPERS
    // =========================================================
    local procedure ValidateItemHasBOM(ItemNo: Code[20]; var ItemRec: Record Item)
    begin
        if not ItemRec.Get(ItemNo) then
            Error('Item %1 not found.', ItemNo);
        if ItemRec."Production BOM No." = '' then
            Error('Item %1 has no Production BOM.', ItemNo);
    end;

    local procedure ClearMaterialLines(var MaterialLine: Record "Work Order Material Line"; WorkOrderNo: Code[20])
    begin
        MaterialLine.SetRange("Work Order No.", WorkOrderNo);
        MaterialLine.DeleteAll();
    end;

    procedure ClearPTLines(WorkOrderNo: Code[20])
    var
        PLine: Record "Pedga Materials Header";
        TLine: Record "Thiocure Materials Header";
    begin
        PLine.SetRange("Work Order No.", WorkOrderNo);
        PLine.DeleteAll(false);
        TLine.SetRange("Work Order No.", WorkOrderNo);
        TLine.DeleteAll(false);
    end;

    local procedure IsStandardRouting(RoutingNo: Code[20]): Boolean
    begin
        exit(
            (RoutingNo = 'BELZER') or
            (RoutingNo = 'SUB-OTS') or
            (RoutingNo = 'FILL_SET') or
            (RoutingNo = 'MOON-MNLT')
        );
    end;

    // =========================================================
    // YOUR EXISTING MAPPING FUNCTIONS (UNCHANGED)
    // =========================================================
    local procedure GetPedgaBaseLineNo(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0436':
                exit(10000);
            'PRT-0437':
                exit(20000);
            'PRT-0439':
                exit(30000);
            'PRT-0440':
                exit(40000);
            'PL-0010-01':
                exit(50000);
            'PN-0444':
                exit(60000);
            'PN-0445':
                exit(70000);
            'PRT-0551-05':
                exit(80000);
            'PRT-0552-02':
                exit(90000);
            'PL-0010-03':
                exit(100000);
            else
                Error('No PEDGA base line number defined for item %1', ItemNo);
        end;
    end;

    local procedure GetThiocureBaseLineNo(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PN-0442':
                exit(10000);
            'PRT-0437':
                exit(20000);
            'PN-0438':
                exit(30000);
            'PRT-0439':
                exit(40000);
            'PRT-0441':
                exit(50000);
            'PL-0010-02':
                exit(60000);
            'PN-0444':
                exit(70000);
            'PN-0445':
                exit(80000);
            'PRT-0551-05':
                exit(90000);
            'PRT-0552-02':
                exit(100000);
            'PL-0010-04':
                exit(110000);
            else
                Error('No THIOCURE base line number defined for item %1', ItemNo);
        end;
    end;

    local procedure GetPedgaLineCount(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0436', 'PRT-0437', 'PRT-0439':
                exit(3);
            'PRT-0440', 'PN-0444', 'PN-0445':
                exit(2);
            else
                exit(1);
        end;
    end;

    local procedure GetThiocureLineCount(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PN-0442', 'PRT-0439':
                exit(3);
            'PRT-0437', 'PRT-0441', 'PN-0444', 'PN-0445':
                exit(2);
            else
                exit(1);
        end;
    end;

    local procedure GetPRT049201BaseLineNo(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0484':
                exit(10000);
            'PRT-0485-02':
                exit(20000);
            'PRT-0486-01':
                exit(30000);
            'PL-0002-01':
                exit(40000);
            'PL-0002-10':
                exit(50000);
            'PRT-0483':
                exit(60000);
            'PL-0002-09':
                exit(70000);
            'PRT-0481':
                exit(80000);
            'PRT-0479':
                exit(90000);
            'PRT-0478':
                exit(100000);
            'PRT-0487':
                exit(110000);
            'PRT-0534':
                exit(120000);
            'PL-0002-05':
                exit(130000);
            else
                Error('No base line number defined for item %1', ItemNo);
        end;
    end;

    local procedure GetPRT049202BaseLineNo(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0484':
                exit(10000);
            'PRT-0485-03':
                exit(20000);
            'PRT-0486-02':
                exit(30000);
            'PL-0002-02':
                exit(40000);
            'PL-0002-11':
                exit(50000);
            'PRT-0483':
                exit(60000);
            'PL-0002-09':
                exit(70000);
            'PRT-0480':
                exit(80000);
            'PRT-0476':
                exit(90000);
            'PRT-0477':
                exit(100000);
            'PRT-0489':
                exit(110000);
            'PRT-0534':
                exit(120000);
            'PL-0002-06':
                exit(130000);
            else
                Error('No base line number defined for item %1', ItemNo);
        end;
    end;

    local procedure GetPRT049203BaseLineNo(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0484':
                exit(10000);
            'PRT-0485-04':
                exit(20000);
            'PRT-0486-03':
                exit(30000);
            'PL-0002-03':
                exit(40000);
            'PL-0002-12':
                exit(50000);
            'PRT-0491':
                exit(60000);
            'PL-0002-09':
                exit(70000);
            'PRT-0480':
                exit(80000);
            'PRT-0476':
                exit(90000);
            'PRT-0477':
                exit(100000);
            'PRT-0490':
                exit(110000);
            'PRT-0534':
                exit(120000);
            'PL-0002-07':
                exit(130000);
            else
                Error('No base line number defined for item %1', ItemNo);
        end;
    end;

    local procedure GetPRT049204BaseLineNo(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0519':
                exit(10000);
            'PRT-0485-03':
                exit(20000);
            'PRT-0520-01':
                exit(30000);
            'PL-0002-04':
                exit(40000);
            'PL-0002-13':
                exit(50000);
            'PRT-0483':
                exit(60000);
            'PL-0002-09':
                exit(70000);
            'PRT-0481':
                exit(80000);
            'PRT-0479':
                exit(90000);
            'PRT-0478':
                exit(100000);
            'PRT-0521':
                exit(110000);
            'PRT-0522':
                exit(120000);
            'PL-0002-08':
                exit(130000);
            else
                Error('No base line number defined for item %1', ItemNo);
        end;
    end;

    local procedure GetPRT049205BaseLineNo(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0554-01':
                exit(10000);
            'PRT-0485-03':
                exit(20000);
            'PL-0002-15':
                exit(30000);
            else
                Error('No base line number defined for item %1', ItemNo);
        end;
    end;

    local procedure GetPRT049206BaseLineNo(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0554-01':
                exit(10000);
            'PRT-0485-04':
                exit(20000);
            'PL-0002-16':
                exit(30000);
            else
                Error('No base line number defined for item %1', ItemNo);
        end;
    end;

    local procedure GetPRT049207BaseLineNo(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0554-01':
                exit(10000);
            'PRT-0485-01':
                exit(20000);
            'PL-0002-17':
                exit(30000);
            else
                Error('No base line number defined for item %1', ItemNo);
        end;
    end;

    local procedure GetSA100102BaseLineNo(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0501':
                exit(10000);
            'PRT-0510':
                exit(20000);
            'PL-0003-03':
                exit(30000);
            'PRT-0515-02':
                exit(40000);
            'PRT-0516':
                exit(50000);
            else
                Error('No base line number defined for item %1', ItemNo);
        end;
    end;

    local procedure GetSA100103BaseLineNo(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0501':
                exit(10000);
            'PRT-0509':
                exit(20000);
            'PL-0003-03':
                exit(30000);
            'PRT-0515-02':
                exit(40000);
            'PRT-0516':
                exit(50000);
            else
                Error('No base line number defined for item %1', ItemNo);
        end;
    end;

    local procedure GetPRT049201LineCount(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0484', 'PRT-0485-02':
                exit(3);
            'PRT-0481', 'PRT-0479', 'PRT-0478':
                exit(2);
            else
                exit(1);
        end;
    end;

    local procedure GetPRT049202LineCount(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0484', 'PRT-0485-03':
                exit(3);
            'PRT-0480', 'PRT-0476', 'PRT-0477':
                exit(2);
            else
                exit(1);
        end;
    end;

    local procedure GetPRT049203LineCount(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0484', 'PRT-0485-04':
                exit(3);
            'PRT-0480', 'PRT-0476', 'PRT-0477':
                exit(2);
            else
                exit(1);
        end;
    end;

    local procedure GetPRT049204LineCount(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0519', 'PRT-0485-03':
                exit(3);
            'PRT-0481', 'PRT-0479', 'PRT-0478':
                exit(2);
            else
                exit(1);
        end;
    end;

    local procedure GetPRT049205LineCount(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0554-01', 'PRT-0485-03':
                exit(3);
            else
                exit(1);
        end;
    end;

    local procedure GetPRT049206LineCount(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0554-01', 'PRT-0485-04':
                exit(3);
            else
                exit(1);
        end;
    end;

    local procedure GetPRT049207LineCount(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0554-01', 'PRT-0485-01':
                exit(3);
            else
                exit(1);
        end;
    end;

    local procedure GetSA100102LineCount(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0510':
                exit(3);
            else
                exit(1);
        end;
    end;

    local procedure GetSA100103LineCount(ItemNo: Code[20]): Integer
    begin
        case ItemNo of
            'PRT-0509':
                exit(3);
            else
                exit(1);
        end;
    end;
}