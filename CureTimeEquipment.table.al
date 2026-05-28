table 60509 "Cure Time Equipment Header"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Work Order No."; Code[20])
        {
            TableRelation = "Work Order Header";
        }
        field(2; "Equipment Description"; Text[250])
        {
            Editable = false;
        }
        field(3; "CT Equipment Line No."; Integer)
        {
            Editable = false;
        }
        field(4; "EQ#/Part Number"; Text[100])
        {
            Editable = false;
        }
        field(5; "EQ#/Cal. ID/Equivalent used"; Text[100]) { }
        field(6; "Equipment Parameters"; Text[2048])
        {
            Editable = false;
        }
        field(7; "Equipment Performed By"; Text[100]) { }
        field(8; "Equipment Performed Date"; Date) { }
    }
    keys
    {
        key(PK; "Work Order No.", "CT Equipment Line No.")
        {
            Clustered = true;
        }
    }
}