@IsTest
private class ECOANotificationRepositoryTests {

	private final static ECOANotificationRepository sut;
	private final static EcoaNotificationMock.ofIDataProvider mockDataProvider;

	static {
		mockDataProvider = new EcoaNotificationMock.ofIDataProvider();
		sut = new ECOANotificationRepository(mockDataProvider);
	}

	@IsTest
    static void it_should_return_a_list_of_loan_dm_when_a_list_of_loan_pm_is_provider() {
		Date startDate = Date.newInstance(2000,1,2);
		Date endDate = Date.newInstance(2000,2,3);
		Date flagDate =  Date.newInstance(2000,1,2);
		Date printDate = Date.newInstance(2000,1,2);
		Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');	
		Id entity1Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
		Id entity2Id = ObjectFactory.getFakeId(Account.SObjectType, '2');
		Account entity1 = new Account(Id = entity1Id, Name = 'test entity');	
		Account entity2 = new Account(Id = entity2Id, Name = 'test entity 2');	
		LLC_BI__Loan__c pm1 = new LLC_BI__Loan__c();
		pm1.Id = loanId;
		pm1.Name = 'test loan';
		pm1.LLC_BI__Account__c = entity1.Id;
		pm1.LLC_BI__Account__r = entity1;
		pm1.LLC_BI__Product__c = 'test product';
		pm1.LLC_BI__Product_Line__c = 'loan purpose';
		pm1.ECOA_Date_Flagged__c = flagDate;
		pm1.ECOA_Date_Printed__c = printDate;
		LLC_BI__Loan__c pm2 = new LLC_BI__Loan__c();
		pm2.Id = loanId;
		pm2.Name = 'test loan 2';
		pm2.ECOA_Date_Flagged__c = flagDate;
		pm2.ECOA_Date_Printed__c = printDate;
		pm2.LLC_BI__Account__c = entity2.Id;
		pm2.LLC_BI__Account__r = entity2;
		pm2.LLC_BI__Product__c = 'test product 2';
		pm2.LLC_BI__Product_Line__c = 'loan purpose 2';
		List<LLC_BI__Loan__c> pms = new List<LLC_BI__Loan__c>{pm1, pm2};
		List<EB_Loan_Application__c> loanAppPms = new List<EB_Loan_Application__c>();
		mockDataProvider.setup('getLoansForNotification', new List<Object>{startDate, endDate}).returns(pms);
		mockDataProvider.setup('getLoanAppsForNotification', new List<Object>{startDate, endDate}).returns(loanAppPms);

		List<DmLoan> result = sut.getLoansForNotification(startDate, endDate);

		mockDataProvider.verify('getLoansForNotification', new List<Object>{startDate, endDate}, Times.Once);
		mockDataProvider.verify('getLoanAppsForNotification', new List<Object>{startDate, endDate}, Times.Once);
		System.assertEquals(2, result.size());
		System.assertEquals(loanId,  result[0].Id);
		System.assertEquals('test loan',  result[0].Name);
		System.assertEquals(entity1Id,  result[0].primaryBorrower.Id);
		System.assertEquals('test entity',  result[0].primaryBorrower.Name);
		System.assertEquals('test product',  result[0].loanType);
		System.assertEquals('loan purpose',  result[0].productLine);
		System.assertEquals(flagDate,  result[0].ecoaDateFlagged);
		System.assertEquals(printDate,  result[0].ecoaDatePrinted);

		System.assertEquals(loanId,  result[1].Id);
		System.assertEquals('test loan 2',  result[1].Name);
		System.assertEquals(entity2Id,  result[1].primaryBorrower.Id);
		System.assertEquals('test entity 2',  result[1].primaryBorrower.Name);
		System.assertEquals('test product 2',  result[1].loanType);
		System.assertEquals('loan purpose 2',  result[1].productLine);
		System.assertEquals(flagDate,  result[1].ecoaDateFlagged);
		System.assertEquals(printDate,  result[1].ecoaDatePrinted);
	}

