table 60104 "Particulate Test Header"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Work Order No."; Code[200]) { }
        field(2; "List of Samples"; Text[2048]) { }
        field(3; "Particulate Testing Test 1"; Option)
        {
            Caption = 'The average particle count ≥ 10 μm shall be ≤ 25 particles/mL';
            OptionMembers = Open,Pass,Fail;
        }
        field(4; "Particulate Testing Test 2"; Option)
        {
            Caption = 'The average particle count ≥ 25 μm shall be ≤ 3 particles/mL';
            OptionMembers = Open,Pass,Fail;
        }
        field(5; "Particulate Comments"; Text[2048]) { }
        field(6; "Particulate Performed By"; Text[100]) { }
        field(7; "Particulate Date"; Date) { }
    }
    keys
    {
        key(PK; "Work Order No.")
        {
            Clustered = true;
        }
    }
}