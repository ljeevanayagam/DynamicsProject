codeunit 50108 "Purch.-Post Event Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchLine', '', false, false)]
    local procedure OnBeforePostPurchLine(
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        var IsHandled: Boolean)
    begin
        // Intentionally left blank.
        // Inspection lines are generated manually using the
        // "Generate Inspection Lines" button.
    end;

}