	@IsTest
    static void it_should_return_a_list_of_loan_app_dm_when_a_list_of_loan_app_pm_is_provider() {
		Date startDate = Date.newInstance(2000,1,2);
		Date endDate = Date.newInstance(2000,2,3);
		Date flagDate =  Date.newInstance(2000,1,2);
		Date printDate = Date.newInstance(2000,1,2);
		Id loanId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');	
		Id entity1Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
		Id entity2Id = ObjectFactory.getFakeId(Account.SObjectType, '2');
		Id packetId = ObjectFactory.getFakeId(EB_Loan_Packet__c.SObjectType, '1');
		Account entity1 = new Account(Id = entity1Id, Name = 'test entity');	
		Account entity2 = new Account(Id = entity2Id, Name = 'test entity 2');
		EB_Loan_Packet__c packet = new EB_Loan_Packet__c(Id = packetId, Lead_Entity__r = entity1);	
		EB_Loan_Application__c pm = new EB_Loan_Application__c();
		pm.Id = loanId;
		pm.EB_Loan_Packet__r = packet;
		pm.EB_Loan_Packet__r.Lead_Entity__c = entity1.Id;
		pm.EB_Loan_Packet__r.Lead_Entity__r.Name = entity1.Name;
		pm.Loan_Type__c = 'test product';
		pm.Business_Purpose__c = 'Yes';
		pm.ECOA_Date_Flagged__c = flagDate;
		pm.ECOA_Date_Printed__c = printDate;		
		List<LLC_BI__Loan__c> pms = new List<LLC_BI__Loan__c>();
		List<EB_Loan_Application__c> loanAppPms = new List<EB_Loan_Application__c>{pm};
		mockDataProvider.setup('getLoansForNotification', new List<Object>{startDate, endDate}).returns(pms);
		mockDataProvider.setup('getLoanAppsForNotification', new List<Object>{startDate, endDate}).returns(loanAppPms);

		List<DmLoan> result = sut.getLoansForNotification(startDate, endDate);

		System.assertEquals(1, result.size());
		System.assertEquals(loanId,  result[0].Id);
		System.assertEquals(null,  result[0].Name);
		System.assertEquals(entity1Id,  result[0].primaryBorrower.Id);
		System.assertEquals('test entity',  result[0].primaryBorrower.Name);
		System.assertEquals('test product',  result[0].loanType);
		System.assertEquals('Business',  result[0].productLine);
		System.assertEquals(flagDate,  result[0].ecoaDateFlagged);
		System.assertEquals(printDate,  result[0].ecoaDatePrinted);
	}

	@IsTest
    static void it_should_build_pms_and_save_when_save_sms_are_provided() {
		Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		Date printDate =  Date.newinstance(2000, 1,2);
		ECOANotification.NotificationSm sm1 = new ECOANotification.NotificationSm();
		sm1.id = loanId;
		sm1.printDate = printDate;
		Id loanAppId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
		ECOANotification.NotificationSm sm2 = new ECOANotification.NotificationSm();
		sm2.id = loanAppId;
		sm2.printDate = printDate;
		List<ECOANotification.NotificationSm> sms = new List<ECOANotification.NotificationSm>{sm1, sm2};

		sut.save(sms);

		mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		List<Object> arguments = mockDataProvider.getArgumentsFromCall('save');
		List<SObject> loans = (List<SObject>)arguments[0];
		LLC_BI__Loan__c loan1 = (LLC_BI__Loan__c)loans[0];
		EB_Loan_Application__c loan2 = (EB_Loan_Application__c)loans[1];
		System.assertEquals(loanId ,loan1.Id);
		System.assertEquals(printDate ,loan1.ECOA_Date_Printed__c);
		System.assertEquals(loanAppId ,loan2.Id);
	}

	@IsTest
    static void it_should_not_save_when_sm_id_is_not_loan_app_or_loan_are_provided() {
		Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
		Date printDate =  Date.newInstance(2000, 1,2);
		ECOANotification.NotificationSm sm = new ECOANotification.NotificationSm();
		sm.id = entityId;
		sm.printDate = printDate;		
		List<ECOANotification.NotificationSm> sms = new List<ECOANotification.NotificationSm>{sm};

		sut.save(sms);

		mockDataProvider.verify('save', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
		List<Object> arguments = mockDataProvider.getArgumentsFromCall('save');
		List<SObject> loans = (List<SObject>)arguments[0];
		System.assertEquals(0, loans.size());
	}
}