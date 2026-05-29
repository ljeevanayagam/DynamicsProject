codeunit 60014 "PT Certification Mgt"
{
    procedure GenerateTestResults(var WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        DeleteTestResults(WorkOrder."No.");
        if (WorkOrder."PEDGA Part Number" <> 'PN-0446') or (WorkOrder."Thiocure Part Number" <> 'PN-0447') then
            exit;
        // HARD GUARD: system contract
        if not WorkOrder.IsPTReady() then
            exit;

        LineNo := 10000;
        InsertTestLine(WorkOrder, LineNo, Enum::"PT Component"::PEDGA);

        LineNo += 10000;
        InsertTestLine(WorkOrder, LineNo, Enum::"PT Component"::THIOCURE);
    end;

    local procedure InsertTestLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        Component: Enum "PT Component")
    var
        PTCert: Record "PT Cert of Analysis Data";
    begin
        PTCert.Init();
        PTCert."Work Order No." := WorkOrder."No.";
        PTCert."Line No." := LineNo;
        PTCert.Component := Component;

        case Component of
            Component::PEDGA:
                begin
                    PTCert."BioCure Part No." := WorkOrder."PEDGA Part Number";
                    PTCert."CQ Medical Item No." := '030264';
                    PTCert.Description := WorkOrder."PEDGA Description";
                    PTCert."Lot Number" := WorkOrder."PEDGA Customer Lot Number";
                    PTCert."Mix Date" := WorkOrder."Pedga Mix Date";
                end;

            Component::THIOCURE:
                begin
                    PTCert."BioCure Part No." := WorkOrder."Thiocure Part Number";
                    PTCert."CQ Medical Item No." := '029724';
                    PTCert.Description := WorkOrder."THIOCURE Description";
                    PTCert."Lot Number" := WorkOrder."THIOCURE Customer Lot Number";
                    PTCert."Mix Date" := WorkOrder."Thiocure Mix Date";
                end;
        end;

        PTCert."QTY Shipped" := WorkOrder."QA Released QTY";
        PTCert.Insert(true);
    end;

    procedure DeleteTestResults(WorkOrderNo: Code[20])
    var
        PTCert: Record "PT Cert of Analysis Data";
    begin
        PTCert.SetRange("Work Order No.", WorkOrderNo);
        PTCert.DeleteAll();
    end;
}