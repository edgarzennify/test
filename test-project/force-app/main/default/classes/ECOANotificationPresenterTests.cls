@IsTest
private class ECOANotificationPresenterTests {
    
    private static final ECOANotificationPresenter sut;
    private static final ECOANotificationMock.ofIRepository mockRepository;
    private static final Mock.ofISystem mockSystem;
    
    static {
        mockRepository = new ECOANotificationMock.ofIRepository();
        mockSystem = new Mock.ofISystem();
        sut = new ECOANotificationPresenter(mockRepository, mockSystem);
    }
    
    @IsTest
    static void it_should_get_the_loans_from_the_repository_when_building_the_vm() {
        Date testDate = Date.newInstance(2016,3,25);
        mockSystem.setup('today').returns(testDate);

        sut.buildVm();

        mockRepository.verify('getLoansForNotification', new List<Object>{testDate-30,testDate-1});
    }

    @IsTest
    static void it_should_return_a_built_vm_with_the_correct_dates_and_number_of_notifications_when_building_vm() {
        Date testDate = Date.newInstance(2016,3,25);
        DmLoan ln1 = new DmLoan();
        ln1.id='123';
        ln1.ecoaDateFlagged = testDate-2;
        ln1.ecoaDocumentUrl = 'http://www.google.com';
        ln1.ecoaDatePrinted = null;
        DmLoan ln2 = new DmLoan();
        ln2.id='345';
        ln2.ecoaDateFlagged = testDate-1;
        ln2.ecoaDocumentUrl = 'http://www.google.com';
        ln2.ecoaDatePrinted = testDate;
        DmLoan ln3 = new DmLoan();
        ln3.id='678';
        ln3.ecoaDateFlagged = testDate-1;
        ln3.ecoaDocumentUrl = 'http://www.google.com';
        ln3.ecoaDatePrinted = testDate;
        mockSystem.setup('today').returns(testDate);
        mockRepository.setup('getLoansForNotification', new List<Object>{testDate-30,testDate-1}).returns(new List<DmLoan>{ln1,ln2,ln3});

        ECOANotification.FormVm result = sut.buildVm();

        System.assertEquals(testDate-30, result.startDate);
        System.assertEquals(testDate-1, result.endDate);
        System.assertEquals(2, result.notifications.size());
    }

    @IsTest
    static void it_should_get_the_loans_from_the_repository_when_filtering() {
        Date testDate1 = Date.newInstance(2016,3,25);
        Date testDate2 = Date.newInstance(2016,3,26);

        sut.filterNotifications(testDate1, testDate2);

        mockRepository.verify('getLoansForNotification', new List<Object>{testDate1,testDate2});
    }

    @IsTest
    static void it_should_return_a_built_vm_with_the_correct_dates_and_number_of_notifications_when_filtering() {
        Date testDate1 = Date.newInstance(2016,3,25);
        Date testDate2 = Date.newInstance(2016,3,26);
        DmLoan testLoan = new DmLoan();
        testLoan.id='123';
        mockRepository.setup('getLoansForNotification', new List<Object>{testDate1,testDate2}).returns(new List<DmLoan>{testLoan});

        ECOANotification.FormVm result = sut.filterNotifications(testDate1, testDate2);

        System.assertEquals(testDate1, result.startDate);
        System.assertEquals(testDate2, result.endDate);
        System.assertEquals(1, result.notifications.size());
    }

    @IsTest
    static void it_should_call_save_on_the_repository_when_printing() {
        Date today = Date.newInstance(2016,3,20);
        String selectedDate = '3/1/2016';
        ECOANotification.FormVm testVm = new ECOANotification.FormVm();
        ECOANotification.NotificationVm nvm = new ECOANotification.NotificationVm();
        DmLoan ln = new DmLoan();
        ln.id = '123';
        ln.ecoaDateFlagged = Date.newInstance(2016,3,1);
        nvm.flaggedDateDisplay = '3/1/2016';
        nvm.loans = new List<DmLoan>{ ln };
        testVm.notifications = new List<ECOANotification.NotificationVm>{ nvm };
        mockSystem.setup('today').returns(today);

        sut.print(selectedDate, testVm);

        mockRepository.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)mockRepository.getArgumentsFromCall('save');
        List<ECOANotification.NotificationSm> sms = (List<ECOANotification.NotificationSm>)arguments[0];
        System.assertEquals(1, sms.size());
        System.assertEquals('123', sms[0].id);
        System.assertEquals(today, sms[0].printDate);
    }

    @IsTest
    static void it_should_not_call_save_on_repository_if_selected_loan_has_been_printed_before() {
        Date today = Date.newInstance(2016,3,20);
        String selectedDate = '3/1/2016';
        ECOANotification.FormVm testVm = new ECOANotification.FormVm();
        ECOANotification.NotificationVm nvm = new ECOANotification.NotificationVm();
        DmLoan ln = new DmLoan();
        ln.id = '123';
        ln.ecoaDateFlagged = Date.newInstance(2016,3,1);
        ln.ecoaDatePrinted = Date.newInstance(2016,3,2);
        nvm.flaggedDateDisplay = '3/1/2016';
        nvm.loans = new List<DmLoan>{ ln };
        testVm.notifications = new List<ECOANotification.NotificationVm>{ nvm };
        mockSystem.setup('today').returns(today);

        sut.print(selectedDate, testVm);

        mockRepository.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)mockRepository.getArgumentsFromCall('save');
        List<ECOANotification.NotificationSm> sms = (List<ECOANotification.NotificationSm>)arguments[0];
        System.assertEquals(0, sms.size());
    }

    @IsTest
    static void it_should_not_send_any_sms_to_the_repository_if_no_vm_contain_the_selected_date() {
        Date today = Date.newInstance(2016,3,20);
        String selectedDate = '3/1/2016';
        ECOANotification.FormVm testVm = new ECOANotification.FormVm();
        ECOANotification.NotificationVm nvm = new ECOANotification.NotificationVm();
        DmLoan ln = new DmLoan();
        ln.id = '123';
        ln.ecoaDateFlagged = Date.newInstance(2016,3,2);
        nvm.flaggedDateDisplay = '3/2/2016';
        nvm.loans = new List<DmLoan>{ ln };
        testVm.notifications = new List<ECOANotification.NotificationVm>{ nvm };
        mockSystem.setup('today').returns(today);

        sut.print(selectedDate, testVm);

        mockRepository.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
        List<Object> arguments = (List<Object>)mockRepository.getArgumentsFromCall('save');
        List<ECOANotification.NotificationSm> sms = (List<ECOANotification.NotificationSm>)arguments[0];
        System.assertEquals(0, sms.size());
    }
}