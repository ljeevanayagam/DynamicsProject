page 60107 "Belzer Certification Page"
{
    PageType = ListPart;
    SourceTable = "Certificate of Analysis Belzer";
    ApplicationArea = All;
    layout
    {

        area(Content)
        {
            field("Work Order No."; Rec."Work Order No.")
            {
                Visible = false;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            group("Shipping Info")
            {
                field("Ship To"; Rec."Ship To") { }
                field(Attention; Rec.Attention) { }
                field(Address; Rec.Address) { }
                field(Phone; Rec.Phone) { }
                field(Email; Rec.Email) { }
            }
            group("Certificate of Analysis")
            {
                field("Product Part Number"; Rec."Product Part Number")
                {
                }
                field("Product Description"; Rec."Product Description") { }
                field("Lot Number"; Rec."Lot Number") { }
                field("Manufacture Date"; Rec."Manufacture Date") { }
                field("Expiration Date"; Rec."Expiration Date") { }
                field("Bulk Solution Lot Numbers"; Rec."Bulk Solution Lot Numbers") { }
                field("Lot Quantity"; Rec."Lot Quantity") { }
            }
            group("Test Results")
            {
                repeater(Group)
                {
                    field(Test; Rec.Test) { }
                    field("Test Method"; Rec."Test Method") { }
                    field(Specification; Rec.Specification) { }
                    field(Results; Rec.Results) { }
                }
            }
            field("Quality Assurance"; Rec."Quality Assurance") { }
            field(Date; Rec.Date) { }
        }
    }
}