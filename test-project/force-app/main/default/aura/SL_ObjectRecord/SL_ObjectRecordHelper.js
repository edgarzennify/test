({
    expandCollapseRecordCards: function (component, helper) {
        var cardProp = component.get("v.RecordExpandCollapse");
        var isExpanded = (cardProp === 'Allow-default collapsed' || cardProp === 'Don\'t allow-always expanded') ? false : true;
        var auraId = component.get("v.auraId");

        component.set("v.IsCardExpEnabled", cardProp === 'Don\'t allow-always expanded' ? false : true);

        if (auraId.length > 24) {
            component.set("v.IsDetailCard", true);
        }

        if (component.get("v.IsCardExpEnabled")) {
            if (component.get("v.IsExpanded"))
                component.set("v.IsExpanded", isExpanded);
            else
                component.set("v.IsExpanded", isExpanded);
        } else {
            component.set("v.IsExpanded", true);
        }
    },
    getFileAndAttach: function (component, helper, event) {
        var Id = component.get('v.SObjectRecord').Id;
        var action = component.get('c.getAttachmentAndFiles');
        action.setParams({
            "recordID": Id
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                if (!ret) return

                var lstAttachments = ret.lstAttachmentAfterSOQL;
                var lstFiles = ret.lstFilesAfterSOQL;
                component.set("v.lstAttachments", lstAttachments);
                component.set("v.lstFiles", lstFiles);
                if (lstAttachments.length <= 0 || lstFiles.length <= 0) {
                    component.set("v.recordDisplay", false);

                }
                component.set("v.ShowFiles", true);
            }
        });
        $A.enqueueAction(action);
    }
})