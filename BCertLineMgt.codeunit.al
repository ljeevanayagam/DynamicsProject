codeunit 60009 "Belzer Certificate Mgt"
{
    procedure GenerateTestResults(var WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        DeleteTestResults(WorkOrder."No.");
        if (WorkOrder."Routing No." <> 'BELZER') then
            exit;
        LineNo := 1;
        insertBTestLine(WorkOrder, LineNo, 'Appearance', 'Visual', 'Clear Liquid & No Particulate Matter');
        LineNo += 1;
        insertBTestLine(WorkOrder, LineNo, 'Endotoxin', 'USP <85>', '≤ 0.5 EU/mL');
        LineNo += 1;
        insertBTestLine(WorkOrder, LineNo, 'Sterility', 'USP <71>', 'No Growth');
        LineNo += 1;
        insertBTestLine(WorkOrder, LineNo, 'Particulate', 'USP <788>', '≤ 25 particles per mL ≥ 10 μm');
        LineNo += 1;
        insertBTestLine(WorkOrder, LineNo, 'Particulate', 'USP <788>', '≤ 3 particles per mL ≥ 25 μm');
    end;

    local procedure insertBTestLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        Test: Text[100];
        TestMethod: Text[100];
        Spec: Text[1000]
    )
    var
        BCert: Record "Certificate of Analysis Belzer";
    begin
        BCert.Init();
        BCert."Work Order No." := WorkOrder."No.";
        BCert."Line No." := LineNo;
        BCert.Test := Test;
        Bcert."Test Method" := TestMethod;
        BCert.Specification := Spec;
        BCert.Insert(true);
    end;

    procedure DeleteTestResults(WorkOrderNo: Code[20])
    var
        BCert: Record "Certificate of Analysis Belzer";
    begin
        BCert.SetRange("Work Order No.", WorkOrderNo);
        if BCert.FindSet() then
            BCert.DeleteAll();
    end;
}