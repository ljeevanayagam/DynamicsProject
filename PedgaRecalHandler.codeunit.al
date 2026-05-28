codeunit 60016 "Pedga Calculation Mgt"
{
    procedure RecalculateIfNeeded(WorkOrderNo: Code[50])
    var
        WO: Record "Work Order Header";
    begin
        if not WO.Get(WorkOrderNo) then
            exit;
        if not WO."Pedga Recalc Required" then
            exit;
        RecalculatePedga(WorkOrderNo);
        WO."Pedga Recalc Required" := false;
        WO.Modify(true);
    end;

    procedure RecalculatePedga(WorkOrderNo: Code[50])
    var
        Line: Record "Pedga Materials Header";
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
                if Line."Line No." in [40001, 40002] then
                    TotalCalcQty += Line."Calculated Quantity";
            until Line.Next() = 0;

        // 🔥 SINGLE SOURCE OF TRUTH
        WO."Pedga Qty release inspection" := TotalCalcQty - 10;

        WO."Pedga total qty further proc" :=
            WO."Pedga Qty release inspection"
            - WO."Pedga rejected Qty";

        WO.Modify(true);
    end;
}