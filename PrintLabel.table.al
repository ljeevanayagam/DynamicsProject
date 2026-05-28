table 60109 "Print Label Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Work Order No."; Code[20])
        {
            TableRelation = "Work Order Header";
        }
        field(2; "Label Part No."; Code[50])
        {
            InitValue = 'PL-0002-09';
        }
        field(3; "Label Revision"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Work Order Header".Revision where("No." = FIELD("Work Order No.")));
        }
        field(4; "Label Stock Part No."; Code[20]) { InitValue = 'PRT-0475'; }
        field(5; "Ribbon Part No."; Code[20]) { InitValue = 'PRT-0472-01'; }
        field(6; "Label Stock Lot No."; Code[50]) { }
        field(7; "Ribbon Lot No."; Code[50]) { }
        field(8; Status; Option)
        {
            OptionMembers = Open,"In Progress",Completed;
        }
        field(9; "Total Printed"; Integer) { Editable = false; }
        field(10; "Total Retain"; Integer) { Editable = false; }
        field(11; "Total Accepted"; Integer) { Editable = false; }
        field(12; "Total Rejected"; Integer) { Editable = false; }
        field(13; "Location Code"; Code[10]) { InitValue = 'MAIN'; }
        field(14; "Bin Code"; Code[20]) { InitValue = 'PROD-01'; }
        field(15; "Show PRINTLABEL"; Boolean) { Editable = false; }
    }
    keys
    {
        key(PK; "Work Order No.") { Clustered = true; }
    }
    procedure ResetTotals()
    begin
        "Total Printed" := 0;
        "Total Retain" := 0;
        "Total Accepted" := 0;
        "Total Rejected" := 0;

        Modify(true);
    end;

    trigger OnModify()
    var
        PLMgt: Codeunit "Print Label Post Mgt";
    begin
        PLMgt.UpdateWorkOrderPrintLabelStatus("Work Order No.");
    end;

    procedure HasAnyInput(): Boolean
    begin
        exit(
            ("Label Stock Lot No." <> '') or
            ("Ribbon Lot No." <> '')
        );
    end;

    procedure IsComplete(): Boolean
    begin
        exit(
            ("Label Stock Lot No." <> '') and
            ("Ribbon Lot No." <> '')
        );
    end;
}