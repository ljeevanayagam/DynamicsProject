codeunit 60018 "Thiocure Calculation Mgt"
{
    procedure RecalculateIfNeeded(WorkOrderNo: Code[50])
    var
        WO: Record "Work Order Header";
    begin
        if not WO.Get(WorkOrderNo) then
            exit;
        if not WO."Thiocure Recalc Required" then
            exit;
        RecalculateThiocure(WorkOrderNo);
        WO."Thiocure Recalc Required" := false;
        WO.Modify(true);
    end;

    procedure RecalculateThiocure(WorkOrderNo: Code[50])
    var
        Line: Record "Thiocure Materials Header";
        WO: Record "Work Order Header";
        TotalCalcQty: Decimal;
    begin
        if WorkOrderNo = '' then
            exit;

        if not WO.Get(WorkOrderNo) then
            exit;

        TotalCalcQty := 0;

        Line.SetRange("Work Order No.", WorkOrderNo);

        if Line.FindSet() then
            repeat
                if Line."Line No." in [50001, 50002] then
                    TotalCalcQty += Line."Calculated Quantity";
            until Line.Next() = 0;

        // MAIN CALCULATION
        WO."TH333 Qty release inspection" := TotalCalcQty - 10;

        WO."TH333 total qty further proc" :=
            WO."TH333 Qty release inspection"
            - WO."Thiocure rejected qty";

        WO.Modify(true);
    end;
}