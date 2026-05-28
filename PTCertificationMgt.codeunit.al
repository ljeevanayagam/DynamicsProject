codeunit 60014 "PT Certification Mgt"
{
    procedure GenerateTestResults(var WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        DeleteTestResults(WorkOrder."No.");
        if (WorkOrder."PEDGA Part Number" <> 'PN-0446') or (WorkOrder."Thiocure Part Number" <> 'PN-0447') then
            exit;
        LineNo := 1;
        insertPTestLine(WorkOrder, LineNo, WorkOrder."PEDGA Part Number", '030264', WorkOrder."PEDGA Description", WorkOrder."PEDGA Customer Lot Number", WorkOrder."Pedga Mix Date", WorkOrder."QA Released QTY");
        LineNo += 1;
        insertPTestLine(WorkOrder, LineNo, WorkOrder."Thiocure Part Number", '029724', WorkOrder."THIOCURE Description", WorkOrder."THIOCURE Customer Lot Number", WorkOrder."Thiocure Mix Date", WorkOrder."QA Released QTY");
    end;

    local procedure insertPTestLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        BCPart: Text[20];
        CQItem: Text[100];
        Description: Text[250];
        CustomerLot: Code[500];
        MixDate: Date;
        QTY: Integer
    )
    var
        PTCert: Record "PT Cert of Analysis Data";
    begin
        PTCert.Init();
        PTCert."Work Order No." := WorkOrder."No.";
        PTCert."Line No." := LineNo;
        PTCert."BioCure Part No." := BCPart;
        PTCert."CQ Medical Item No." := CQItem;
        PTCert.Description := Description;
        PTCert."Lot Number" := CustomerLot;
        PTCert."Mix Date" := MixDate;
        PTCert."QTY Shipped" := QTY;
        PTCert.Insert(true);
    end;

    procedure DeleteTestResults(WorkOrderNo: Code[20])
    var
        PTCert: Record "PT Cert of Analysis Data";
    begin
        PTCert.SetRange("Work Order No.", WorkOrderNo);
        if PTCert.FindSet() then
            PTCert.DeleteAll();
    end;
}