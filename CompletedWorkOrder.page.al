page 50103 "Completed Work Orders"
{
    PageType = List;
    SourceTable = "Completed Work Order";
    ApplicationArea = All;
    Caption = 'Completed Work Orders';
    UsageCategory = Lists;
    SourceTableView = where(Status = const(Completed));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No;"; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Work Order No."; Rec."Work Order No.")
                {
                    ApplicationArea = All;
                }
                field("Product Part Number"; Rec."Product Part Number") { }
                field("Product Description"; Rec."Product Description") { }
                field("Lot Number"; Rec."Lot Number") { }
                field("Routing No."; Rec."Routing No.") { }
                field(Status; Rec.Status) { }
                field("Requires Product Release"; Rec."Requires Product Release") { }
                field("GTIN-14, Container"; Rec."GTIN-14, Container") { }
                field("GTIN-14, Carton"; Rec."GTIN-14, Carton") { }
                field("Lot Quantity"; Rec."Lot Quantity") { }
                field("Quantity Actually Used"; Rec."Quantity Actually Used") { }
                field("Completed Date"; Rec."Completed Date") { }
                // field("Run No."; Rec."Run No.")
                // {
                //     ApplicationArea = All;
                // }
                field("Completed By"; Rec."Completed By") { }
            }
            part(Runs; "Completed WO Runs Subpage")
            {
                SubPageLink = "Work Order No." = field("Work Order No.");
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(TestInsert)
            {
                Caption = 'TEST INSERT';
                ApplicationArea = All;

                trigger OnAction()
                var
                    TestRec: Record "Completed Work Order";
                begin
                    TestRec.Init();
                    TestRec."Work Order No." := 'TEST';
                    // TestRec."Run No." := 999;
                    TestRec."Quantity Actually Used" := 123;

                    TestRec.Insert(true);
                    CurrPage.Update();
                    Message('Manual insert done');
                end;
            }
        }
    }
}