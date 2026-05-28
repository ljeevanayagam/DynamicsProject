codeunit 60012 "Cure Time Equipment Mgt"
{
    procedure GenerateCTEqupment(var WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        if (WorkOrder."PEDGA Part Number" <> 'PN-0446') or
           (WorkOrder."Thiocure Part Number" <> 'PN-0447') then
            exit;

        // ALWAYS rebuild safely
        DeleteTestResults(WorkOrder."No.");

        LineNo := 1;
        InsertCTEquipmentLine(WorkOrder, LineNo, 'Stir Plate', 'EQ-00052', 'Speed Dial Position 4, Estimated Speed 120 rpm');
        LineNo += 1;
        InsertCTEquipmentLine(WorkOrder, LineNo, 'Stir Bar', 'PRT-0553-01', '');
        LineNo += 1;
        InsertCTEquipmentLine(WorkOrder, LineNo, 'Beaker, 100 mL', '', '');
        LineNo += 1;
        InsertCTEquipmentLine(WorkOrder, LineNo, 'Timer', 'C-0057', '');
        LineNo += 1;
        InsertCTEquipmentLine(WorkOrder, LineNo, 'Spatula', '', '');

        WorkOrder."CT Equipment Generated" := true;
        WorkOrder.Modify(false);
    end;

    local procedure InsertCTEquipmentLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        EqDes: Text;
        EQID: Text;
        Param: Text)
    var
        CT: Record "Cure Time Equipment Header";
    begin
        CT.Init();
        CT."Work Order No." := WorkOrder."No.";
        CT."CT Equipment Line No." := LineNo;
        CT."Equipment Description" := EqDes;
        CT."EQ#/Part Number" := EQID;
        CT."Equipment Parameters" := Param;
        CT.Insert();
    end;

    procedure DeleteTestResults(WorkOrderNo: Code[20])
    var
        CTT: Record "Cure Time Equipment Header";
    begin
        CTT.SetRange("Work Order No.", WorkOrderNo);
        CTT.DeleteAll();
    end;
}