table 60001 "Work Order Header"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "No."; Code[100]) { }
        field(2; "Item No."; Code[50]) { }
        field(3; "Lot Number"; Code[50]) { }
        field(4; "Product Part Number"; Code[50])
        {
            TableRelation = Item;
            trigger OnValidate()
            var
                ItemRec: Record Item;
                PL: Record "Print Label Header";
                WO: Codeunit "Work Order Orchestrator";
            begin
                // ----------------------------
                // Populate description + routing
                // ----------------------------
                if ItemRec.Get("Product Part Number") then begin
                    "Product Description" := ItemRec.Description;
                    Revision := ItemRec."Description 2";
                    if "Routing No." <> ItemRec."Routing No." then
                        Validate("Routing No.", ItemRec."Routing No.");
                end;
                // ----------------------------
                // GTIN AUTO-SET
                // ----------------------------
                case "Product Part Number" of
                    'PRT-0492-01':
                        begin
                            "GTIN-14, Container" := '00199284590434';
                            "GTIN-14, Carton" := '00199284849280';
                        end;

                    'PRT-0492-02':
                        begin
                            "GTIN-14, Container" := '00198715358155';
                            "GTIN-14, Carton" := '00199284309944';
                        end;

                    'PRT-0492-03':
                        begin
                            "GTIN-14, Container" := '00199284914773';
                            "GTIN-14, Carton" := '00199284210417';
                        end;

                    'PRT-0492-04':
                        begin
                            "GTIN-14, Container" := '00198715783704';
                            "GTIN-14, Carton" := '00198715327236';
                        end;
                end;
            end;
        }
        field(5; Revision; Text[50]) { }
        field(6; "Product Description"; Text[250]) { }
        field(7; "Lot Quantity"; Integer)
        {
            trigger OnValidate()
            begin
                if "Lot Quantity" < 0 then
                    Error('Lot Quantity must not be negative.');
                InitializeQuantityOfBags();
                if "Quantity of Bags" = 0 then
                    exit;
                matchlotquantity();
                if "Routing No." = 'BELZER' then
                    RecalculateBELZER();
                UpdateUnitReconciliation();
            end;
        }
        field(8; Verification; Enum "Verification") { }
        field(9; "Unit Size (mL)"; Integer) { }
        field(10; "Storage Condition"; Text[100]) { }
        field(11; "Date of Manufacture"; Date) { }
        field(12; "Expiration Date"; Date) { }
        field(13; "Data Entered By"; Text[100]) { }
        field(14; "GTIN-14, Container"; Code[250]) { }
        field(15; "GTIN-14, Carton"; Code[250]) { }
        field(16; "Material No."; Integer) { }
        field(17; "Operational Supplies No."; Integer) { }
        field(18; "Item Description"; Text[250]) { }
        field(19; "Part No."; Code[50]) { }
        field(20; "Lot No."; Code[50]) { }
        field(21; "Routing No."; Code[20])
        {
            trigger OnValidate()
            var
                WOOrchestrator: Codeunit "Work Order Orchestrator";
            begin
                if Rec."No." = '' then
                    exit;
                if xRec."Routing No." = Rec."Routing No." then
                    exit;
                if Rec.IsTemporary then
                    exit;
                "CT Materials Generated" := false;
                "CT Equipment Generated" := false;
                WOOrchestrator.HandleRoutingChange(Rec);
            end;
        }
        field(22; "Show BELZER"; Boolean) { }
        field(23; "Show SUB-OTS"; Boolean)
        {
            trigger OnValidate()
            begin
                RecalculateSUBOTS();
            end;
        }
        field(24; "Show FILL_SET"; Boolean) { }
        field(25; "Show MOON-MNLT"; Boolean) { }
        field(26; "Show PRINTLABEL"; Boolean) { }
        field(27; "Work Order Status"; Enum "Work Order Status") { Editable = false; }
        field(28; "Requires Product Release"; Boolean)
        {
            Caption = 'Requires Product Release';
            Editable = false;
            trigger OnValidate()
            var
                ProdRelMgt: Codeunit "Product Release Mgt";
            begin
                if "Requires Product Release" then
                    ProdRelMgt.EnsureChecklistExists("No.")
                else
                    ProdRelMgt.RemoveChecklist("No.");
            end;
        }
        field(29; "PL Labels Locked"; Boolean)
        {
            Caption = 'PL Labels Locked';
            Editable = false;
        }
        field(30; "QA Review & Lot Release By"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(31; "QA Review Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(32; "QA Released QTY"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(33; "Quantity for Processing"; Integer) { Editable = false; }
        field(34; "Submitted"; Boolean)
        {
            Caption = 'Submitted';
        }
        field(35; "Released"; Boolean) { }
        field(36; "Total Quantity Ready"; Integer)
        {
            trigger OnValidate()
            begin
            end;
        }
        field(37; "Rejected Quantity"; Integer)
        {
            trigger OnValidate()
            begin
            end;
        }
        field(38; "Total Sample Quantity"; Integer)
        {
            trigger OnValidate()
            begin
            end;
        }
        field(39; "1st pallet Carton Qty"; Integer) { Editable = false; }
        field(40; "2nd pallet Carton Qty"; Integer) { Editable = false; }
        field(41; "Quantity of Bags"; Integer)
        {
            trigger OnValidate()
            begin
                if IsBagRequired() and ("Quantity of Bags" <= 0) then
                    Error('Quantity of Bags is required.');
                RecalculateBELZER();
                matchlotquantity();
                UpdateStatus();
            end;
        }
        field(42; "Total Full Cartons released"; Integer) { Editable = false; }
        field(43; "Total Containers in Partial"; Integer) { Editable = false; }
        field(44; "Total Pallets"; Integer) { }
        field(45; "Total Carton Positions"; Integer) { }
        field(46; "Label Quantity Rejected"; Integer) { }
        field(47; "Label Quantity Accepted"; Integer) { }
        field(48; "Label Retain Quantity"; Integer) { }
        field(49; "Label Quantity Used"; Integer) { }
        field(50; "Total Labels Printed"; Integer) { Editable = false; }
        field(51; "Quantity to be Scrapped"; Integer) { }
        field(52; "Pedga Mix Date"; Date)
        {
            trigger OnValidate()
            begin
                if Rec."No." = '' then
                    exit;
                RefreshPTConfiguration();
            end;
        }
        field(53; "Thiocure Mix Date"; Date)
        {
            trigger OnValidate()
            begin
                if Rec."No." = '' then
                    exit;
                RefreshPTConfiguration();
            end;
        }
        field(54; "Moonlight Therap Contents"; Integer) { }
        field(55; "Batch Size (Theor. Units)"; Integer) { }
        field(56; "PEDGA Customer Lot Number"; Code[500]) { Editable = false; }
        field(57; "THIOCURE Customer Lot Number"; Code[500]) { Editable = false; }
        field(58; "Lot Quantity (Cases)"; Integer) { }
        field(59; "Lot Quantity (Bags)"; Integer) { }
        field(60; Theoretical; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Work Order Header"."Lot Quantity" where("No." = field("No.")));
        }
        field(61; Actual; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Work Order Header"."Quantity for Processing" where("No." = field("No.")));
        }
        field(62; Variance; Integer) { Editable = false; }
        field(63; "Yield = Theoretical ± 10%"; Boolean) { Editable = false; }
        field(64; "PEDGA Part Number"; Code[50])
        {
            trigger OnValidate()
            var
                ItemRec: Record Item;
                WOOrchestrator: Codeunit "Work Order Orchestrator";
            begin
                if ItemRec.Get("PEDGA Part Number") then begin
                    "PEDGA Description" := ItemRec.Description;
                    "PEDGA Revision" := ItemRec."Description 2";
                end else begin
                    Clear("PEDGA Description");
                    Clear("PEDGA Revision");
                end;
                if Rec.IsPTReady() then begin
                    Rec.Modify(true);
                    WOOrchestrator.HandleRoutingChange(Rec);
                end;

                "CT Materials Generated" := false;
                "CT Equipment Generated" := false;
                RefreshPTConfiguration();
            end;
        }
        field(65; "Thiocure Part Number"; Code[50])
        {
            trigger OnValidate()
            var
                ItemRec: Record Item;
                WOOrchestrator: Codeunit "Work Order Orchestrator";
            begin
                if ItemRec.Get("Thiocure Part Number") then begin
                    "THIOCURE Description" := ItemRec.Description;
                    "THIOCURE Revision" := ItemRec."Description 2";
                end else begin
                    Clear("THIOCURE Description");
                    Clear("THIOCURE Revision");
                end;
                if Rec.IsPTReady() then begin
                    Rec.Modify(true);
                    WOOrchestrator.HandleRoutingChange(Rec);
                end;
                "CT Materials Generated" := false;
                "CT Equipment Generated" := false;
                RefreshPTConfiguration();
            end;
        }
        field(66; "PEDGA Revision"; Text[50]) { }
        field(67; "THIOCURE Revision"; Text[50]) { }
        field(68; "PEDGA Description"; Text[250]) { }
        field(69; "THIOCURE Description"; Text[250]) { }
        field(70; PLLabelsAlreadyGenerated; Boolean) { }
        field(71; ThiocurePLLabelsGenerated; Boolean) { }
        field(72; "Batch Volume Required (mL)"; Integer) { }
        field(73; "PEDGA Amount needed (g)"; Integer) { }
        field(74; "Pedga Volume (mL)"; Decimal) { DecimalPlaces = 0 : 0; }
        field(75; "PEDGA Water Weight (g)"; Decimal) { DecimalPlaces = 0 : 0; }
        field(76; "Thiocure 333 needed (g)"; Decimal) { DecimalPlaces = 0 : 0; }
        field(77; "TH333 Volume (mL)"; Decimal) { DecimalPlaces = 0 : 0; }
        field(78; "SBC Soln Weight (g)"; Decimal) { DecimalPlaces = 0 : 0; }
        field(79; "SBC Soln Vol (L)"; Decimal) { DecimalPlaces = 0 : 1; }
        field(80; "SBC Weight (g)"; Decimal) { DecimalPlaces = 0 : 0; }
        field(81; "TH333 Water Weight (g)"; Decimal) { DecimalPlaces = 0 : 0; }
        field(82; "Verify Pedga Amount (g)"; Integer) { }
        field(83; "Verify Pedga Water weight"; Integer) { }
        field(84; "Verify PEDGA Customer"; Code[500]) { }
        field(85; "P Refrigeratior EQ (Optional)"; Text[2048]) { }
        field(86; "Pedga Qty release inspection"; Integer)
        {
            Editable = false;
            trigger OnValidate()
            begin
                RecalculatePT();
                UpdateLabelCalculations();
                UpdateUnitReconciliation();
            end;
        }
        field(87; "Pedga Sample Size"; Integer) { }
        field(88; "PEDGA LHR Record Verify #1"; Option) { OptionMembers = Open,Pass,Fail; }
        field(89; "PEDGA LHR Record Verify #2"; Option) { OptionMembers = Open,Pass,Fail; }
        field(90; "PEDGA LHR Record Verify #3"; Option) { OptionMembers = Open,Pass,Fail; }
        field(91; "Pedga rejected Qty"; Integer)
        {
            trigger OnValidate()
            begin
                RecalcPedgaTotals();
            end;
        }
        field(92; "Pedga total qty further proc"; Integer) { Editable = false; }
        field(93; "Verify Thiocure SBC Weight"; Decimal) { DecimalPlaces = 0 : 0; }
        field(94; "Verify Thiocure Water Weight"; Decimal) { DecimalPlaces = 0 : 0; }
        field(95; "Verify Mix Date code"; Code[50]) { }
        field(96; "Verify Thiocure 333 in mL"; Decimal) { }
        field(97; "Actual Thiocure 333 weight"; Decimal) { }
        field(98; "Verify Thiocure Customer"; Code[500]) { }
        field(99; "TH333 Qty release inspection"; Integer)
        {
            Editable = false;
            trigger OnValidate()
            begin
                RecalculatePT();
                UpdateLabelCalculations();
                UpdateUnitReconciliation();
            end;
        }
        field(100; "Thiocure Sample Size"; Integer) { }
        field(101; "Thiocure LHR Record Verify #1"; Option) { OptionMembers = Open,Pass,Fail; }
        field(102; "Thiocure LHR Record Verify #2"; Option) { OptionMembers = Open,Pass,Fail; }
        field(103; "Thiocure LHR Record Verify #3"; Option) { OptionMembers = Open,Pass,Fail; }
        field(104; "Thiocure rejected qty"; Integer)
        {
            trigger OnValidate()
            begin
                RecalcThiocureTotals();
            end;
        }
        field(105; "TH333 total qty further proc"; Integer) { Editable = false; }
        field(106; "Cure Time Sample # 1 Result"; Decimal) { DecimalPlaces = 0 : 2; }
        field(107; "Cure Time Sample # 2 Result"; Decimal) { DecimalPlaces = 0 : 2; }
        field(108; "Cure Time Sample # 3 Result"; Decimal) { DecimalPlaces = 0 : 2; }
        field(109; "Average Cure Time"; Decimal) { DecimalPlaces = 0 : 2; }
        field(110; "Cure Time Average Pass or Fail"; Option) { OptionMembers = Open,Pass,Fail; }
        field(111; "Is Cure Time Samples Required?"; Boolean) { }
        field(112; "Autoclave Cycle Number"; Text[50]) { }
        field(113; "Autoclave Record Date"; Date) { }
        field(114; "Which EQ did you use?"; Option) { OptionMembers = Open,"EQ-00036","EQ-00003"; }
        field(115; "Autoclave Cycle Verification"; Option) { OptionMembers = Open,Pass,Fail; }
        field(116; "Amount of cure samples needed"; Integer) { }
        field(117; "Pedga Recalc Required"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(118; "Thiocure Recalc Required"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(119; "Tubing Sample Size"; Integer) { }
        field(120; "Verify 1st Tubing length"; Option) { OptionMembers = Open,Pass,Fail; }
        field(121; "Total rej qty 1st Tubing"; Integer) { }
        field(122; "Verify 2nd Tubing length"; Option) { OptionMembers = Open,Pass,Fail; }
        field(123; "Total rej qty 2nd Tubing"; Integer) { }
        field(124; "Verify 3rd Tubing length"; Option) { OptionMembers = Open,Pass,Fail; }
        field(125; "Total rej qty 3rd Tubing"; Integer) { }
        field(126; "Verify 4th Tubing length"; Option) { OptionMembers = Open,NA,Pass,Fail; }
        field(127; "Total rej qty 4rd Tubing"; Integer) { }
        field(128; "LHR 1003 Heat Temp (F)"; Integer) { }
        field(129; "LHR 1003 Heating Time (sec)"; Integer) { }
        field(130; "LHR 1003 Cooling Temp (CT-F)"; Integer) { }
        field(131; "Packaging Sample Size"; Integer) { }
        field(132; "LHR 1003 Verify # 1"; Option) { OptionMembers = Open,Pass,Fail; }
        field(133; "LHR 1003 Verify # 2"; Option) { OptionMembers = Open,Pass,Fail; }
        field(134; "LHR 1003 total qty furth proc"; Integer) { }
        field(135; "LHR 1003 total rejected qty"; Integer) { }
        field(136; "LHR 1003 Total carton needed"; Integer) { }
        field(137; "LHR 1003 Label Ins SampleSize"; Integer) { }
        field(138; "LHR 1003 Verify # 3"; Option) { OptionMembers = Open,Pass,Fail; }
        field(139; "LHR 1003 Verify # 4"; Option) { OptionMembers = Open,Pass,Fail; }
        field(140; "LHR1003 Total Cartons released"; Integer) { }
        field(141; "CT Materials Generated"; Boolean) { }
        field(142; "CT Equipment Generated"; Boolean) { }
        field(143; "Print Label Status"; Enum "Print Label Status") { }
        field(144; "PL Status Needs Recalc"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(145; "PT Update In Progress"; Boolean) { }
        field(146; "PT Update Required"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    procedure UpdatePLLabelStatus()
    var
        PLLabel: Record "Work Order PL Label";
        HasData: Boolean;
        AllComplete: Boolean;
    begin
        HasData := false;
        AllComplete := true;

        PLLabel.SetRange("Work Order No.", "No.");

        if not PLLabel.FindSet() then begin
            "Print Label Status" := "Print Label Status"::Open;
            exit;
        end;
        repeat
            // Any entered data?
            if
                (PLLabel."Ribbon Lot No." <> '') or
                (PLLabel."Label Blank Lot No." <> '') or
                (PLLabel."Label Printed/Verified By" <> '') or
                (PLLabel."Labels Printed/Verified Date" <> 0D) or
                (PLLabel."Scan Retain Label Barcode" <> '') or
                (PLLabel."Label Barcode Verification" <> PLLabel."Label Barcode Verification"::Open) or
                (PLLabel."Label Barcode Verification By" <> '') or
                (PLLabel."Barcode Verification Date" <> 0D) or
                (PLLabel."Label Retain Quantity" <> 0) or
                (PLLabel."Label Quantity Rejected" <> 0) or
                (PLLabel."Label Quantity Accepted" <> 0) or
                (PLLabel."Labels Verified By" <> '') or
                (PLLabel."Labels Verified Date" <> 0D) or
                (PLLabel."Label Reconcil. Performed By" <> '') or
                (PLLabel."Label Reconcil. Performed Date" <> 0D) or
                (PLLabel."Unused Labels Scrapped By" <> '') or
                (PLLabel."Unused Labels Scrapped Date" <> 0D) or
                (PLLabel."Reconciliation Verified By" <> '') or
                (PLLabel."Reconcil. Verification Date" <> 0D)
            then
                HasData := true;

            // Complete?
            if not PLLabel.IsComplete() then
                AllComplete := false;

        until PLLabel.Next() = 0;

        if not HasData then
            "Print Label Status" := "Print Label Status"::Open
        else
            if AllComplete then
                "Print Label Status" := "Print Label Status"::Completed
            else
                "Print Label Status" := "Print Label Status"::"In Progress";
    end;

    procedure RefreshPTConfiguration()
    begin
        // ensure record is committed before generation
        if ("No." = '') then
            exit;
        if not IsPTReady() then
            exit;
        RegeneratePTSetup();

        // force CT regeneration explicitly after setup
        if ("PEDGA Part Number" = 'PN-0446') and ("Thiocure Part Number" = 'PN-0447') then begin
            "PT Update Required" := true;
            Modify(true);
        end;
    end;

    local procedure RefreshPLLabels()
    begin
        RefreshMaterialAndLabels();
    end;

    procedure RegeneratePTSetup()
    var
        BOMMgt: Codeunit "Work Order BOM Mgt";
        SupplyMgt: Codeunit "Operational Supply Mgt";
        EquipMgt: Codeunit "Equipment Line Mgt";
        // CTMat: Codeunit "Cure Time Materials Mgt";
        CTEq: Codeunit "Cure Time Equipment Mgt";
        PTCert: Codeunit "PT Certification Mgt";
        PTPack: Codeunit "PT Packing List Mgt";
        ProdRelMgt: Codeunit "Product Release Mgt";
        LabelMgt: Codeunit "Work Order Label Mgt";
        WOOrchestrator: Codeunit "Work Order Orchestrator";
    begin
        if (Rec."PEDGA Part Number" = '') or
        (Rec."Thiocure Part Number" = '') then
            exit;

        if (Rec."PEDGA Part Number" <> 'PN-0446') or
        (Rec."Thiocure Part Number" <> 'PN-0447') then
            exit;
        BOMMgt.ClearPTLines("No.");
        BOMMgt.GeneratePTMaterialLines(Rec);
        SupplyMgt.GenerateSupplies(Rec);
        EquipMgt.GeneratePTEquipment(Rec);
        // CTMat.GenerateCTMaterials(Rec);
        CTEq.GenerateCTEqupment(Rec);
        PTCert.GenerateTestResults(Rec);
        PTPack.GeneratePTPacking(Rec);
        ProdRelMgt.HandleRoutingChange(Rec);
        LabelMgt.RefreshLabels(Rec);
        RecalculatePT();
        WOOrchestrator.UpdatePTLotNumbers(Rec);
        UpdateQAReleasedQty();
        UpdateLabelCalculations();
    end;

    trigger OnInsert()
    begin
        if "Lot Number" = '' then
            Error('Lot Number is required.');
        "No." := "Lot Number";
        if "Product Part Number" <> 'PL-0002-09' then
            "Work Order Status" := "Work Order Status"::Open
        else
            "Print Label Status" := "Print Label Status"::Open;
        ResetLabelData();
        SetUIFlags();
    end;

    procedure RecalcPedgaTotals()
    begin
        "Pedga total qty further proc" :=
            "Pedga Qty release inspection" - "Pedga rejected Qty";
        UpdateQAReleasedQty();
    end;

    procedure RecalcThiocureTotals()
    begin
        "TH333 total qty further proc" :=
            "TH333 Qty release inspection" - "Thiocure rejected qty";
        UpdateQAReleasedQty();
    end;

    trigger OnModify()
    var
        PCalc: Codeunit "Pedga Calculation Mgt";
        TCalc: Codeunit "Thiocure Calculation Mgt";
    begin
    end;

    procedure UpdateStatus()
    begin
        if "Routing No." = 'SUB-OTS' then
            RecalculateSUBOTS();
        if "Product Part Number" <> 'PL-0002-09' then
            "Work Order Status" := ComputeStatus()
        else
            "Print Label Status" := EvaluatePrintLabelStatus();
    end;

    local procedure ComputeStatus(): Enum "Work Order Status"
    var
        MaterialLine: Record "Work Order Material Line";
        SupplyLine: Record "Work Order Supply Line";
        ReleaseItem: Record "Product Release Item";
        PLLabel: Record "Work Order PL Label";
        AllMaterialPass: Boolean;
        ChecklistAllFinished: Boolean;
        LabelsAllComplete: Boolean;
        AllQAValid: Boolean;
        HasActivity: Boolean;
        ChecklistStarted: Boolean;
    begin
        if "Show PRINTLABEL" then
            exit("Work Order Status"::Open);

        AllMaterialPass := true;
        HasActivity := false;
        // ---------------- MATERIAL + SUPPLY ----------------
        MaterialLine.SetRange("Work Order No.", "No.");
        if MaterialLine.FindSet() then
            repeat
                HasActivity := HasActivity or (MaterialLine.Verification <> MaterialLine.Verification::Open);
                AllMaterialPass := AllMaterialPass and (MaterialLine.Verification = MaterialLine.Verification::Pass);
            until MaterialLine.Next() = 0;

        SupplyLine.SetRange("Work Order No.", "No.");
        if SupplyLine.FindSet() then
            repeat
                HasActivity := HasActivity or (SupplyLine.Verification <> SupplyLine.Verification::Open);
                AllMaterialPass := AllMaterialPass and (SupplyLine.Verification = SupplyLine.Verification::Pass);
            until SupplyLine.Next() = 0;
        // ---------------- CHECKLIST ----------------
        ChecklistAllFinished := true;
        ChecklistStarted := false;
        ReleaseItem.SetRange("Work Order No.", "No.");
        if ReleaseItem.FindSet() then
            repeat
                ChecklistStarted := ChecklistStarted or (ReleaseItem.Status <> ReleaseItem.Status::Open);
                ChecklistAllFinished :=
                    ChecklistAllFinished and
                    (ReleaseItem.Status in [ReleaseItem.Status::NA, ReleaseItem.Status::Complete]);
            until ReleaseItem.Next() = 0
        else
            ChecklistAllFinished := false;
        // ---------------- LABELS ----------------
        LabelsAllComplete := true;

        PLLabel.SetRange("Work Order No.", "No.");
        if PLLabel.FindSet() then
            repeat
                LabelsAllComplete := LabelsAllComplete and PLLabel.IsComplete();
            until PLLabel.Next() = 0
        else
            LabelsAllComplete := false;
        // ---------------- QA ----------------
        AllQAValid :=
            ("QA Review & Lot Release By" <> '') and
            ("QA Review Date" <> 0D);
        // ---------------- STATUS ----------------
        if (not HasActivity) and (not ChecklistStarted) and (not PLLabel.FindSet()) then
            exit("Work Order Status"::Open);

        if AllMaterialPass and ChecklistAllFinished and AllQAValid and LabelsAllComplete then
            exit("Work Order Status"::Completed);
        exit("Work Order Status"::"In Progress");
    end;

    procedure ArePLLabelsComplete(): Boolean
    var
        PLLabel: Record "Work Order PL Label";
    begin
        PLLabel.SetRange("Work Order No.", "No.");
        if PLLabel.FindSet() then begin
            repeat
                if not PLLabel.Posted then
                    exit(false);
            until PLLabel.Next() = 0;
        end else
            exit(false);
        exit(true);
    end;

    local procedure EvaluatePrintLabelStatus(): Enum "Print Label Status"
    begin
        if ArePLLabelsComplete() then
            exit("Print Label Status"::Completed);
        if HasLabelEntryActivity() then
            exit("Print Label Status"::"In Progress");
        exit("Print Label Status"::Open);
    end;

    local procedure HasLabelEntryActivity(): Boolean
    var
        PLLabel: Record "Work Order PL Label";
    begin
        PLLabel.SetRange("Work Order No.", "No.");
        if PLLabel.FindSet() then
            repeat
                if (PLLabel."Ribbon Lot No." <> '') or
                (PLLabel."Label Blank Lot No." <> '') then
                    exit(true);
            until PLLabel.Next() = 0;
        exit(false);
    end;

    procedure AreRequiredPLLabelsPosted(): Boolean
    var
        PLLabel: Record "Work Order PL Label";
    begin
        PLLabel.SetRange("Work Order No.", "No.");
        if not PLLabel.FindSet() then
            exit(false);
        repeat
            if not PLLabel.Posted then
                exit(false);
        until PLLabel.Next() = 0;
        exit(true);
    end;

    procedure ValidateBELZER()
    var
        Is0492_01_04: Boolean;
    begin
        if "Routing No." <> 'BELZER' then
            exit;
        Is0492_01_04 :=
            ("Product Part Number" IN ['PRT-0492-01', 'PRT-0492-02', 'PRT-0492-03', 'PRT-0492-04']);
        if "Total Quantity Ready" = 0 then
            Error('Total Quantity Ready is required.');
        if "Rejected Quantity" < 0 then
            Error('Rejected Quantity is required.');
        if Is0492_01_04 then begin
            if "Total Sample Quantity" = 0 then
                Error('Total Sample Quantity is required.');
            if "1st pallet Carton Qty" = 0 then
                Error('1st pallet Carton Qty is required.');
            if "2nd pallet Carton Qty" < 0 then
                Error('2nd pallet Carton Qty must be valid.');
        end;

        if IsBagRequired() then begin
            if "Quantity of Bags" <= 0 then
                Error('Quantity of Bags is required for this product.');
        end else begin
            if "Quantity of Bags" <> 0 then
                Error('Quantity of Bags must not be entered for this product.');
        end;
    end;

    procedure IsBagRequired(): Boolean
    begin
        exit("Product Part Number" IN ['PRT-0492-01', 'PRT-0492-02', 'PRT-0492-03', 'PRT-0492-04', 'PRT-0492-05', 'PRT-0492-06', 'PRT-0492-07']);
    end;

    trigger OnDelete()
    var
        LabelMgt: Codeunit "Work Order Label Mgt";
        BOMMgt: Codeunit "Work Order BOM Mgt";
        ProdRel: Codeunit "Product Release Mgt";
        PTTop: Record "PT Certificate of Analysis Top";
        Disposition: Record "Disposition of Discrep Mat";
        PrintHead: Record "Print Label Header";
        PrintLine: Record "Print Label Line";
    begin
        LabelMgt.ClearPLLabels("No.", true);
        BOMMgt.ClearPTLines("No.");
        ProdRel.RemoveChecklist("No.");
        PTTop.SetRange("Work Order No.", "No.");
        PTTop.DeleteAll();
        Disposition.SetRange("Work Order No.", "No.");
        Disposition.DeleteAll();
        PrintLine.SetRange("Work Order No.", "No.");
        PrintLine.DeleteAll();
        PrintHead.SetRange("Work Order No.", "No.");
        PrintHead.DeleteAll();
    end;

    procedure RefreshImportantData()
    begin
        ProcessPLStatusRecalc();
        RefreshPLLabels();
        matchlotquantity();
        case "Routing No." of
            'BELZER':
                RecalculateBELZER();
            'SUB-OTS':
                RecalculateSUBOTS();
        end;
        RecalculatePT();
        UpdateUnitReconciliation();
        UpdateLabelCalculations();
        UpdateStatus();
        UpdateQAReleasedQty();
    end;

    procedure UpdateQAReleasedQty()
    var
        Cert: Record "PT Cert of Analysis Data";
        Pack: Record "Packing List PT Data";
    begin
        if ("Routing No." = 'BELZER') or ("Routing No." = 'SUB-OTS') then
            "QA Released QTY" := "Quantity for Processing"
        else if ("PEDGA Part Number" = 'PN-0446') and
                ("Thiocure Part Number" = 'PN-0447') then begin
            if "Pedga total qty further proc" < "TH333 total qty further proc" then
                "QA Released QTY" := "Pedga total qty further proc"
            else
                "QA Released QTY" := "TH333 total qty further proc";
        end;

        Cert.SetRange("Work Order No.", "No.");
        if Cert.FindSet() then
            repeat
                Cert."QTY Shipped" := "QA Released QTY";
                Cert.Modify(true);
            until Cert.Next() = 0;

        Pack.SetRange("Work Order No.", "No.");
        if Pack.FindSet() then
            repeat
                Pack.Quantity := "QA Released QTY";
                Pack.Modify(true);
            until Pack.Next() = 0;
    end;

    procedure RefreshMaterialAndLabels()
    var
        MaterialLine: Record "Work Order Material Line";
        LabelMgt: Codeunit "Work Order Label Mgt";
    begin
        // =====================================================
        // 1. RECALCULATE MATERIAL QUANTITIES
        // =====================================================
        MaterialLine.SetRange("Work Order No.", "No.");
        if MaterialLine.FindSet() then
            repeat
                MaterialLine."Calculated Quantity" :=
                    GetCalculatedQty(
                        MaterialLine."Item Description",
                        MaterialLine."Unit Quantity");

                MaterialLine.Modify(true);
            until MaterialLine.Next() = 0;
        // =====================================================
        // 2. HARD LOCK LABELS AFTER POSTING
        // =====================================================
        if HasAnyPostedPLLabels() then begin
            if not "PL Labels Locked" then begin
                "PL Labels Locked" := true;
            end;
            exit;
        end;
        // =====================================================
        // 3. ALLOW SAFE REGENERATION BEFORE POSTING
        // =====================================================
        "PL Labels Locked" := false;
        PLLabelsAlreadyGenerated := false;
        "ThiocurePLLabelsGenerated" := false;
        // =====================================================
        // 4. REGENERATE LABELS
        // =====================================================
        if not HasAnyPLLabels() then
            LabelMgt.GeneratePLLabels(Rec);
        PLLabelsAlreadyGenerated := true;
        "ThiocurePLLabelsGenerated" := true;

    end;

    local procedure HasAnyPLLabels(): Boolean
    var
        PLLabel: Record "Work Order PL Label";
    begin
        PLLabel.SetRange("Work Order No.", "No.");
        exit(PLLabel.FindFirst());
    end;

    local procedure HasAnyPostedPLLabels(): Boolean
    var
        PLLabel: Record "Work Order PL Label";
    begin
        PLLabel.SetRange("Work Order No.", "No.");
        PLLabel.SetRange(Posted, true);
        exit(PLLabel.FindFirst());
    end;

    procedure RecalculateQuantityForProcessing()
    begin
        case "Routing No." of

            'BELZER':
                begin
                    if IsBagRequired() then
                        "Quantity for Processing" :=
                            "Total Quantity Ready"
                            - "Total Sample Quantity"
                            - "Rejected Quantity"
                    else
                        "Quantity for Processing" :=
                            "Total Quantity Ready"
                            - "Rejected Quantity";

                    if "Quantity for Processing" < 0 then
                        "Quantity for Processing" := 0;
                end;

            'SUB-OTS':
                begin
                    "Quantity for Processing" :=
                        "Lot Quantity" - "Rejected Quantity";

                    if "Quantity for Processing" < 0 then
                        "Quantity for Processing" := 0;
                end;

            else
                "Quantity for Processing" := 0;
        end;
    end;

    procedure RecalculatePT()
    var
        PM: Record "Pedga Materials Header";
        TM: Record "Thiocure Materials Header";
    begin
        if (Rec."PEDGA Part Number" <> 'PN-0446') or (Rec."Thiocure Part Number" <> 'PN-0447') then
            exit;
        "Batch Volume Required (mL)" := ("Batch Size (Theor. Units)" * "Unit Size (mL)");
        "PEDGA Amount needed (g)" := ("Batch Size (Theor. Units)" * 10);
        "Pedga Volume (mL)" := ("PEDGA Amount needed (g)" / 1.12);
        "PEDGA Water Weight (g)" := ("Batch Volume Required (mL)" - "Pedga Volume (mL)");
        "Thiocure 333 needed (g)" := ("Batch Size (Theor. Units)" * 14.9);
        "TH333 Volume (mL)" := ("Thiocure 333 needed (g)" / 1.15);
        "SBC Soln Weight (g)" := ("Batch Volume Required (mL)" - "TH333 Volume (mL)");
        "SBC Soln Vol (L)" := ("SBC Soln Weight (g)" / 1000);
        "SBC Weight (g)" := (84 * 0.375 * "SBC Soln Vol (L)");
        "TH333 Water Weight (g)" := ("SBC Soln Weight (g)" - "SBC Weight (g)");
    end;

    procedure RecalculateBELZER()
    var
        TotalPositions: Integer;
        MaxPerPallet: Integer;
        BPL: Record "Packing List Belzer";
    begin
        if "Routing No." <> 'BELZER' then begin
            ClearBELZEROutputs();
            UpdateStatus();
            exit;
        end;
        // -------------------------
        // CORE CALCULATION
        // -------------------------
        if IsBagRequired() then
            "Quantity for Processing" := "Total Quantity Ready" - "Total Sample Quantity" - "Rejected Quantity"
        else
            "Quantity for Processing" := "Total Quantity Ready" - "Rejected Quantity";

        if "Quantity for Processing" < 0 then
            "Quantity for Processing" := 0;
        // -------------------------
        // SAFETY (READ ONLY)
        // -------------------------
        if "Quantity of Bags" <= 0 then begin
            "Total Containers in Partial" := 0;
            "Total Full Cartons released" := 0;
            "Total Carton Positions" := 0;
            "Total Pallets" := 0;
            exit;
        end;
        // -------------------------
        // CARTONS
        // -------------------------
        "Total Containers in Partial" := "Quantity for Processing" MOD "Quantity of Bags";
        "Total Full Cartons released" := "Quantity for Processing" DIV "Quantity of Bags";
        TotalPositions := "Total Full Cartons released";

        if "Total Containers in Partial" > 0 then
            TotalPositions += 1;

        "Total Carton Positions" := TotalPositions;
        // -------------------------
        // PALLETS
        // -------------------------
        if "Product Part Number" IN ['PRT-0492-01', 'PRT-0492-04'] then
            MaxPerPallet := 54
        else
            MaxPerPallet := 30;

        if TotalPositions = 0 then begin
            "Total Pallets" := 0;
            "1st pallet Carton Qty" := 0;
            "2nd pallet Carton Qty" := 0;
            exit;
        end;

        "Total Pallets" := TotalPositions DIV MaxPerPallet;
        if (TotalPositions MOD MaxPerPallet) > 0 then
            "Total Pallets" += 1;

        if TotalPositions >= MaxPerPallet then
            "1st pallet Carton Qty" := MaxPerPallet
        else
            "1st pallet Carton Qty" := TotalPositions;

        if TotalPositions > MaxPerPallet then
            "2nd pallet Carton Qty" := TotalPositions - MaxPerPallet
        else
            "2nd pallet Carton Qty" := 0;
    end;

    procedure RecalculateSUBOTS()
    begin
        if "Routing No." <> 'SUB-OTS' then begin
            exit;
        end;
        "Quantity for Processing" := "Lot Quantity" - "Rejected Quantity";
    end;

    procedure ClearBELZEROutputs()
    begin
        "Quantity for Processing" := 0;
        "Total Full Cartons released" := 0;
        "Total Containers in Partial" := 0;
        "Total Carton Positions" := 0;
        "Total Pallets" := 0;
        "1st pallet Carton Qty" := 0;
        "2nd pallet Carton Qty" := 0;
    end;

    procedure UpdateLabelCalculations()
    var
        PLLabel: Record "Work Order PL Label";
    begin
        // ------------------------------------
        // RESET HEADER TOTALS FIRST
        // ------------------------------------
        "Label Quantity Accepted" := 0;
        "Label Quantity Rejected" := 0;
        "Label Retain Quantity" := 0;
        "Label Quantity Used" := 0;
        // ------------------------------------
        // AGGREGATE FROM PL LABEL LINES
        // ------------------------------------
        PLLabel.SetRange("Work Order No.", "No.");

        if PLLabel.FindSet() then
            repeat
                "Label Quantity Accepted" += PLLabel."Label Quantity Accepted";
                "Label Quantity Rejected" += PLLabel."Label Quantity Rejected";
                "Label Retain Quantity" += PLLabel."Label Retain Quantity";
                "Label Quantity Used" += PLLabel."Quantity Used";
            until PLLabel.Next() = 0;
        // ------------------------------------
        // DERIVED FIELDS
        // ------------------------------------
        "Total Labels Printed" :=
            "Label Quantity Accepted"
            + "Label Retain Quantity"
            + "Label Quantity Rejected";

        if "Total Labels Printed" < 0 then
            "Total Labels Printed" := 0;

        "Quantity to be Scrapped" :=
            "Label Quantity Accepted" - "Label Quantity Used";

        if "Quantity to be Scrapped" < 0 then
            "Quantity to be Scrapped" := 0;
    end;

    procedure GetCalculatedQty(
    Description: Text;
    QtyPer: Decimal): Decimal
    begin
        if "Total Quantity Ready" = 0 then
            exit(0);
        if (StrPos(UpperCase(Description), 'CARTON') > 0) or
           (StrPos(UpperCase(Description), 'IFU') > 0) or
           (StrPos(UpperCase(Description), 'INSTRUCTIONS FOR USE') > 0) or
           (StrPos(UpperCase(Description), 'RSC') > 0) or
           (StrPos(UpperCase(Description), 'FOAM') > 0) then
            exit(("1st pallet Carton Qty" + "2nd pallet Carton Qty") * QtyPer);

        if (StrPos(UpperCase(Description), 'CONTAINER') > 0) or
           (StrPos(UpperCase(Description), 'POLY') > 0) then
            exit("Total Quantity Ready");

        if (StrPos(UpperCase(Description), 'OUTER POUCH IS NOT A') > 0) then
            exit("Total Quantity Ready" * 2);

        if (not IsBagRequired()) then
            exit(QtyPer * "Lot Quantity")
        else
            exit(QtyPer * "Lot Quantity" / "Quantity of Bags");
    end;

    procedure UpdateUnitReconciliation()
    var
        Tolerance: Decimal;
    begin
        Rec.Variance := Rec."Lot Quantity" - Rec."Quantity for Processing";

        if Rec."Lot Quantity" = 0 then begin
            Rec."Yield = Theoretical ± 10%" := false;
            exit;
        end;

        Tolerance := Rec."Lot Quantity" * 0.1;

        if Abs(Rec.Variance) <= Tolerance then
            Rec."Yield = Theoretical ± 10%" := true
        else
            Rec."Yield = Theoretical ± 10%" := false;
    end;

    local procedure matchlotquantity()
    begin
        if ("Lot Quantity" = 0) or ("Quantity of Bags" = 0) then
            exit;

        if ("Lot Quantity" MOD "Quantity of Bags" <> 0) then
            Error('Lot Quantity must be divisible by Quantity of Bags');
        if ("Product Part Number" IN ['PRT-0492-01', 'PRT-0492-02', 'PRT-0492-03', 'PRT-0492-04']) then begin
            Rec."Lot Quantity (Cases)" := (Rec."Lot Quantity") DIV (Rec."Quantity of Bags");
            Rec."Lot Quantity (Bags)" := Rec."Lot Quantity";
        end;
        if ("Product Part Number" IN ['PRT-0492-05', 'PRT-0492-06', 'PRT-0492-07']) then begin
            Rec."Lot Quantity (Cases)" := Rec."Lot Quantity";
            Rec."Lot Quantity (Bags)" := Rec."Lot Quantity";
        end;
    end;

    local procedure InitializeQuantityOfBags()
    begin
        case "Product Part Number" of
            'PRT-0492-01', 'PRT-0492-04':
                "Quantity of Bags" := 6;

            'PRT-0492-02':
                "Quantity of Bags" := 10;

            'PRT-0492-03':
                "Quantity of Bags" := 5;
            'PRT-0492-05', 'PRT-0492-06', 'PRT-0492-07':
                "Quantity of Bags" := 1;
        end;
    end;

    procedure ValidatePEDGACustomer()
    begin
        if Rec."Verify PEDGA Customer" <> Rec."PEDGA Customer Lot Number" then
            Error(
                'Your input %1 does not match the PEDGA Customer Lot Number %2.',
                Rec."Verify PEDGA Customer",
                Rec."PEDGA Customer Lot Number");
    end;

    procedure ApplyRoutingChange()
    var
        WOOrchestrator: Codeunit "Work Order Orchestrator";
    begin
        if Rec.IsTemporary then
            exit;
        WOOrchestrator.HandleRoutingChange(Rec);
    end;

    procedure ProcessPLStatusRecalc()
    begin
        if not "PL Status Needs Recalc" then
            exit;

        "PL Status Needs Recalc" := false;

        UpdatePLLabelStatus();
    end;

    procedure SyncHeaderStatus()
    var
        WorkOrder: Record "Work Order Header";
    begin
        if WorkOrder.Get("No.") then
            WorkOrder.UpdatePLLabelStatus();
    end;

    local procedure ResetLabelData()
    var
        RunLine: Record "Print Label Line";
        LabHead: Record "Print Label Header";
    begin
        RunLine.SetRange("Work Order No.", "No.");
        RunLine.DeleteAll();

        if LabHead.Get("No.") then
            LabHead.ResetTotals();

        "Print Label Status" := "Print Label Status"::Open;
    end;

    procedure SetUIFlags()
    begin
        if "Product Part Number" = '' then
            "Show PRINTLABEL" := false
        else
            "Show PRINTLABEL" := true;
    end;

    procedure ValidatePedgaWaterWeight()
    var
        Expected: Decimal;
        Actual: Decimal;
    begin
        if "Verify Pedga Water weight" < 0 then
            Error('Weight must not be negative');

        Expected := Round("PEDGA Water Weight (g)", 1);
        Actual := Round("Verify Pedga Water weight", 1);

        if Actual <> Expected then
            Error('Mismatch detected. Expected %1 but got %2', Expected, Actual);
    end;

    procedure UpdateBELZERState()
    begin
        RecalculateBELZER();
        RefreshImportantData();
        UpdateUnitReconciliation();
    end;

    procedure IsPTReady(): Boolean
    begin
        exit(
            ("PEDGA Part Number" = 'PN-0446') and
            ("Thiocure Part Number" = 'PN-0447') and
            ("Pedga Mix Date" <> 0D) and
            ("Thiocure Mix Date" <> 0D)
        );
    end;
}