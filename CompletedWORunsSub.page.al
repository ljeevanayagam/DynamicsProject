page 50102 "Completed WO Runs Subpage"
{
    PageType = ListPart;
    SourceTable = "Completed Work Order Run";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Run No."; Rec."Run No.") { }
                field("Accepted Quantity"; Rec."Accepted Quantity") { }
                field("Posted Date"; Rec."Posted Date") { }
            }
        }
    }
}