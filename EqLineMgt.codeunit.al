codeunit 60007 "Equipment Line Mgt"
{
    procedure GeneratePTEquipment(var WorkOrder: Record "Work Order Header")
    begin
        DeletePedgaEquipment(WorkOrder."No.");
        DeleteThiocureEquipment(WorkOrder."No.");
        if (WorkOrder."PEDGA Part Number" <> 'PN-0446') or (WorkOrder."Thiocure Part Number" <> 'PN-0447') then
            exit;
        InsertSet5(WorkOrder);
    end;

    procedure GenerateEquipment(var WorkOrder: Record "Work Order Header")
    begin
        DeleteEquipment(WorkOrder."No.");

        if WorkOrder."Routing No." = '' then
            exit;

        case WorkOrder."Routing No." of
            'BELZER':
                InsertSet1(WorkOrder);

            'SUB-OTS':
                InsertSet2(WorkOrder);

            'FILL_SET':
                InsertSet3(WorkOrder);

            'MOON-MNLT':
                InsertSet4(WorkOrder);

            'PRINTLABEL':
                exit;
        end;

    end;

    // -------------------------
    // SET 1 - BELZER
    // -------------------------
    local procedure InsertSet1(WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        LineNo := 1;

        InsertLine(WorkOrder, LineNo, 'Laminar Flow Hood', 'EQ-00025', '');
        LineNo += 1;
        InsertLine(WorkOrder, LineNo, 'Peristaltic Pump', 'EQ-00029', '');
        LineNo += 1;
        InsertLine(WorkOrder, LineNo, 'Balance', 'EQ-00028', '');
        LineNo += 1;
        InsertLine(WorkOrder, LineNo, '500g Weight', 'C-0013 – C-0016', '');
        LineNo += 1;
        InsertLine(WorkOrder, LineNo, 'Vante Tube Sealing System', 'EQ-00013',
            'RF Power: 10, RF Dwell: 1.5-2.5, Clamp Time: 0.2, Pressure 40-120 psi');
        LineNo += 1;

        // Product-specific additions (THIS is where Product Part No. belongs)
        if WorkOrder."Product Part Number" in [
            'PRT-0492-01', 'PRT-0492-02', 'PRT-0492-03', 'PRT-0492-04'
        ] then begin
            InsertLine(WorkOrder, LineNo, 'Impulse Sealer', 'EQ-00012',
                'Temp: 250 ± 10 °F, HT: 1.0 ± 0.1 Sec. CT: 200 °F');
            LineNo += 1;

            InsertLine(WorkOrder, LineNo, 'Liquid Particle Counter', 'EQ-00014',
                'USP_39_788_>100mL_Test1.A');
            LineNo += 1;
        end;

        InsertLine(WorkOrder, LineNo, 'Filter Integrity Test Fixture', 'EQ-00026',
            'Bubble Point Pressure ≥ 50 psi');
    end;

    // -------------------------
    // SET 2 - SUB-OTS
    // -------------------------
    local procedure InsertSet2(WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        LineNo := 1;

        if WorkOrder."Product Part Number" = 'SA-1001-01' then begin
            InsertLine(WorkOrder, LineNo, 'Autoclave Model 2340M', 'EQ-00003',
                'Temp: 123°C, Sterilization Time: 60 Minutes, Dry Time: 10 Minutes');
            LineNo += 1;
            InsertLine(WorkOrder, LineNo, 'Autoclave Model EZ9', 'EQ-00036',
            'Temp: 123°C, Sterilization Time: 60 Minutes, Dry Time: 10 Minutes');
        end;

        if WorkOrder."Product Part Number" in ['SA-1001-02', 'SA-1001-03'] then begin
            InsertLine(WorkOrder, LineNo, 'Autoclave Model 2340E', 'EQ-00001',
                'Temp: 134°C, Sterilization Time: 60 Minutes, Dry Time: 10 Minutes');

            LineNo += 1;
            InsertLine(WorkOrder, LineNo, 'Autoclave Model EZ9', 'EQ-00036',
                'Temp: 134°C, Sterilization Time: 60 Minutes, Dry Time: 10 Minutes');

            LineNo += 1;
            InsertLine(WorkOrder, LineNo, 'Autoclave Model 2340M', 'EQ-00003',
                'Temp: 134°C, Sterilization Time: 85 Minutes, Dry Time: 10 Minutes');
        end;
    end;

    // -------------------------
    // SET 3 - FILL SET
    // -------------------------
    local procedure InsertSet3(WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        LineNo := 1;
        InsertLine(WorkOrder, LineNo, 'Calibrated Ruler', '', '');
    end;

    // -------------------------
    // SET 4 - MOONLIGHT
    // -------------------------
    local procedure InsertSet4(WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        LineNo := 1;

        InsertLine(WorkOrder, LineNo, 'Fuji MS-350-NP Medical Pouch Sealer', 'EQ-00010',
            'Temp: 250 ± 10°F; HT: 0.8 ± 0.1 Sec. CT: 150° F, Pressure: Normal');

        LineNo += 1;

        InsertLine(WorkOrder, LineNo, 'Tensile Tester', 'EQ-00035',
            'Cross-Head Speed: 12°/Min, Method: Supported 180°, Technique C');
    end;

    // -------------------------
    // SET 5 - PEDGA Part Number PN-0446 and THIOCURE Part Number PN-0447
    // -------------------------
    local procedure InsertSet5(WorkOrder: Record "Work Order Header")
    var
        PLineNo: Integer;
        TLineNo: Integer;
    begin
        PLineNo := 1;
        TLineNo := 1;


        InsertPedgaLine(WorkOrder, PLineNo, 'Fume Hood', 'EQ-00047', '');
        PLineNo += 1;
        InsertPedgaLine(WorkOrder, PLineNo, 'Magnetic Stirrer', 'EQ-00046', '');
        PLineNo += 1;
        InsertPedgaLine(WorkOrder, PLineNo, 'Balance', 'EQ-00020', '');
        PLineNo += 1;
        InsertPedgaLine(WorkOrder, PLineNo, '500g Weight', 'C-00013 - C-00016', '');
        PLineNo += 1;
        InsertPedgaLine(WorkOrder, PLineNo, 'Peristaltic Pump', 'EQ-00051', '');
        PLineNo += 1;
        InsertPedgaLine(WorkOrder, PLineNo, 'Refrigerator', 'EQ-00022', '2-8°C');


        InsertThiocureLine(WorkOrder, TLineNo, 'Fume Hood', 'EQ-00047', '');
        TLineNo += 1;
        InsertThiocureLine(WorkOrder, TLineNo, 'Magnetic Stirrer', 'EQ-00046', '');
        TLineNo += 1;
        InsertThiocureLine(WorkOrder, TLineNo, 'Balance', 'EQ-00020', '');
        TLineNo += 1;
        InsertThiocureLine(WorkOrder, TLineNo, '500g Weight', 'C-00013 - C-00016', '');
        TLineNo += 1;
        InsertThiocureLine(WorkOrder, TLineNo, 'Peristaltic Pump', 'EQ-00051', '');
        TLineNo += 1;
        InsertThiocureLine(WorkOrder, TLineNo, 'Refrigerator', 'EQ-00022', '2-8°C');
    end;

    // -------------------------
    // INSERT HELPER
    // -------------------------

    local procedure InsertLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        Desc: Text;
        EqNo: Code[50];
        Params: Text)
    var
        Equip: Record "Work Order Equipment Line";
    begin
        Equip.Init();
        Equip."Work Order No." := WorkOrder."No.";
        Equip."Line No." := LineNo;
        Equip."Equipment Description" := Desc;
        Equip."EQ#, Cal. ID or Equivalent" := EqNo;
        Equip."Eqpt Parameters/accpt criteria" := Params;
        Equip.Insert(true);
    end;

    local procedure InsertPedgaLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        Desc: Text;
        EqNo: Code[50];
        Params: Text)
    var
        Equip: Record "Pedga Equipment Used";
    begin
        Equip.Init();
        Equip."Work Order No." := WorkOrder."No.";
        Equip."Line No." := LineNo;
        Equip."Equipment Description" := Desc;
        Equip."EQ#, Cal. ID or Equivalent" := EqNo;
        Equip."Eqpt Parameters/accpt criteria" := Params;
        Equip.Insert(true);
    end;

    local procedure InsertThiocureLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        Desc: Text;
        EqNo: Code[50];
        Params: Text)
    var
        Equip: Record "Thiocure Equipment Used";
    begin
        Equip.Init();
        Equip."Work Order No." := WorkOrder."No.";
        Equip."Line No." := LineNo;
        Equip."Equipment Description" := Desc;
        Equip."EQ#, Cal. ID or Equivalent" := EqNo;
        Equip."Eqpt Parameters/accpt criteria" := Params;
        Equip.Insert(true);
    end;

    procedure DeleteEquipment(WorkOrderNo: Code[20])
    var
        Equip: Record "Work Order Equipment Line";
    begin
        Equip.SetRange("Work Order No.", WorkOrderNo);
        if Equip.FindSet() then
            Equip.DeleteAll();
    end;

    procedure DeletePedgaEquipment(WorkOrderNo: Code[20])
    var
        Equip: Record "Pedga Equipment Used";
    begin
        Equip.SetRange("Work Order No.", WorkOrderNo);
        if Equip.FindSet() then
            Equip.DeleteAll();
    end;

    procedure DeleteThiocureEquipment(WorkOrderNo: Code[20])
    var
        Equip: Record "Thiocure Equipment Used";
    begin
        Equip.SetRange("Work Order No.", WorkOrderNo);
        if Equip.FindSet() then
            Equip.DeleteAll();
    end;
}