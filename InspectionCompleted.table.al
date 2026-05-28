table 50101 "Inspection Header Completed"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Inspection No."; Code[20]) { }
        field(2; "Date Received"; Date) { }
        field(3; "Purchase Order No."; Code[20]) { }
        field(4; "Vendor No."; Text[50])
        {

        }
        field(5; "Vendor Name"; Text[100]) { }
        field(6; "Item No."; Code[20]) { }
        field(7; "Item Description"; Text[100]) { }
        field(8; "Lot No."; Code[50]) { }
        field(9; "Serial No."; Code[50]) { }
        field(10; Quantity; Decimal) { }
        field(11; Status; Enum "Inspection Status") { }
        field(12; "Received By"; Code[50]) { }
        field(13; Notes; Text[250]) { }
        field(14; "The Inspection No."; Text[250])
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'No longer needed in this extension.';
            ObsoleteTag = '1.1';
        }
        field(15; "Purchase Order Line No."; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'No longer needed in this extension.';
            ObsoleteTag = '1.1';
        }
        field(16; "Received Quantity"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'No longer needed in this extension.';
            ObsoleteTag = '1.1';
        }
        field(17; "Failed Quantity"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'No longer needed in this extension.';
            ObsoleteTag = '1.1';
        }
    }

    keys
    {
        key(PK; "Inspection No.") { Clustered = true; }
    }
}