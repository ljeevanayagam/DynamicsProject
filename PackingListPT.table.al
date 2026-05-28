table 60512 "Packing List PT Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Work Order No."; Code[50])
        {
            TableRelation = "Work Order Header";
        }
        field(2; "Ship To"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PT Certificate of Analysis Top"."Ship To"
                where("Work Order No." = field("Work Order No.")));
        }

        field(3; Attention; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PT Certificate of Analysis Top"."Ship Attention"
                where("Work Order No." = field("Work Order No.")));
        }

        field(4; Address; Text[200])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PT Certificate of Analysis Top"."Ship Address"
                where("Work Order No." = field("Work Order No.")));
        }

        field(5; Phone; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PT Certificate of Analysis Top"."Ship Phone No."
                where("Work Order No." = field("Work Order No.")));
        }

        field(6; "PO No."; Code[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PT Certificate of Analysis Top"."PO No."
                where("Work Order No." = field("Work Order No.")));
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