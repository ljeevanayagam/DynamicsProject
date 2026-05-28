pageextension 50107 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        modify("Direct Unit Cost")
        {
            Caption = 'Actual Unit Price';
            ApplicationArea = All;
            ToolTip = 'Manual entry of Direct Unit Cost allowed for any line type.';
        }
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
        addbefore(Type)
        {
            field("Item Line No."; Rec.ItemLineNo)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}