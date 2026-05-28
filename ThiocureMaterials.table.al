table 60504 "Thiocure Materials Header"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Work Order No."; Code[50])
        {
            TableRelation = "Work Order Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Item';
        }
        field(3; "Display Order"; Integer) { }
        field(4; "Item No."; Code[20])
        {
            TableRelation = Item;
            Caption = 'Part Number';
            Editable = false;
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
        field(5; "Item Description"; Text[100])
        {
            Editable = false;
            Caption = 'Description';
        }
        field(6; "Lot No."; Code[50]) { }
        field(7; Verification; Enum "Verification")
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
        field(8; "Unit Quantity"; Decimal) { }
        field(9; "Unit of Measure"; Code[10]) { Editable = false; }
        field(10; "Calculated Quantity"; Decimal)
        {
            trigger onValidate()
            var
                WO: Record "Work Order Header";
            begin
                if WO.Get("Work Order No.") then begin
                    WO.UpdateStatus();
                    WO.Modify(true);
                end;
            end;
        }
        field(11; "Performed By"; Text[100]) { }
        field(12; "Performed Date"; Date) { }
        field(13; "Verified By"; Text[100]) { }
        field(14; "Verification Date"; Date) { }
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
            LabelMgt.ClearPLLabels(WorkOrder."No.", true);
            WorkOrder.UpdateStatus();
            WorkOrder.Modify(true);
        end;
    end;
}