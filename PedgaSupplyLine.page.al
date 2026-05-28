page 60502 "PEDGA Operational Page"
{
    PageType = ListPart;
    SourceTable = "Pedga Operational Header";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."Line No.") { Editable = false; }
                field("Item No."; Rec."Item No.") { Editable = false; }
                field("Item Description"; Rec."Item Description") { Editable = false; }
                field("Lot No."; Rec."Lot No.") { }
                field(Verification; Rec.Verification) { }
                field("Unit Quantity"; Rec."Unit Quantity") { Editable = false; }
                field("Unit of Measure"; Rec."Unit of Measure") { Editable = false; }
                field("Performed By"; Rec."Performed By") { }
                field(Date; Rec.Date) { }
            }
        }
    }
}