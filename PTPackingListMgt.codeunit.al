codeunit 60015 "PT Packing List Mgt"
{
    procedure GeneratePTPacking(var WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        DeleteTestResults(WorkOrder."No.");
        if (WorkOrder."PEDGA Part Number" <> 'PN-0446') or (WorkOrder."Thiocure Part Number" <> 'PN-0447') then
            exit;
        LineNo := 1;
        insertPTestLine(WorkOrder, LineNo, WorkOrder."PEDGA Part Number", WorkOrder."PEDGA Customer Lot Number", WorkOrder."PEDGA Description", WorkOrder."QA Released QTY");
        LineNo += 1;
        insertPTestLine(WorkOrder, LineNo, WorkOrder."Thiocure Part Number", WorkOrder."THIOCURE Customer Lot Number", WorkOrder."THIOCURE Description", WorkOrder."QA Released QTY");
    end;

    local procedure insertPTestLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        BCPart: Text[20];
        CustomerLot: Code[250];
        Description: Text[500];
        Quantity: Integer
    )
    var
        PTPack: Record "Packing List PT Data";
    begin
        PTPack.Init();
        PTPack."Work Order No." := WorkOrder."No.";
        PTPack."Line No." := LineNo;
        PTPack."Part Number" := BCPart;
        PTPack."Customer Lot Number" := CustomerLot;
        PTPack.Description := Description;
        PTPack.Quantity := Quantity;
        PTPack.Insert(true);
    end;

    procedure DeleteTestResults(WorkOrderNo: Code[20])
    var
        PTCert: Record "Packing List PT Data";
    begin
        PTCert.SetRange("Work Order No.", WorkOrderNo);
        if PTCert.FindSet() then
            PTCert.DeleteAll();
    end;
}