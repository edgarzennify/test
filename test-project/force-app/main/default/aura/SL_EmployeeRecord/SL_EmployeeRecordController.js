({
    doInit: function (component) {

    },
    redirectToProfile: function (component, event, helper) {
        var navigateToEvent = $A.get("e.force:navigateToSObject");
        var record = component.get("v.EmployeeRecord");
        navigateToEvent.setParams({
            "recordId": record.Id,
            "slideDevName": "detail"
        });
        navigateToEvent.fire();
    },
    navigateToRecord: function (component, event, helper) {
        if (
            component.get("v.DetailFieldsetResults").length <= 0 ||
            !component.get("v.DetailFieldsetResults")
        ) {
            var navigateToEvent = $A.get("e.force:navigateToSObject");
            var record = component.get("v.EmployeeRecord");
            navigateToEvent.setParams({
                "recordId": record.Id,
                "slideDevName": "detail"
            });
            navigateToEvent.fire();
        } else {
            component.set("v.isShowModal", true);
        }
    },
    closeModal: function (component, event, helper) {
        component.set("v.isShowModal", false);
    }
})