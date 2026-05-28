table 60510 "PT Certificate of Analysis Top"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Work Order No."; Code[50])
        {
            TableRelation = "Work Order Header";
        }
        field(2; "Line No."; Integer) { }
        field(3; "Ship To"; Text[100]) { }
        field(4; "Ship Attention"; Text[100]) { }
        field(5; "Ship Address"; Text[200]) { }
        field(6; "Ship Phone No."; Text[30]) { }
        field(7; "Ship Email"; Text[100]) { }
        field(8; "Bill To"; Text[100]) { }
        field(9; "Bill Address"; Text[100]) { }
        field(10; "Bill Phone No."; Text[30]) { }
        field(11; "Bill Email"; Text[100]) { }
        field(12; "PO No."; Code[30]) { }
    }
    keys
    {
        key(PK; "Work Order No.", "Line No.")
        {
            Clustered = true;
        }
    }
}