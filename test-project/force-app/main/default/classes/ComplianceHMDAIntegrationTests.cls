@isTest
public with sharing class ComplianceHMDAIntegrationTests {
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


	private static testMethod void it_should_not_be_HMDA_if_loan_type_is_Home_equity_line(){
		loanApp.Loan_Type__c = 'Home Equity Line';
		update loanApp;

		EB_Loan_Application__c sut =[SELECT IsHMDA__c, IsHMDAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		System.assertEquals('No',sut.IsHMDA__c);
		System.assertEquals(false,sut.IsHMDAAsDeterminedByTrigger__c);
	}

	private static testMethod void it_should_be_HMDA_if_loan_type_non_home_equity_line_and_use_of_funds_is_purchased_residential_real_estate_and_hasdwellingcollateral_is_one(){
		loanApp.Loan_Type__c = 'test loan type';
		loanApp.Use_of_Funds__c = 'Purchase Residential Real Estate';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Single Family Residential', '50');
		testCollCode1.IsHMDADwelling__c = true;	
		testCollCode2.IsHMDADwelling__c = false;
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT IsHMDA__c, IsHMDAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		System.assertEquals('Yes',sut.IsHMDA__c);
		System.assertEquals(true,sut.IsHMDAAsDeterminedByTrigger__c);		
	}

	private static testMethod void it_should_not_be_HMDA_if_loan_type_non_home_equity_line_and_use_of_funds_is_purchased_residential_real_estate_and_hasdwellingcollateral_is_zero(){
		loanApp.Loan_Type__c = 'test loan type';
		loanApp.Use_of_Funds__c = 'Purchase Residential Real Estate';
		update loanApp;
		Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
		Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Single Family Residential', '50');
		testCollCode1.IsHMDADwelling__c = false;	
		testCollCode2.IsHMDADwelling__c = false;
		update testCollCode1;
		update testCollCode2;
		EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
		EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
		Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
		ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
		ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);

		EB_Loan_Application__c sut =[SELECT IsHMDA__c, IsHMDAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		System.assertEquals('No',sut.IsHMDA__c);
		System.assertEquals(false,sut.IsHMDAAsDeterminedByTrigger__c);		
	}

	private static testMethod void it_should_be_HMDA_if_loan_type_not_home_equity_line_and_use_of_funds_is_refinance_residential_real_estate_and_refinance_type_is_payoff_of_existing_debt(){
		loanApp.Loan_Type__c = 'Not Home Equity Line';
		loanApp.Use_of_Funds__c = 'Refinance Residential Real Estate';
		loanApp.Refinance_Type__c = 'Payoff of Exsisting Debt by the same Borrower';
		update loanApp;
		
		EB_Loan_Application__c sut =[SELECT IsHMDA__c, IsHMDAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		System.assertEquals('Yes',sut.IsHMDA__c);
		System.assertEquals(true,sut.IsHMDAAsDeterminedByTrigger__c);		
	}

	private static testMethod void it_should_be_HMDA_if_loan_type_not_home_equity_line_and_use_of_funds_is_refinance_residential_real_estate_and_refinance_type_is_not_payoff_of_existing_debt(){
		loanApp.Loan_Type__c = 'Not Home Equity Line';
		loanApp.Use_of_Funds__c = 'Refinance Residential Real Estate';
		loanApp.Refinance_Type__c = 'Not Payoff of Exsisting Debt by the same Borrower';
		update loanApp;
		
		EB_Loan_Application__c sut =[SELECT IsHMDA__c, IsHMDAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		System.assertEquals('No',sut.IsHMDA__c);
		System.assertEquals(false,sut.IsHMDAAsDeterminedByTrigger__c);		
	}

	private static testMethod void it_should_be_HMDA_if_loan_type_not_home_equity_line_and_use_of_funds_is_home_improvement(){
		loanApp.Loan_Type__c = 'Not Home Equity Line';
		loanApp.Use_of_Funds__c = 'Home Improvement';
		update loanApp;
		
		EB_Loan_Application__c sut =[SELECT IsHMDA__c, IsHMDAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		System.assertEquals('Yes',sut.IsHMDA__c);
		System.assertEquals(true,sut.IsHMDAAsDeterminedByTrigger__c);		
	}

	private static testMethod void it_should_be_HMDA_if_loan_type_not_home_equity_line_and_use_of_funds_is_residential_rehab(){
		loanApp.Loan_Type__c = 'Not Home Equity Line';
		loanApp.Use_of_Funds__c = 'Residential Rehab';
		update loanApp;
		
		EB_Loan_Application__c sut =[SELECT IsHMDA__c, IsHMDAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		System.assertEquals('Yes',sut.IsHMDA__c);
		System.assertEquals(true,sut.IsHMDAAsDeterminedByTrigger__c);		
	}

	private static testMethod void it_should_not_be_HMDA_if_loan_type_is_not_home_equity_and_use_of_funds_is_not_HMDA_friendly()
	{
		loanApp.Loan_Type__c = 'Not Home Equity Line';
		loanApp.Use_of_Funds__c = 'Not HMDA Friendly Use of Funds';
		update loanApp;
		
		EB_Loan_Application__c sut =[SELECT IsHMDA__c, IsHMDAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

		System.assertEquals('No',sut.IsHMDA__c);
		System.assertEquals(false,sut.IsHMDAAsDeterminedByTrigger__c);		
	}


}