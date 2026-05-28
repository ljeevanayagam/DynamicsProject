table 60111 "Work Order PL Label Run"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Work Order No."; Code[100]) { }
        field(2; "PL Item No."; Code[50]) { }
        field(3; "Run No."; Integer) { }

        // =====================================
        // RUN DATA
        // =====================================

        field(10; "Ribbon Lot No."; Code[100]) { }

        field(11; "Label Blank Lot No."; Code[100]) { }

        field(12; "Label Printed/Verified By"; Text[100]) { }

        field(13; "Labels Printed/Verified Date"; Date) { }

        field(14; "Scan Retain Label Barcode"; Text[250]) { }

        field(15; "Label Barcode Verification"; Option)
        {
            OptionMembers = Open,Pass,Fail;
        }

        field(16; "Label Barcode Verification By"; Text[100]) { }

        field(17; "Barcode Verification Date"; Date) { }

        field(18; "Label Retain Quantity"; Integer) { }

        field(19; "Label Quantity Rejected"; Integer) { }

        field(20; "Label Quantity Accepted"; Integer) { }

        field(21; "Total Labels Printed"; Integer)
        {
            Editable = false;
        }

        field(22; "Labels Verified By"; Text[100]) { }

        field(23; "Labels Verified Date"; Date) { }

        field(24; "Quantity Used"; Integer) { }

        field(25; "Quantity to be Scrapped"; Integer)
        {
            Editable = false;
        }

        field(26; "Label Reconcil. Performed By"; Text[100]) { }

        field(27; "Label Reconcil. Performed Date"; Date) { }

        field(28; "Unused Labels Scrapped By"; Text[100]) { }

        field(29; "Unused Labels Scrapped Date"; Date) { }

        field(30; "Reconciliation Verified By"; Text[100]) { }

        field(31; "Reconcil. Verification Date"; Date) { }

        field(32; Comments; Text[2048]) { }

        field(33; Posted; Boolean) { }
    }

    keys
    {
        key(PK; "Work Order No.", "PL Item No.", "Run No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Run No." = 0 then
            "Run No." := GetNextRunNo();
    end;

    procedure UpdateCalculations()
    begin
        "Total Labels Printed" :=
            "Label Quantity Accepted"
            + "Label Quantity Rejected"
            + "Label Retain Quantity";

        "Quantity to be Scrapped" :=
            "Label Quantity Accepted" - "Quantity Used";

        if "Quantity to be Scrapped" < 0 then
            "Quantity to be Scrapped" := 0;
    end;

    local procedure GetNextRunNo(): Integer
    var
        Run: Record "Work Order PL Label Run";
    begin
        Run.SetRange("Work Order No.", "Work Order No.");
        Run.SetRange("PL Item No.", "PL Item No.");

        if Run.FindLast() then
            exit(Run."Run No." + 1);

        exit(1);
    end;
}