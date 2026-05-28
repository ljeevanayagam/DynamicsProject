table 61000 "Completed Work Order Run"
{
    fields
    {
        field(1; "Work Order No."; Code[20]) { }
        field(2; "Run No."; Integer) { }
        field(3; "Accepted Quantity"; Integer) { }
        field(4; "Posted Date"; Date) { }
    }
    keys
    {
        key(PK; "Work Order No.", "Run No.") { Clustered = true; }
    }
}