codeunit 50105 "Purch Dates Mgmt"
{
    Permissions =
        tabledata "Purchase Header" = RIMD,
        tabledata "Purchase Line" = RIMD;

    procedure CalculateDates(var PurchHeader: Record "Purchase Header")
    var
        PaymentTerms: Record "Payment Terms";
        ExpRecDate: Date;
        DueDateControl: Codeunit "Purch Due Date Control";
    begin
        if PurchHeader."Document Date" = 0D then exit;
        if PurchHeader."Payment Terms Code" = '' then exit;

        if PaymentTerms.Get(PurchHeader."Payment Terms Code") then begin
            ExpRecDate := CalcDate(PaymentTerms."Due Date Calculation", PurchHeader."Document Date");

            DueDateControl.Enable();
            PurchHeader.Validate("Expected Receipt Date", ExpRecDate);
            PurchHeader.Validate("Due Date", ExpRecDate);
            DueDateControl.Disable();
        end;
    end;
}