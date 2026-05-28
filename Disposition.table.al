table 60105 "Disposition of Discrep Mat"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Work Order No."; Code[50])
        {
            TableRelation = "Work Order Header";
        }
        field(2; "Reject at Step"; Integer) { }
        field(3; "Initial"; Code[50]) { }
        field(4; Date; Date) { }
        field(5; "Reject Qty"; Integer) { }
        field(6; "Scrap Qty"; Integer) { }
        field(7; "Rework Qty"; Integer) { }
        field(8; "Other"; Text[2048]) { }
        field(9; "NCR Number"; Integer) { }
        field(10; "Disposition Comments"; Text[2048]) { }
        field(11; "Flow"; Integer) { }
        field(12; "Performed By"; Text[100]) { }
        field(13; "Line Clearance Date"; Date) { }
        field(14; "Pre or Post"; Option)
        {
            OptionMembers = Open,Pre,Post;
        }
        field(15; Comments; Text[2048])
        {

        }
        field(16; "General Comments"; Text[2048])
        {

        }
    }

    keys
    {
        key(PK; "Work Order No.")
        {
            Clustered = true;
        }
    }
}