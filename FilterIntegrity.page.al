page 60102 "Filter Integrity Test"
{
    PageType = ListPart;
    SourceTable = "Filter Integrity";
    ApplicationArea = All;
    Editable = true;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Step #"; Rec."Step #") { }
                field("Filter #"; Rec."Filter #") { }
                field("MPI-0116 Test Procedure Result"; Rec."MPI-0116 Test Procedure Result") { }
                field("Bubble Point Pressure Verify"; Rec."Bubble Point Pressure Verify") { }
            }
            field("Performed By"; Rec."Performed By") { }
            field(Date; Rec.Date) { }

        }
    }
}