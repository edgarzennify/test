@isTest
private class CreditRelationshipVmBuilderTests{
	
	private static final CreditRelationshipVmBuilder sut;

	static{
		sut = new CreditRelationshipVmBuilder();
	}

	private static testMethod void it_should_build_view_models_of_archived_reports_when_given_domain_models(){
		DmUser user = new DmUser();
		user.name = 'mr. user';
		DmArchivedReport dm = new DmArchivedReport();
		dm.id = '001';
		dm.name = 'Archived Report One';
		dm.url = 'some url';
		dm.createdDate = Datetime.newInstance(1960, 2, 17);
		dm.createdBy = user;

		List<CreditRelationship.ArchivedReportVm> result = sut.buildArchivedReportVms(new List<DmArchivedReport> {dm});

		CreditRelationship.ArchivedReportVm	resultVm = result[0];
		System.assertEquals(dm.id, resultVm.id);
		System.assertEquals(dm.url, resultVm.url);
		System.assertEquals(dm.name, resultVm.name);
		System.assertEquals(dm.createdDate, resultVm.createdDate);
		System.assertEquals(dm.createdBy.name + ', ' + dm.createdDate.format(), resultVm.createdBy);
	}

	private static testMethod void it_should_build_view_models_of_related_entities_when_given_domain_models(){
		DmCreditRelationshipRelatedEntity dm1 = new DmCreditRelationshipRelatedEntity();
		dm1.id = '123';
		dm1.name = 'Abc';

		DmEntity dm1entity = new DmEntity();
		dm1entity.id = '456';
		dm1entity.name = 'Name1';
		dm1entity.billingStreet = '123 Anywhere St.';
		dm1entity.billingCity = 'St. Louis';
		dm1entity.billingState = 'MO';
		dm1entity.billingPostalCode = '63132';
		dm1.entity = dm1entity;

		List<CreditRelationship.RelatedEntityVm> result = sut.buildRelatedEntityVms(new List<DmCreditRelationshipRelatedEntity>{dm1});	

		CreditRelationship.RelatedEntityVm resultVm = result[0];
		System.assertEquals(dm1.id, resultVm.id);
		System.assertEquals(dm1.entity.id, resultVm.entityId);
		System.assertEquals(dm1.entity.name, resultVm.name);
		System.assertEquals(dm1.entity.billingStreet, resultVm.street);
		System.assertEquals(dm1.entity.billingCity, resultVm.city);
		System.assertEquals(dm1.entity.billingState, resultVm.state);
		System.assertEquals(dm1.entity.billingPostalCode, resultVm.zip);
	}

	private static testMethod void it_should_not_build_view_model_of_related_entities_when_given_domain_model_has_no_entity(){
		DmCreditRelationshipRelatedEntity dm1 = new DmCreditRelationshipRelatedEntity();
		dm1.id = '123';
		dm1.name = 'Abc';

		List<CreditRelationship.RelatedEntityVm> result = sut.buildRelatedEntityVms(new List<DmCreditRelationshipRelatedEntity>{dm1});	

		CreditRelationship.RelatedEntityVm resultVm = result[0];
		System.assertEquals(null, resultVm);
	}	

	private static testMethod void it_should_build_view_models_of_related_accounts_when_given_domain_models(){
		DmEntity primaryOwner = new DmEntity();
		primaryOwner.name = 'test owner';
		DmEbAccount acct = new DmEbAccount();
		acct.id = '001';
		acct.name = '123-15';
		acct.accountNumber = '123';
		acct.accountLine1 = 'acctname1';
		acct.riskRating = '05';
		acct.contributionMargin = 123.45;
		acct.primaryOwner = primaryOwner;
		acct.application = 2;
		acct.currentCommitment = 234.56;
		acct.unadvancedLoanAmount = 345.67;
		acct.currentBalance = 456.78;
		acct.status = 'A';

		List<CreditRelationship.RelatedAccountVm> result = sut.buildRelatedAccountVms(new List<DmEbAccount>{acct});

		CreditRelationship.RelatedAccountVm resultVm = result[0];
		System.assertEquals(acct.id, resultVm.id);
        System.assertEquals(acct.name, resultVm.accountNumber);
        System.assertEquals(acct.accountLine1, resultVm.accountTitle);
        System.assertEquals(acct.riskRating, resultVm.riskRating);
        System.assertEquals(acct.contributionMargin, resultVm.contributionMargin);
        System.assertEquals(acct.primaryOwner.name, resultVm.primaryOwner);
        System.assertEquals(acct.application, resultVm.application);
        System.assertEquals(acct.currentCommitment, resultVm.currentCommitment);
        System.assertEquals(acct.unadvancedLoanAmount, resultVm.unadvancedLoanAmount);
        System.assertEquals(acct.currentBalance, resultVm.currentBalance);
        System.assertEquals(acct.status, resultVm.status);
	}

