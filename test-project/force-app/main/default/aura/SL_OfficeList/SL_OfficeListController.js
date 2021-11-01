({
	doInit: function(component, event, helper) {
		if ($A.util.isEmpty(component.get('v.sOfficeObject'))) {
			return;
		}
		if (window['Date']['getMaxDate'] === undefined) {
			return;
		}
		var sDevice = $A.get("$Browser.formFactor");
		helper.init(component);
	},
	openDetail : function(component, event, helper) {
		var nIdx = event.target.dataset.idx,
			oEl = component.get('v._aData')[nIdx];
		component.set('v._oEl', oEl);
		//helper._showDetail(component, oEl);
	},
	closeDetail : function(component, event, helper) {
		component.set('v._oEl', null);
	},

	goToDetail : function(component, event, helper) {
		var oEl = component.get('v._oEl'),
			sUrl = component.get('v.sDetailsUrl');
		component.set('v._oEl', null);
		if (!$A.util.isEmpty(sUrl)) {
			var oEvt = $A.get("e.force:navigateToURL");
			if (oEvt) {
			    oEvt.setParams({
			      "url": sUrl.replace('[id]', oEl.id)
			    });
			    oEvt.fire();
			}
		} else {
			var oEvt = $A.get("e.force:navigateToSObject");
			if (oEvt) {
				oEvt.setParams({
					"recordId" : oEl.id,
					"slideDevName" : "related"
				});
				oEvt.fire();
			}
		}

	},
	showMap : function(component, event, helper) {
		var oEl = component.get('v._oEl'),
			sUrl = 'https://maps.google.com/?q=' + oEl.address;
		var oEvt = $A.get("e.force:navigateToURL");
		if (oEvt) {
		    oEvt.setParams({
		      "url": sUrl.replace('[id]', oEl.id)
		    });
		    oEvt.fire();
		}

	},
	detailEvent : function(component, event, helper) {
		var sId = event.target.dataset.evt,
			oEvt = $A.get("e.force:navigateToSObject");
		if (oEvt) {
			oEvt.setParams({
				"recordId" : sId,
				"slideDevName" : "related"
			});
			oEvt.fire();
		}


	}
})