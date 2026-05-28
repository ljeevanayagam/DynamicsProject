pageextension 50103 "Item Card Ext" extends "Item Card"
{
    layout
    {
        modify("Default Deferral Template Code")
        {
            Visible = false;
            ApplicationArea = All;
        }

        modify("Tariff No.")
        {
            Visible = false;
            ApplicationArea = All;
        }

        modify("Country/Region of Origin Code")
        {
            Visible = false;
            ApplicationArea = All;
        }

        modify("Allow Invoice Disc.")
        {
            Visible = false;
            ApplicationArea = All;
        }

        modify("Common Item No.")
        {
            Visible = false;
            ApplicationArea = All;
        }

        // Rename No. to Part No.
        modify("No.")
        {
            Caption = 'Part No.';
            ApplicationArea = All;
        }

        // Rename Description 2 to Revision
        modify("Description 2")
        {
            Caption = 'Revision';
            ApplicationArea = All;
        }

        modify("Search Description")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Purchasing Code")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Shelf No.")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Qty. on Component Lines")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Net Weight")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Gross Weight")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Standard Cost")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Unit Cost")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Indirect Cost %")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Last Direct Cost")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Cost is Adjusted")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Excluded from Cost Adjustment")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Cost is Posted to G/L")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Inventory Value Zero")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Unit Price")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Item Disc. Group")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Sales Unit of Measure")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Purch. Unit of Measure")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Scrap %")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Include Inventory")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Put-away Unit of Measure Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
    }
}