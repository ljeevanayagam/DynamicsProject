table 60511 "PT Cert of Analysis Data"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Work Order No."; Code[20])
        {
            TableRelation = "Work Order Header";
        }
        field(2; "Line No."; Integer) { }
        field(3; "BioCure Part No."; Code[30])
        {
            Editable = false;
        }
        field(4; "CQ Medical Item No."; Code[100])
        {
            Editable = false;
        }
        field(5; Description; Text[500])
        {
            Editable = false;
        }
        field(6; "Lot Number"; Code[500])
        {
            Editable = false;
        }
        field(7; "Mix Date"; Date)
        {
            Editable = false;
        }
        field(8; "QTY Shipped"; Integer)
        {
            Editable = false;
        }
        field(9; "Specification Verification 1"; Option)
        {
            Caption = 'Appearance: Clear Colorless Liquid';
            OptionMembers = Open,Pass,Fail;
        }
        field(10; "Specification Verification 2"; Option)
        {
            Caption = 'Fill Volumne: 25 ± 1 mL';
            OptionMembers = Open,Pass,Fail;
        }
        field(11; "Cure Time Verification"; Option)
        {
            Caption = 'Cure Time: ≤ 5 Minutes';
            OptionMembers = Open,Pass,Fail;
        }
        field(12; "Quality Assurance"; Text[100]) { }
        field(13; Date; Date) { }
    }
    keys
    {
        key(PK; "Work Order No.", "Line No.")
        {
            Clustered = true;
        }
    }
}