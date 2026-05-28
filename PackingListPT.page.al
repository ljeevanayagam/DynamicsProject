page 60512 "Packing List PT Page"
{
    PageType = ListPart;
    SourceTable = "Packing List PT Header";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group("Shipping Info")
            {
                field("Ship To"; Rec."Ship To") { }
                field(Attention; Rec.Attention) { }
                field(Address; Rec.Address) { }
                field(Phone; Rec.Phone) { }
                field("PO No."; Rec."PO No.") { }
            }
        }
    }
}