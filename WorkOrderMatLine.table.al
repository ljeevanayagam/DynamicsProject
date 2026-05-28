table 60003 "Work Order Material Line"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Work Order No."; Code[50]) { TableRelation = "Work Order Header"."No."; }
        field(2; "Line No."; Integer) { }
        field(3; "Display Order"; Integer) { }
        field(4; "Item No."; Code[20])
        {
            TableRelation = Item;
            trigger OnValidate()
            var
                ItemRec: Record Item;
            begin
                if ItemRec.Get("Item No.") then begin
                    "Item Description" := ItemRec.Description;
                    "Unit of Measure" := ItemRec."Base Unit of Measure";
                end;
            end;
        }
        field(5; "Item Description"; Text[100]) { Editable = false; }
        field(6; "Part No."; Code[50])
        {
        }
        field(7; "Lot No."; Code[50]) { }
        field(8; "Expiration Date"; Date) { }
        field(9; Verification; Enum "Verification")
        {
            trigger OnValidate()
            var
                WorkOrder: Record "Work Order Header";
            begin
                if WorkOrder.Get("Work Order No.") then begin
                    WorkOrder.UpdateStatus();
                    WorkOrder.Modify(true);
                end;
            end;
        }
        field(10; "Unit Quantity"; Decimal) { }
        field(11; "Unit of Measure"; Code[10]) { Editable = false; }
        field(12; "Calculated Quantity"; Decimal) { }
        field(13; "Performed By"; Text[100]) { }
        field(14; "Performed Date"; Date) { }
        field(15; "Verified By"; Text[100]) { }
        field(16; "Verification Date"; Date) { }
    }

    keys
    {
        key(PK; "Work Order No.", "Line No.") { Clustered = true; }
    }

    trigger OnInsert()
    var
        WorkOrder: Record "Work Order Header";
        LabelMgt: Codeunit "Work Order Label Mgt";
    begin
        if WorkOrder.Get("Work Order No.") then begin
            LabelMgt.GeneratePLLabels(WorkOrder);
            WorkOrder.UpdateStatus();
            WorkOrder.Modify(true);
        end;
    end;

    trigger OnModify()
    var
        WorkOrder: Record "Work Order Header";
        LabelMgt: Codeunit "Work Order Label Mgt";
    begin
        if WorkOrder.Get("Work Order No.") then begin
            LabelMgt.GeneratePLLabels(WorkOrder);
            WorkOrder.UpdateStatus();
            WorkOrder.Modify(true);
        end;
    end;

    trigger OnDelete()
    var
        WorkOrder: Record "Work Order Header";
        LabelMgt: Codeunit "Work Order Label Mgt";
    begin
        if WorkOrder.Get("Work Order No.") then begin
            LabelMgt.GeneratePLLabels(WorkOrder);
            WorkOrder.UpdateStatus();
            WorkOrder.Modify(true);
        end;
    end;
}