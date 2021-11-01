({
	doInit: function(component, event, helper) {
        helper.initMessage(component);
        var oToken;
        var fCheck = function(){
            setTimeout(
                $A.getCallback(function() {
                    oToken = document.getElementById('tokenDiv');
                    if (oToken == null) {
                        fCheck();
                    }
                    helper.initUrl(component);
                }), 
                500
            );
        }
        fCheck();
	}
})