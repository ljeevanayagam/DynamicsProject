page 60105 "Disposition of Disc Mat"
{
    PageType = ListPart;
    SourceTable = "Disposition of Discrep Mat";
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group("Disposition of Discrepant Materials")
            {
                repeater(DGroup)
                {
                    field("Reject at Step"; Rec."Reject at Step") { }
                    field(Initial; Rec.Initial) { }
                    field(Date; Rec.Date) { }
                    field("Reject Qty"; Rec."Reject Qty") { }
                    field("Scrap Qty"; Rec."Scrap Qty") { }
                    field("Rework Qty"; Rec."Rework Qty") { }
                    field(Other; Rec.Other) { }
                    field("NCR Number"; Rec."NCR Number") { }
                    field("Disposition Comments"; Rec."Disposition Comments") { }
                }

            }
            group("Line Clearance")
            {
                repeater(LGroup)
                {
                    field(Flow; Rec.Flow) { }
                    field("Pre or Post"; Rec."Pre or Post") { }
                    field("Performed By"; Rec."Performed By") { }
                    field("Line Clearance Date"; Rec."Line Clearance Date") { }
                    field(Comments; Rec.Comments) { }
                }
            }
            field("General Comments"; Rec."General Comments")
            {
                Caption = 'Comments';
            }
        }
    }
}