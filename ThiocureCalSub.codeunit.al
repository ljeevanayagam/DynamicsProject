codeunit 60019 "Thiocure Recalc Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Thiocure Materials Header",
                     'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterThiocureModify(var Rec: Record "Thiocure Materials Header"; var xRec: Record "Thiocure Materials Header"; RunTrigger: Boolean)
    var
        Calc: Codeunit "Thiocure Calculation Mgt";
    begin
        if Rec."Work Order No." = '' then
            exit;

        Calc.RecalculateThiocure(Rec."Work Order No.");
    end;
}