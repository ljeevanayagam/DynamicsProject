table 60513 "Packing List PT Data"
{
    fields
    {
        field(1; "Work Order No."; Code[50])
        {
            TableRelation = "Work Order Header";
        }
        field(2; "Line No."; Integer) { }
        field(3; "Part Number"; Code[20])
        {
            Editable = false;
        }
        field(4; "Customer Lot Number"; Code[50])
        {
            Editable = false;
        }
        field(5; Description; Text[100])
        {
            Editable = false;
        }
        field(6; Quantity; Integer)
        {
            Editable = false;
        }
        field(7; "Packaged By"; Text[100]) { }
        field(8; "Packaged Date"; Date) { }
        field(9; "Verified By"; Text[100]) { }
        field(10; "Verified Date"; Date) { }
        field(11; "Component"; Enum "PT Component") { }
    }
    keys
    {
        key(PK; "Work Order No.", "Line No.")
        {
            Clustered = true;
        }
    }
}