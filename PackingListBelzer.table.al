table 60108 "Packing List Belzer"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Work Order No."; Code[50])
        {
            TableRelation = "Work Order Header";
        }
        field(2; "Bill To"; Text[100])
        {
        }
        field(3; "Ship To"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Certificate of Analysis Belzer"."Ship To" where("Work Order No." = field("Lot Number")));
        }
        field(4; "Ship Attention"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Certificate of Analysis Belzer".Attention where("Work Order No." = field("Lot Number")));
        }
        field(5; "Ship Address"; Text[200])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Certificate of Analysis Belzer".Address where("Work Order No." = field("Lot Number")));
        }
        field(6; "Ship Phone No."; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Certificate of Analysis Belzer".Phone where("Work Order No." = field("Lot Number")));
        }
        field(7; "Ship Email"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Certificate of Analysis Belzer".Email where("Work Order No." = field("Lot Number")));
        }
        field(8; "Product Part Number"; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Work Order Header"."Product Part Number" where("No." = field("Work Order No.")));
        }
        field(9; "Product Description"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Work Order Header"."Product Description" where("No." = field("Work Order No.")));
        }
        field(10; "Lot Number"; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Work Order Header"."Lot Number" where("No." = field("Work Order No.")));
        }
        field(11; "Manufacture Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Work Order Header"."Date of Manufacture" where("No." = field("Work Order No.")));
        }
        field(12; "Expiration Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Work Order Header"."Expiration Date" where("No." = field("Work Order No.")));
        }
        field(13; "No. of Cartons"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Work Order Header"."Total Carton Positions" where("No." = field("Work Order No.")));
        }
        field(14; "No. of Bags"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Work Order Header"."Quantity for Processing" where("No." = field("Work Order No.")));
        }
        field(15; "No. of Pallets"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Work Order Header"."Total Pallets" where("No." = field("Work Order No.")));
        }
        field(16; "Packaged By"; Text[100]) { }
        field(17; "Packaged Date"; Date) { }
        field(18; "Verified By"; Text[100]) { }
        field(19; "Verified Date"; Date) { }
    }
    keys
    {
        key(PK; "Work Order No.")
        {
            Clustered = true;
        }
    }
}