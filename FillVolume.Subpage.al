page 60101 "Fill Volume Subpage"
{
    PageType = ListPart;
    SourceTable = "Fill Volume Line";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Bulk Solution Serial No."; Rec."Bulk Solution Serial No.") { }
                field("Bag #"; Rec."Bag #") { }
                field("Bag Wt (g)"; Rec."Bag Wt (g)") { }
                field("Weight Verification"; Rec."Weight Verification") { }
            }
            field("Performed By"; Rec."Performed By") { }
            field(Date; Rec.Date) { }
        }
    }
}