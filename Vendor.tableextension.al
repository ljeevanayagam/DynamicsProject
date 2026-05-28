enum 50101 "Vendor Category Enum"
{
    Extensible = true;

    value(0; NonCritical) { Caption = 'Non-Critical'; }
    value(1; Critical) { Caption = 'Critical'; }
    value(2; Important) { Caption = 'Important'; }
    value(3; Consulting) { Caption = 'Consulting'; }
}

enum 50102 "Vendor Status Enum"
{
    Extensible = true;

    value(0; Approved) { Caption = 'Approved'; }
    value(1; Conditional) { Caption = 'Conditional'; }
    value(2; NotApproved) { Caption = 'Not Approved'; }
    value(3; Inactive) { Caption = 'Inactive'; }
}

enum 50103 "Monitoring Requirement Type"
{
    Extensible = true;
    value(0; "Periodic Monitoring") { Caption = 'Periodic Monitoring'; }
    value(1; Annual) { Caption = 'Annual'; }
    value(2; "3-Year Evaluation") { Caption = '3-Year Evaluation'; }
    value(3; "For Cause") { Caption = 'For Cause'; }
    value(4; "Supplier Change") { Caption = 'Supplier Change'; }
}
tableextension 50100 "Vendor Extension" extends Vendor
{
    fields
    {
        field(50100; "Vendor Category"; Enum "Vendor Category Enum")
        {
            Caption = 'Vendor Category';
            DataClassification = CustomerContent;
        }

        field(50101; "Vendor Status"; Enum "Vendor Status Enum")
        {
            Caption = 'Vendor Status';
            DataClassification = CustomerContent;
        }

        field(50103; "Monitoring Requirements"; Text[250])
        {
            Caption = 'Monitoring Requirements';
            DataClassification = CustomerContent;
            ObsoleteState = Pending;
            ObsoleteReason = 'Replaced by Monitoring Requirement and Monitoring Explanation.';
        }

        field(50104; "Monitoring Requirement"; Enum "Monitoring Requirement Type")
        {
            Caption = 'Monitoring Requirement';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin

                if (("Monitoring Requirement" <> "Monitoring Requirement"::"For Cause") and
                    ("Monitoring Requirement" <> "Monitoring Requirement"::"Supplier Change")) then
                    Clear("Monitoring Explanation");
            end;
        }

        field(50105; "Monitoring Explanation"; Text[250])
        {
            Caption = 'Monitoring Explanation';
            DataClassification = CustomerContent;
        }
    }
}