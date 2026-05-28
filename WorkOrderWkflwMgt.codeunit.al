codeunit 60021 "Work Order Workflow Mgt"
{
    procedure SubmitProductRelease(
        var WorkOrder: Record "Work Order Header")
    var
        PostingMgt: Codeunit "Work Order Posting Mgt";
    begin
        if not WorkOrder.AreRequiredPLLabelsPosted() then
            Error(
              'All printed labels must be submitted before Product Release.');

        WorkOrder.ValidateBELZER();

        ValidateChecklist(WorkOrder);

        ValidateMaterialAndSupplyVerification(WorkOrder);

        ValidateProductReleaseHeader(WorkOrder);

        PostingMgt.PostWorkOrder(WorkOrder);

        WorkOrder."Released" := true;

        WorkOrder.UpdateStatus();

        WorkOrder.Modify(true);
    end;

    local procedure ValidateChecklist(var WorkOrder: Record "Work Order Header")
    var
        ItemRec: Record "Product Release Item";
    begin
        ItemRec.SetRange("Work Order No.", WorkOrder."No.");

        if not ItemRec.FindFirst() then
            Error('Checklist has not been created.');

        repeat
            if ItemRec.Status = ItemRec.Status::Open then
                Error(
                    'Checklist item "%1" is still Open.',
                    ItemRec."Checklist Item");
        until ItemRec.Next() = 0;
    end;

    local procedure ValidateMaterialAndSupplyVerification(var WorkOrder: Record "Work Order Header")
    var
        MaterialLine: Record "Work Order Material Line";
        SupplyLine: Record "Work Order Supply Line";
    begin
        if WorkOrder."Show PRINTLABEL" then
            exit;

        MaterialLine.SetRange("Work Order No.", WorkOrder."No.");

        if MaterialLine.FindSet() then
            repeat
                if (MaterialLine.Verification <> MaterialLine.Verification::Pass) and
                   (MaterialLine.Verification <> MaterialLine.Verification::NA)
                then
                    Error(
                        'Material Item %1 must have Verification = Pass. Current value: %2',
                        MaterialLine."Item No.",
                        Format(MaterialLine.Verification));
            until MaterialLine.Next() = 0;

        SupplyLine.SetRange("Work Order No.", WorkOrder."No.");

        if SupplyLine.FindSet() then
            repeat
                if (SupplyLine.Verification <> SupplyLine.Verification::Pass) and
                   (SupplyLine.Verification <> SupplyLine.Verification::NA)
                then
                    Error(
                        'Supply Item %1 must have Verification = Pass. Current value: %2',
                        SupplyLine."Item No.",
                        Format(SupplyLine.Verification));
            until SupplyLine.Next() = 0;
    end;

    local procedure ValidateProductReleaseHeader(var WorkOrder: Record "Work Order Header")
    begin
        if WorkOrder."QA Review & Lot Release By" = '' then
            Error('QA Review By is required.');

        if WorkOrder."QA Review Date" = 0D then
            Error('QA Review Date is required.');
    end;
}