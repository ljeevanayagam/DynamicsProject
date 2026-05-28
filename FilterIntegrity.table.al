table 60102 "Filter Integrity"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Work Order No."; Code[20])
        {
            TableRelation = "Work Order Header";
        }
        field(2; "Step #"; Integer) { }
        field(3; "Filter #"; Integer) { }
        field(4; "MPI-0116 Test Procedure Result"; Integer) { }
        field(5; "Bubble Point Pressure Verify"; Option)
        {
            OptionMembers = Open,Pass,Fail;
        }
        field(6; "Performed By"; Text[100]) { }
        field(7; Date; Date) { }
    }
    keys
    {
        key(PK; "Work Order No.")
        {
            Clustered = true;
        }
    }
}