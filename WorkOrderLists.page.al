page 50123 "Work Orders"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Work Order Header";
    Caption = 'Work Orders';
    UsageCategory = Lists;
    CardPageId = "Work Order Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                    DrillDown = true;
                }
                field("Lot Number"; Rec."Lot Number") { }
                field("Product Part Number"; Rec."Product Part Number")
                {
                    TableRelation = Item where("No." = filter(
                        'PRT-0492-01|PRT-0492-02|PRT-0492-03|PRT-0492-04|PRT-0492-05|PRT-0492-06|PRT-0492-07|PRT-0527|PRT-0528|PRT-0529|PRT-0530|SA-1001-01|SA-1001-02|SA-1001-03|PRT-0544-01|PRT-0544-02|PL-0002-09'));
                    trigger OnValidate()
                    var
                        ItemRec: Record Item;
                        WO: Codeunit "Work Order Orchestrator";
                    begin
                        if ItemRec.Get(Rec."Product Part Number") then begin
                            Rec.Modify(true);
                            WO.HandleRoutingChange(Rec);
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field(Revision; Rec.Revision) { }
                field("Product Description"; Rec."Product Description") { Editable = false; }
                field("PEDGA Part Number"; Rec."PEDGA Part Number")
                {
                    TableRelation = Item;

                    trigger OnValidate()
                    var
                        ItemRec: Record Item;
                        WO: Codeunit "Work Order Orchestrator";
                    begin
                        if (Rec."PEDGA Part Number" <> 'PN-0446') then
                            Error('PEDGA Part Number must be PN-0446');
                        if ItemRec.Get(Rec."PEDGA Part Number") then begin
                            Rec."PEDGA Description" := ItemRec.Description;
                            Rec."PEDGA Revision" := ItemRec."Description 2";
                        end;
                        if ItemRec.Get('PN-0447') then begin
                            Rec."Thiocure Part Number" := 'PN-0447';
                            Rec."THIOCURE Description" := ItemRec.Description;
                            Rec."THIOCURE Revision" := ItemRec."Description 2";
                        end;
                        Rec.Modify(true);
                        Wo.HandleRoutingChange(Rec);
                    end;
                }
                field("PEDGA Revision"; Rec."PEDGA Revision") { Editable = false; }
                field("PEDGA Description"; Rec."PEDGA Description") { Editable = false; }
                field("Thiocure Part Number"; Rec."Thiocure Part Number")
                {
                    TableRelation = Item;
                    Editable = false;
                }
                field("THIOCURE Revision"; Rec."THIOCURE Revision") { Editable = false; }
                field("THIOCURE Description"; Rec."THIOCURE Description") { Editable = false; }
                field("Routing No."; Rec."Routing No.") { Editable = false; }
            }
        }
    }
}