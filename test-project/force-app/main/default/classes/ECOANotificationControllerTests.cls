@IsTest
private class ECOANotificationControllerTests {

	private static ECOANotificationController sut;
	private static ECOANotificationMock.ofIPresenter mockPresenter;

	static {
		mockPresenter = new ECOANotificationMock.ofIPresenter();
		sut = new ECOANotificationController(mockPresenter);
	}

	@IsTest
    static void it_should_build_the_vm_when_initialized(){		
		mockPresenter.setup('buildVm').returns(new ECOANotification.FormVm());

		sut.initialize();

		mockPresenter.verify('buildVm', Times.Once);
	}

	@IsTest
    static void it_should_initialize_the_date_object_when_initialized() {
		ECOANotification.FormVm testFormVm = new ECOANotification.FormVm();
		testFormVm.startDate = Date.newInstance(1960, 2, 17);
		testFormVm.endDate = Date.newInstance(2016, 3, 24);
		mockPresenter.setup('buildVm').returns(testFormVm);

		sut.initialize();

		Grenzsoldat__c dtObj = sut.dateObject;
		Boolean navigateValue = sut.navigate;
		System.assertEquals(testFormVm.startDate, dtObj.Bogus_Date_1__c);
		System.assertEquals(testFormVm.endDate, dtObj.Bogus_Date_2__c);
		System.assertEquals(false, navigateValue);
	}

	@IsTest
    static void it_should_relay_the_filter_call_to_the_presenter() {
		Date startDate = Date.newInstance(2001, 1, 1);
		Date endDate = Date.newInstance(2002, 2, 2);
		mockPresenter.setup('buildVm').returns(new ECOANotification.FormVm());

		sut.initialize();
		sut.dateObject.Bogus_Date_1__c = startDate;
		sut.dateObject.Bogus_Date_2__c = endDate;
		sut.filterNotifications();

		mockPresenter.verify('filterNotifications', new List<Object>{startDate, endDate}, Times.Once);
	}

	@IsTest
    static void it_should_assign_the_returned_vm_when_filtering() {
		ECOANotification.FormVm testFormVm = new ECOANotification.FormVm();
		testFormVm.startDate = Date.newInstance(1960, 2, 17);
		testFormVm.endDate = Date.newInstance(2016, 3, 24);
		mockPresenter.setup('buildVm').returns(new ECOANotification.FormVm());
		mockPresenter.setup('filterNotifications', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(testFormVm);

		sut.initialize();
		sut.filterNotifications();
		
		ECOANotification.FormVm result = sut.vm;
		Boolean navigateValue = sut.navigate;
		System.assertEquals(testFormVm, result);
		System.assertEquals(false, navigateValue);
	}

	@IsTest
    static void it_should_relay_the_print_call_to_the_presenter() {
		ECOANotification.FormVm testFormVm = new ECOANotification.FormVm();
		testFormVm.startDate = Date.newInstance(1960, 2, 17);
		testFormVm.endDate = Date.newInstance(2016, 3, 24);
		String testSelectedDate = '1/1/1900';
		mockPresenter.setup('buildVm').returns(testFormVm);

		sut.initialize();
		sut.selectedDate = testSelectedDate;
		sut.selectedUrl = '';
		sut.print();

		Boolean navigateValue = sut.navigate;
		mockPresenter.verify('print', new List<Object>{testSelectedDate, testFormVm}, Times.Once);
		System.assertEquals(true, navigateValue);
	}

	@IsTest
    static void code_coverage_call_default_constructor() {
		ECOANotificationController xsut = new ECOANotificationController();
	}
}