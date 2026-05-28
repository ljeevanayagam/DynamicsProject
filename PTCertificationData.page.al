page 60511 "PT Certification Data page"
{
    PageType = ListPart;
    SourceTable = "PT Cert of Analysis Data";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("BioCure Part No."; Rec."BioCure Part No.") { }
                field("CQ Medical Item No."; Rec."CQ Medical Item No.") { }
                field(Description; Rec.Description) { }
                field("Lot Number"; Rec."Lot Number") { }
                field("Mix Date"; Rec."Mix Date") { }
                field("QTY Shipped"; Rec."QTY Shipped") { }
                field("Specification Verification 1"; Rec."Specification Verification 1") { }
                field("Specification Verification 2"; Rec."Specification Verification 2") { }
            }
            field("Cure Time Verification"; Rec."Cure Time Verification") { }
            field("Quality Assurance"; Rec."Quality Assurance") { }
            field(Date; Rec.Date) { }
        }
    }
}