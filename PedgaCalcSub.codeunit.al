codeunit 60017 "Pedga Recalc Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Pedga Materials Header",
                     'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterPedgaModify(var Rec: Record "Pedga Materials Header"; var xRec: Record "Pedga Materials Header"; RunTrigger: Boolean)
    var
        Calc: Codeunit "Pedga Calculation Mgt";
    begin
        if Rec."Work Order No." = '' then
            exit;

        Calc.RecalculatePedga(Rec."Work Order No.");
    end;
}