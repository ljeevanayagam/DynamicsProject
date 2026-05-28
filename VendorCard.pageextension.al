pageextension 50104 "Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("Vendor Category"; Rec."Vendor Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the category of the vendor. Use this field to classify vendors as Non-Critical, Critical, Important, or Consulting for evaluation purposes.';
            }

            field("Vendor Status"; Rec."Vendor Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the current status of the vendor. Approved vendors are fully active, Conditional vendors have limitations, and Not Approved or Inactive vendors should not be used for transactions.';

                trigger OnValidate()
                begin
                    SetBlockedByStatus();
                end;
            }

            field("Monitoring Requirement"; Rec."Monitoring Requirement")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how often the vendor must be monitored. Options include Periodic Monitoring, Annual, 3-Year Evaluation, For Cause, or Supplier Change.';
            }

            field("Monitoring Explanation"; Rec."Monitoring Explanation")
            {
                ApplicationArea = All;
                MultiLine = true;
                ToolTip = 'Provide details or justification when the monitoring requirement is set to For Cause or Supplier Change. This ensures proper documentation of the monitoring decision.';
            }
        }

        modify(Blocked)
        {
            ApplicationArea = All;
            Editable = false;
            ToolTip = 'Shows whether the vendor is blocked for transactions. This field is automatically updated based on Vendor Status and cannot be edited directly.';
        }

        modify("Privacy Blocked")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("GLN")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Currency Code")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("IC Partner Code")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Disable Search by Name")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Company Size Code")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Statistics Group")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Language Code")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Format Region")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("EORI Number")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Bank Communication")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Invoice Disc. Code")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify(Priority)
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Exclude from Pmt. Practices")
        {
            ApplicationArea = All;
            Visible = false;
        }

        modify("Responsibility Center")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Purchaser Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Payment Terms Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Payment Method Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Block Payment Tolerance")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Partner Type")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Intrastat Partner Type")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Cash Flow Payment Terms Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Federal ID No.")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Tax Identification Type")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Creditor No.")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Check Date Format")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Check Date Separator")
        {
            ApplicationArea = All;
            Visible = false;
        }
        modify("Shipment Method Code")
        {
            ApplicationArea = All;
            Visible = false;
        }
    }
    trigger OnOpenPage()
    begin
        SetBlockedByStatus();
    end;

    local procedure SetBlockedByStatus()
    var
        BlankBlocked: Enum "Vendor Blocked";
    begin
        case Rec."Vendor Status" of
            Rec."Vendor Status"::Approved:
                Rec.Blocked := BlankBlocked;
            Rec."Vendor Status"::Conditional:
                Rec.Blocked := Rec.Blocked::Payment;
            else
                Rec.Blocked := Rec.Blocked::All;
        end;

        CurrPage.UPDATE();
    end;
}