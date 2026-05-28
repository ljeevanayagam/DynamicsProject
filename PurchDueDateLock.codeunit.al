codeunit 50106 "Purch Due Date Lock"
{
    Permissions =
        tabledata "Purchase Header" = RIMD,
        tabledata "Purchase Line" = RIMD;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header",
                     'OnBeforeValidateEvent', 'Due Date', false, false)]
    local procedure PreventManualDueDateChange(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    var
        DueDateControl: Codeunit "Purch Due Date Control";
    begin
        if DueDateControl.IsAllowed() then exit;

        if CurrFieldNo <> 0 then
            if Rec."Due Date" <> xRec."Due Date" then
                Error('Due Date is calculated automatically and cannot be edited.');
    end;
}