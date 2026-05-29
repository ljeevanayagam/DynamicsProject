codeunit 60112 "Work Order Orchestrator"
{
    procedure HandleRoutingChange(var WO: Record "Work Order Header")
    begin
        if WO."No." = '' then
            exit;
        if WO."Product Part Number" = '' then
            exit;
        if WO."PT Update In Progress" then
            exit;
        SetUpdateFlag(WO, true);
        RunAllPhases(WO);
        SetUpdateFlag(WO, false);
        WO.Modify(true);
        Commit();
    end;

    local procedure RunAllPhases(var WO: Record "Work Order Header")
    begin
        RunRoutingPhase(WO);
        RunCalculationPhase(WO);
        RunGenerationPhase(WO);
        RunFinalizationPhase(WO);
    end;

    local procedure SetUpdateFlag(var WO: Record "Work Order Header"; Value: Boolean)
    begin
        WO."PT Update In Progress" := Value;
    end;

    local procedure RunRoutingPhase(var WO: Record "Work Order Header")
    var
        ItemRec: Record Item;
    begin
        if WO."Product Part Number" = '' then
            exit;
        if ItemRec.Get(WO."Product Part Number") then
            if (ItemRec."Routing No." <> '') and
               (WO."Routing No." <> ItemRec."Routing No.") then
                WO.Validate("Routing No.", ItemRec."Routing No.");

        ClearFlags(WO);
    end;

    local procedure RunCalculationPhase(var WO: Record "Work Order Header")
    var
        CTEquip: Codeunit "Cure Time Equipment Mgt";
        CTMat: Codeunit "Cure Time Materials Mgt";
    begin
        if not WO.IsPTReady() then
            exit;
        WO.RecalculatePT();
        WO.UpdateQAReleasedQty();
        UpdatePTLotNumbers(WO);
        CTEquip.GenerateCTEqupment(WO);
        CTMat.GenerateCTMaterials(WO);
    end;

    local procedure RunGenerationPhase(var WO: Record "Work Order Header")
    var
        BOMMgt: Codeunit "Work Order BOM Mgt";
        EquipMgt: Codeunit "Equipment Line Mgt";
        SupplyMgt: Codeunit "Operational Supply Mgt";
        ProdRelMgt: Codeunit "Product Release Mgt";
        BCert: Codeunit "Belzer Certificate Mgt";
        PCert: Codeunit "PT Certification Mgt";
        PTPack: Codeunit "PT Packing List Mgt";
    begin
        if WO.IsPTReady() then begin
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

        SupplyMgt.GenerateSupplies(WO);
        ProdRelMgt.HandleRoutingChange(WO);
        BCert.GenerateTestResults(WO);
    end;

    local procedure RunFinalizationPhase(var WO: Record "Work Order Header")
    var
        LabelMgt: Codeunit "Work Order Label Mgt";
    begin
        if not WO."PL Labels Locked" then
            LabelMgt.GeneratePLLabels(WO);

        SetRoutingFlags(WO);
    end;

    procedure UpdatePTLotNumbers(var WO: Record "Work Order Header")
    begin
        if WO."Pedga Mix Date" <> 0D then
            WO."PEDGA Customer Lot Number" :=
                Format(WO."Pedga Mix Date", 0, '<Year,2><Month,2><Day,2>') + '-PEDGA';

        if WO."Thiocure Mix Date" <> 0D then
            WO."THIOCURE Customer Lot Number" :=
                Format(WO."Thiocure Mix Date", 0, '<Year,2><Month,2><Day,2>') + '-TH333';
    end;

    procedure GetPTLotNumberByComponent(Component: Enum "PT Component"; WO: Record "Work Order Header"): Code[50]
    begin
        case Component of
            Component::PEDGA:
                if WO."Pedga Mix Date" <> 0D then
                    exit(Format(WO."Pedga Mix Date", 0, '<Year,2><Month,2><Day,2>') + '-PEDGA');

            Component::THIOCURE:
                if WO."Thiocure Mix Date" <> 0D then
                    exit(Format(WO."Thiocure Mix Date", 0, '<Year,2><Month,2><Day,2>') + '-TH333');
        end;
    end;

    procedure GetPTMixDateByComponent(Component: Enum "PT Component"; WO: Record "Work Order Header"): Date
    begin
        case Component of
            Component::PEDGA:
                exit(WO."Pedga Mix Date");

            Component::THIOCURE:
                exit(WO."Thiocure Mix Date");
        end;
    end;

    local procedure ClearFlags(var WO: Record "Work Order Header")
    begin
        WO."Show BELZER" := false;
        WO."Show PRINTLABEL" := false;
        WO."Show SUB-OTS" := false;
        WO."Show FILL_SET" := false;
        WO."Show MOON-MNLT" := false;
    end;

    local procedure SetRoutingFlags(var WO: Record "Work Order Header")
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

    procedure RunFullPTGeneration(var WO: Record "Work Order Header")
    begin
        UpdatePTLotNumbers(WO);

        HandleRoutingChange(WO);

        WO.RefreshMaterialAndLabels();

        if WO."Requires Product Release" then
            Codeunit.Run(Codeunit::"Product Release Mgt");
    end;

    procedure ProcessPTIfRequired(var WO: Record "Work Order Header")
    begin
        if not WO."PT Update Required" then
            exit;

        WO."PT Update Required" := false;
        WO.Modify(false);

        RunFullPTGeneration(WO);
    end;
}