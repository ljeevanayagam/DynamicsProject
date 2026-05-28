page 60001 "Work Order Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Work Order Header";
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            group(BelzerGeneral)
            {
                Caption = 'General';
                Visible = Rec."Show BELZER";
                field("No."; Rec."No.") { Editable = false; }
                field("Product Part Number"; Rec."Product Part Number") { Editable = false; }
                field(Revision; Rec.Revision) { }
                field("Product Description"; Rec."Product Description") { Editable = false; }
                field("Lot Number"; Rec."Lot Number") { Editable = false; }
                field("Lot Quantity (Bags)"; Rec."Lot Quantity (Bags)") { Editable = false; }
                field("Lot Quantity (Cases)"; Rec."Lot Quantity (Cases)") { Editable = false; }
                field("Lot Quantity"; Rec."Lot Quantity")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field("Quantity of Bags"; Rec."Quantity of Bags")
                {
                    Editable = false;
                    trigger OnValidate()
                    begin
                        Rec.RefreshImportantData();
                        CurrPage.Update(false);
                    end;
                }
                field("Unit Size (mL)"; Rec."Unit Size (mL)")
                {
                    Visible = Rec."Show BELZER";
                }
                field("Storage Condition"; Rec."Storage Condition") { }
                field("Date of Manufacture"; Rec."Date of Manufacture")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field("Data Entered By"; Rec."Data Entered By") { }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field("GTIN-14, Container"; Rec."GTIN-14, Container") { Editable = false; }
                field("GTIN-14, Carton"; Rec."GTIN-14, Carton") { Editable = false; }
                field("Routing No."; Rec."Routing No.") { Editable = false; }
                field(BelzerStatus; Rec."Work Order Status")
                {
                    Visible = not Rec."Show PRINTLABEL";
                }
            }
            group(SUBOTSGeneral)
            {
                Caption = 'General';
                Visible = Rec."Show SUB-OTS";
                field("SUBOTS Product Part Number"; Rec."Product Part Number") { Editable = false; }
                field(SUBOTSRevision; Rec.Revision) { Editable = false; }
                field("SUBOTS Product Description"; Rec."Product Description") { Editable = false; }
                field("SUBOTS Lot Number"; Rec."Lot Number") { Editable = false; }
                field("SUBOTS Lot Quantity"; Rec."Lot Quantity") { }
                field("SUBOTS Date of Manufacture"; Rec."Date of Manufacture") { }
                field("SUBOTS Storage Condition"; Rec."Storage Condition") { }
                field("SUBOTS Data Entered By"; Rec."Data Entered By") { }
                field(SUBOTSStatus; Rec."Work Order Status")
                {
                    Visible = not Rec."Show PRINTLABEL";
                }
            }
            group(FILLSETGeneral)
            {
                Caption = 'General';
                Visible = Rec."Show FILL_SET";
                field("FILL Product Part Number"; Rec."Product Part Number") { Editable = false; }
                field(FILLRevision; Rec.Revision) { Editable = false; }
                field("FILL Product Description"; Rec."Product Description") { Editable = false; }
                field("FILL Lot Number"; Rec."Lot Number") { Editable = false; }
                field("FILL Lot Quantity"; Rec."Lot Quantity") { }
                field("FILL Date of Manufacture"; Rec."Date of Manufacture") { }
                field("FILL Storage Condition"; Rec."Storage Condition") { }
                field("FILL Data Entered By"; Rec."Data Entered By") { }
                field(FILLStatus; Rec."Work Order Status")
                {
                    Visible = not Rec."Show PRINTLABEL";
                }
            }
            group(MOONMLTGeneral)
            {
                Caption = 'General';
                Visible = Rec."Show MOON-MNLT";
                field("MOON Product Part Number"; Rec."Product Part Number") { Editable = false; }
                field(MOONRevision; Rec.Revision) { Editable = false; }
                field("MOON Product Description"; Rec."Product Description") { Editable = false; }
                field("MOON Lot Number"; Rec."Lot Number") { Editable = false; }
                field("MOON Lot Quantity"; Rec."Lot Quantity") { }
                field("MOON Date of Manufacture"; Rec."Date of Manufacture") { }
                field("MOON Storage Condition"; Rec."Storage Condition") { }
                field("Moonlight Therap Contents"; Rec."Moonlight Therap Contents") { }
                field("MOON Data Entered By"; Rec."Data Entered By") { }
                field(MOONStatus; Rec."Work Order Status")
                {
                    Visible = not Rec."Show PRINTLABEL";
                }
            }
            group(PedgaGeneral)
            {
                Caption = 'PEDGA General';
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                field("PEDGA Part Number"; Rec."PEDGA Part Number") { Editable = false; }
                field("PEDGA Revision"; Rec."PEDGA Revision") { Editable = false; }
                field("PEDGA Description"; Rec."PEDGA Description") { Editable = false; }
                field("P Batch Size (Theor. Units)"; Rec."Batch Size (Theor. Units)")
                {
                    trigger OnValidate()
                    begin
                        Rec.RecalculatePT();
                    end;
                }
                field("Pedga Unit Size (mL)"; Rec."Unit Size (mL)")
                {
                    trigger OnValidate()
                    begin
                        Rec.RecalculatePT();
                        CurrPage.Update(false);
                    end;
                }
                field("P Storage Condition"; Rec."Storage Condition") { }
                field("Pedga Mix Date"; Rec."Pedga Mix Date") { }
                field("PEDGA Customer Lot Number"; Rec."PEDGA Customer Lot Number")
                {
                    Caption = 'Customer Lot Number';
                }
            }
            group("PEDGA Materials Used")
            {
                Caption = 'Pedga Materials Used';
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                part(PedgaMaterial; "Pedga Materials Page") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("PEDGA Operational Supplies")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                part(PEDGAOperation; "PEDGA Operational Page") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("PEDGA Equipment Used")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                part(PEDGAEquipment; "Pedga Equipment Used page") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("LHR 1005 PEDGA Inputs")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') or (Rec."Thiocure Part Number" = 'PN-0447');
                field("Batch Volume Required (mL)"; Rec."Batch Volume Required (mL)") { Editable = false; }
                field("PEDGA Amount needed (g)"; Rec."PEDGA Amount needed (g)") { Editable = false; }
                field("Pedga Volume (mL)"; Rec."Pedga Volume (mL)") { Editable = false; }
                field("PEDGA Water Weight (g)"; Rec."PEDGA Water Weight (g)") { Editable = false; }
                field("Verify Pedga Amount (g)"; Rec."Verify Pedga Amount (g)")
                {
                    Tooltip = 'Place the container (Jar, Bottle or Stainless Steel Pot) with Stir Bar on Balance and tare. Weigh PEDGA 700 to calculated amount; record actual weight (g) and verify.';
                    trigger OnValidate()
                    var
                        ValidationMgt: Codeunit "Work Order Validation Mgt";
                    begin
                        ValidationMgt.ValidateRoundedWeight(Rec."PEDGA Amount needed (g)", Rec."Verify Pedga Amount (g)", Rec."Verify Pedga Amount (g)".ToText())
                    end;
                }
                field("Verify Pedga Water weight"; Rec."Verify Pedga Water weight")
                {
                    Tooltip = 'Tare Container with PEDGA; add calculated Molecular Biology Grade water, record actual weight (g) and verify; cap/cover the Container and stir until the solution is homogenous';
                    trigger OnValidate()
                    var
                        Expected: Decimal;
                        Actual: Decimal;
                    begin
                        Rec.ValidatePedgaWaterWeight();
                        Rec.Modify();
                    end;
                }
                field("Verify PEDGA Customer"; Rec."Verify PEDGA Customer")
                {
                    Tooltip = 'Label container with Customer Lot No., record Lot No.; solution is ready for filling.';
                    trigger OnValidate()
                    begin
                        Rec.ValidatePEDGACustomer();
                        Rec.Modify()
                    end;
                }
                field("P Refrigeratior EQ (Optional)"; Rec."P Refrigeratior EQ (Optional)")
                {
                    Tooltip = 'If filling is delayed, store solution at 2-8 °C (refrigerated) and record refrigerator EQ No.; otherwise enter "N/A"';
                }
                field("Pedga Qty release inspection"; Rec."Pedga Qty release inspection")
                {
                    Tooltip = 'Enter the total quantity released for inspection (excluding the 10 samples)';
                    trigger OnValidate()
                    begin
                        if Rec."Pedga Qty release inspection" < -10 then
                            Error('Quantity must not be negative');
                    end;
                }
                field("Pedga Sample Size"; Rec."Pedga Sample Size")
                {
                    Tooltip = 'Enter sample size for PEDGA';
                    trigger OnValidate()
                    begin
                        if Rec."Pedga Sample Size" < 0 then
                            Error('Sample size must not be negative');
                    end;
                }
                field("PEDGA LHR Record Verify #1"; Rec."PEDGA LHR Record Verify #1")
                {
                    Tooltip = 'Verify proper label placement, Lot and Part Numbers are correct & legible.';
                }
                field("PEDGA LHR Record Verify #2"; Rec."PEDGA LHR Record Verify #2")
                {
                    Tooltip = 'Inspect the filled syringe for: Fill volume (25 ± 1 mL), no leakage, secure cap installation';
                }
                field("PEDGA LHR Record Verify #3"; Rec."PEDGA LHR Record Verify #3")
                {
                    Tooltip = 'Verify foreign matter inside the filled syringe.';
                }
                field("Pedga rejected Qty"; Rec."Pedga rejected Qty")
                {
                    Tooltip = 'Enter the total rejected quantity (if applicable) and complete all required fields on the DIsposition of Discrepant Materials page.';
                    trigger OnValidate()
                    begin
                        if Rec."Pedga rejected Qty" < 0 then
                            Error('Quantity must not be negative');
                        if Rec."Pedga rejected Qty" > Rec."Pedga Qty release inspection" then
                            Error('Rejected quantity cannot exceed the quantity released for inspection.');
                    end;
                }
                field("Pedga total qty further proc"; Rec."Pedga total qty further proc")
                {
                    Tooltip = 'Total quantity released for further processing.';
                    trigger OnValidate()
                    begin
                        if Rec."Pedga total qty further proc" < 0 then
                            Error('Quantity must not be negative');
                    end;
                }
            }
            group(ThiocureGeneral)
            {
                Caption = 'Thiocure General';
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                field("Thiocure Part Number"; Rec."Thiocure Part Number") { Editable = false; }
                field("THIOCURE Revision"; Rec."THIOCURE Revision") { Editable = false; }
                field("THIOCURE Description"; Rec."THIOCURE Description") { Editable = false; }
                field("T Batch Size (Theor. Units)"; Rec."Batch Size (Theor. Units)") { Editable = false; }
                field("Thiocure Unit Size (mL)"; Rec."Unit Size (mL)") { Editable = false; }
                field("T Storage Condition"; Rec."Storage Condition") { Editable = false; }
                field("Thiocure Mix Date"; Rec."Thiocure Mix Date") { }
                field("THIOCURE Customer Lot Number"; Rec."THIOCURE Customer Lot Number")
                {
                    Caption = 'Customer Lot Number';
                }
            }
            group("THIOCURE Materials Used")
            {
                Caption = 'Thiocure Materials Used';
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                part(ThiocureMaterial; "Thiocure Materials Page") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("THIOCURE Operational Supplies")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                part(THIOCUREOperation; "Thiocure Operational Page") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("THIOCURE Equipment Used")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                part(THIOCUREEquipment; "Thiocure Equipment Used page") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("LHR 1005 Thiocure Inputs")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') or (Rec."Thiocure Part Number" = 'PN-0447');
                field("Thiocure 333 needed (g)"; Rec."Thiocure 333 needed (g)") { Editable = false; }
                field("TH333 Volume (mL)"; Rec."TH333 Volume (mL)") { Editable = false; }
                field("SBC Soln Weight (g)"; Rec."SBC Soln Weight (g)") { Editable = false; }
                field("SBC Soln Vol (L)"; Rec."SBC Soln Vol (L)") { Editable = false; }
                field("SBC Weight (g)"; Rec."SBC Weight (g)") { Editable = false; }
                field("TH333 Water Weight (g)"; Rec."TH333 Water Weight (g)") { Editable = false; }
                field("Verify Thiocure SBC Weight"; Rec."Verify Thiocure SBC Weight")
                {
                    Tooltip = 'Place the container (Jar, Bottle or Stainless Steel Pot) with Stir Bar on Balance and tare. Weigh SBC to calculated amount; record actual weight (g) and verify.';
                    trigger OnValidate()
                    var
                        Expected: Decimal;
                        Actual: Decimal;
                    begin
                        if Rec."Verify Thiocure SBC Weight" < 0 then
                            Error('Weight must not be negative');

                        // Normalize both values FIRST
                        Expected := Round(Rec."SBC Weight (g)", 1);
                        Actual := Round(Rec."Verify Thiocure SBC Weight", 1);

                        if Actual <> Expected then
                            Error(
                                'Mismatch detected. Expected %1 but got %2',
                                Expected,
                                Actual);
                    end;
                }
                field("Verify Thiocure Water Weight"; Rec."Verify Thiocure Water Weight")
                {
                    Tooltip = 'Tare container with SBC; add calculated Molecular Biology Grade Water, record actual wt (g) and verify; cap/cover and stir until fully dissolved.';
                    trigger OnValidate()
                    var
                        Expected: Decimal;
                        Actual: Decimal;
                    begin
                        if Rec."Verify Thiocure Water Weight" < 0 then
                            Error('Weight must not be negative');

                        // Normalize both values FIRST
                        Expected := Round(Rec."TH333 Water Weight (g)", 1);
                        Actual := Round(Rec."Verify Thiocure Water Weight", 1);

                        if Actual <> Expected then
                            Error(
                                'Mismatch detected. Expected %1 but got %2',
                                Expected,
                                Actual);
                    end;
                }
                field("Verify Mix Date code"; Rec."Verify Mix Date code")
                {
                    Tooltip = 'Label container (jar, bottle, or stainless steel pot) with Lot Date Code and "-SB" record Lot Date Code and set aside in flow hood.';
                    trigger OnValidate()
                    begin
                        if Rec."Verify Mix Date code" <>
                        (Format(Rec."Thiocure Mix Date", 0, '<Year,2><Month,2><Day,2>') + '-SB')
                        then
                            Error(
                                'Your input %1 does not match the expected format %2. Please verify the entry.',
                                Rec."Verify Mix Date code",
                                Format(Rec."Thiocure Mix Date", 0, '<Year,2><Month,2><Day,2>') + '-SB');
                    end;
                }
                field("Verify Thiocure 333 in mL"; Rec."Verify Thiocure 333 in mL")
                {
                    Tooltip = 'Place container with stir bar on balance and tare; weigh calculated Thiocure 333 into container, record actual wt (g) and verify.';
                    trigger OnValidate()
                    var
                        Expected: Decimal;
                        Actual: Decimal;
                    begin
                        if Rec."Verify Thiocure 333 in mL" < 0 then
                            Error('Weight must not be negative');

                        // Normalize both values FIRST
                        Expected := Round(Rec."Thiocure 333 needed (g)", 1);
                        Actual := Round(Rec."Verify Thiocure 333 in mL", 1);

                        if Actual <> Expected then
                            Error(
                                'Mismatch detected. Expected %1 but got %2',
                                Expected,
                                Actual);
                    end;
                }
                field("Actual Thiocure 333 weight"; Rec."Actual Thiocure 333 weight")
                {
                    Tooltip = 'Tare container with TH333; add calculated 0.375 M Sodium Bicarbonate Solution; Record the actual weight (g) and verify; cap/cover and stir until homogeneous.';
                    trigger OnValidate()
                    begin
                        if Rec."Actual Thiocure 333 weight" < 0 then
                            Error('Weight must not be negative');
                        if (Rec."Actual Thiocure 333 weight" <> Round(Rec."Thiocure 333 needed (g)", 1, '>')) then
                            Error('Actual weight differs from calculated amount. Please verify the weight entry and ensure it is correct.');
                    end;
                }
                field("Verify Thiocure Customer"; Rec."Verify Thiocure Customer")
                {
                    Tooltip = 'Label Container with Customer Lot No.; record Lot No. in LHR; solution ready for filling.';
                    trigger OnValidate()
                    begin
                        if Rec."Verify Thiocure Customer" <> Rec."THIOCURE Customer Lot Number" then
                            Error('Your input %1 does not match the THIOCURE Customer Lot Number %2. Please verify the entry.', Rec."Verify Thiocure Customer", Rec."THIOCURE Customer Lot Number");
                    end;
                }
                field("TH333 Qty release inspection"; Rec."TH333 Qty release inspection")
                {
                    Tooltip = 'Enter the total quantity released for inspection (excluding the ten samples).';
                    trigger OnValidate()
                    begin
                        if Rec."TH333 Qty release inspection" < -10 then
                            Error('Quantity must not be negative');
                    end;
                }
                field("Thiocure Sample Size"; Rec."Thiocure Sample Size")
                {
                    Tooltip = 'Enter Sample Size.';
                    trigger OnValidate()
                    begin
                        if Rec."Thiocure Sample Size" < 0 then
                            Error('Sample size must not be negative');
                    end;
                }
                field("Thiocure LHR Record Verify #1"; Rec."Thiocure LHR Record Verify #1")
                {
                    Tooltip = 'Verify proper label placement, Lot and Part Numbers are correct & legible.';
                }
                field("Thiocure LHR Record Verify #2"; Rec."Thiocure LHR Record Verify #2")
                {
                    Tooltip = 'Inspect the filled syringe for: Fill volume (25 ± 1 mL), no leakage, secure cap installation';
                }
                field("Thiocure LHR Record Verify #3"; Rec."Thiocure LHR Record Verify #3")
                {
                    Tooltip = 'Verify foreign matter inside the filled syringe.';
                }
                field("Thiocure rejected qty"; Rec."Thiocure rejected qty")
                {
                    Tooltip = 'Enter the total rejected quantity (if applicable) and complete all required fields on the DIsposition of Discrepant Materials page.';
                    trigger OnValidate()
                    begin
                        if Rec."Thiocure rejected qty" < 0 then
                            Error('Quantity must not be negative');
                        if Rec."Thiocure rejected qty" > Rec."TH333 Qty release inspection" then
                            Error('Rejected quantity cannot exceed the quantity released for inspection.');
                    end;
                }
                field("TH333 total qty further proc"; Rec."TH333 total qty further proc")
                {
                    Tooltip = 'Total quantity released for further processing.';
                    trigger OnValidate()
                    begin
                        if Rec."TH333 total qty further proc" < 0 then
                            Error('Quantity must not be negative');
                    end;
                }
            }
            group("Materials Used")
            {
                Visible = Rec."Show BELZER" or Rec."Show FILL_SET" or Rec."Show SUB-OTS" or Rec."Show MOON-MNLT";
                part(Materials; "Materials Subpage") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("LHR 1001 Inputs")
            {
                Visible = Rec."Show BELZER";
                field("Total Sample Quantity"; Rec."Total Sample Quantity")
                {
                    trigger OnValidate()
                    begin
                        if Rec."Total Sample Quantity" < 0 then
                            Error('Quantity must not be negative');
                        Rec.RefreshMaterialAndLabels();
                        Rec.UpdateBELZERState();
                        CurrPage.Update(false);
                    end;
                }
                field("Total Quantity Ready"; Rec."Total Quantity Ready")
                {
                    trigger OnValidate()
                    begin
                        if Rec."Total Quantity Ready" < 0 then
                            Error('Quantity must not be negative');
                        Rec.UpdateBELZERState();
                        CurrPage.Update(false);
                    end;
                }
                field("Rejected Quantity"; Rec."Rejected Quantity")
                {
                    trigger OnValidate()
                    begin
                        if Rec."Total Quantity Ready" < 0 then
                            Error('Quantity must not be negative');
                        Rec.UpdateBELZERState();
                        CurrPage.Update(false);
                    end;
                }
                field("Quantity for Processing"; Rec."Quantity for Processing") { }
                field("1st pallet Carton Qty"; Rec."1st pallet Carton Qty") { }
                field("2nd pallet Carton Qty"; Rec."2nd pallet Carton Qty") { }
                field("Total Full Cartons released"; Rec."Total Full Cartons released") { }
                field("Total Containers in Partial"; Rec."Total Containers in Partial") { }
                group("Unit Reconciliation")
                {
                    field(Theoretical; Rec.Theoretical) { }
                    field(Actual; Rec.Actual) { }
                    field(Variance; Rec.Variance) { }
                    field("Yield = Theoretical ± 10%"; Rec."Yield = Theoretical ± 10%") { }
                }
            }
            group("LHR 1002 Inputs")
            {
                Visible = Rec."Show SUB-OTS";
                repeater(LHR1002Group)
                {
                    field(AutoclaveCycle; Rec."Autoclave Cycle Number") { }
                    field(AutoclaveDate; Rec."Autoclave Record Date") { }
                    field(AutoclaveEQ; Rec."Which EQ did you use?") { }
                    field(autoclaveVerification; Rec."Autoclave Cycle Verification") { }
                }
            }
            group("LHR 1003 Inputs")
            {
                Visible = Rec."Show FILL_SET";
                field("Tubing Sample Size"; Rec."Tubing Sample Size") { ToolTip = 'Tubing Length Verification, Primary Package (1.0 AQL). Enter sample size.'; }
                field("Verify 1st Tubing length"; Rec."Verify 1st Tubing length") { ToolTip = 'Verify that the tubing length is within 36 ± 1/4 inches. Visually inspect both cut ends to ensure they are smooth and free from shreds or angle hair.'; }
                field("Total rej qty 1st Tubing"; Rec."Total rej qty 1st Tubing") { ToolTip = 'Enter the total rejected quantity (if applicable)'; }
                field("Verify 2nd Tubing length"; Rec."Verify 2nd Tubing length") { ToolTip = 'Verify that the tubing length is within 28 ± 1/4 inches. Visually inspect both cut ends to ensure they are smooth and free from shreds or angle hair.'; }
                field("Total rej qty 2nd Tubing"; Rec."Total rej qty 2nd Tubing") { ToolTip = 'Enter the total rejected quantity (if applicable)'; }
                field("Verify 3rd Tubing length"; Rec."Verify 3rd Tubing length") { ToolTip = 'Verify that the tubing length is within 12 ± 1/4 inches. Visually inspect both cut ends to ensure they are smooth and free from shreds or angle hair.'; }
                field("Total rej qty 3rd Tubing"; Rec."Total rej qty 3rd Tubing") { ToolTip = 'Enter the total rejected quantity (if applicable)'; }
                field("Verify 4th Tubing length"; Rec."Verify 4th Tubing length") { ToolTip = 'Verify that the tubing length is within 1/8 ± 1/16 inches. Visually inspect both cut ends to ensure they are smooth and free from shreds or angle hair.'; }
                field("Total rej qty 4rd Tubing"; Rec."Total rej qty 4rd Tubing") { ToolTip = 'Enter the total rejected quantity (if applicable)'; }
                field("LHR 1003 Heat Temp (F)"; Rec."LHR 1003 Heat Temp (F)") { }
                field("LHR 1003 Heating Time (sec)"; Rec."LHR 1003 Heating Time (sec)") { }
                field("LHR 1003 Cooling Temp (CT-F)"; Rec."LHR 1003 Cooling Temp (CT-F)") { }
                field("Packaging Sample Size"; Rec."Packaging Sample Size") { Tooltip = 'Packaging Verification, Primary Package (0.65 AQL). Enter sample size.'; }
                field("LHR 1003 Verify # 1"; Rec."LHR 1003 Verify # 1") { Tooltip = 'Verify proper label placement, Lot and Part Numbers are correct & legible.'; }
                field("LHR 1003 Verify # 2"; Rec."LHR 1003 Verify # 2") { ToolTip = 'Verify foreign matter inside the Poly-Bag conforms to Standard and the Poly-Bag is sealed.'; }
                field("LHR 1003 total qty furth proc"; Rec."LHR 1003 total qty furth proc") { ToolTip = 'Enter the total quantity released for further processing'; }
                field("LHR 1003 total rejected qty"; Rec."LHR 1003 total rejected qty") { ToolTip = 'Enter the total rejected quantity (if applicable)'; }
                field("LHR 1003 Total carton needed"; Rec."LHR 1003 Total carton needed") { ToolTip = 'Assemble the carton and record the total number needed.'; }
                field("LHR 1003 Label Ins SampleSize"; Rec."LHR 1003 Label Ins SampleSize") { ToolTip = 'QA - Labeling Inspection (ANSI/ASQ Z1.4 AQL 1.0 Level II, Normal Single Sampling Plan). Enter sample size. The acceptance will be accept on 0, reject on 1 for all printed data.'; }
                field("LHR 1003 Verify # 3"; Rec."LHR 1003 Verify # 3") { ToolTip = 'Verify correct Carton Label, Part Number & Lot Number'; }
                field("LHR 1003 Verify # 4"; Rec."LHR 1003 Verify # 4") { ToolTip = 'LHR Document Review'; }
                field("LHR1003 Total Cartons released"; Rec."LHR1003 Total Cartons released") { ToolTip = 'Enter total quantity of Cartons released'; }
            }
            group("LHR 1004 Inputs")
            {
                Visible = Rec."Show MOON-MNLT";
            }
            group("Printed Labels Data")
            {
                Visible = not Rec."Show PRINTLABEL";
                part(PLLabels; "Work Order PL Label Subpage")
                {
                    SubPageLink = "Work Order No." = FIELD("No.");
                }
            }
            group("Operational Reusable Items")
            {
                Visible = not (Rec."Show PRINTLABEL" or Rec."Show BELZER" or Rec."Show FILL_SET" or Rec."Show MOON-MNLT" or (Rec."PEDGA Part Number" = 'PN-0446') or (Rec."Thiocure Part Number" = 'PN-0447'));
                part(ReusableItems; "Operational Supplies Subpage") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("Operational Supplies")
            {
                Visible = not (Rec."Show PRINTLABEL" or Rec."Show SUB-OTS" or Rec."Show FILL_SET" or Rec."Show MOON-MNLT" or (Rec."PEDGA Part Number" = 'PN-0446') or (Rec."Thiocure Part Number" = 'PN-0447'));
                part(Supplies; "Operational Supplies Subpage") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("Equipment Used")
            {
                Visible = (not Rec."Show PRINTLABEL") and (Rec."PEDGA Part Number" = '') and (Rec."Thiocure Part Number" = '');
                part(Equipment; "Equipment Used Subpage") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("Fill Volume Verification")
            {
                Visible = Rec."Show BELZER";
                part(FillVolume; "Fill Volume Subpage") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("Filter Integrity Test")
            {
                Visible = Rec."Show BELZER";
                part(FIT; "Filter Integrity Test") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("Appearance & Particulate Tests")
            {
                Visible = Rec."Show BELZER";
                part(Appearance; "Appearance Test") { SubPageLink = "Work Order No." = FIELD("No."); }
                part(Particulate; "Particulate Test") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("Cure Time Materials Used")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                part(CTMaterials; "Cure Time Materials") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("Cure Time Equipment Used")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                part(CTEquipment; "Cure Time Equipment Page") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("Cure Time Samples Results")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                field("Cure Time Sample # 1 Result"; Rec."Cure Time Sample # 1 Result")
                {
                    trigger OnValidate()
                    begin
                        ComputeCuretimeStatus();
                    end;
                }
                field("Cure Time Sample # 2 Result"; Rec."Cure Time Sample # 2 Result")
                {
                    trigger OnValidate()
                    begin
                        ComputeCuretimeStatus();
                    end;
                }
                field("Cure Time Sample # 3 Result"; Rec."Cure Time Sample # 3 Result")
                {
                    trigger OnValidate()
                    begin
                        ComputeCuretimeStatus();
                    end;
                }
                field("Average Cure Time"; Rec."Average Cure Time") { Editable = false; }
                field("Cure Time Average Pass or Fail"; Rec."Cure Time Average Pass or Fail") { }
                field("Is Cure Time Samples Required?"; Rec."Is Cure Time Samples Required?")
                {
                    trigger OnValidate()
                    begin
                        ComputeCuretimeStatus();
                    end;
                }
            }
            group("Disposition of Descrep Materials")
            {
                Visible = not (Rec."Show PRINTLABEL" or Rec."Show SUB-OTS");
                part(DM; "Disposition of Disc Mat") { SubPageLink = "Work Order No." = FIELD("No."); }
            }
            group("Product Release Form")
            {
                Visible = not ((Rec."Show PRINTLABEL") or (Rec."Show SUB-OTS"));
                part(ProductRelease; "Product Release Subpage")
                {
                    SubPageLink = "Work Order No." = FIELD("No.");
                    Visible = not ((Rec."Show PRINTLABEL") or (Rec."Show SUB-OTS"));
                }
                field("QA Review & Lot Release By"; Rec."QA Review & Lot Release By") { }
                field("QA Review Date"; Rec."QA Review Date") { }
                field("QA Released QTY"; Rec."QA Released QTY") { Editable = false; }
            }
            group("Belzer Certification of Analysis")
            {
                Visible = Rec."Show BELZER";
                part(BCERT; "Belzer Certification Page")
                {
                    SubPageLink = "Work Order No." = FIELD("No.");
                }
            }
            group("PT Certification General")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                part(PG; "PT Certificate of Analysis Gen")
                {
                    SubPageLink = "Work Order No." = FIELD("No.");
                    UpdatePropagation = Both;
                }
            }
            group("PT Certification Data")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                part(PD; "PT Certification Data page")
                {
                    SubPageLink = "Work Order No." = FIELD("No.");
                }
            }
            group("Belzer Packing List")
            {
                Visible = Rec."Show BELZER";
                part(BPackingList; "Packing List Belzer Page")
                {
                    Visible = Rec."Show BELZER";
                    SubPageLink = "Work Order No." = FIELD("No.");
                }
            }
            group("PT Packing List Shipping Info")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                part(PTPackGeneral; "Packing List PT Page")
                {
                    SubPageLink = "Work Order No." = FIELD("No.");
                    UpdatePropagation = Both;
                }
            }
            group("PT Packing List Data")
            {
                Visible = (Rec."PEDGA Part Number" = 'PN-0446') and (Rec."Thiocure Part Number" = 'PN-0447');
                part(PackDataGeneral; "Packing List PT Data Page")
                {
                    SubPageLink = "Work Order No." = FIELD("No.");
                }
            }
            group("Label Information")
            {
                Visible = Rec."Routing No." = 'PRINTLABEL';

                field("Label Part No."; PrintHeader."Label Part No.") { Editable = false; }
                field("Label Revision"; Rec.Revision) { Editable = false; }
                field("WORK"; Rec."Lot Number") { Editable = false; }
                field("Label Stock Part No."; PrintHeader."Label Stock Part No.") { Editable = false; }
                field("Label Stock Lot No."; PrintHeader."Label Stock Lot No.")
                {
                    TableRelation = "Lot No. Information"."Lot No.";
                    trigger OnValidate()
                    begin
                        PrintHeader.Modify(true);
                        Rec.Get(Rec."No.");
                        CurrPage.Update(false);
                    end;
                }
                field("Ribbon Part No."; PrintHeader."Ribbon Part No.") { Editable = false; }
                field("Ribbon Lot No."; PrintHeader."Ribbon Lot No.")
                {
                    TableRelation = "Lot No. Information"."Lot No.";
                    trigger OnValidate()
                    begin
                        PrintHeader.Modify(true);
                        Rec.Get(Rec."No.");
                        CurrPage.Update(false);
                    end;
                }
                field("Print Label Status"; Rec."Print Label Status") { Editable = false; }
            }
            group("Label Printing & Verification")
            {
                Visible = Rec."Show PRINTLABEL";
                part(PL; "Print Label Subpage")
                {
                    ApplicationArea = All;
                    SubPageLink = "Work Order No." = field("No.");
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SubmitProductRelease)
            {
                Caption = 'Submit Product Release';
                Visible = Rec."Requires Product Release" and not Rec."Show PRINTLABEL";
                trigger OnAction()
                var
                    WorkflowMgt: Codeunit "Work Order Workflow Mgt";
                begin
                    WorkflowMgt.SubmitProductRelease(Rec);
                    CurrPage.Update(false);
                    Message('Product Release Form submitted successfully.');
                end;
            }
            action(SubmitWorkOrder)
            {
                Caption = 'Submit Work Order';
                Visible = not Rec."Requires Product Release";
                trigger OnAction()
                var
                    WorkflowMgt: Codeunit "Work Order Workflow Mgt";
                begin
                    WorkflowMgt.SubmitProductRelease(Rec);
                    CurrPage.Update(false);
                    Message('Work Order posted successfully.');
                end;
            }
            action(SubmitPrintedLabels)
            {
                Caption = 'Submit Printed Labels';
                Visible = not Rec."Show PRINTLABEL";
                trigger OnAction()
                var
                    LabelPostMgt: Codeunit "Print Label Post Mgt";
                begin
                    if not Rec.ArePLLabelsComplete() then
                        Error('All PL Labels must be completed before posting.');
                    LabelPostMgt.ApplyPrintLabelStatus(Rec);
                end;
            }
            action(SubmitPrintLabelWorkOrder)
            {
                Caption = 'Submit Print Label Work Order';
                Visible = Rec."Show PRINTLABEL";
                trigger OnAction()
                var
                    Print: Record "Print Label Header";
                    PostMgt: Codeunit "Print Label Post Mgt";
                begin
                    Rec.Get(Rec."No.");
                    if Rec."Print Label Status" in [Rec."Print Label Status"::Open, Rec."Print Label Status"::"In Progress"] then
                        Error('Work Order must be Completed before submission.');
                    Rec."Submitted" := true;
                    PostMgt.ApplyPrintLabelStatus(Rec);
                    Rec.Get(Rec."No.");
                    CurrPage.SetRecord(Rec);
                    CurrPage.Update(false);
                    Message('Print Label Work Order submitted.');
                    CurrPage.Close();
                end;
            }
        }
    }
    var
        PrintHeader: Record "Print Label Header";

    trigger OnAfterGetRecord()
    begin
    end;

    trigger OnOpenPage()
    begin
        InitializeRelatedRecords();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if PrintHeader."Work Order No." <> '' then
            PrintHeader.Modify(true);
    end;

    local procedure EnsureParticulateExists()
    var
        PartRec: Record "Particulate Test Header";
    begin
        if not PartRec.Get(Rec."No.") then begin
            PartRec.Init();
            PartRec."Work Order No." := Rec."No.";
            PartRec.Insert(true);
        end;
    end;

    local procedure InitializeRelatedRecords()
    begin
        EnsurePackingListBelzer();
        EnsurePrintLabelHeader();
        EnsureParticulateExists();
    end;

    procedure EnsurePrintLabelHeader()
    begin
        if Rec."Routing No." <> 'PRINTLABEL' then
            exit;
        if not PrintHeader.Get(Rec."No.") then begin
            PrintHeader.Init();
            PrintHeader."Work Order No." := Rec."No.";
            PrintHeader.Insert(true);
        end;
        PrintHeader.Get(Rec."No.");
    end;

    local procedure EnsurePackingListBelzer()
    var
        Pack: Record "Packing List Belzer";
    begin
        if Rec."Routing No." <> 'BELZER' then
            exit;
        if not Pack.Get(Rec."No.") then begin
            Pack.Init();
            Pack."Work Order No." := Rec."No.";
            Pack.Insert(true);
        end;
    end;

    local procedure ComputeCuretimeStatus()
    begin
        cureTimeSampleNot0();
        if Rec."Amount of cure samples needed" <= 0 then begin
            Rec."Average Cure Time" := 0;
            exit;
        end;
        Rec."Average Cure Time" := (Rec."Cure Time Sample # 1 Result" + Rec."Cure Time Sample # 2 Result" + Rec."Cure Time Sample # 3 Result") / Rec."Amount of cure samples needed";
        if (Rec."Is Cure Time Samples Required?") then begin
            if (Rec."Cure Time Sample # 1 Result" < 300) and (Rec."Cure Time Sample # 2 Result" < 300) and (Rec."Cure Time Sample # 3 Result" < 300) then
                Rec."Cure Time Average Pass or Fail" := Rec."Cure Time Average Pass or Fail"::Pass
            else
                Rec."Cure Time Average Pass or Fail" := Rec."Cure Time Average Pass or Fail"::Fail
        end
        else
            Rec."Cure Time Average Pass or Fail" := Rec."Cure Time Average Pass or Fail"::Open;
        CurrPage.Update(false);
    end;

    local procedure CureTimeSampleNot0()
    begin
        if (Rec."Cure Time Sample # 3 Result" = 0) and (Rec."Cure Time Sample # 2 Result" <> 0) and (Rec."Cure Time Sample # 1 Result" <> 0) then
            Rec."Amount of cure samples needed" := 2
        else if (Rec."Cure Time Sample # 2 Result" = 0) and (Rec."Cure Time Sample # 3 Result" = 0) and (Rec."Cure Time Sample # 1 Result" <> 0) then
            Rec."Amount of cure samples needed" := 1
        else
            Rec."Amount of cure samples needed" := 3;
    end;
}