codeunit 50110 "PermissionHelper"
{
    Permissions =
        tabledata "Purchase Line" = RIMD,
        tabledata "Purchase Header" = RIMD,
        tabledata Vendor = RIMD,
        tabledata Item = RIMD;

    procedure ModifyPurchaseLine(var PurchLine: Record "Purchase Line")
    begin
        PurchLine.Modify(true);
    end;
}