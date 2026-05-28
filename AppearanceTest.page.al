page 60103 "Appearance Test"
{
    PageType = ListPart;
    SourceTable = "Appearance Test Header";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group("Appearance Test")
            {
                repeater(Group)
                {
                    field("Sample #"; Rec."Sample #") { }
                    field(Parameter; Rec.Parameter) { }
                    field("Appearance Test Specification"; Rec."Appearance Test Specification") { }

                    field("Appearance Verification"; Rec."Appearance Verification")
                    {
                        Caption = 'Verification';
                    }
                }

                field("Appearance Comments"; Rec."Appearance Comments") { }
                field("Appearance Performed By"; Rec."Appearance Performed By") { }
                field("Appearance Date"; Rec."Appearance Date") { }
            }
        }
    }
}