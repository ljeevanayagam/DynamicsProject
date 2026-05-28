//Revision A
codeunit 50102 "Inspection Line Creation"
{
    Subtype = Normal;

    procedure CreateInspectionLinesFromPO(PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        TrackingSpec: Record "Tracking Specification";
    begin

        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetFilter(Quantity, '>0');
        PurchLine.SetFilter("Line Amount", '>0');

        if PurchLine.FindSet() then
            repeat

                // Look for tracking lines
                TrackingSpec.Reset();
                TrackingSpec.SetRange("Source Type", Database::"Purchase Line");
                TrackingSpec.SetRange("Source Subtype", 1);
                TrackingSpec.SetRange("Source ID", PurchLine."Document No.");
                TrackingSpec.SetRange("Source Ref. No.", PurchLine."Line No.");
                TrackingSpec.SetRange("Item No.", PurchLine."No.");

                if TrackingSpec.FindSet() then begin

                    repeat
                        CreateInspectionLineTracking(PurchHeader, PurchLine, TrackingSpec);
                    until TrackingSpec.Next() = 0;

                end else begin

                    CreateInspectionLineNoTracking(PurchHeader, PurchLine);

                end;

            until PurchLine.Next() = 0;

    end;

    local procedure CreateInspectionLineTracking(
    PurchHeader: Record "Purchase Header";
    PurchLine: Record "Purchase Line";
    TrackingSpec: Record "Tracking Specification")
    var
        InspectionRec: Record "Inspection Header";
        VendorRec: Record Vendor;
    begin
        InspectionRec.Reset();
        InspectionRec.SetRange("Purchase Order No.", PurchHeader."No.");
        InspectionRec.SetRange("Item No.", PurchLine."No.");
        InspectionRec.SetRange("Lot No.", TrackingSpec."Lot No.");
        InspectionRec.SetRange("Serial No.", TrackingSpec."Serial No.");

        if InspectionRec.FindFirst() then
            exit; // Prevent duplicates

        InspectionRec.Init();
        InspectionRec."Inspection No." := '';
        InspectionRec."Purchase Order No." := PurchHeader."No.";

        if VendorRec.Get(PurchHeader."Buy-from Vendor No.") then begin
            InspectionRec."Vendor No." := VendorRec."No.";
            InspectionRec."Vendor Name" := VendorRec.Name;
        end;

        InspectionRec."Item No." := PurchLine."No.";
        InspectionRec."Item Description" := PurchLine.Description;

        // **Assign Lot/Serial from PO tracking lines**
        InspectionRec."Lot No." := TrackingSpec."Lot No.";
        InspectionRec."Serial No." := TrackingSpec."Serial No.";
        InspectionRec.Quantity := TrackingSpec."Quantity (Base)";
        InspectionRec."Received By" := UserId;
        InspectionRec."Date Received" := WorkDate;

        InspectionRec.Validate(Status, "Inspection Status"::Open);

        InspectionRec.Insert(true);
    end;

    local procedure CreateInspectionLineNoTracking(
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line")
    var
        InspectionRec: Record "Inspection Header";
        VendorRec: Record Vendor;
    begin

        InspectionRec.Reset();
        InspectionRec.SetRange("Purchase Order No.", PurchHeader."No.");
        InspectionRec.SetRange("Item No.", PurchLine."No.");

        if InspectionRec.FindFirst() then
            exit;

        InspectionRec.Init();

        InspectionRec."Inspection No." := '';
        InspectionRec."Purchase Order No." := PurchHeader."No.";

        if VendorRec.Get(PurchHeader."Buy-from Vendor No.") then begin
            InspectionRec."Vendor No." := VendorRec."No.";
            InspectionRec."Vendor Name" := VendorRec.Name;
        end;

        InspectionRec."Item No." := PurchLine."No.";
        InspectionRec."Item Description" := PurchLine.Description;

        InspectionRec.Quantity := PurchLine.Quantity;
        InspectionRec."Received By" := UserId;
        InspectionRec."Date Received" := WorkDate;

        InspectionRec.Validate(Status, "Inspection Status"::Open);

        InspectionRec.Insert(true);

    end;

    procedure CreateInspectionLine(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"): Record "Inspection Header"
    var
        InspectionRec: Record "Inspection Header";
        VendorRec: Record Vendor;
    begin

        if PurchLine.Type <> PurchLine.Type::Item then
            exit;

        if PurchLine.Quantity <= 0 then
            exit;

        InspectionRec.Init();

        // InspectionRec."Inspection No." := CopyStr(Format(CreateGuid()), 1, 20);
        // InspectionRec."Inspection No." := InspectionRec."Inspection No.";

        InspectionRec."Purchase Order No." := PurchHeader."No.";
        //InspectionRec."Purchase Order Line No." := PurchLine."Line No.";

        if VendorRec.Get(PurchHeader."Buy-from Vendor No.") then begin
            InspectionRec."Vendor No." := VendorRec."No.";
            InspectionRec."Vendor Name" := VendorRec."Name";
        end;

        InspectionRec."Item No." := PurchLine."No.";
        InspectionRec."Item Description" := PurchLine.Description;
        InspectionRec.Quantity := PurchLine.Quantity;
        InspectionRec."Received By" := UserId;

        InspectionRec.Validate(Status, "Inspection Status"::Open);

        InspectionRec.Insert(true);

        exit(InspectionRec);
    end;

}