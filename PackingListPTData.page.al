page 60513 "Packing List PT Data Page"
{
    PageType = ListPart;
    SourceTable = "Packing List PT Data";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Part Number"; Rec."Part Number") { }
                field("Customer Lot Number"; Rec."Customer Lot Number") { }
                field(Description; Rec.Description) { }
                field(Quantity; Rec.Quantity) { }
            }
            field("Packaged By"; Rec."Packaged By") { }
            field("Packaged Date"; Rec."Packaged Date") { }
            field("Verified By"; Rec."Verified By") { }
            field("Verified Date"; Rec."Verified Date") { }
        }
    }
}