tableextension 50410 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        field(50100; ItemLineNo; Integer)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50410; "Revision"; Code[20])
        {
            Caption = 'Revision';
            DataClassification = CustomerContent;
        }
        modify("Location Code")
        {
            trigger OnBeforeValidate()
            begin
                if Rec.Type = Rec.Type::Item then
                    Rec."Location Code" := 'MAIN';
            end;
        }
        modify("Bin Code")
        {
            trigger OnBeforeValidate()
            begin
                if Rec.Type = Rec.Type::Item then
                    Rec."Bin Code" := 'RCV-01';
            end;
        }
    }
}