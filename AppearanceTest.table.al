table 60103 "Appearance Test Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Work Order No."; Code[200])
        {
            TableRelation = "Work Order Header";
        }

        field(2; "Sample #"; Code[50]) { }

        field(3; Parameter; Text[200])
        {
            InitValue = 'Appearance';
            Editable = false;
        }

        field(4; "Appearance Test Specification"; Text[500])
        {
            InitValue = 'Clear, colorless to slightly yellow & no visible particles';
            Editable = false;
        }

        field(5; "Appearance Verification"; Option)
        {
            OptionMembers = Open,Pass,Fail;
        }

        field(6; "Appearance Comments"; Text[2048]) { }
        field(7; "Appearance Performed By"; Text[100]) { }
        field(8; "Appearance Date"; Date) { }
    }

    keys
    {
        key(PK; "Work Order No.", "Sample #")
        {
            Clustered = true;
        }
    }
}