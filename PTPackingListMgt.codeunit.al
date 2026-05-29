codeunit 60015 "PT Packing List Mgt"
{
    procedure GeneratePTPacking(var WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        DeletePTPackingLines(WorkOrder."No.");
        // 🔥 HARD GUARD: prevent partial PT execution
        if (WorkOrder."PEDGA Part Number" <> 'PN-0446') or (WorkOrder."Thiocure Part Number" <> 'PN-0447') then
            exit;

        // System contract check
        if not WorkOrder.IsPTReady() then
            exit;

        LineNo := 10000;
        InsertPackingLine(WorkOrder, LineNo, Enum::"PT Component"::PEDGA);

        LineNo += 10000;
        InsertPackingLine(WorkOrder, LineNo, Enum::"PT Component"::THIOCURE);
    end;

    local procedure InsertPackingLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        Component: Enum "PT Component")
    var
        PTPack: Record "Packing List PT Data";
    begin
        PTPack.Init();
        PTPack."Work Order No." := WorkOrder."No.";
        PTPack."Line No." := LineNo;
        PTPack.Component := Component;

        case Component of
            Component::PEDGA:
                begin
                    PTPack."Part Number" := WorkOrder."PEDGA Part Number";
                    PTPack."Customer Lot Number" := WorkOrder."PEDGA Customer Lot Number";
                    PTPack.Description := WorkOrder."PEDGA Description";
                end;

            Component::THIOCURE:
                begin
                    PTPack."Part Number" := WorkOrder."Thiocure Part Number";
                    PTPack."Customer Lot Number" := WorkOrder."THIOCURE Customer Lot Number";
                    PTPack.Description := WorkOrder."THIOCURE Description";
                end;
        end;

        PTPack.Quantity := WorkOrder."QA Released QTY";
        PTPack.Insert(true);
    end;

    procedure DeletePTPackingLines(WorkOrderNo: Code[20])
    var
        PTPack: Record "Packing List PT Data";
    begin
        PTPack.SetRange("Work Order No.", WorkOrderNo);
        PTPack.DeleteAll();
    end;
}