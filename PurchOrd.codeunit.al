codeunit 50103 "Purchase Line Numbering"
{
    Permissions =
        tabledata "Purchase Line" = RIMD;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line",
                 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertPurchaseLine(var Rec: Record "Purchase Line")
    begin
        if Rec."Document No." <> '' then
            RenumberItemLines(Rec."Document No.");
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line",
                    'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeletePurchaseLine(var Rec: Record "Purchase Line")
    begin
        if Rec."Document No." <> '' then
            RenumberItemLines(Rec."Document No.");
    end;

    procedure RenumberItemLines(PurchaseOrderNo: Code[20])
    var
        IsRenumbering: Boolean;
        PurchLine: Record "Purchase Line";
        Counter: Integer;
    begin

        if IsRenumbering then
            exit;

        IsRenumbering := true;

        PurchLine.SetRange("Document No.", PurchaseOrderNo);

        if PurchLine.FindSet(true) then begin
            repeat
                if PurchLine.Type = PurchLine.Type::Item then begin
                    Counter += 1;

                    if PurchLine."ItemLineNo" <> Counter then begin
                        PurchLine."ItemLineNo" := Counter;
                        PurchLine.Modify(false);
                    end;

                end else begin
                    if PurchLine."ItemLineNo" <> 0 then begin
                        PurchLine."ItemLineNo" := 0;
                        PurchLine.Modify(false);
                    end;
                end;

            until PurchLine.Next() = 0;
        end;

        IsRenumbering := false;
    end;
}