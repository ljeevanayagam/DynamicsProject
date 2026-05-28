codeunit 60112 "Work Order Orchestrator"
{
    procedure HandleRoutingChange(var WO: Record "Work Order Header")
    var
        SupplyMgt: Codeunit "Operational Supply Mgt";
        EquipMgt: Codeunit "Equipment Line Mgt";
        ProdRelMgt: Codeunit "Product Release Mgt";
        BOMMgt: Codeunit "Work Order BOM Mgt";
        BCert: Codeunit "Belzer Certificate Mgt";
        PCert: Codeunit "PT Certification Mgt";
        PTPack: Codeunit "PT Packing List Mgt";
        LabelMgt: Codeunit "Work Order Label Mgt";
        CTMat: Codeunit "Cure Time Materials Mgt";
        CTEquip: Codeunit "Cure Time Equipment Mgt";
    begin
        if WO."No." = '' then
            exit;
        // =====================================================
        // 1. RESOLVE ROUTING + FLAGS
        // =====================================================
        ResolveRouting(WO);
        // =====================================================
        // 2. PT RECALCULATIONS (IN MEMORY ONLY)
        // =====================================================
        if IsPTWorkOrder(WO) then begin
            WO.RecalculatePT();
            WO.UpdateQAReleasedQty();
            UpdatePTLotNumbers(WO);
            CTEquip.GenerateCTEqupment(WO);
            CTMat.GenerateCTMaterials(WO);
        end;
        // =====================================================
        // 3. MATERIAL / EQUIPMENT GENERATION
        // =====================================================
        if IsPTWorkOrder(WO) then begin
            BOMMgt.GeneratePTMaterialLines(WO);
            EquipMgt.GeneratePTEquipment(WO);
            PCert.GenerateTestResults(WO);
            PTPack.GeneratePTPacking(WO);
        end else begin
            if WO."Product Part Number" <> '' then begin
                BOMMgt.GenerateMaterialLines(WO);
                EquipMgt.GenerateEquipment(WO);
            end;
        end;
        // =====================================================
        // 4. SHARED GENERATION
        // =====================================================
        SupplyMgt.GenerateSupplies(WO);
        ProdRelMgt.HandleRoutingChange(WO);
        BCert.GenerateTestResults(WO);
        // =====================================================
        // 5. LABEL REFRESH
        // =====================================================
        if WO."PL Labels Locked" = false then
            LabelMgt.GeneratePLLabels(WO);
    end;

    procedure UpdatePTLotNumbers(var WO: Record "Work Order Header")
    var
        Cert: Record "PT Cert of Analysis Data";
        Pack: Record "Packing List PT Data";
        CIndex: Integer;
        PIndex: Integer;
    begin
        // =====================================================
        // HEADER VALUES ONLY
        // =====================================================
        if (WO."Pedga Mix Date" <> 0D) then
            WO."PEDGA Customer Lot Number" := Format(WO."Pedga Mix Date", 0, '<Year,2><Month,2><Day,2>') + '-PEDGA';
        if (WO."Thiocure Mix Date" <> 0D) then
            WO."THIOCURE Customer Lot Number" := Format(WO."Thiocure Mix Date", 0, '<Year,2><Month,2><Day,2>') + '-TH333';
        // =====================================================
        // PUSH TO CERTIFICATE DATA
        // =====================================================
        Cert.SetRange("Work Order No.", WO."No.");
        if Cert.FindSet() then begin
            CIndex := 1;
            repeat
                if CIndex = 1 then begin
                    Cert."Lot Number" := WO."PEDGA Customer Lot Number";
                    Cert."Mix Date" := WO."Pedga Mix Date";
                end else begin
                    Cert."Lot Number" := WO."THIOCURE Customer Lot Number";
                    Cert."Mix Date" := WO."Thiocure Mix Date";
                end;
                Cert.Modify(false);
                CIndex += 1;
            until Cert.Next() = 0;
        end;
        // =====================================================
        // PUSH TO PACKING DATA
        // =====================================================
        Pack.SetRange("Work Order No.", WO."No.");
        if Pack.FindSet() then begin
            PIndex := 1;
            repeat
                if PIndex = 1 then
                    Pack."Customer Lot Number" := WO."PEDGA Customer Lot Number"
                else
                    Pack."Customer Lot Number" := WO."THIOCURE Customer Lot Number";
                Pack.Modify(false);
                PIndex += 1;
            until Pack.Next() = 0;
        end;
    end;

    local procedure IsPTWorkOrder(WO: Record "Work Order Header"): Boolean
    begin
        exit(
            (WO."PEDGA Part Number" = 'PN-0446') and
            (WO."Thiocure Part Number" = 'PN-0447')
        );
    end;

    local procedure ResolveRouting(var WO: Record "Work Order Header")
    var
        ItemRec: Record Item;
    begin
        if WO."Product Part Number" = '' then
            exit;

        if ItemRec.Get(WO."Product Part Number") then begin
            if (ItemRec."Routing No." <> '') and
               (WO."Routing No." <> ItemRec."Routing No.")
            then
                WO.Validate("Routing No.", ItemRec."Routing No.");
        end;

        ClearFlags(WO);

        SetRoutingFlags(WO);
    end;

    local procedure ClearFlags(var WO: Record "Work Order Header")
    begin
        WO."Show BELZER" := false;
        WO."Show PRINTLABEL" := false;
        WO."Show SUB-OTS" := false;
        WO."Show FILL_SET" := false;
        WO."Show MOON-MNLT" := false;
    end;

    procedure SetRoutingFlags(var WO: Record "Work Order Header")
    begin
        case WO."Routing No." of
            'BELZER':
                WO."Show BELZER" := true;

            'PRINTLABEL':
                WO."Show PRINTLABEL" := true;

            'SUB-OTS':
                WO."Show SUB-OTS" := true;

            'FILL_SET':
                WO."Show FILL_SET" := true;

            'MOON-MNLT':
                WO."Show MOON-MNLT" := true;
        end;
    end;
}