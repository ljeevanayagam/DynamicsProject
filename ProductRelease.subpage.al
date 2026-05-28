page 60106 "Product Release Subpage"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Product Release Item";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Checklist Item"; Rec."Checklist Item")
                {
                    Editable = false; // text read-only
                }

                field(Status; Rec.Status)
                {
                    Editable = true; // Status is editable
                }

            }
        }
    }
    trigger OnModifyRecord(): Boolean
    var
        WorkOrder: Record "Work Order Header";
    begin
        if WorkOrder.Get(Rec."Work Order No.") then begin
            WorkOrder.UpdateStatus();
            WorkOrder.Modify(true);
        end;

        CurrPage.Update(false);
        exit(true);
    end;
}