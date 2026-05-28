page 60111 "WorkOrder PL Label Run Subpage"
{
    PageType = ListPart;
    SourceTable = "Work Order PL Label Run";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Run No."; Rec."Run No.") { }
                field(Posted; Rec.Posted) { }
                field("Quantity Used"; Rec."Quantity Used") { }
                field("Ribbon Lot No."; Rec."Ribbon Lot No.") { }
                field("Label Blank Lot No."; Rec."Label Blank Lot No.") { }
            }
        }
    }
}