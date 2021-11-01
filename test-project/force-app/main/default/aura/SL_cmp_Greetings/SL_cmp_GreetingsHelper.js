({
	getCurrentUser: function (component) {
		var action = component.get('c.getUser');
		var _this = this;
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				if (state === 'SUCCESS') {
					var ret = response.getReturnValue();
					component.set('v.curUser', ret);

					var time = {
						hours: new Date().getHours(),
						minutes: new Date().getMinutes()
					};

					component.set('v.greetings', _this.getGreetingsText(time));
				}
			})
		);
		$A.enqueueAction(action);
	},
	getGreetingsText: function (time) {
		if (
			(time.hours >= 7 && time.minutes >= 0) &&
			(time.hours <= 11 && time.minutes <= 59)
		) {
			return 'Good Morning';
		}
		if (
			(time.hours >= 12 && time.minutes >= 0) &&
			(time.hours <= 17 && time.minutes <= 59)
		) {
			return 'Good Afternoon';
		}
		if (
			(time.hours >= 18 && time.minutes >= 0) &&
			(time.hours <= 21 && time.minutes <= 59)
		) {
			return 'Good Evening';
		}
		if (
			(time.hours >= 22 && time.minutes >= 0) &&
			(time.hours <= 6 && time.minutes <= 59)
		) {
			return 'Good Night';
		}
		if (!time) return 'Hello';
		return 'Hello';
	}
})