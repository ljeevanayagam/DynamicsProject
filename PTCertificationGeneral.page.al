page 60510 "PT Certificate of Analysis Gen"
{
    PageType = ListPart;
    SourceTable = "PT Certificate of Analysis Top";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group("Ship Information")
            {
                field("Ship To"; Rec."Ship To") { }
                field("Ship Attention"; Rec."Ship Attention") { }
                field("Ship Address"; Rec."Ship Address") { }
                field("Ship Phone No."; Rec."Ship Phone No.") { }
                field("Ship Email"; Rec."Ship Email") { }
            }
            group("Bill Information")
            {
                field("Bill To"; Rec."Bill To") { }
                field("Bill Address"; Rec."Bill Address") { }
                field("Bill Phone No."; Rec."Bill Phone No.") { }
                field("Bill Email"; Rec."Bill Email") { }
                field("PO No."; Rec."PO No.") { }
            }
        }
    }
    trigger OnModifyRecord(): Boolean
    begin
        CurrPage.Update(false);
        exit(true);
    end;
}