@IsTest
private class ModificationRequestTriggerHandlerTests {
	
    private static final TriggerHandlerTester tester;
    private static final MockofIModReqTriggerHandlerDataProv mockDataProv;
    private static final Mock.ofIParentRelationshipSvc mockParentRelSvc;
    private static final ModificationRequestTriggerHandler sut;

    static {
        tester = new TriggerHandlerTester();
		mockDataProv = new MockofIModReqTriggerHandlerDataProv();
        mockParentRelSvc = new Mock.ofIParentRelationshipSvc();
		sut = new ModificationRequestTriggerHandler(mockDataProv, mockParentRelSvc);
		tester.triggerOld = new List<Modification_Request__c>();
		tester.triggerNew = new List<Modification_Request__c>();
    }

    @IsTest
    static void it_should_update_the_RM_if_change_request_is_approved_and_RM_change_made() {
        Id acct1Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id acct2Id = ObjectFactory.getFakeId(Account.SObjectType, '2');
    	Modification_Request__c modReq = new Modification_Request__c();
        modReq.Id = ObjectFactory.getFakeId(Modification_Request__c.SObjectType, '1');
    	modReq.Approval_Status__c = 'Approved';
    	modReq.New_RM__c = ObjectFactory.getFakeId(User.SObjectType, '1');
    	modReq.Account__c = acct1Id;
    	tester.triggerOld.add(modReq);
    	tester.triggerNew.add(modReq);
    	Modification_Request__c modReq2 = new Modification_Request__c();
        modReq2.Id = ObjectFactory.getFakeId(Modification_Request__c.SObjectType, '2');
    	modReq2.Approval_Status__c = 'Approved';
    	modReq2.New_RM__c = ObjectFactory.getFakeId(User.SObjectType, '2');
    	modReq2.Account__c = acct2Id;
    	tester.triggerOld.add(modReq2);
    	tester.triggerNew.add(modReq2);
    	Modification_Request__c modReq3 = new Modification_Request__c();
        modReq3.Id = ObjectFactory.getFakeId(Modification_Request__c.SObjectType, '3');
    	modReq3.Approval_Status__c = 'Approved';
    	modReq3.New_RM__c = null;
    	modReq3.Account__c = ObjectFactory.getFakeId(Account.SObjectType, '3');
    	tester.triggerOld.add(modReq3);
    	tester.triggerNew.add(modReq3);
        mockParentRelSvc.setup('getTopLevelParent', new List<Object>{acct1Id}).returns(new Account(Id=acct1Id));
        mockParentRelSvc.setup('getTopLevelParent', new List<Object>{acct2Id}).returns(new Account(Id=acct2Id));

    	tester.beforeTriggerUpdateSequence(sut);

    	mockDataProv.verify('saveAccounts', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    	List<Object> rawRequest = mockDataProv.getArgumentsFromCall('saveAccounts');
        List<Account> acctsUpdated = (List<Account>) (rawRequest.get(0));
        System.assertEquals(2, acctsUpdated.size());
        System.assertEquals(acct1Id, acctsUpdated[0].Id);
        System.assertEquals(modReq.New_RM__c, acctsUpdated[0].OwnerId);
        System.assertEquals(acct2Id, acctsUpdated[1].Id);
        System.assertEquals(modReq2.New_RM__c, acctsUpdated[1].OwnerId);
    }

    @IsTest
    static void it_should_update_the_RM_of_primary_relationship_if_change_request_is_approved_and_RM_change_made() {
        Id acct1Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id topLevelParentId = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Modification_Request__c modReq = new Modification_Request__c();
        modReq.Approval_Status__c = 'Approved';
        modReq.New_RM__c = ObjectFactory.getFakeId(User.SObjectType, '1');
        modReq.Account__c = acct1Id;
        tester.triggerOld.add(modReq);
        tester.triggerNew.add(modReq);
        mockParentRelSvc.setup('getTopLevelParent', new List<Object>{acct1Id}).returns(new Account(Id=topLevelParentId));

        tester.beforeTriggerUpdateSequence(sut);

        mockDataProv.verify('saveAccounts', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> rawRequest = mockDataProv.getArgumentsFromCall('saveAccounts');
        List<Account> acctsUpdated = (List<Account>) (rawRequest.get(0));
        System.assertEquals(1, acctsUpdated.size());
        System.assertEquals(topLevelParentId, acctsUpdated[0].Id);
        System.assertEquals(modReq.New_RM__c, acctsUpdated[0].OwnerId);
        System.assertEquals(modReq.Processing_Status__c, 'Processed');
    }

    @IsTest
    static void it_should_change_the_processing_status_to_processed_when_the_before_update_is_triggered() {
        Id acct1Id = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id topLevelParentId = ObjectFactory.getFakeId(Account.SObjectType, '2');
        Modification_Request__c modReq = new Modification_Request__c();
        modReq.Approval_Status__c = 'Approved';
        modReq.New_RM__c = ObjectFactory.getFakeId(User.SObjectType, '1');
        modReq.Account__c = acct1Id;
        tester.triggerOld.add(modReq);
        tester.triggerNew.add(modReq);
        mockParentRelSvc.setup('getTopLevelParent', new List<Object>{acct1Id}).returns(new Account(Id=topLevelParentId));

        tester.beforeTriggerUpdateSequence(sut);

        mockDataProv.verify('saveAccounts', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        List<Object> rawRequest = mockDataProv.getArgumentsFromCall('saveAccounts');
        List<Account> acctsUpdated = (List<Account>) (rawRequest.get(0));
        System.assertEquals(1, acctsUpdated.size());
        System.assertEquals(topLevelParentId, acctsUpdated[0].Id);
        System.assertEquals(modReq.New_RM__c, acctsUpdated[0].OwnerId);
        System.assertEquals(modReq.Processing_Status__c, 'Processed');
    }

    @IsTest
    static void it_should_not_update_the_RM_if_change_request_is_not_approved_and_RM_change_made() {
    	Modification_Request__c modReq = new Modification_Request__c();
    	modReq.Approval_Status__c = 'Not Approved';
    	modReq.New_RM__c = ObjectFactory.getFakeId(User.SObjectType, '1');
    	modReq.Account__c = ObjectFactory.getFakeId(Account.SObjectType, '1');
    	tester.triggerOld.add(modReq);
    	tester.triggerNew.add(modReq);

    	tester.beforeTriggerUpdateSequence(sut);

    	mockDataProv.verify('saveAccounts', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Never);
    }

    @IsTest
    static void it_should_not_update_the_RM_if_change_request_is_approved_but_no_RM_change_made() {
    	Modification_Request__c modReq = new Modification_Request__c();
    	modReq.Approval_Status__c = 'Approved';
    	modReq.New_RM__c = null;
    	modReq.Account__c = ObjectFactory.getFakeId(Account.SObjectType, '1');
    	tester.triggerOld.add(modReq);
    	tester.triggerNew.add(modReq);

    	tester.beforeTriggerUpdateSequence(sut);

    	mockDataProv.verify('saveAccounts', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Never);
    }

    @IsTest
    static void it_should_call_default_constructor_without_error() {
        ModificationRequestTriggerHandler sutDef = new ModificationRequestTriggerHandler();
    }

    @IsTest
    static void it_should_not_error_on_integration() {
        Modification_Request__c modReq = new Modification_Request__c();
        insert modReq;
    }

    @IsTest
    static void it_should_not_error_on_typical_sequence() {
    	Modification_Request__c modReq = new Modification_Request__c();
    	tester.triggerOld.add(modReq);
    	tester.triggerNew.add(modReq);
    	tester.beforeTriggerInsertSequence(sut);
    	tester.beforeTriggerUpdateSequence(sut);
    	tester.beforeTriggerDeleteSequence(sut);
    	tester.afterTriggerInsertSequence(sut);
    	tester.afterTriggerDeleteSequence(sut);
    }

	private class MockofIModReqTriggerHandlerDataProv extends ApexMoq implements ModReqTriggerHandlerDataProv.IModReqTriggerHandlerDataProv {
		public void saveAccounts(List<Account> accts) {
			handleMethodInvocation('saveAccounts', new List<Object>{accts});
		}
	}
}