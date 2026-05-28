page 60503 "Pedga Equipment Used page"
{
    PageType = ListPart;
    SourceTable = "Pedga Equipment Used";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Equipment Description"; Rec."Equipment Description")
                {
                    Editable = false;
                }
                field("EQ#, Cal. ID or Equivalent"; Rec."EQ#, Cal. ID or Equivalent")
                {
                    Editable = false;
                }
                field("EQ#/Cal. ID/Equivalent used"; Rec."EQ#/Cal. ID/Equivalent used") { }
                field("Eqpt Parameters/accpt criteria"; Rec."Eqpt Parameters/accpt criteria") { }
                field("Performed By"; Rec."Performed By") { }
                field(Date; Rec.Date) { }
            }
        }
    }
}