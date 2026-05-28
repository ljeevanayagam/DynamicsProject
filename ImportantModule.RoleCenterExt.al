pageextension 50100 ImportantModuleRoleCenterExt extends "Business Manager Role Center"
{
    actions
    {
        addlast(Navigation)
        {
            group("Important Module")
            {
                action("Incoming Inspection")
                {
                    ApplicationArea = All;
                    RunObject = page 50100;
                }

                action("Work Orders")
                {
                    ApplicationArea = All;
                    RunObject = page 60002;
                }

                action("FG Inspection")
                {
                    ApplicationArea = All;
                    RunObject = page 61000;
                }
            }
        }
    }
}