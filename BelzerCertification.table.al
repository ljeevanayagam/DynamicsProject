table 60107 "Certificate of Analysis Belzer"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Work Order No."; Code[50])
        {
            TableRelation = "Work Order Header";
            trigger OnValidate()
            var
                WO: Record "Work Order Header";
            begin
                if WO.Get("Work Order No.") then begin
                    "Product Part Number" := WO."Product Part Number";
                    "Product Description" := WO."Product Description";
                    "Lot Number" := WO."Lot Number";
                    "Manufacture Date" := WO."Date of Manufacture";
                    "Expiration Date" := WO."Expiration Date";
                    "Lot Quantity" := WO."Lot Quantity";
                end;
            end;
        }
        field(2; "Line No."; Integer) { }
        field(3; "Ship To"; Text[100]) { }
        field(4; Attention; Text[100]) { }
        field(5; Address; Text[200]) { }
        field(6; "Phone"; Text[30]) { }
        field(7; Email; Text[100]) { }
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
        field(13; "Bulk Solution Lot Numbers"; Text[100]) { }
        field(14; "Lot Quantity"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Work Order Header"."Quantity for Processing" where("No." = field("Work Order No.")));
        }
        field(15; "Test"; Text[100])
        {
            Editable = false;
        }
        field(16; "Test Method"; Text[100])
        {
            Editable = false;
        }
        field(17; Specification; Text[1000])
        {
            Editable = false;
        }
        field(18; Results; Option)
        {
            OptionMembers = Open,Pass,Fail;
        }
        field(19; "Quality Assurance"; Text[100]) { }
        field(20; Date; Date) { }
    }
    keys
    {
        key(PK; "Work Order No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        BCert: Record "Certificate of Analysis Belzer";
    begin
        if "Line No." = 0 then begin
            BCert.SetRange("Work Order No.", "Work Order No.");
            if BCert.FindLast() then
                "Line No." := BCert."Line No." + 10000
            else
                "Line No." := 10000;
        end;
    end;
}