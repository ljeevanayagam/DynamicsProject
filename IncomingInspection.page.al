page 50100 "Incoming Inspection"
{
    PageType = List;
    SourceTable = "Inspection Header";
    ApplicationArea = All;
    Caption = 'Incoming Inspection';
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Inspection No."; Rec."Inspection No.")
                {
                    ApplicationArea = All;
                }

                field("Date Received"; Rec."Date Received") { }
                field("Purchase Order No."; Rec."Purchase Order No.") { }
                field("Vendor Name"; Rec."Vendor Name") { }
                field("Item No."; Rec."Item No.") { }
                field("Item Description"; Rec."Item Description") { }
                field("Lot No."; Rec."Lot No.") { }
                field("Serial No."; Rec."Serial No.") { }
                field(Quantity; Rec.Quantity) { }
                field("Received By"; Rec."Received By") { }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }

                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}