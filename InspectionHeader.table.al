table 50100 "Inspection Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }

        field(2; "Inspection No."; Code[20])
        {
            Editable = true;

            trigger OnValidate()
            begin
                if "Inspection No." = '' then
                    Error('Inspection No. cannot be blank.');
            end;
        }

        field(3; "Date Received"; Date) { }
        field(4; "Purchase Order No."; Code[20]) { Editable = false; }
        field(5; "Vendor No."; Text[50]) { Editable = false; }
        field(6; "Vendor Name"; Text[100]) { Editable = false; }
        field(7; "Item No."; Code[50]) { Editable = false; }
        field(8; "Item Description"; Text[100]) { Editable = false; }
        field(9; "Lot No."; Code[50]) { Editable = false; }
        field(10; Quantity; Decimal) { }
        field(11; "Received By"; Code[50]) { }
        field(12; Status; Enum "Inspection Status") { }
        field(13; Notes; Text[250]) { }
        field(14; "Purchase Order Line No."; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'No longer needed in this extension.';
            ObsoleteTag = '1.1';
        }
        field(15; "The Inspection No."; Text[250])
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'No longer needed in this extension.';
            ObsoleteTag = '1.1';
        }
        field(16; "Serial No."; Code[250]) { Editable = false; }
        field(17; "Bin Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Received Quantity"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'No longer needed in this extension.';
            ObsoleteTag = '1.1';
        }

        field(19; "Failed Quantity"; Integer)
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'No longer needed in this extension.';
            ObsoleteTag = '1.1';
        }

    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }

        key(InspectionNoKey; "Inspection No.")
        { }
    }
    trigger OnInsert()
    var
        CheckRec: Record "Inspection Header";
    begin
        // Prevent duplicate Inspection No.
        if "Inspection No." <> '' then begin
            CheckRec.Reset();
            CheckRec.SetRange("Inspection No.", "Inspection No.");

            if CheckRec.FindFirst() then
                Error('Inspection No. %1 already exists.', "Inspection No.");
        end;
    end;
}