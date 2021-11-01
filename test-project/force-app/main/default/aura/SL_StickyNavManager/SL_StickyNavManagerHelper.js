({
	initScroll: function(component) {
		window.onscroll = function(event) {
            var self = this,
                body = document.body;
            
            if (self._nTimer !== null) {
                clearTimeout(self._nTimer);
            }
            
            if (body.scrollTop === undefined) {
                return;
            }
            
            self._nTimer = setTimeout(function(){
                if (body === null) {
                    body = document.body;
                }
                if (body === null) {
                    return;
                }
                var nTop = document.documentElement != undefined
                    ? Math.max(document.documentElement.scrollTop, body.scrollTop)
                    : body.scrollTop;
                if (nTop > 111) {
                    $A.util.addClass(body, '_sticky_nav');
                } else {
                    $A.util.removeClass(body, '_sticky_nav');
                }
            }, 50);
        };
	}
})