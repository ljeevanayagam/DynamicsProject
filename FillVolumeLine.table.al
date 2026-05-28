table 60101 "Fill Volume Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Work Order No."; Code[200]) { }

        field(2; "Bulk Solution Serial No."; Code[250]) { }

        field(3; "Line No."; Integer) { }

        field(4; "Bag #"; Integer) { }

        field(5; "Bag Wt (g)"; Integer) { }

        field(6; "Weight Verification"; Option)
        {
            OptionMembers = Open,Pass,Fail;
        }
        field(7; "Performed By"; Text[100]) { }
        field(8; Date; Date) { }
    }

    keys
    {
        key(PK; "Work Order No.", "Bulk Solution Serial No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        FillLine: Record "Fill Volume Line";
    begin
        if "Line No." = 0 then begin
            FillLine.SetRange("Work Order No.", "Work Order No.");
            FillLine.SetRange("Bulk Solution Serial No.", "Bulk Solution Serial No.");

            if FillLine.FindLast() then
                "Line No." := FillLine."Line No." + 10000
            else
                "Line No." := 10000;
        end;
    end;
}