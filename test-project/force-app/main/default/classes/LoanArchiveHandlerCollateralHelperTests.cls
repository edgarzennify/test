@IsTest
private class LoanArchiveHandlerCollateralHelperTests {
	private final static LoanArchiveHandlerCollateralHelper sut;
	private final static Id m_prospectCollaterlId;
	private final static Id m_coreCollateralId;

	static{
		m_prospectCollaterlId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '1');
		m_coreCollateralId = ObjectFactory.getFakeId(LLC_BI__Collateral__c.SObjectType, '2');

		sut = new LoanArchiveHandlerCollateralHelper();
	}

	private static testMethod void it_should_reparent_pledges_when_prospect_and_core_pledges_are_provided() {
		Id loanId1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		Id loanId2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
		LLC_BI__Loan_Collateral2__c prospect1 = new LLC_BI__Loan_Collateral2__c();
		prospect1.LLC_BI__Loan__c = loanId1;
		prospect1.LLC_BI__Collateral__c = m_prospectCollaterlId;
		List<LLC_BI__Loan_Collateral2__c> prospects = new List<LLC_BI__Loan_Collateral2__c>{prospect1};

		LLC_BI__Loan_Collateral2__c core1 = new LLC_BI__Loan_Collateral2__c();
		core1.LLC_BI__Loan__c = loanId1;
		core1.LLC_BI__Collateral__c = m_coreCollateralId;
		LLC_BI__Loan_Collateral2__c core2 = new LLC_BI__Loan_Collateral2__c();
		core2.LLC_BI__Loan__c = loanId2;
		core2.LLC_BI__Collateral__c = m_coreCollateralId;
		List<LLC_BI__Loan_Collateral2__c> cores = new List<LLC_BI__Loan_Collateral2__c>{core1, core2};

		List<LLC_BI__Loan_Collateral2__c>  result = sut.reparentCollateralPledges(prospects, cores);

		System.assertEquals(1, result.size());
		System.assertEquals(core2, result[0]);
	}

	private static testMethod void it_should_reparent_pledges_when_prospect_and_core_pledges_are_provided_and_prospect_has_a_loan_not_present_in_core() {
		Id loanId1 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
		Id loanId2 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2');
		Id loanId3 = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '3');
		LLC_BI__Loan_Collateral2__c prospect1 = new LLC_BI__Loan_Collateral2__c();
		prospect1.LLC_BI__Loan__c = loanId1;
		prospect1.LLC_BI__Collateral__c = m_prospectCollaterlId;
		LLC_BI__Loan_Collateral2__c prospect2 = new LLC_BI__Loan_Collateral2__c();
		prospect2.LLC_BI__Loan__c = loanId3;
		prospect2.LLC_BI__Collateral__c = m_prospectCollaterlId;
		List<LLC_BI__Loan_Collateral2__c> prospects = new List<LLC_BI__Loan_Collateral2__c>{prospect1, prospect2};

		LLC_BI__Loan_Collateral2__c core1 = new LLC_BI__Loan_Collateral2__c();
		core1.LLC_BI__Loan__c = loanId1;
		core1.LLC_BI__Collateral__c = m_coreCollateralId;
		LLC_BI__Loan_Collateral2__c core2 = new LLC_BI__Loan_Collateral2__c();
		core2.LLC_BI__Loan__c = loanId2;
		core2.LLC_BI__Collateral__c = m_coreCollateralId;
		List<LLC_BI__Loan_Collateral2__c> cores = new List<LLC_BI__Loan_Collateral2__c>{core1, core2};

		List<LLC_BI__Loan_Collateral2__c>  result = sut.reparentCollateralPledges(prospects, cores);

		System.assertEquals(1, result.size());
		System.assertEquals(core2, result[0]);
	}

	private static testMethod void it_should_reparent_documents_when_core_collateral_has_documents() {
		LLC_BI__Document_PlaceHolder__c doc1 = new LLC_BI__Document_PlaceHolder__c();
		doc1.LLC_BI__External_Id__c = m_coreCollateralId;
		List<LLC_BI__Document_PlaceHolder__c> coreDocuments = new List<LLC_BI__Document_PlaceHolder__c>{doc1};
		
		List<LLC_BI__Document_PlaceHolder__c>  result = sut.reparentCollateralDocuments(m_prospectCollaterlId, coreDocuments);

		System.assertEquals(1, result.size());
		System.assertEquals(m_prospectCollaterlId ,result[0].LLC_BI__External_Id__c);
	}

	private static testMethod void it_should_not_reparent_documents_when_core_collateral_has_no_documents() {
		List<LLC_BI__Document_PlaceHolder__c> coreDocuments = new List<LLC_BI__Document_PlaceHolder__c>();

		List<LLC_BI__Document_PlaceHolder__c>  result = sut.reparentCollateralDocuments(m_prospectCollaterlId, coreDocuments);

		System.assertEquals(0, result.size());
	}

	private static testMethod void it_should_not_reparent_documents_when_prospect_collateral_does_not_exist() {
		LLC_BI__Document_PlaceHolder__c doc1 = new LLC_BI__Document_PlaceHolder__c();
		doc1.LLC_BI__External_Id__c = m_coreCollateralId;
		List<LLC_BI__Document_PlaceHolder__c> coreDocuments = new List<LLC_BI__Document_PlaceHolder__c>{doc1};

		List<LLC_BI__Document_PlaceHolder__c>  result = sut.reparentCollateralDocuments(null, coreDocuments);

		System.assertEquals(0, result.size());
	}

	private static testMethod void it_should_return_an_empty_save_when_a_prospect_pledges_are_empty() {
		List<LLC_BI__Loan_Collateral2__c> prospects = new List<LLC_BI__Loan_Collateral2__c>();
		LLC_BI__Loan_Collateral2__c core1 = new LLC_BI__Loan_Collateral2__c();
		core1.LLC_BI__Collateral__c = m_coreCollateralId;
		List<LLC_BI__Loan_Collateral2__c> cores = new List<LLC_BI__Loan_Collateral2__c>{core1};

		List<LLC_BI__Loan_Collateral2__c>  result = sut.reparentCollateralPledges(prospects, cores);

		System.assertEquals(0, result.size());
	}

	private static testMethod void it_should_reparent_ownerships_when_prospect_and_core_ownerships_are_provided() {
		Id entityId1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
		Id entityId2 = ObjectFactory.getFakeId(Account.SObjectType, '2');
		LLC_BI__Account_Collateral__c prospect1 = new LLC_BI__Account_Collateral__c();
		prospect1.LLC_BI__Collateral__c = m_prospectCollaterlId;
		prospect1.LLC_BI__Account__c = entityId1;
		List<LLC_BI__Account_Collateral__c> prospects = new List<LLC_BI__Account_Collateral__c>{prospect1};

		LLC_BI__Account_Collateral__c core1 = new LLC_BI__Account_Collateral__c();
		core1.LLC_BI__Collateral__c = m_coreCollateralId;
		core1.LLC_BI__Account__c = entityId1;
		LLC_BI__Account_Collateral__c core2 = new LLC_BI__Account_Collateral__c();
		core2.LLC_BI__Collateral__c = m_coreCollateralId;
		core2.LLC_BI__Account__c = entityId2;
		List<LLC_BI__Account_Collateral__c> cores = new List<LLC_BI__Account_Collateral__c>{core1, core2};

		List<LLC_BI__Account_Collateral__c> result = sut.reparentCollateralOwnerships(prospects, cores);

		System.assertEquals(1, result.size());
		System.assertEquals(core2, result[0]);
	}

	private static testMethod void it_should_reparent_ownerships_when_prospect_and_core_ownerships_are_provided_and_it_has_a_prospect_with_entity_not_in_core() {
		Id entityId1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
		Id entityId2 = ObjectFactory.getFakeId(Account.SObjectType, '2');
		Id entityId3 = ObjectFactory.getFakeId(Account.SObjectType, '3');
		LLC_BI__Account_Collateral__c prospect1 = new LLC_BI__Account_Collateral__c();
		prospect1.LLC_BI__Collateral__c = m_prospectCollaterlId;
		prospect1.LLC_BI__Account__c = entityId1;
		LLC_BI__Account_Collateral__c prospect2 = new LLC_BI__Account_Collateral__c();
		prospect2.LLC_BI__Collateral__c = m_prospectCollaterlId;
		prospect2.LLC_BI__Account__c = entityId3;
		List<LLC_BI__Account_Collateral__c> prospects = new List<LLC_BI__Account_Collateral__c>{prospect1, prospect2};

		LLC_BI__Account_Collateral__c core1 = new LLC_BI__Account_Collateral__c();
		core1.LLC_BI__Collateral__c = m_coreCollateralId;
		core1.LLC_BI__Account__c = entityId1;
		LLC_BI__Account_Collateral__c core2 = new LLC_BI__Account_Collateral__c();
		core2.LLC_BI__Collateral__c = m_coreCollateralId;
		core2.LLC_BI__Account__c = entityId2;
		List<LLC_BI__Account_Collateral__c> cores = new List<LLC_BI__Account_Collateral__c>{core1, core2};

		List<LLC_BI__Account_Collateral__c> result = sut.reparentCollateralOwnerships(prospects, cores);

		System.assertEquals(1, result.size());
		System.assertEquals(core2, result[0]);
	}

	private static testMethod void it_should_reparent_ownerships_when_prospect_and_core_ownerships_are_provided_and_fix_duplicates() {
		Id entityId1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
		Id entityId2 = ObjectFactory.getFakeId(Account.SObjectType, '2');
		LLC_BI__Account_Collateral__c prospect1 = new LLC_BI__Account_Collateral__c();
		prospect1.LLC_BI__Collateral__c = m_prospectCollaterlId;
		prospect1.LLC_BI__Account__c = entityId1;
		List<LLC_BI__Account_Collateral__c> prospects = new List<LLC_BI__Account_Collateral__c>{prospect1};

		LLC_BI__Account_Collateral__c core1 = new LLC_BI__Account_Collateral__c();
		core1.LLC_BI__Collateral__c = m_coreCollateralId;
		core1.LLC_BI__Account__c = entityId1;
		LLC_BI__Account_Collateral__c core2 = new LLC_BI__Account_Collateral__c();
		core2.LLC_BI__Collateral__c = m_coreCollateralId;
		core2.LLC_BI__Account__c = entityId2;
		LLC_BI__Account_Collateral__c core3 = new LLC_BI__Account_Collateral__c();
		core3.LLC_BI__Collateral__c = m_coreCollateralId;
		core3.LLC_BI__Account__c = entityId2;
		List<LLC_BI__Account_Collateral__c> cores = new List<LLC_BI__Account_Collateral__c>{core1, core2, core3};

		List<LLC_BI__Account_Collateral__c> result = sut.reparentCollateralOwnerships(prospects, cores);

		System.assertEquals(1, result.size());
	}

	private static testMethod void it_should_return_empty_ownerships_when_prospect_ownership_provided_is_empty() {
		Id entityId1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
		List<LLC_BI__Account_Collateral__c> prospects = new List<LLC_BI__Account_Collateral__c>();

		LLC_BI__Account_Collateral__c core1 = new LLC_BI__Account_Collateral__c();
		core1.LLC_BI__Collateral__c = m_coreCollateralId;
		core1.LLC_BI__Account__c = entityId1;
		List<LLC_BI__Account_Collateral__c> cores = new List<LLC_BI__Account_Collateral__c>{core1};

		List<LLC_BI__Account_Collateral__c> result = sut.reparentCollateralOwnerships(prospects, cores);

		System.assertEquals(0, result.size());
	}

}