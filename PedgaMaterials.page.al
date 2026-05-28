page 60501 "Pedga Materials Page"
{
    PageType = ListPart;
    SourceTable = "Pedga Materials Header";
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
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = VerificationEditable;
                }
                field(Verification; Rec.Verification)
                {
                    Editable = VerificationEditable;
                }
                field("Unit Quantity"; Rec."Unit Quantity") { }
                field("Unit of Measure"; Rec."Unit of Measure") { Editable = false; }
                field("Calculated Quantity"; Rec."Calculated Quantity") { }
                field("Performed By"; Rec."Performed By") { }
                field("Performed Date"; Rec."Performed Date") { }
                field("Verified By"; Rec."Verified By") { }
                field("Verification Date"; Rec."Verification Date") { }
            }
        }
    }
    var
        VerificationEditable: Boolean;

    trigger OnAfterGetRecord()
    begin
        VerificationEditable := not (Rec."Line No." in [80001, 90001]);
    end;
}