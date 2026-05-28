page 60504 "Thiocure Materials Page"
{
    PageType = ListPart;
    SourceTable = "Thiocure Materials Header";
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
                    ApplicationArea = All;
                    Editable = lotNoEditable;
                }
                field(Verification; Rec.Verification) { Editable = LotNoEditable; }
                field("Unit Quantity"; Rec."Unit Quantity") { }
                field("Unit of Measure"; Rec."Unit of Measure") { Editable = false; }
                field("Calculated Quantity"; Rec."Calculated Quantity")
                {
                    ApplicationArea = All;
                    Editable = CalcQtyEditable;
                }
                field("Performed By"; Rec."Performed By") { }
                field("Performed Date"; Rec."Performed Date") { }
                field("Verified By"; Rec."Verified By") { }
                field("Verification Date"; Rec."Verification Date") { }
            }
        }
    }
    var
        CalcQtyEditable: Boolean;
        LotNoEditable: Boolean;
        VerificationEditable: Boolean;

    trigger OnAfterGetRecord()
    begin
        CalcQtyEditable := Rec."Line No." < 60001; // initially 70001
        LotNoEditable :=
            (Rec."Line No." < 70001)   // standard lines
            or
            (Rec."Line No." = 110001); // special exception
    end;
}