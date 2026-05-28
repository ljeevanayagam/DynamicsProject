codeunit 60020 "Work Order Validation Mgt"
{
    procedure ValidateRoundedWeight(
        Expected: Decimal;
        Actual: Decimal;
        FieldCaption: Text)
    begin
        if Actual < 0 then
            Error('%1 must not be negative.', FieldCaption);

        if Round(Expected, 1) <> Round(Actual, 1) then
            Error(
                '%1 mismatch. Expected %2 but got %3.',
                FieldCaption,
                Round(Expected, 1),
                Round(Actual, 1));
    end;
}