	private static testMethod void it_should_build_view_models_of_excluded_accounts_when_given_domain_models(){
		DmCreditRelationshipExcludedAccount dmExcludedAccount1 = new DmCreditRelationshipExcludedAccount();
		dmExcludedAccount1.id = '00000000000000a';
		dmExcludedAccount1.name = 'CRRelExcl-1001';
		DmEbAccount acct1 = new DmEbAccount();
		acct1.id='000000000000b';
		acct1.name = '11111';
		acct1.accountLine1='acctname1';
		acct1.riskRating = '05';
		acct1.contributionMargin = 123.12;
		DmEntity dmEntity1 = new DmEntity();
		dmEntity1.id = '00000000000000c';
		acct1.primaryOwner = dmEntity1;
		dmExcludedAccount1.ebAccount = acct1;

		List<CreditRelationship.ExcludedAccountVm> result = sut.buildExcludedAccountVms(new List<DmCreditRelationshipExcludedAccount> {dmExcludedAccount1});

		CreditRelationship.ExcludedAccountVm resultVm = result[0];
		System.assertEquals(dmExcludedAccount1.ebAccount.name, resultVm.accountNumber);
		System.assertEquals(dmExcludedAccount1.id, resultVm.id);
    	System.assertEquals(dmExcludedAccount1.ebAccount.id, resultVm.accountId);
    	System.assertEquals(dmExcludedAccount1.ebAccount.accountLine1, resultVm.accountTitle);
    	System.assertEquals(dmExcludedAccount1.ebAccount.riskRating, resultVm.riskRating);
    	System.assertEquals(dmExcludedAccount1.ebAccount.contributionMargin, resultVm.contributionMargin);
    	System.assertEquals(dmExcludedAccount1.ebAccount.primaryOwner.name, resultVm.primaryOwner);
	}

	private static testMethod void it_should_not_build_view_model_of_excluded_accounts_when_domain_model_does_not_have_ebaccount(){
		DmCreditRelationshipExcludedAccount dmExcludedAccount1 = new DmCreditRelationshipExcludedAccount();
		dmExcludedAccount1.id = '00000000000000a';
		dmExcludedAccount1.name = 'CRRelExcl-1001';

		List<CreditRelationship.ExcludedAccountVm> result = sut.buildExcludedAccountVms(new List<DmCreditRelationshipExcludedAccount> {dmExcludedAccount1});

		System.assertEquals(null,result[0]);
	}

	private static testMethod void it_should_build_view_models_of_credit_relationship_notes_when_given_domain_models(){
		DmCreditRelationshipNote dmNote1 = new DmCreditRelationshipNote();
		dmNote1.id ='00000000000000w';
		dmNote1.name='note123';

		DmRecordType recordType = new DmRecordType();
		recordType.description = 'test record type';
		dmNote1.recordType = recordType;

		DmCreditRelationship creditRelationship = new DmCreditRelationship();
		creditRelationship.id = 'abc';
		dmNote1.creditRelationship = creditRelationship;

		dmNote1.diary = 'diary';
		dmNote1.situationFlag = false;

		DmUser dmUser = new DmUser();
		dmUser.Name = 'Mr. User';
	    dmNote1.createdBy = dmUser;

		Datetime dT = System.now();
		dmNote1.createdDate = dT;
		List<DmCreditRelationshipNote> dms = new List<DmCreditRelationshipNote>{dmNote1};
		
		List<CreditRelationship.NoteVm> result	= sut.buildNoteVms(dms);
		
		System.assertEquals(dms[0].name, result[0].name);
		System.assertEquals(dms[0].id, result[0].id);
		System.assertEquals(dms[0].createdBy.name + ', ' + dms[0].createdDate.format(), result[0].createdBy);
		System.assertEquals(dms[0].diary,result[0].diary);
		System.assertEquals(dms[0].situationFlag,result[0].locked);
	}

	private static testMethod void it_should_build_view_models_of_possible_related_entities_when_given_domain_models(){
		List<DmEntity> dms = new List<DmEntity>();
		DmEntity dmEntity1 = new DmEntity();
		dmEntity1.name='Entity1';
		dms.add(dmEntity1);
		DmEntity dmEntity2 = new DmEntity();
		dmEntity2.name='Entity2';
		dms.add(dmEntity2);
		
		List<CreditRelationship.PossibleRelatedEntityVm> result = sut.buildPossibleRelatedEntityVms(dms);
		
		System.assertEquals(dms[0].name, result[0].name);
		System.assertEquals(dms[0].id, result[0].id);
		System.assertEquals(dms[0].billingStreet, result[0].street);
		System.assertEquals(dms[0].billingCity, result[0].city);
		System.assertEquals(dms[0].billingState, result[0].state);
		System.assertEquals(dms[0].billingPostalCode, result[0].zip);
	}
}