table 60110 "Print Label Line"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Work Order No."; Code[20]) { }
        field(2; "Run No."; Integer) { }
        field(3; "Labels Printed By"; Text[100]) { }
        field(4; "Labels Printed Date"; Date) { }
        field(5; "Retain Verified By"; Text[100]) { }
        field(6; "Retain Verified Date"; Date) { }
        field(7; "Quantity of Labels Printed"; Integer)
        {
            trigger OnValidate()
            begin
                Calc();
            end;
        }
        field(8; "Retain Quantity"; Integer)
        {
            trigger OnValidate()
            begin
                Calc();
            end;
        }

        field(9; "Accepted Quantity"; Integer) { Editable = false; }
        field(10; "Rejected Quantity"; Integer)
        {
            trigger OnValidate()
            begin
                Calc();
            end;
        }
        field(11; "Labels Verified By"; Text[100]) { }
        field(12; "Labels Verified Date"; Date) { }
        field(13; Submitted; Boolean) { }
        field(14; "Run Id"; Guid) { Editable = false; }
    }

    keys
    {
        key(PK; "Work Order No.", "Run No.") { Clustered = true; }
    }

    trigger OnInsert()
    var
        PLMgt: Codeunit "Print Label Post Mgt";
    begin
        if "Run No." = 0 then
            "Run No." := GetNext();

        "Run Id" := CreateGuid();
        PLMgt.UpdateWorkOrderPrintLabelStatus("Work Order No.");
    end;

    trigger OnModify()
    var
        PLMgt: Codeunit "Print Label Post Mgt";
    begin
        if xRec.Submitted then
            Error('This run is already submitted and cannot be modified.');
        Calc();
        PLMgt.UpdateWorkOrderPrintLabelStatus("Work Order No.");
    end;

    trigger OnDelete()
    var
        PLMgt: Codeunit "Print Label Post Mgt";
    begin
        PLMgt.UpdateWorkOrderPrintLabelStatus("Work Order No.");
    end;

    procedure Calc()
    begin
        "Accepted Quantity" :=
            "Quantity of Labels Printed"
            - "Retain Quantity"
            - "Rejected Quantity";

        if "Accepted Quantity" < 0 then
            "Accepted Quantity" := 0;
    end;

    procedure GetNext(): Integer
    var
        L: Record "Print Label Line";
    begin
        L.SetRange("Work Order No.", "Work Order No.");

        if L.FindLast() then
            exit(L."Run No." + 1);

        exit(1);
    end;

    procedure IsComplete(): Boolean
    begin
        exit(
            ("Labels Printed By" <> '') and
            ("Labels Printed Date" <> 0D) and
            ("Retain Verified By" <> '') and
            ("Retain Verified Date" <> 0D) and
            ("Quantity of Labels Printed" >= 0) and
            ("Labels Verified By" <> '') and
            ("Labels Verified Date" <> 0D) and
            ("Retain Quantity" >= 0) and
            ("Accepted Quantity" >= 0) and
            ("Rejected Quantity" >= 0)
        );
    end;
}