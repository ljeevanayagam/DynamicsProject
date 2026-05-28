tableextension 50102 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(50300; "Account ID"; Code[100])
        {
            Caption = 'Account ID';
            DataClassification = CustomerContent;
        }
    }
}