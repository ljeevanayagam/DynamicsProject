page 60104 "Particulate Test"
{
    PageType = ListPart;
    SourceTable = "Particulate Test Header";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group("Particulate Test")
            {
                field("List of Samples"; Rec."List of Samples")
                {
                    Editable = false;
                }
                field("Particulate Testing Test 1"; Rec."Particulate Testing Test 1") { }
                field("Particulate Testing Test 2"; Rec."Particulate Testing Test 2") { }
                field("Particulate Comments"; Rec."Particulate Comments") { }
                field("Particulate Performed By"; Rec."Particulate Performed By") { }
                field("Particulate Date"; Rec."Particulate Date") { }
            }
        }
    }
}