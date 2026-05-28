codeunit 50100 "NavigationHelper"
{
    Subtype = Normal;

    procedure RunPage(SelectedOption: Enum "NavOption")
    var
        PageMapping: Dictionary of [Enum "NavOption", Integer];
        PageID: Integer;
    begin
        // Initialize the mapping dictionary with Enum values and corresponding page IDs
        PageMapping.Add("NavOption"::IncomingInspection, 50100); // Incoming Inspection List
        PageMapping.Add("NavOption"::WorkOrders, 60002);         // Work Orders List
        PageMapping.Add("NavOption"::FGInspection, 50122);       // FG Inspection List

        // Look up the page ID for the selected option using ContainsKey
        if PageMapping.ContainsKey(SelectedOption) then begin
            // Use Get method to retrieve the Page ID
            PageMapping.Get(SelectedOption, PageID);
            Page.Run(PageID); // Run the page with the resolved PageID
        end else
            Message('Selected option not found.');
    end;
}