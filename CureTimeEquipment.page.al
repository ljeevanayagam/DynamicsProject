page 60509 "Cure Time Equipment Page"
{
    PageType = ListPart;
    SourceTable = "Cure Time Equipment Header";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(CTEquipment)
            {
                field("Equipment Description"; Rec."Equipment Description") { }
                field("EQ#/Part Number"; Rec."EQ#/Part Number") { }
                field("EQ#/Cal. ID/Equivalent used"; Rec."EQ#/Cal. ID/Equivalent used") { }
                field("Equipment Parameters"; Rec."Equipment Parameters") { }
                field("Equipment Performed By"; Rec."Equipment Performed By")
                {
                    Caption = 'Performed By';
                }
                field("Equipment Performed Date"; Rec."Equipment Performed Date")
                {
                    Caption = 'Date';
                }
            }
        }
    }
}