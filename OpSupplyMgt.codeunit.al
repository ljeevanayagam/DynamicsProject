codeunit 60006 "Operational Supply Mgt"
{
    // =====================================================
    // ENTRY POINT (ONLY METHOD CALLED FROM HEADER)
    // =====================================================
    procedure GenerateSupplies(var WorkOrder: Record "Work Order Header")
    begin
        if WorkOrder."No." = '' then
            exit;
        // 🔥 ALWAYS RESET FIRST
        DeleteSupplies(WorkOrder."No.");
        if (WorkOrder."PEDGA Part Number" = 'PN-0446') and (WorkOrder."Thiocure Part Number" = 'PN-0447') then begin
            GeneratePedgaThiocureSupplies(WorkOrder);
            exit;
        end;

        case WorkOrder."Routing No." of
            'BELZER':
                GenerateBelzerSupplies(WorkOrder);
            'SUB-OTS':
                GenerateSubassembliesSupplies(WorkOrder);
        end;
    end;

    // =====================================================
    // BELZER
    // =====================================================
    local procedure GenerateBelzerSupplies(var WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        LineNo := 1;

        InsertLine(WorkOrder, LineNo, 'SA-1001-01', 1);
        LineNo += 1;
        InsertLine(WorkOrder, LineNo, 'SA-1001-02', 1);
        LineNo += 1;
        InsertLine(WorkOrder, LineNo, 'SA-1001-03', 2);
        LineNo += 1;
        InsertLine(WorkOrder, LineNo, 'PRT-0526', 1);
        LineNo += 1;
        InsertLine(WorkOrder, LineNo, 'PRT-0482', 1);
    end;

    // =====================================================
    // SUB-OTS
    // =====================================================
    local procedure GenerateSubassembliesSupplies(var WorkOrder: Record "Work Order Header")
    var
        LineNo: Integer;
    begin
        LineNo := 1;

        if WorkOrder."Product Part Number" = 'SA-1001-01' then begin
            InsertLine(WorkOrder, LineNo, 'PRT-0500-02', 1);
            LineNo += 1;
            InsertLine(WorkOrder, LineNo, 'PRT-0500-01', 1);
            LineNo += 1;
            InsertLine(WorkOrder, LineNo, 'PRT-0502', 4);
            LineNo += 1;
            InsertLine(WorkOrder, LineNo, 'PRT-0505', 1);
        end
        else begin
            InsertLine(WorkOrder, LineNo, 'PRT-0507', 1);
            LineNo += 1;
            InsertLine(WorkOrder, LineNo, 'PRT-0495', 1);
            LineNo += 1;
            InsertLine(WorkOrder, LineNo, 'PRT-0502', 1);
        end;
    end;

    // =====================================================
    // PEDGA / THIOCURE
    // =====================================================
    local procedure GeneratePedgaThiocureSupplies(var WorkOrder: Record "Work Order Header")
    var
        PLineNo: Integer;
        TLineNo: Integer;
    begin
        PLineNo := 1;
        TLineNo := 1;

        InsertPLine(WorkOrder, PLineNo, 'PRT-0497', 1);
        PLineNo += 1;
        InsertPLine(WorkOrder, PLineNo, 'PRT-0550', 1);
        PLineNo += 1;
        InsertPLabware(
                    WorkOrder,
                    PLineNo,
                    'Labware (Non-Serialized)',
                    'Clean labware container, size appropriate for batch.'
                    , WorkOrder.Verification::NA, '');

        InsertTLine(WorkOrder, TLineNo, 'PRT-0497', 1);
        TLineNo += 1;
        InsertTLine(WorkOrder, TLineNo, 'PRT-0550', 1);
        TLineNo += 1;
        InsertTLabware(
                WorkOrder,
                TLineNo,
                'Labware (Non-Serialized)',
                'Clean labware container, size appropriate for batch.'
                , WorkOrder.Verification::NA, '');

    end;

    // =====================================================
    // INSERT ITEM LINE
    // =====================================================
    local procedure InsertLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        ItemNo: Code[20];
        Qty: Decimal)
    var
        SupplyLine: Record "Work Order Supply Line";
    begin
        SupplyLine.Init();
        SupplyLine."Work Order No." := WorkOrder."No.";
        SupplyLine."Line No." := LineNo;
        SupplyLine."Display Order" := LineNo;
        SupplyLine.Validate("Item No.", ItemNo);
        SupplyLine.Validate("Unit Quantity", Qty);
        SupplyLine.Insert(true);
    end;

    local procedure InsertPLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        ItemNo: Code[20];
        Qty: Decimal)
    var
        SupplyLine: Record "Pedga Operational Header";
    begin
        SupplyLine.Init();
        SupplyLine."Work Order No." := WorkOrder."No.";
        SupplyLine."Line No." := LineNo;
        SupplyLine."Display Order" := LineNo;
        SupplyLine.Validate("Item No.", ItemNo);
        SupplyLine.Validate("Unit Quantity", Qty);
        SupplyLine.Insert(true);
    end;

    local procedure InsertTLine(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        ItemNo: Code[20];
        Qty: Decimal)
    var
        SupplyLine: Record "Thiocure Operational Header";
    begin
        SupplyLine.Init();
        SupplyLine."Work Order No." := WorkOrder."No.";
        SupplyLine."Line No." := LineNo;
        SupplyLine."Display Order" := LineNo;
        SupplyLine.Validate("Item No.", ItemNo);
        SupplyLine.Validate("Unit Quantity", Qty);
        SupplyLine.Insert(true);
    end;

    // =====================================================
    // INSERT FREE TEXT LINE
    // =====================================================
    local procedure InsertPLabware(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        ItemNo: Code[50];
        Description: Text[250];
        Verification: Enum Verification;
        Details: Text[250])
    var
        PSupplyLine: Record "Pedga Operational Header";
    begin
        PSupplyLine.Init();
        PSupplyLine."Work Order No." := WorkOrder."No.";
        PSupplyLine."Line No." := LineNo;
        PSupplyLine."Display Order" := LineNo;
        PSupplyLine."Item No." := ItemNo;
        PSupplyLine."Item Description" := Description;
        PSupplyLine.Verification := Verification;
        PSupplyLine."Unit Quantity" := 1;
        PSupplyLine.Insert(true);
    end;

    local procedure InsertTLabware(
        WorkOrder: Record "Work Order Header";
        LineNo: Integer;
        ItemNo: Code[50];
        Description: Text[250];
        Verification: Enum Verification;
        Details: Text[250])
    var
        PSupplyLine: Record "Thiocure Operational Header";
    begin
        PSupplyLine.Init();
        PSupplyLine."Work Order No." := WorkOrder."No.";
        PSupplyLine."Line No." := LineNo;
        PSupplyLine."Display Order" := LineNo;
        PSupplyLine."Item No." := ItemNo;
        PSupplyLine."Item Description" := Description;
        PSupplyLine.Verification := Verification;
        PSupplyLine."Unit Quantity" := 1;
        PSupplyLine.Insert(true);
    end;

    // =====================================================
    // DELETE ALL
    // =====================================================
    procedure DeleteSupplies(WorkOrderNo: Code[100])
    var
        SupplyLine: Record "Work Order Supply Line";
        PSupplyLine: Record "Pedga Operational Header";
        TSupplyLine: Record "Thiocure Operational Header";
    begin
        // Standard supply lines
        SupplyLine.SetRange("Work Order No.", WorkOrderNo);
        if SupplyLine.FindSet() then
            SupplyLine.DeleteAll();

        // PEDGA supply lines
        PSupplyLine.SetRange("Work Order No.", WorkOrderNo);
        if PSupplyLine.FindSet() then
            PSupplyLine.DeleteAll();

        // THIOCURE supply lines
        TSupplyLine.SetRange("Work Order No.", WorkOrderNo);
        if TSupplyLine.FindSet() then
            TSupplyLine.DeleteAll();
    end;
}