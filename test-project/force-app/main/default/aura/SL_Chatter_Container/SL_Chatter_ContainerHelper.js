({
	initMessage : function(component) {
        var bResize = component.get('v.height') == 0,
            sDomain;
		var fListener = function(event) {
            if (event.data != undefined) {
                var aInfo = JSON.parse(event.data);
                if (aInfo.type == 'init') {
                    sDomain = aInfo.domain;
                } else if (aInfo.type == 'detail') {

                    var oNavEvt = $A.get("e.force:navigateToSObject");
                    oNavEvt.setParams({
                      "recordId": aInfo.id,
                      "slideDevName": "detail"
                    });
                    oNavEvt.fire();
				} else if (aInfo.type == 'url') {
					var oNavEvt = $A.get("e.force:navigateToURL");
                    oNavEvt.setParams({
                      "url": aInfo.url
                    });
                    oNavEvt.fire();
                } else if (aInfo.type == 'resize' && bResize) {
                	component.set('v.height', aInfo.height);
                }
                
            }
    	}
            
    	if (window.addEventListener !== undefined) {
	        window.addEventListener("message", fListener, false);
	    } else {
	        attachEvent("onmessage", fListener);
	    }
	},
    initUrl : function(component) {
		var sUrl = component.get('v.path'),
            oToken = document.getElementById('tokenDiv');
        sUrl += (sUrl.indexOf('?') > 0 ? '&' : '?')
			+ 'parent=' + encodeURIComponent(window.location.protocol + '//' + window.location.hostname);

        var sFontColor = window.getComputedStyle(oToken, null).getPropertyValue("color"),
            sBGColor = window.getComputedStyle(oToken, null).getPropertyValue("border-top-color"),
            sFontSize = window.getComputedStyle(oToken, null).getPropertyValue("font-size");
        
        sUrl += '&color=' + sFontColor + '&bg=' + sBGColor + '&font=' + sFontSize;
        if (!$A.util.isEmpty(component.get('v.sId'))) {
            sUrl += '&id=' + component.get('v.sId');
            sUrl = sUrl.replace('SL_Chatter_Container', 'SL_Chatter_Container_ID');
        } else if (component.get('v.bUseCurentPage') && !$A.util.isEmpty(component.get('v.recordId'))) {
            sUrl += '&id=' + component.get('v.recordId');
            sUrl = sUrl.replace('SL_Chatter_Container', 'SL_Chatter_Container_ID');
        }

		component.set('v._url', sUrl);
    }
})