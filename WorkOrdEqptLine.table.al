table 60005 "Work Order Equipment Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Work Order No."; Code[50]) { TableRelation = "Work Order Header"."No."; }
        field(2; "Line No."; Integer) { }
        field(3; "Equipment Description"; Text[250]) { }
        field(4; "EQ#, Cal. ID or Equivalent"; Text[250]) { }
        field(5; "EQ#/Cal. ID/Equivalent used"; Text[250]) { }
        field(6; "Eqpt Parameters/accpt criteria"; Text[2048]) { }
        field(7; "Performed By"; Text[100]) { }
        field(8; Date; Date) { }

    }

    keys
    {
        key(PK; "Work Order No.", "Line No.") { Clustered = true; }
    }

    trigger OnInsert()
    var
        EquipLine: Record "Work Order Equipment Line";
    begin
        if "Line No." = 0 then begin
            EquipLine.SetRange("Work Order No.", "Work Order No.");
            if EquipLine.FindLast() then
                "Line No." := EquipLine."Line No." + 10000
            else
                "Line No." := 10000;
        end;
    end;
}