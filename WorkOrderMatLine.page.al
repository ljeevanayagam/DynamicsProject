page 60003 "Materials Subpage"
{
    PageType = ListPart;
    SourceTable = "Work Order Material Line";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.") { Editable = false; }
                field("Item No."; Rec."Item No.")
                {
                    TableRelation = Item;
                }
                field("Item Description"; Rec."Item Description") { Editable = false; }
                field("Part No."; Rec."Part No.")
                {

                }
                field("Lot No."; Rec."Lot No.")
                {
                }
                field("Expiration Date"; Rec."Expiration Date") { }
                field(Verification; Rec.Verification)
                {
                }
                field("Unit Quantity"; Rec."Unit Quantity") { }
                field("Unit of Measure"; Rec."Unit of Measure") { Editable = false; }
                field("Calculated Quantity"; Rec."Calculated Quantity")
                {
                }
                field("Performed By"; Rec."Performed By") { }
                field("Performed Date"; Rec."Performed Date") { }
                field("Verified By"; Rec."Verified By") { }
                field("Verification Date"; Rec."Verification Date") { }
            }
        }
    }
}