table 60002 "Work Order PL Label"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Work Order No."; Code[50]) { }
        field(2; Revision; Code[50]) { }
        field(3; "PL Item No."; Code[20]) { }
        field(4; Description; Text[250]) { }
        // -------------------------
        // INPUT FIELDS (NO AUTO RECALC HERE)
        // -------------------------
        field(5; "Label Barcode Verification"; Option)
        {
            OptionMembers = Open,Pass,Fail;
        }
        field(6; "Label Retain Quantity"; Integer) { }
        field(7; "Label Quantity Rejected"; Integer) { }
        field(8; "Label Quantity Accepted"; Integer) { }
        field(9; "Ribbon Item No."; Code[50]) { TableRelation = Item; }
        field(10; "Ribbon Lot No."; Code[50]) { }
        field(11; "Label Blank Item No."; Code[50]) { TableRelation = Item; }
        field(12; "Label Blank Lot No."; Code[50]) { }
        field(13; "Label Printed/Verified By"; Text[100]) { }
        field(14; "Labels Printed/Verified Date"; Date) { }
        field(15; "Scan Retain Label Barcode"; Code[2048]) { }
        field(16; "Label Barcode Verification By"; Text[100]) { }
        field(17; "Barcode Verification Date"; Date) { }
        field(18; "Labels Verified By"; Text[100]) { }
        field(19; "Labels Verified Date"; Date) { }
        field(20; "Label Reconcil. Performed By"; Text[100]) { }
        field(21; "Label Reconcil. Performed Date"; Date) { }
        field(22; "Unused Labels Scrapped By"; Text[100]) { }
        field(23; "Unused Labels Scrapped Date"; Date) { }
        field(24; "Reconciliation Verified By"; Text[100]) { }
        field(25; "Reconcil. Verification Date"; Date) { }
        field(26; Comments; Text[2048]) { }
        field(27; "Material Line No."; Integer) { }
        field(28; Posted; Boolean) { Editable = false; }
        // -------------------------
        // DERIVED FIELDS (READ ONLY)
        // -------------------------
        field(29; "Quantity Used"; Integer) { }
        field(30; "Total Labels Printed"; Integer) { Editable = false; }
        field(31; "Quantity to be Scrapped"; Integer) { Editable = false; }
        field(32; "Quantity Accepted"; Integer) { Editable = false; }
        field(33; "Source Type"; Enum "PL Label Source Type") { }
    }
    keys
    {
        key(PK; "Work Order No.", "PL Item No.", "Source Type")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        WorkOrder: Record "Work Order Header";
    begin
        ValidateLocked();
        UpdateCalculations();
    end;

    trigger OnModify()
    var
        WorkOrder: Record "Work Order Header";
    begin
        ValidateLocked();
        UpdateCalculations();
    end;

    trigger OnDelete()
    var
        WorkOrder: Record "Work Order Header";
    begin
        if WorkOrder.Get("Work Order No.") then
            if WorkOrder."PL Labels Locked" then
                Error('Labels are locked after posting and cannot be deleted.');
    end;
    // -------------------------
    // CORE CALCULATIONS
    // -------------------------
    procedure UpdateCalculations()
    var
        MatLine: Record "Work Order Material Line";
    begin
        // SAFE: only read material once, no cascading triggers
        if MatLine.Get("Work Order No.", "Material Line No.") then
            "Quantity Used" := MatLine."Calculated Quantity";

        "Total Labels Printed" :=
            "Label Quantity Accepted"
            + "Label Retain Quantity"
            + "Label Quantity Rejected";

        if "Total Labels Printed" < 0 then
            "Total Labels Printed" := 0;

        "Quantity to be Scrapped" :=
            "Label Quantity Accepted" - "Quantity Used";

        if "Quantity to be Scrapped" < 0 then
            "Quantity to be Scrapped" := 0;

        "Quantity Accepted" := "Label Quantity Accepted";
    end;
    // -------------------------
    // HELPERS
    // -------------------------
    local procedure ValidateLocked()
    var
        WorkOrder: Record "Work Order Header";
    begin
        if WorkOrder.Get("Work Order No.") then
            if WorkOrder."PL Labels Locked" then
                Error('Labels are locked after posting and cannot be modified.');
    end;

    procedure IsComplete(): Boolean
    begin
        exit(
            ("Ribbon Item No." <> '') and
            ("Ribbon Lot No." <> '') and
            ("Label Blank Item No." <> '') and
            ("Label Blank Lot No." <> '') and
            ("Label Printed/Verified By" <> '') and
            ("Labels Printed/Verified Date" <> 0D) and
            ("Scan Retain Label Barcode" <> '') and
            ("Label Barcode Verification" = "Label Barcode Verification"::Pass) and
            ("Label Barcode Verification By" <> '') and
            ("Barcode Verification Date" <> 0D) and
            ("Labels Verified By" <> '') and
            ("Labels Verified Date" <> 0D) and
            ("Label Reconcil. Performed By" <> '') and
            ("Label Reconcil. Performed Date" <> 0D) and
            ("Unused Labels Scrapped By" <> '') and
            ("Unused Labels Scrapped Date" <> 0D) and
            ("Reconciliation Verified By" <> '') and
            ("Reconcil. Verification Date" <> 0D)
        );
    end;
}