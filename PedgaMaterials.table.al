table 60501 "Pedga Materials Header"
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
        field(5; "Item Description"; Text[100]) { Editable = false; Caption = 'Description'; }
        field(6; "Lot No."; Code[50])
        {
            trigger OnValidate()
            begin
                SyncToThiocure();
            end;
        }
        field(7; Verification; Enum "Verification")
        {
            trigger OnValidate()
            var
                WorkOrder: Record "Work Order Header";
            begin
                SyncToThiocure();
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
                SyncToThiocure();
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

    local procedure GetMatchingThiocureLineNo(PedgaLineNo: Integer): Integer
    begin
        case PedgaLineNo of
            50001:
                exit(60001);
            60001:
                exit(70001);
            60002:
                exit(70002);
            70001:
                exit(80001);
            70002:
                exit(80002);
            80001:
                exit(90001);
            90001:
                exit(100001);
            100001:
                exit(110001);
        end;
        exit(0);
    end;

    local procedure SyncThiocureQuantityOnly()
    var
        ThiocureLine: Record "Thiocure Materials Header";
        TargetLineNo: Integer;
    begin
        TargetLineNo := GetMatchingThiocureLineNo("Line No.");
        if TargetLineNo = 0 then
            exit;
        if not ThiocureLine.Get("Work Order No.", TargetLineNo) then
            exit;
        ThiocureLine.Validate("Calculated Quantity", "Calculated Quantity");
        ThiocureLine.Modify(true);
    end;

    local procedure SyncThiocureFull()
    var
        ThiocureLine: Record "Thiocure Materials Header";
        TargetLineNo: Integer;
    begin
        TargetLineNo := GetMatchingThiocureLineNo("Line No.");
        if TargetLineNo = 0 then
            exit;
        if not ThiocureLine.Get("Work Order No.", TargetLineNo) then
            exit;
        ThiocureLine.Validate("Calculated Quantity", "Calculated Quantity");
        ThiocureLine.Validate("Lot No.", "Lot No.");
        ThiocureLine.Validate(Verification, Verification);
        ThiocureLine.Modify(true);
    end;

    local procedure GetSyncMode(LineNo: Integer): Integer
    begin
        case LineNo of
            60001, 60002,
            70001, 70002,
            80001, 90001:
                exit(1); // FULL SYNC
            50001, 100001:
                exit(2); // QTY ONLY
        end;
        exit(0);
    end;

    local procedure SyncToThiocure()
    begin
        case GetSyncMode("Line No.") of
            1:
                SyncThiocureFull();
            2:
                SyncThiocureQuantityOnly();
        end;
    end;

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