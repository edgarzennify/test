({
  doInit: function(component, event, helper) {
    // console.log('doInit',component.get('v.ShowAttachmentDetail'));
    //Display the first field in the Fieldset as the header for the record
    var record = component.get('v.SObjectRecord');
    var FieldsetResults = component.get('v.FieldsetResults');
    if (FieldsetResults) {
      var firstField = {};

      if (FieldsetResults[0].type === 'IMAGE') {
        if (FieldsetResults[1]) firstField = FieldsetResults[1];
        component.set(
          'v.strFirstFieldUserImage',
          getRecordValue(record, FieldsetResults[0].fieldPath)
        );
        component.set('v.secondField', FieldsetResults[0].fieldPath);
      } else firstField = FieldsetResults[0];

      component.set(
        'v.firstFieldValue',
        getRecordValue(record, firstField.fieldPath)
      );
      component.set('v.firstFieldPath', firstField.fieldPath);
      component.set('v.firstFieldType', firstField.type);
      component.set('v.isLoaded', true);
      
    }

    /* Function that recompose the reference fields.
         * eg: Oppty.Account.Name recomposes to Record['Oppty']['Account']['Name']
         */
    function getRecordValue(value, fieldName) {
      var lstFields = fieldName.split('.');
      var recordValue = value[lstFields[0]];
      if (lstFields[1] && recordValue) {
        lstFields.splice(0, 1);
        var newFieldName = lstFields.join('.');
        return getRecordValue(recordValue, newFieldName);
      }
      return recordValue;
    }

    var parentElement = component.find('cardHeader');
    if (component.get('v.IsExpanded')) $A.util.addClass(parentElement, '_open');

    helper.expandCollapseRecordCards(component, helper);
  },
  openClose: function(component) {
    var parentElement = component.find('cardHeader');
    var record = component.get('v.SObjectRecord');
    var auraId = component.get('v.auraId');
    var upIcon = document.getElementById(auraId + '__up');
    var downIcon = document.getElementById(auraId + '__down');
    console.log('test');
    if (auraId.length > 24) {
      $A.util.toggleClass(upIcon, 'hide');
      $A.util.toggleClass(downIcon, 'hide');
    }

    if (component.get('v.IsCardExpEnabled')) {
      if (auraId.length < 25) {
        $A.util.toggleClass(upIcon, 'hide');
        $A.util.toggleClass(downIcon, 'hide');
      }
      if (component.get('v.IsExpanded')) component.set('v.IsExpanded', false);
      else component.set('v.IsExpanded', true);
      $A.util.toggleClass(parentElement, '_open');
    } else {
      $A.util.addClass(parentElement, '_open');
    }
  },
  redirectToRecordDetail: function(component, event, helper) {
    var navigateToEvent = $A.get('e.force:navigateToSObject');
    var record = component.get('v.SObjectRecord');
    navigateToEvent.setParams({
      recordId: record.Id,
      slideDevName: 'detail'
    });
    navigateToEvent.fire();
  },
  navigateToRecord: function(component, event, helper) {
    var detailBehaviour = component.get('v.DetailBehaviour');
    var isDisableLinks = component.get('v.DisableLinks');
    var record = component.get('v.SObjectRecord');

    //If On-click is fired from Object Detail component, it will be redirected to Record Detail page
    //Else if fired from Object List widget, a event to Object Detail is fired.
    if (detailBehaviour === 'Redirect to Detail Page') {
      var navEvt = $A.get('e.force:navigateToSObject');
      navEvt.setParams({
        recordId: record.Id,
        slideDevName: 'detail'
      });
      navEvt.fire();
    } else if (detailBehaviour === 'Object Detail Component') {
      if (!isDisableLinks) {
        //Event for Object Detail fired only when Disabled Links attribute is set false.
        var showDetailEvent = $A.get('e.c:ShowObjectDetailEvent');
        console.log(showDetailEvent, ' event');
        showDetailEvent.setParams({
          recordId: record.Id,
          strSObjectName: component.get('v.SObjectName')
        });
        showDetailEvent.fire();
      }
    } else if (
      component.get('v.DetailFieldsetResults').length > 0 &&
      !isDisableLinks
    ) {
      component.set('v.isShowModal', true);
    }
    event.stopImmediatePropagation();
  },
  closeModal: function(component, event, helper) {
    component.set('v.isShowModal', false);
    component.set('v.ShowFiles', false);
  },
  openCloseAttachments: function(component, event, helper) {
    component.set('v.NotInModelpopup', true);
    if (!component.get('v.ShowFiles')) {
      helper.getFileAndAttach(component, event, helper);
    } else {
      component.set('v.ShowFiles', false);
    }
  },
  openCloseAttachments1: function(component, event, helper) {
    // component.set('v.BoolForModelPopup',false);
    component.set('v.NotInModelpopup', false);

    if (!component.get('v.ShowFiles')) {
      helper.getFileAndAttach(component, event, helper);
    } else {
      component.set('v.ShowFiles', false);
    }
  },
  showFiles: function(component, event, helper) {
    $A.get('e.lightning:openFiles').fire({
      recordIds: [event.currentTarget.id]
    });
  },
  closeModelpopUp: function(component, event, helper) {
    component.set('v.ShowFiles', false);
  }
});