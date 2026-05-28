page 60100 "Print Label Subpage"
{
    PageType = ListPart;
    SourceTable = "Print Label Line";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Run No."; Rec."Run No.") { Editable = false; }

                field("Labels Printed By"; Rec."Labels Printed By") { }
                field("Labels Printed Date"; Rec."Labels Printed Date") { }
                field("Retain Verified By"; Rec."Retain Verified By") { }
                field("Retain Verified Date"; Rec."Retain Verified Date") { }
                field("Quantity of Labels Printed"; Rec."Quantity of Labels Printed") { }
                field("Retain Quantity"; Rec."Retain Quantity") { }
                field("Accepted Quantity"; Rec."Accepted Quantity") { Editable = false; }
                field("Rejected Quantity"; Rec."Rejected Quantity") { }
                field("Labels Verified By"; Rec."Labels Verified By") { }
                field("Labels Verified Date"; Rec."Labels Verified Date") { }
                field("Submitted"; Rec.Submitted)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SubmitRun)
            {
                Caption = 'Submit Run';
                trigger OnAction()
                var
                    PostMgt: Codeunit "Print Label Post Mgt";
                    Header: Record "Work Order Header";
                begin
                    Header.Get(Rec."Work Order No.");
                    if not Rec.IsComplete() then
                        Error('Enter run data before submitting.');
                    PostMgt.PostRun(Rec);
                    Header.Get(Rec."Work Order No.");
                    PostMgt.ApplyPrintLabelStatus(Header);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}