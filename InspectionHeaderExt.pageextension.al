pageextension 50101 "Incoming Inspection Extension" extends "Incoming Inspection"
{
    actions
    {
        addlast(processing)
        {
            action(GenerateInspectionLines)
            {
                Caption = 'Generate Inspection Lines';
                ApplicationArea = All;
                ToolTip = 'Generate Incoming Inspection lines from a Purchase Order.';
                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    InspectionLineCreation: Codeunit "Inspection Line Creation";
                begin
                    PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
                    if Page.RunModal(Page::"Purchase Order List", PurchHeader) = Action::LookupOK then begin
                        InspectionLineCreation.CreateInspectionLinesFromPO(PurchHeader);
                        Message('Inspection lines created for Purchase Order %1.', PurchHeader."No.");
                    end;
                end;
            }

            // action(SubmitInspection)
            // {
            //     Caption = 'Submit Inspection';
            //     ApplicationArea = All;
            //     trigger OnAction()
            //     var
            //         InspectionMgt: Codeunit "Inspection Mgt";
            //     begin
            //         if Rec.Status = Rec.Status::Open then
            //             Error('Inspection must be Pass or Fail before submitting.');

            //         if Rec.Status = Rec.Status::Fail then begin
            //             InspectionMgt.PostFailedQuantity(Rec);
            //             Rec."Bin Code" := 'REJ-01';
            //         end;

            //         if Rec.Status = Rec.Status::Pass then begin
            //             Rec."Bin Code" := 'PROD-01';
            //         end;

            //         InspectionMgt.AddToCompleted(Rec);

            //         CurrPage.Update(false);

            //         Message('Inspection %1 completed.', Rec."Inspection No.");
            //     end;
            // }
            action(SubmitInspection)
            {
                Caption = 'Submit Inspection';
                ApplicationArea = All;

                trigger OnAction()
                var
                    InspectionMgt: Codeunit "Inspection Mgt";
                begin

                    if Rec.Status = Rec.Status::Open then
                        Error('Inspection must be Pass or Fail before submitting.');

                    if Rec.Status = Rec.Status::Pass then
                        InspectionMgt.PostPassedQuantity(Rec);

                    if Rec.Status = Rec.Status::Fail then
                        InspectionMgt.PostFailedQuantity(Rec);

                    InspectionMgt.AddToCompleted(Rec);

                    CurrPage.Update(false);

                    Message('Inspection %1 completed.', Rec."Inspection No.");
                end;
            }
        }
    }
}