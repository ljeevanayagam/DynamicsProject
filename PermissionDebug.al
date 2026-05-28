codeunit 50111 "Permission Debug"
{
    Permissions = tabledata "Purchase Line" = RIMD;

    procedure Test()
    var
        LineRec: Record "Purchase Line";
    begin
        if LineRec.FindFirst() then
            Message('You have modify permission on Purchase Line!');
    end;
}