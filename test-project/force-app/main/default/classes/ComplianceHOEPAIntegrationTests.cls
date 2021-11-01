@isTest
public with sharing class ComplianceHOEPAIntegrationTests {
	private static final EB_Loan_Application__c loanApp;

	static{
		TestUtilities.createLoanAppStages();
		Id record_typeClientId = Utility.recordTypeObject('Account', 'Client').Id;
        EB_Unit__c branch = ObjectFactory.getUnit('testBranch', 4001);
        EB_Team_Member__c teamRM = ObjectFactory.getTeamMember('Team1');
        Account leadEntity  = ObjectFactory.getEntity('Test account 1', record_typeClientId, teamRM);
        leadEntity.EB_UnitID__r = branch;
        leadEntity.EB_UnitID__c = branch.Id;
        update leadEntity;
        Account requeryEntity = [SELECT  EB_UnitID__r.Name , EB_UnitID__c FROM Account WHERE id =:leadEntity.Id];
      
        EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Accouny','12345',requeryEntity);
	    EB_Loan_Packet__c packet = ObjectFactory.getLoanPacket(requeryEntity);     
	    loanApp = ObjectFactory.getLoanApplication(packet,null,'12345');
	}

	private static testMethod void ShowHOEPAFields_should_return_false_when_business_purpose_is_yes(){
		loanApp.Business_Purpose__c='Yes';
		loanApp.Loan_Type__c='Fixed Line';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Real Estate';
		testCollCode2.Category__c='Possessory';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT Id, ShowHOEPAFields__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('false',sut.ShowHOEPAFields__c);
	}

	private static testMethod void ShowHOEPAFields_should_return_false_when_there_is_no_real_estate_collateral(){
		loanApp.Business_Purpose__c='No';
		loanApp.Loan_Type__c='Fixed Line';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Not Real Estate';
		testCollCode2.Category__c='Not Real Estate';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT Id, ShowHOEPAFields__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('false',sut.ShowHOEPAFields__c);
	}

	private static testMethod void ShowHOEPAFields_should_return_true_when_business_purpose_is_no_and_hasREcollateral_is_one_and_loan_type_is_fixed_line(){
		loanApp.Business_Purpose__c='No';
		loanApp.Loan_Type__c='Fixed Line';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Real Estate';
		testCollCode2.Category__c='Possessory';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT Id, ShowHOEPAFields__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('true',sut.ShowHOEPAFields__c);
	}

	private static testMethod void ShowHOEPAFields_should_return_true_when_business_purpose_is_no_and_hasREcollateral_is_one_and_loan_type_is_home_equity_line(){
		loanApp.Business_Purpose__c='No';
		loanApp.Loan_Type__c='Home Equity Line';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Real Estate';
		testCollCode2.Category__c='Possessory';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT Id, ShowHOEPAFields__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('true',sut.ShowHOEPAFields__c);
	}

	private static testMethod void ShowHOEPAFields_should_return_true_when_business_purpose_is_no_and_hasREcollateral_is_one_and_loan_type_is_permanent_mortgage(){
		loanApp.Business_Purpose__c='No';
		loanApp.Loan_Type__c='Permanent Mortgage';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Real Estate';
		testCollCode2.Category__c='Possessory';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT Id, ShowHOEPAFields__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('true',sut.ShowHOEPAFields__c);
	}

	private static testMethod void ShowHOEPAFields_should_return_true_when_business_purpose_is_no_and_hasREcollateral_is_one_and_loan_type_is_revolving_line(){
		loanApp.Business_Purpose__c='No';
		loanApp.Loan_Type__c='Revolving Line';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Real Estate';
		testCollCode2.Category__c='Possessory';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT Id, ShowHOEPAFields__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('true',sut.ShowHOEPAFields__c);
	}

	private static testMethod void ShowHOEPAFields_should_return_true_when_business_purpose_is_no_and_hasREcollateral_is_one_and_loan_type_is_5_1_arm(){
		loanApp.Business_Purpose__c='No';
		loanApp.Loan_Type__c='5/1 ARM';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Real Estate';
		testCollCode2.Category__c='Possessory';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT Id, ShowHOEPAFields__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('true',sut.ShowHOEPAFields__c);
	}

	private static testMethod void ShowHOEPAFields_should_return_true_when_business_purpose_is_no_and_hasREcollateral_is_one_and_loan_type_is_Term(){
		loanApp.Business_Purpose__c='No';
		loanApp.Loan_Type__c='Term';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Real Estate';
		testCollCode2.Category__c='Possessory';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT Id, ShowHOEPAFields__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('true',sut.ShowHOEPAFields__c);
	}

	private static testMethod void ShowHOEPAFields_should_return_false_when_loan_type_is_not_HOEPA_friendly(){
		loanApp.Business_Purpose__c='No';
		loanApp.Loan_Type__c='Not a HOEPA friendly Type';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Real Estate';
		testCollCode2.Category__c='Real Estate';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT Id, ShowHOEPAFields__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('false',sut.ShowHOEPAFields__c);
	}

	private static testMethod void it_should_return_yes_for_isHOEPA_when_showhoepafields_is_true_and_hoepa_finance_purchase_or_construction_is_no()
	{
		loanApp.Business_Purpose__c='No';
		loanApp.Loan_Type__c='Term';
		loanApp.HOEPA_Finance_Purchase_Or_Construction__c = 'No';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Real Estate';
		testCollCode2.Category__c='Possessory';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT ShowHOEPAFields__c, Is_HOEPA__c, IsHOEPAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('true',sut.ShowHOEPAFields__c);
		System.assertEquals('Yes',sut.Is_HOEPA__c);
		System.assertEquals(true,sut.IsHOEPAAsDeterminedByTrigger__c);
	}

	private static testMethod void it_should_return_no_for_isHOEPA_when_showhoepafields_is_true_and_hoepa_finance_purchase_or_construction_is_yes(){

		loanApp.Business_Purpose__c='No';
		loanApp.Loan_Type__c='Term';
		loanApp.HOEPA_Finance_Purchase_Or_Construction__c = 'Yes';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Real Estate';
		testCollCode2.Category__c='Possessory';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT ShowHOEPAFields__c, Is_HOEPA__c, IsHOEPAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('true',sut.ShowHOEPAFields__c);
		System.assertEquals('No',sut.Is_HOEPA__c);
		System.assertEquals(false,sut.IsHOEPAAsDeterminedByTrigger__c);

	}

		private static testMethod void it_should_return_no_for_isHOEPA_when_showhoepafields_is_false_and_hoepa_finance_purchase_or_construction_is_no()
	{
		loanApp.Business_Purpose__c='No';
		loanApp.Loan_Type__c='Not HOEPA Friendly';
		loanApp.HOEPA_Finance_Purchase_Or_Construction__c = 'No';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Real Estate';
		testCollCode2.Category__c='Possessory';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT ShowHOEPAFields__c, Is_HOEPA__c, IsHOEPAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('false',sut.ShowHOEPAFields__c);
		System.assertEquals('No',sut.Is_HOEPA__c);
		System.assertEquals(false,sut.IsHOEPAAsDeterminedByTrigger__c);
	}

	private static testMethod void it_should_return_no_for_isHOEPA_when_showhoepafields_is_false_and_hoepa_finance_purchase_or_construction_is_yes(){

		loanApp.Business_Purpose__c='No';
		loanApp.Loan_Type__c='Not HOEPA Friendly';
		loanApp.HOEPA_Finance_Purchase_Or_Construction__c = 'Yes';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
		testCollCode1.Category__c='Real Estate';
		testCollCode2.Category__c='Possessory';
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT ShowHOEPAFields__c, Is_HOEPA__c, IsHOEPAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		system.assertEquals('false',sut.ShowHOEPAFields__c);
		System.assertEquals('No',sut.Is_HOEPA__c);
		System.assertEquals(false,sut.IsHOEPAAsDeterminedByTrigger__c);

	}
}