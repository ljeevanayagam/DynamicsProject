table 60004 "Work Order Supply Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Work Order No."; Code[50]) { TableRelation = "Work Order Header"."No."; }
        field(2; "Line No."; Integer) { }
        field(3; "Display Order"; Integer) { Caption = 'No.'; Editable = false; }
        field(4; "Item No."; Code[50])
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
        field(6; "Part No."; Code[50]) { }
        field(7; "Lot No."; Code[50]) { }
        field(8; Verification; Enum "Verification")
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
        field(9; "Unit Quantity"; Decimal) { }
        field(10; "Unit of Measure"; Code[10]) { Editable = false; }
        field(11; "Performed By"; Text[100]) { }
        field(12; Date; Date) { }
    }

    keys
    {
        key(PK; "Work Order No.", "Line No.") { Clustered = true; }
    }

    trigger OnInsert()
    var
        LastLine: Record "Work Order Supply Line";
        Header: Record "Work Order Header";
    begin
        if Header.Get("Work Order No.") then begin
            Header."Operational Supplies No." += 1;
            Header.Modify();
        end;

        LastLine.SetRange("Work Order No.", "Work Order No.");
        LastLine.SetCurrentKey("Display Order");
        if LastLine.FindLast() then
            "Display Order" := LastLine."Display Order" + 1
        else
            "Display Order" := 1;

        // Update status on insert
        if Header.Get("Work Order No.") then begin
            Header.UpdateStatus();
            Header.Modify();
        end;
    end;

    trigger OnModify()
    var
        Header: Record "Work Order Header";
    begin
        // Update status whenever a supply line changes
        if Header.Get("Work Order No.") then begin
            Header.UpdateStatus();
            Header.Modify();
        end;
    end;

    trigger OnDelete()
    var
        Header: Record "Work Order Header";
    begin
        ResequenceDisplayOrder("Work Order No.");

        // Update status after deletion
        if Header.Get("Work Order No.") then begin
            Header.UpdateStatus();
            Header.Modify();
        end;
    end;

    local procedure ResequenceDisplayOrder(WorkOrderNo: Code[50])
    var
        LineRec: Record "Work Order Supply Line";
        Counter: Integer;
    begin
        Counter := 1;
        LineRec.SetRange("Work Order No.", WorkOrderNo);
        LineRec.SetCurrentKey("Display Order");
        if LineRec.FindSet() then
            repeat
                if LineRec."Display Order" <> Counter then begin
                    LineRec."Display Order" := Counter;
                    LineRec.Modify();
                end;
                Counter += 1;
            until LineRec.Next() = 0;
    end;
}