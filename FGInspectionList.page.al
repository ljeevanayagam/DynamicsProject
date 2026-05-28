page 61000 "FG Inspection List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Work Order Header";
    Caption = 'FG Inspection';
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { }
                // field(Revision; Rec.Revision) { }
                // field("Lot Quantity"; Rec."Lot Quantity") { }
                // field("Product Part Number"; Rec."Product Part Number") { }
                // field("Product Description"; Rec."Product Description") { }

            }
        }
    }
}