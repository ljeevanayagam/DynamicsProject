codeunit 50107 "Purch Due Date Control"
{
    Permissions =
        tabledata "Purchase Header" = RIMD,
        tabledata "Purchase Line" = RIMD;

    SingleInstance = true;

    var
        AllowDueDateChange: Boolean;

    procedure Enable()
    begin
        AllowDueDateChange := true;
    end;

    procedure Disable()
    begin
        AllowDueDateChange := false;
    end;

    procedure IsAllowed(): Boolean
    begin
        exit(AllowDueDateChange);
    end;
}