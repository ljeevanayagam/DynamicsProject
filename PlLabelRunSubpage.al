page 60112 "PL Label Run Subpage"
{
    PageType = ListPart;
    SourceTable = "Work Order PL Label Run";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Run No."; Rec."Run No.")
                {
                    Editable = false;
                }
                field(Posted; Rec.Posted) { }
                field("Quantity Used"; Rec."Quantity Used") { }
                field("Ribbon Lot No."; Rec."Ribbon Lot No.") { }
                field("Label Blank Lot No."; Rec."Label Blank Lot No.") { }
                field("Label Printed/Verified By"; Rec."Label Printed/Verified By") { }
                field("Labels Printed/Verified Date"; Rec."Labels Printed/Verified Date") { }
                field("Scan Retain Label Barcode"; Rec."Scan Retain Label Barcode") { }
                field("Label Barcode Verification"; Rec."Label Barcode Verification") { }
                field("Label Barcode Verification By"; Rec."Label Barcode Verification By") { }
                field("Barcode Verification Date"; Rec."Barcode Verification Date") { }
                field("Label Retain Quantity"; Rec."Label Retain Quantity") { }
                field("Label Quantity Rejected"; Rec."Label Quantity Rejected") { }
                field("Label Quantity Accepted"; Rec."Label Quantity Accepted") { }
                field("Total Labels Printed"; Rec."Total Labels Printed")
                {
                    Editable = false;
                }
                field("Labels Verified By"; Rec."Labels Verified By") { }
                field("Labels Verified Date"; Rec."Labels Verified Date") { }
                field("Quantity to be Scrapped"; Rec."Quantity to be Scrapped")
                {
                    Editable = false;
                }
                field("Label Reconcil. Performed By"; Rec."Label Reconcil. Performed By") { }
                field("Label Reconcil. Performed Date"; Rec."Label Reconcil. Performed Date") { }
                field("Unused Labels Scrapped By"; Rec."Unused Labels Scrapped By") { }
                field("Unused Labels Scrapped Date"; Rec."Unused Labels Scrapped Date") { }
                field("Reconciliation Verified By"; Rec."Reconciliation Verified By") { }
                field("Reconcil. Verification Date"; Rec."Reconcil. Verification Date") { }
                field(Comments; Rec.Comments) { }
            }
        }
    }
    trigger OnModifyRecord(): Boolean
    begin
        Rec.UpdateCalculations();
    end;
}