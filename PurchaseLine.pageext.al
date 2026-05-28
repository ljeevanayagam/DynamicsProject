pageextension 50102 "Purchase Line Ext" extends "Purchase Order Subform"
{
    layout
    {
        modify("No.")
        {
            Caption = 'Part No.';
            ApplicationArea = All;
        }

        modify("Description 2")
        {
            Caption = 'Revision';
            ApplicationArea = All;
        }
        modify("Promised Receipt Date")
        {
            ApplicationArea = All;
            Visible = false;
        }

    }
}