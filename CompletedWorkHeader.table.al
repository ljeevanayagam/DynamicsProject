table 61001 "Completed Work Order"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[100])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Work Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Work Order No.';
        }
        field(3; "Product Part Number"; Code[20]) { }
        field(4; "Product Description"; Text[250]) { }
        field(5; Revision; Text[50]) { }
        field(6; "Lot Number"; Code[50]) { }
        field(7; "Routing No."; Code[20]) { }
        field(8; Status; Option)
        {
            OptionMembers = Completed;
        }
        field(9; "Requires Product Release"; Boolean) { }
        field(10; "GTIN-14, Container"; Code[250])
        {

        }
        field(11; "GTIN-14, Carton"; Code[250]) { }
        field(12; "Lot Quantity"; Integer) { }
        field(13; "Quantity Actually Used"; Integer) { }
        field(14; "Completed Date"; Date) { }
        field(15; "Completed By"; Code[50]) { }
        // field(16; "Run No."; Integer)
        // {
        //     DataClassification = CustomerContent;
        // }
        field(17; "Storage Condition"; Text[100]) { }
        field(18; "Date of Manufacture"; Date) { }
        field(19; "Expiration Date"; Date) { }
        field(20; "Data Entered By"; Text[100]) { }
    }
    //         field(2; "Status"; Option)
    //         {
    //             OptionMembers = Open,Released,Completed;
    //             DataClassification = CustomerContent;
    //             Caption = 'Status';
    //         }

    //         field(3; "Requires Product Release"; Boolean)
    //         {
    //             DataClassification = CustomerContent;
    //             Caption = 'Requires Product Release';
    //         }

    //         field(4; "Completed Date"; Date)
    //         {
    //             DataClassification = CustomerContent;
    //             Caption = 'Completed Date';
    //         }

    //         field(6; "Product Description"; Text[250]) { }
    //         field(7; Revision; Text[50]) { }
    //         field(8; "Storage Condition"; Text[100]) { }
    //         field(9; "Date of Manufacture"; Date) { }
    //         field(10; "Expiration Date"; Date) { }
    //         field(11; "Data Entered By"; Text[100]) { }
    //         field(12; "GTIN-14, Container"; Code[250]) { }
    //         field(13; "GTIN-14, Carton"; Code[250]) { }
    //         field(14; "Lot Quantity"; Decimal) { }
    //         field(15; "Quantity actually used"; Decimal) { }
    //     }

    keys
    {
        key(PK; "Work Order No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if Rec."No." = '' then
            Rec."No." := "Work Order No.";
    end;

    procedure UpdateFromRuns()
    var
        Run: Record "Completed Work Order Run";
        TotalQty: Integer;
    begin
        TotalQty := 0;

        Run.SetRange("Work Order No.", "Work Order No.");
        if Run.FindSet() then
            repeat
                TotalQty += Run."Accepted Quantity";
            until Run.Next() = 0;

        "Quantity Actually Used" := TotalQty;
        "Completed Date" := Today;
        "Completed By" := UserId;
        Status := Status::Completed;

        Modify(true);
    end;
}