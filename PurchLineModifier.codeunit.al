codeunit 50109 "Purchase Line Modifier"
{
    Permissions = tabledata "Purchase Line" = RIMD;

    procedure ModifyLine(var PurchLine: Record "Purchase Line")
    begin
        PurchLine.Modify(true);
    end;
}