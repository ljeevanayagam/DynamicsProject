page 50101 "Completed Inspections"
{
    PageType = List;
    SourceTable = "Inspection Header Completed";
    ApplicationArea = All;
    Caption = 'Completed Inspections';
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Inspection No."; Rec."Inspection No.") { }
                field("Date Received"; Rec."Date Received") { }
                field("Purchase Order No."; Rec."Purchase Order No.") { }
                field("Lot No."; Rec."Lot No.") { }
                field("Vendor Name"; Rec."Vendor Name") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Description"; Rec."Item Description") { }
                field(Quantity; Rec.Quantity) { }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Received By"; Rec."Received By") { }
                field(Notes; Rec.Notes) { }
            }
        }
    }
}