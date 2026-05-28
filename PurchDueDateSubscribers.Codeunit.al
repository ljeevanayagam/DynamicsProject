codeunit 50104 "Purch Dates Subscribers"
{
    Permissions =
        tabledata "Purchase Header" = RIMD,
        tabledata "Purchase Line" = RIMD;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header",
                     'OnAfterValidateEvent', 'Document Date', false, false)]
    local procedure OnDocumentDateChanged(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        DatesMgmt: Codeunit "Purch Dates Mgmt";
    begin
        DatesMgmt.CalculateDates(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header",
                     'OnAfterValidateEvent', 'Payment Terms Code', false, false)]
    local procedure OnPaymentTermsChanged(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        DatesMgmt: Codeunit "Purch Dates Mgmt";
    begin
        DatesMgmt.CalculateDates(Rec);
    end;
}