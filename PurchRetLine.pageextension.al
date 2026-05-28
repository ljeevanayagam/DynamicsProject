pageextension 50105 "Purchase Return Line" extends "Purchase Return Order Subform"
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
    }
}