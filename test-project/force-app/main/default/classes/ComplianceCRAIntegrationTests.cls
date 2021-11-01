@isTest
public with sharing class ComplianceCRAIntegrationTests {
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


    static testMethod void is_agricultural_should_return_one_when_use_of_funds_is_set_to_agricultural_purpose(){
        loanApp.Use_of_Funds__c='Agricultural Purpose';
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsAgricultural__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(1,sut.IsAgricultural__c);
    }

    static testMethod void is_agricultural_should_return_zero_when_use_of_funds_is_set_to_agricultural_purpose(){
        loanApp.Use_of_Funds__c = 'Not Agricultural Purpose';
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsAgricultural__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(0,sut.IsAgricultural__c);
    }

    static testMethod void it_should_return_yes_when_business_purpose(){
        loanApp.Business_Purpose__c = 'Yes';
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, Business_Purpose__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals('Yes',sut.Business_Purpose__c);
    }

    static testMethod void it_should_return_No_when_not_business_purpose(){
        loanApp.Business_Purpose__c = 'No';
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, Business_Purpose__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals('No',sut.Business_Purpose__c);
    }

    static testMethod void it_should_have_a_value_of_one_for_IsLoanAmountOver500K_when_the_bank_owned_amount_is_greater_Than_five_hundread_thousand(){
        loanApp.Bank_Owned_Loan_Amount__c = 500001.00;
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsLoanAmountOver500K__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(1,sut.IsLoanAmountOver500K__c);
    }

    static testMethod void it_should_have_a_value_of_zero_for_IsLoanAmountOver500K_when_the_bank_owned_amount_is_less_Than_five_hundread_thousand(){
        loanApp.Bank_Owned_Loan_Amount__c = 490000.00;
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsLoanAmountOver500K__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(0,sut.IsLoanAmountOver500K__c);
    }

    static testMethod void it_should_have_a_value_of_one_for_IsOriginalLoanAmtOver500K_when_the_total_loan_amount_is_greater_Than_five_hundread_thousand(){
        loanApp.Bank_Owned_Loan_Amount__c = 500001.00;
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsOriginalLoanAmtOver500K__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(1,sut.IsOriginalLoanAmtOver500K__c);
    }

    static testMethod void it_should_have_a_value_of_zero_for_IsOriginalLoanAmtOver500K_when_the_total_loan_amount_is_not_greater_Than_five_hundread_thousand(){
        loanApp.Bank_Owned_Loan_Amount__c = 500000.00;
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsOriginalLoanAmtOver500K__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(0,sut.IsOriginalLoanAmtOver500K__c);
    }

    static testMethod void it_should_have_a_value_of_one_for_IsLoanAmountOver1M_when_the_bank_owned_amount_is_greater_than_one_million(){
        loanApp.Bank_Owned_Loan_Amount__c = 1000001.00;
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsLoanAmountOver1M__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(1,sut.IsLoanAmountOver1M__c);
    }

    static testMethod void it_should_have_a_value_of_zero_for_IsLoanAmountOver1M_when_the_bank_owned_amount_is_not_greater_than_one_million(){
        loanApp.Bank_Owned_Loan_Amount__c = 999999.00;
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsLoanAmountOver1M__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(0,sut.IsLoanAmountOver1M__c);
    }

    static testMethod void it_should_have_a_value_of_one_for_IsLetterOfCredit_when_the_Loan_Type_is_Letter_of_Credit(){
        loanApp.Loan_Type__c = 'Letter of Credit';
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsLetterOfCredit__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(1,sut.IsLetterOfCredit__c);
    }

    static testMethod void it_should_have_a_value_of_zero_for_IsLetterOfCredit_when_the_Loan_Type_is_not_Letter_of_Credit(){
        loanApp.Loan_Type__c = 'Not Letter of Credit';
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsLetterOfCredit__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(0,sut.IsLetterOfCredit__c);
    }

    static testMethod void it_should_have_a_value_of_one_for_IsConstructionLandanddevelopement_when_the_use_of_fund_is_construction_land_and_development(){
        loanApp.Use_of_Funds__c = 'Construction / Land Development';
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsConstructionLandDevelopment__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(1,sut.IsConstructionLandDevelopment__c);
    }

    static testMethod void it_should_have_a_value_of_zero_for_IsConstructionLandanddevelopement_when_the_use_of_fund_is_not_construction_land_and_development(){
        loanApp.Use_of_Funds__c = '';
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsConstructionLandDevelopment__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(0,sut.IsConstructionLandDevelopment__c);
    }

    static testMethod void it_should_have_a_value_of_one_for_IsPurposeOfLoanToBuySecurities_when_the_use_of_fund_is_buy_or_carry_securities(){
        loanApp.Use_of_Funds__c = 'Buy or Carry Securities';
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsPurposeOfLoanToBuySecurities__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(1,sut.IsPurposeOfLoanToBuySecurities__c);
    }

    static testMethod void it_should_have_a_value_of_zero_for_IsPurposeOfLoanToBuySecurities_when_the_use_of_fund_is_not_buy_or_carry_securities(){
        loanApp.Use_of_Funds__c = 'Other';
        update loanApp;

        EB_Loan_Application__c sut =[SELECT Id, IsPurposeOfLoanToBuySecurities__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(0,sut.IsPurposeOfLoanToBuySecurities__c);
    }

    static testMethod void it_should_have_a_value_of_one_for_HasDwellingCollateral_when_any_of_the_related_Collateral_have_an_isDwelling_of_one() {
        Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Home Equity Line', '70');
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
    
        EB_Loan_Application__c sut =[SELECT Id, HasDwellingCollateral__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(1,sut.HasDwellingCollateral__c);
    }

    static testMethod void it_should_have_a_value_of_zero_for_HasDwellingCollateral_when_none_of_the_related_Collateral_have_an_isDwelling_of_one() {
        Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Home Equity Line', '70');
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
    
        EB_Loan_Application__c sut =[SELECT Id, HasDwellingCollateral__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(0,sut.HasDwellingCollateral__c);
    }

    static testMethod void is_should_have_a_value_of_one_for_HasRealEstateCollateral_when_any_of_related_collateral_is_real_estate(){
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
        
        EB_Loan_Application__c sut =[SELECT Id, HasRealEstateCollateral__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(1,sut.HasRealEstateCollateral__c);
    }

    static testMethod void is_should_have_a_value_of_zero_for_HasRealEstateCollateral_when_none_of_related_collateral_is_real_estate(){
        Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Stocks and Bonds (Marketable)', '75');
        Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Coins/Other Currency', 'CU');
        testCollCode1.Category__c='Possessory';
        testCollCode2.Category__c='Possessory';
        update testCollCode1;
        update testCollCode2;
        EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
        EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
        Id recordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
        ObjectFactory.relateCollateralToLoanApp(testCollateral1, loanApp, recordTypeId);
        ObjectFactory.relateCollateralToLoanApp(testCollateral2, loanApp, recordTypeId);
        
        EB_Loan_Application__c sut =[SELECT Id, HasRealEstateCollateral__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(0,sut.HasRealEstateCollateral__c);
    }

    static testMethod void is_should_have_a_value_of_one_for_HasPurchasedParticipation_when_at_least_one_of_related_loan_participation_is_type_bought(){
        Id boughtRecordTypeId = Utility.recordTypeObject('EB_Loan_Participation__c', 'Bought').Id;
        EB_Loan_Participation__c partic1 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
        EB_Loan_Participation__c partic2 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
        insert partic1;
        insert partic2;

        EB_Loan_Application__c sut =[SELECT Id, HasPurchasedParticipation__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(1,sut.HasPurchasedParticipation__c);
    }

    static testMethod void is_should_have_a_value_of_zero_for_HasPurchasedParticipation_when_none_of_related_loan_participation_is_type_bought(){
        Id soldRecordTypeId = Utility.recordTypeObject('EB_Loan_Participation__c', 'Sold').Id;
        EB_Loan_Participation__c partic1 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = soldRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
        EB_Loan_Participation__c partic2 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = soldRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
        insert partic1;
        insert partic2;

        EB_Loan_Application__c sut =[SELECT Id, HasPurchasedParticipation__c FROM EB_Loan_Application__c WHERE Id=:loanApp.Id];

        System.assertEquals(0,sut.HasPurchasedParticipation__c);
    }

    static testMethod void it_should_have_a_value_of_one_for_hasnoncommercialrealestatecollateral_when_at_least_one_of_the_loan_app_collateral_relationships_has_a_isnoncommercialestate_as_one()
    {
        Id allRecordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
        Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
        testCollCode1.Category__c='Real Estate';
        testCollCode1.CRA_Real_Estate_Details__c = 'Non-Commercial';
        Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('test code', '700');
        testCollCode2.Category__c='test';
        testCollCode2.CRA_Real_Estate_Details__c = 'test 2';
        update testCollCode1;
        update testCollCode2;
        EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
        EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
        EB_Loan_App_Collateral_Relationship__c testCollateralRel1 = new EB_Loan_App_Collateral_Relationship__c(EB_Loan_Application_ID__c = loanApp.Id,EB_Collateral_ID__c = testCollateral1.Id , Purpose_Of_Collateral__c = 'Primary');
        EB_Loan_App_Collateral_Relationship__c testCollateralRel2 = new EB_Loan_App_Collateral_Relationship__c(EB_Loan_Application_ID__c = loanApp.Id,EB_Collateral_ID__c = testCollateral2.Id , Purpose_Of_Collateral__c = 'Additional');
        insert testCollateralRel1;
        insert testCollateralRel2;

        EB_Loan_Application__c sut = [SELECT Id, HasNonCommercialRealEstateCollateral__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals(1,sut.HasNonCommercialRealEstateCollateral__c);
    }   
    
    static testMethod void it_should_have_a_value_of_zero_for_hasnoncommercialrealestatecollateral_when_none_of_the_loan_app_collateral_relationships_has_a_isnoncommercialestate_as_one()
    {
        Id allRecordTypeId = Utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;
        Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('test code 1', '900');
        testCollCode1.Category__c='test 1';
        Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('test code 2', '700');
        testCollCode2.Category__c='test 2';
        testCollCode2.CRA_Real_Estate_Details__c = 'test 2';
        update testCollCode1;
        update testCollCode2;
        EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
        EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
        EB_Loan_App_Collateral_Relationship__c testCollateralRel1 = new EB_Loan_App_Collateral_Relationship__c(EB_Loan_Application_ID__c = loanApp.Id,EB_Collateral_ID__c = testCollateral1.Id, Purpose_Of_Collateral__c = 'Primary');
        EB_Loan_App_Collateral_Relationship__c testCollateralRel2 = new EB_Loan_App_Collateral_Relationship__c(EB_Loan_Application_ID__c = loanApp.Id,EB_Collateral_ID__c = testCollateral2.Id, Purpose_Of_Collateral__c = 'Additional');
        insert testCollateralRel1;
        insert testCollateralRel2;

        EB_Loan_Application__c sut = [SELECT HasNonCommercialRealEstateCollateral__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals(0,sut.HasNonCommercialRealEstateCollateral__c);
    }

    static testMethod void it_should_not_be_CRA_Eligible_when_Use_of_Funds_is_Agricultural_Purpose_and_Loan_Amount_over_500k(){
        loanApp.Use_of_Funds__c = 'Agricultural Purpose';
        loanApp.Bank_Owned_Loan_Amount__c = 500001.00;
        update loanApp;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('No',sut.IsCRA__c);
        System.assertEquals(false,sut.IsCRAAsDeterminedByTrigger__c);
    }

    static testMethod void it_should_be_CRA_Eligible_when_Use_of_Funds_is_Agricultural_Purpose_and_Loan_Amount_less_500k_and_has_not_purchased_participation(){
        loanApp.Use_of_Funds__c = 'Agricultural Purpose';
        loanApp.Bank_Owned_Loan_Amount__c = 400000.00;
        update loanApp;
        Id soldRecordTypeId = Utility.recordTypeObject('EB_Loan_Participation__c', 'Sold').Id;
        EB_Loan_Participation__c partic1 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = soldRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
        EB_Loan_Participation__c partic2 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = soldRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
        insert partic1;
        insert partic2;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('Yes',sut.IsCRA__c);
        System.assertEquals(true,sut.IsCRAAsDeterminedByTrigger__c);
    }

    static testMethod void it_should_not_be_CRA_Eligible_when_Use_of_Funds_is_Ag_Purpose_and_Loan_Amt_less_500k_and_has_purchased_participation_and_has_total_ln_amt_greater_than_500k(){
        loanApp.Use_of_Funds__c = 'Agricultural Purpose';
        loanApp.Bank_Owned_Loan_Amount__c = 400000.00;
        update loanApp;
        Id boughtRecordTypeId = Utility.recordTypeObject('EB_Loan_Participation__c', 'Bought').Id;
        EB_Loan_Participation__c partic1 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 100001);
        EB_Loan_Participation__c partic2 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 1);
        insert partic1;
        insert partic2;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('No',sut.IsCRA__c);
        System.assertEquals(false,sut.IsCRAAsDeterminedByTrigger__c);
    }

    static testMethod void it_should_be_CRA_Eligible_when_Use_of_Funds_is_Ag_Purpose_and_Loan_Amt_less_500k_and_has_purchased_participation_and_has_total_ln_amt_less_than_500k(){
        loanApp.Use_of_Funds__c = 'Agricultural Purpose';
        loanApp.Bank_Owned_Loan_Amount__c = 400000.00;
        update loanApp;
        Id boughtRecordTypeId = Utility.recordTypeObject('EB_Loan_Participation__c', 'Bought').Id;
        EB_Loan_Participation__c partic1 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 90000);
        EB_Loan_Participation__c partic2 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 10);
        insert partic1;
        insert partic2;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('Yes',sut.IsCRA__c);
        System.assertEquals(true,sut.IsCRAAsDeterminedByTrigger__c);
    }

    static testMethod void it_should_not_be_CRA_Eligible_when_Use_of_Funds_is_not_Agricultural_Purpose_and_is_not_Business_Purpose(){
        loanApp.Use_of_Funds__c = 'Not Agricultural Purpose';
        loanApp.Business_Purpose__c = 'No';
        update loanApp;

        EB_Loan_Application__c sut = [SELECT IsCRA__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('No',sut.IsCRA__c);
    }

    static testMethod void it_should_not_be_CRA_Eligible_when_Use_of_Funds_is_not_Agricultural_Purpose_and_is_Business_Purpose_and_loan_amount_over_1M(){
        loanApp.Use_of_Funds__c = 'Not Agricultural Purpose';
        loanApp.Business_Purpose__c ='Yes';
        loanApp.Bank_Owned_Loan_Amount__c = 1000001.00;
        update loanApp;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('No',sut.IsCRA__c);
        System.assertEquals(false,sut.IsCRAAsDeterminedByTrigger__c);
    }

    static testMethod void it_should_not_be_CRA_Eligible_when_Use_of_Funds_is_not_Ag_Purpose_and_it_is_Business_Purpose_and_loan_amount_not_over_1M_and_has_purch_partic_and_orig_ln_amt_is_over_1M(){
        loanApp.Use_of_Funds__c = 'Not Agricultural Purpose';
        loanApp.Business_Purpose__c ='Yes';
        loanApp.Bank_Owned_Loan_Amount__c = 900000.00;
        update loanApp;
        Id boughtRecordTypeId = Utility.recordTypeObject('EB_Loan_Participation__c', 'Bought').Id;
        EB_Loan_Participation__c partic1 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 100000);
        EB_Loan_Participation__c partic2 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 100000);
        insert partic1;
        insert partic2;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('No',sut.IsCRA__c);
        System.assertEquals(false,sut.IsCRAAsDeterminedByTrigger__c);
    }

    static testMethod void it_should_not_be_CRA_Eligible_when_Use_of_Funds_is_not_Ag_Purpose_and_it_is_Business_Purpose_and_loan_amount_not_over_1M_and_has_purch_partic_and_orig_ln_amt_is_under_1M_and_has_a_letter_of_credit(){
        loanApp.Use_of_Funds__c = 'Not Agricultural Purpose';
        loanApp.Business_Purpose__c ='Yes';
        loanApp.Bank_Owned_Loan_Amount__c = 700000.00;
        LoanApp.Loan_Type__c = 'Letter Of Credit';
        update loanApp;
        Id boughtRecordTypeId = Utility.recordTypeObject('EB_Loan_Participation__c', 'Bought').Id;
        EB_Loan_Participation__c partic1 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 100000);
        EB_Loan_Participation__c partic2 = new EB_Loan_Participation__c(Loan_Application_ID__c = loanApp.Id, RecordTypeId = boughtRecordTypeId, Participating_Institution__c = 'inst', Participated_Amount__c = 100000);
        insert partic1;
        insert partic2;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('No',sut.IsCRA__c);
        System.assertEquals(false,sut.IsCRAAsDeterminedByTrigger__c);
    }

    static testMethod void it_should_not_be_CRA_Eligible_when_Use_of_Funds_is_not_Ag_Purpose_and_it_is_Business_Purpose_and_loan_amount_not_over_1M_and_has_no_purch_partic_and_has_a_letter_of_credit(){
        loanApp.Use_of_Funds__c = 'Not Agricultural Purpose';
        loanApp.Business_Purpose__c ='Yes';
        loanApp.Bank_Owned_Loan_Amount__c = 700000.00;
        LoanApp.Loan_Type__c = 'Letter Of Credit';
        update loanApp;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('No',sut.IsCRA__c);
        System.assertEquals(false,sut.IsCRAAsDeterminedByTrigger__c);
    }

    static testMethod void it_should_not_be_CRA_Eligible_when_Use_of_Funds_is_not_Ag_Purpose_and_it_is_Business_Purpose_and_loan_amount_not_over_1M_and_has_no_purch_partic_and_no_loc_and_does_not_have_rel_estate_coll_and_purp_of_loan_is_to_buy_sec(){
        loanApp.Business_Purpose__c ='Yes';
        loanApp.Bank_Owned_Loan_Amount__c = 700000.00;
        LoanApp.Loan_Type__c = 'Not Letter Of Credit';
        loanApp.Use_of_Funds__c = 'Buy or Carry Securities';
        update loanApp;
        Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('test code', '700');
        testCollCode1.Category__c='test';
        testCollCode1.CRA_Real_Estate_Details__c = 'Commercial';
        update testCollCode1;
        EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
        EB_Loan_App_Collateral_Relationship__c testCollateralRel1 = new EB_Loan_App_Collateral_Relationship__c(EB_Loan_Application_ID__c = loanApp.Id,EB_Collateral_ID__c = testCollateral1.Id , Purpose_Of_Collateral__c = 'Primary');
        insert testCollateralRel1;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('No',sut.IsCRA__c);
        System.assertEquals(false,sut.IsCRAAsDeterminedByTrigger__c);
    }

    static testMethod void it_should_be_CRA_Eligible_when_Use_of_Funds_is_not_Ag_Purpose_and_it_is_Business_Purpose_and_loan_amount_not_over_1M_and_has_no_purch_partic_and_no_loc_and_does_not_have_rel_estate_coll_and_purp_of_loan_is_Not_to_buy_sec(){
        loanApp.Business_Purpose__c ='Yes';
        loanApp.Bank_Owned_Loan_Amount__c = 700000.00;
        LoanApp.Loan_Type__c = 'Not Letter Of Credit';
        loanApp.Use_of_Funds__c = 'Not Buy or Carry Securities';
        update loanApp;
        Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('test code', '700');
        testCollCode1.Category__c='test';
        testCollCode1.CRA_Real_Estate_Details__c = 'Commercial';
        update testCollCode1;
        EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
        EB_Loan_App_Collateral_Relationship__c testCollateralRel1 = new EB_Loan_App_Collateral_Relationship__c(EB_Loan_Application_ID__c = loanApp.Id,EB_Collateral_ID__c = testCollateral1.Id , Purpose_Of_Collateral__c = 'Primary');
        insert testCollateralRel1;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('Yes',sut.IsCRA__c);
        System.assertEquals(true,sut.IsCRAAsDeterminedByTrigger__c);
    }

    static testMethod void it_should_not_be_CRA_Eligible_when_Use_of_Funds_is_not_Ag_Purpose_and_it_is_Business_Purpose_and_loan_amount_not_over_1M_and_has_no_purch_partic_and_no_loc_and_has_rel_estate_coll_and_isconstruction(){
        loanApp.Use_of_Funds__c = 'Construction / Land Development';
        loanApp.Business_Purpose__c ='Yes';
        loanApp.Bank_Owned_Loan_Amount__c = 700000.00;
        LoanApp.Loan_Type__c = 'Not Letter Of Credit';
        update loanApp;
        Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
        testCollCode1.Category__c='Real Estate';
        testCollCode1.CRA_Real_Estate_Details__c = 'Non-Commercial';
        update testCollCode1;
        EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
        EB_Loan_App_Collateral_Relationship__c testCollateralRel1 = new EB_Loan_App_Collateral_Relationship__c(EB_Loan_Application_ID__c = loanApp.Id,EB_Collateral_ID__c = testCollateral1.Id , Purpose_Of_Collateral__c = 'Primary');
        insert testCollateralRel1;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('No',sut.IsCRA__c);
        System.assertEquals(false,sut.IsCRAAsDeterminedByTrigger__c);
    }

    static testMethod void it_should_be_CRA_Eligible_when_Use_of_Funds_is_not_Ag_Purpose_and_it_is_Business_Purpose_and_loan_amount_not_over_1M_and_has_no_purch_partic_and_no_loc_and_has_rel_estate_coll_and_isNot_construction_and_all_RE_isCommercial(){
        loanApp.Use_of_Funds__c = 'Working Capital';
        loanApp.Business_Purpose__c ='Yes';
        loanApp.Bank_Owned_Loan_Amount__c = 700000.00;
        LoanApp.Loan_Type__c = 'Not Letter Of Credit';
        update loanApp;
        Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
        testCollCode1.Category__c='Real Estate';
        testCollCode1.CRA_Real_Estate_Details__c = 'Commercial';
        update testCollCode1;
        EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
        EB_Loan_App_Collateral_Relationship__c testCollateralRel1 = new EB_Loan_App_Collateral_Relationship__c(EB_Loan_Application_ID__c = loanApp.Id,EB_Collateral_ID__c = testCollateral1.Id , Purpose_Of_Collateral__c = 'Primary');
        insert testCollateralRel1;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('Yes',sut.IsCRA__c);
        System.assertEquals(true,sut.IsCRAAsDeterminedByTrigger__c);
    }

    static testMethod void it_should_be_CRA_Eligible_when_Use_of_Funds_is_not_Ag_Purpose_and_it_is_Business_Purpose_and_loan_amount_not_over_1M_and_has_no_purch_partic_and_no_loc_and_has_rel_estate_coll_and_isNot_construction_and_not_all_RE_isCommercial(){
        loanApp.Use_of_Funds__c = 'Working Capital';
        loanApp.Business_Purpose__c ='Yes';
        loanApp.Bank_Owned_Loan_Amount__c = 700000.00;
        LoanApp.Loan_Type__c = 'Not Letter Of Credit';
        update loanApp;
        Collateral_Code__c testCollCode1 = ObjectFactory.getCollateralCode('Res - Single Family Home (investment)', '70');
        testCollCode1.Category__c='Real Estate';
        testCollCode1.CRA_Real_Estate_Details__c = 'Non-Commercial';
        Collateral_Code__c testCollCode2 = ObjectFactory.getCollateralCode('Hotels/Motels', '50');
        testCollCode2.Category__c='Real Estate';
        testCollCode2.CRA_Real_Estate_Details__c = 'Commercial';
        update testCollCode1;
        update testCollCode2;
        EB_Collateral__c testCollateral1 = ObjectFactory.getCollateral('Test Coll 1',testCollCode1,false);
        EB_Collateral__c testCollateral2 = ObjectFactory.getCollateral('Test Coll 2',testCollCode2,false);
        EB_Loan_App_Collateral_Relationship__c testCollateralRel1 = new EB_Loan_App_Collateral_Relationship__c(EB_Loan_Application_ID__c = loanApp.Id,EB_Collateral_ID__c = testCollateral1.Id , Purpose_Of_Collateral__c = 'Primary');
        EB_Loan_App_Collateral_Relationship__c testCollateralRel2 = new EB_Loan_App_Collateral_Relationship__c(EB_Loan_Application_ID__c = loanApp.Id,EB_Collateral_ID__c = testCollateral2.Id , Purpose_Of_Collateral__c = 'Additional');
        insert testCollateralRel1;
        insert testCollateralRel2;

        EB_Loan_Application__c sut = [SELECT IsCRA__c, IsCRAAsDeterminedByTrigger__c FROM EB_Loan_Application__c WHERE Id=: loanApp.Id];

        System.assertEquals('No',sut.IsCRA__c);
        System.assertEquals(false,sut.IsCRAAsDeterminedByTrigger__c);
    }

}