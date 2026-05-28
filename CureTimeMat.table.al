table 60508 "Cure Time Materials Header"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Work Order No."; Code[20])
        {
            TableRelation = "Work Order Header";
        }
        field(2; "CT Material Line No."; Integer)
        {
            Editable = false;
        }
        field(3; "Item No."; Code[50])
        {
            Editable = false;
        }
        field(4; "Item Description"; Text[250])
        {
            Editable = false;
        }
        field(5; "Lot No."; Code[50]) { }
        field(6; Verification; Option)
        {
            OptionMembers = Open,Pass,Fail;
        }
        field(7; "Unit Qty"; Integer)
        {
            Editable = false;
        }
        field(8; UOM; Code[20])
        {
            Editable = false;
        }
        field(9; "Materials Performed By"; Text[100]) { }
        field(10; "Materials Performed Date"; Date) { }
    }
    keys
    {
        key(PK; "Work Order No.", "CT Material Line No.")
        {
            Clustered = true;
        }
    }
}