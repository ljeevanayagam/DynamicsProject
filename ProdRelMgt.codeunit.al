codeunit 60008 "Product Release Mgt"
{
    procedure EnsureChecklistExists(WorkOrderNo: Code[20])
    var
        ChecklistItems: array[19] of Text[250];
        i: Integer;
        ItemRec: Record "Product Release Item";
        LastLineNo: Integer;
    begin
        if WorkOrderNo = '' then
            exit;

        // 🔥 FULL RESET (intentional design)
        ItemRec.SetRange("Work Order No.", WorkOrderNo);
        ItemRec.DeleteAll();

        ChecklistItems[1] := 'Verify all components picked show lot numbers.';
        ChecklistItems[2] := 'Ensure all items on Material Movement Ticket apply to Work Order.';
        ChecklistItems[3] := 'Ensure all Material Movement Tickets are complete, signed & dated.';
        ChecklistItems[4] := 'All operations on the LHR are completed, signed & dated.';
        ChecklistItems[5] := 'Verify Count reconciliation (Qty start = Qty Finish + Qty Rejected)';
        ChecklistItems[6] := 'Correct Lot Number.';
        ChecklistItems[7] := 'Reconciliation of label.';
        ChecklistItems[8] := 'Samples or copies of labels are present.';
        ChecklistItems[9] := 'Ensure Fill Volume Verification results are acceptable and present.';
        ChecklistItems[10] := 'Ensure Filter Integrity test results are acceptable and present.';
        ChecklistItems[11] := 'Ensure sufficient samples issued.';
        ChecklistItems[12] := 'Ensure Particulate Matter test results are acceptable and present.';
        ChecklistItems[13] := 'Ensure Appearance Test results are acceptable and present.';
        ChecklistItems[14] := 'Ensure Cure Time test results are acceptable and present.';
        ChecklistItems[15] := 'Ensure Endotoxin test results are acceptable and present.';
        ChecklistItems[16] := 'Ensure Sterility test results are acceptable and present.';
        ChecklistItems[17] := 'Verify Qty accepted matches Qty on LHR.';
        ChecklistItems[18] := 'Verify all records are complete, signed & dated.';
        ChecklistItems[19] := 'Verify all NMRs or Deviations are released.';

        LastLineNo := 0;

        for i := 1 to 19 do begin
            ItemRec.Init();
            ItemRec."Work Order No." := WorkOrderNo;
            ItemRec."Checklist Item" := ChecklistItems[i];
            ItemRec.Status := ItemRec.Status::Open;

            LastLineNo += 10000;
            ItemRec."Line No." := LastLineNo;

            ItemRec.Insert();
        end;
    end;

    procedure RemoveChecklist(WorkOrderNo: Code[20])
    var
        ItemRec: Record "Product Release Item";
    begin
        ItemRec.SetRange("Work Order No.", WorkOrderNo);
        ItemRec.DeleteAll();
    end;

    procedure HandleRoutingChange(var WorkOrder: Record "Work Order Header")
    begin
        if RequiresProductRelease(WorkOrder) then
            WorkOrder.Validate("Requires Product Release", true)
        else
            WorkOrder.Validate("Requires Product Release", false);
    end;

    local procedure RequiresProductRelease(WorkOrder: Record "Work Order Header"): Boolean
    begin
        exit(
            (WorkOrder."Routing No." = 'BELZER') or
            (WorkOrder."Routing No." = 'FILL_SET') or
            (WorkOrder."Routing No." = 'MOON-MNLT') or
            ((WorkOrder."PEDGA Part Number" = 'PN-0446') and
             (WorkOrder."Thiocure Part Number" = 'PN-0447'))
        );
    end;
}