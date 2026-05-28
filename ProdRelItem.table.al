table 60106 "Product Release Item"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Work Order No."; Code[50]) { TableRelation = "Work Order Header"."No."; }
        field(2; "Line No."; Integer) { }
        field(3; "Checklist Item"; Text[250]) { }
        field(4; Status; Enum "WO Checklist Status")
        {
            trigger OnValidate()
            begin
                UpdateWorkOrder();
            end;
        }
        field(5; "QA Review & Lot Release By"; Text[100])
        {
            trigger OnValidate()
            begin
                UpdateWorkOrder();
            end;
        }
        field(6; "QA Review Date"; Date)
        {
            trigger OnValidate()
            begin
                UpdateWorkOrder();
            end;
        }
        field(7; "QA Released QTY"; Integer)
        {
            Editable = false;
            trigger OnValidate()
            var
                WorkOrder: Record "Work Order Header";
            begin
                if not WorkOrder."Requires Product Release" then
                    exit;
                UpdateWorkOrder();
            end;
        }

        field(8; "Lot No."; Code[50])
        {
            TableRelation = "Work Order Header";
        }
    }

    keys
    {
        key(PK; "Work Order No.", "Line No.") { Clustered = true; }
    }

    trigger OnInsert()
    var
        ExistingItem: Record "Product Release Item";
        LastLineNo: Integer;
        WorkOrder: Record "Work Order Header";
    begin
        // Prevent duplicate checklist items
        ExistingItem.SetRange("Work Order No.", "Work Order No.");
        ExistingItem.SetRange("Checklist Item", "Checklist Item");
        if ExistingItem.FindFirst() then
            exit;

        // Auto-increment Line No
        ExistingItem.Reset();
        ExistingItem.SetRange("Work Order No.", "Work Order No.");
        if ExistingItem.FindLast() then
            LastLineNo := ExistingItem."Line No."
        else
            LastLineNo := 0;

        "Line No." := LastLineNo + 10000;

        // if Status = Status::Open then
        //     Status := Status::Open;
    end;

    local procedure ClearOtherQALines()
    var
        OtherLine: Record "Product Release Item";
        CurrLineNo: Integer;
        CurrQAQty: Integer;
        CurrQABy: Text[100];
        CurrQADate: Date;
    begin
        // 🔒 Store current values BEFORE modifying others
        CurrLineNo := "Line No.";
        CurrQAQty := "QA Released QTY";
        CurrQABy := "QA Review & Lot Release By";
        CurrQADate := "QA Review Date";

        OtherLine.SetRange("Work Order No.", "Work Order No.");
        if OtherLine.FindSet() then
            repeat
                if OtherLine."Line No." <> CurrLineNo then begin
                    OtherLine."QA Released QTY" := 0;
                    OtherLine."QA Review Date" := 0D;
                    OtherLine."QA Review & Lot Release By" := '';
                    OtherLine.Modify();
                end;
            until OtherLine.Next() = 0;

        // 🔁 Re-apply current values (ensures nothing got wiped)
        "QA Released QTY" := CurrQAQty;
        "QA Review & Lot Release By" := CurrQABy;
        "QA Review Date" := CurrQADate;
    end;

    local procedure UpdateWorkOrder()
    var
        WorkOrder: Record "Work Order Header";
    begin
        if WorkOrder.Get("Work Order No.") then begin
            WorkOrder.UpdateStatus();
        end;
    end;
}