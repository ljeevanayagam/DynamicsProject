pageextension 50106 "Purchase Order Header Ext" extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field("Account ID"; Rec."Account ID")
            {
                ApplicationArea = All;
            }
        }

        modify("Currency Code") { Visible = false; ApplicationArea = All; }
        modify("Requested Receipt Date") { Visible = false; ApplicationArea = All; }
        modify("Promised Receipt Date") { Visible = false; ApplicationArea = All; }
        modify("On Hold") { Visible = false; ApplicationArea = All; }
        modify("Creditor No.") { Visible = false; ApplicationArea = All; }

        // Lock these fields from manual editing
        modify("Due Date") { Editable = false; ApplicationArea = All; }
        modify("Expected Receipt Date") { Editable = false; ApplicationArea = All; }
    }
}