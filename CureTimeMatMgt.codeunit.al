codeunit 60013 "Cure Time Materials Mgt"
{
    procedure GenerateCTMaterials(var WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        if (WorkOrder."PEDGA Part Number" <> 'PN-0446') or
           (WorkOrder."Thiocure Part Number" <> 'PN-0447') then
            exit;

        DeleteTestResults(WorkOrder."No.");

        LineNo := 1;
        InsertCTMaterialLine(WorkOrder, LineNo,
            WorkOrder."PEDGA Part Number",
            WorkOrder."PEDGA Description",
            3, 'EA');

        LineNo += 1;

        InsertCTMaterialLine(WorkOrder, LineNo,
            WorkOrder."Thiocure Part Number",
            WorkOrder."THIOCURE Description",
            3, 'EA');

        WorkOrder."CT Materials Generated" := true;
        WorkOrder.Modify(false);
    end;

    local procedure InsertCTMaterialLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        PartNo: Code[20];
        Desc: Text[250];
        Qty: Integer;
        UOM: Code[20])
    var
        CT: Record "Cure Time Materials Header";
    begin
        CT.Init();
        CT."Work Order No." := WorkOrder."No.";
        CT."CT Material Line No." := LineNo;
        CT."Item No." := PartNo;
        CT."Item Description" := Desc;
        CT."Unit Qty" := Qty;
        CT.UOM := UOM;
        CT.Insert();
    end;

    procedure DeleteTestResults(WorkOrderNo: Code[20])
    var
        CTT: Record "Cure Time Materials Header";
    begin
        CTT.SetRange("Work Order No.", WorkOrderNo);
        CTT.DeleteAll();
    end;
}