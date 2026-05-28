page 60508 "Cure Time Materials"
{
    PageType = ListPart;
    SourceTable = "Cure Time Materials Header";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(CTMaterials)
            {
                field("CT Material Line No."; Rec."CT Material Line No.")
                {
                    Caption = 'Line No.';
                }
                field("Item No."; Rec."Item No.") { }
                field("Item Description"; Rec."Item Description") { }
                field(Verification; Rec.Verification) { }
                field("Lot No."; Rec."Lot No.") { }
                field("Unit Qty"; Rec."Unit Qty") { }
                field(UOM; Rec.UOM) { }
                field("Materials Performed By"; Rec."Materials Performed By")
                {
                    Caption = 'Performed By';
                }
                field("Materials Performed Date"; Rec."Materials Performed Date")
                {
                    Caption = 'Date';
                }
            }
        }
    }
}