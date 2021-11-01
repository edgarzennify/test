@IsTest
public class EbCollateralTriggerHelperTests {
	public static testMethod void verifyValidationForRelatedCollaterals(){
		TestUtilities.createLoanAppStages();
	 	EB_Appraisal_County__c county = objectfactory.getEbAppraisalCounty('county');
	 	Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '9980' );
        EB_Collateral__c col = objectfactory.getCollateral('test', CollateralCode, true);
        col.Future_Advance_Amount__c = 1;
        col.Future_Advance_Amount__c = 1;
        col.Street__c = '111 street';
        col.City__c = 'saint louis';
        col.State__c ='MO';
        col.Zip_Code__c = '22323';
        col.Lien_Position__c = 'NA';
        col.Valuation_Type__c = 'NA';
        col.Survey_Required_Picklist__c = 'NA';
        col.EB_Appraisal_County__c = county.id;
        update col;
        System.debug('#################' + 'START: ' + 'verifyValidationForRelatedEntities()');
        EB_Unit__c branch = ObjectFactory.getUnit('testBranch', 4001);
        EB_Team_Member__c teamRM = ObjectFactory.getTeamMember('Team1');
        Id ClientRecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
        
        //Parent insert
        Account leadEntity  = ObjectFactory.getEntity('Test account 1', ClientRecordTypeId, teamRM);
        leadEntity.EB_UnitId__c = branch.Id;
        
        leadEntity.OFAC_Verified__c = 'No';
        leadentity.State_Of_Incorporation__c = 'MO';
        leadentity.Net_Worth__c = 1;
        leadentity.Liquid_Assets__c = 2;
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        leadentity.Last_Financial_Statement__c = d;
        leadentity.Tax_Returns__c = 'Yes';
        leadentity.Annual_Financial_Statements__c = 'No';
        leadentity.Interim_Statements__c = 'Monthly';
        
        leadentity.BillingStreet = '1647 Sauget Business st';
        leadentity.BillingCity = 'Sauget';
        leadentity.BillingStreet = '111 street';
        leadentity.BillingState = 'MO';
        leadentity.BillingPostalCode = '60000';
        leadentity.Phone = '6183371700';
        leadentity.SSNTIN_Encrypted__c = '000000000';
        leadentity.SSN_TIN_Has_Value__c = true;
        leadentity.Reg_O_Qualifications__c = 'Not Applicable';
        update leadEntity;
        Account testAccount = [SELECT SSN_TIN_Has_Value__c FROM Account WHERE id =:leadentity.id limit 1];
        system.debug('#################SSN' + leadentity.SSN_TIN_Has_Value__c);
        EB_Account__c ebAccount = ObjectFactory.getEBAccount('Test Accouny','12345',leadEntity);
        EB_Loan_Packet__c packet = ObjectFactory.getLoanPacket(leadEntity);
        //EB_Loan_Application__c loanApp = ObjectFactory.getLoanApplication(packet,null,'12345');
        
        //EB_Loan_App_Collateral_Relationship__c rel = ObjectFactory.relateCollateralToLoanAppObj(col, loanApp, recordTypeId);
        Id recordTypeId = utility.recordTypeObject('EB_Loan_App_Collateral_Relationship__c', 'All').Id;//objectfactory.getRecordTypeIdByNameAndObject('All', 'EB_Loan_App_Collateral_Relationship__c'); 
        EB_Loan_App_Collateral_Relationship__c lastRel = new EB_Loan_App_Collateral_Relationship__c();
        List<EB_Loan_App_Collateral_Relationship__c>relList = new List<EB_Loan_App_Collateral_Relationship__c>();
        Map<Id,EB_Loan_App_Collateral_Relationship__c>relMap = new Map<Id,EB_Loan_App_Collateral_Relationship__c>();
        for(integer i = 0;i<4;i++){
             EB_Loan_Application__c loanApp = ObjectFactory.getLoanApplication(packet,null,'12345' + String.valueOf(i));
             EB_Loan_App_Collateral_Relationship__c rel = Objectfactory.relateCollateralToLoanAppObj(col, loanApp, recordTypeId);
             rel.IsRealEstate__c = 1;
             rel.Requires_Centralized_Disbursing__c = 'NA';
             relList.add(rel);
             relMap.put(rel.Id,rel);
             //EB_Loan_App_Collateral_Relationship__c testrel = [select id,Missing_Required_Fields_For_Approval__c,Missing_Required_Fields_For_Doc__c, Stage_Validation__c FROM EB_Loan_App_Collateral_Relationship__c WHERE id =:rel.id limit 1 ];                          
             lastRel = rel;//testrel;
        }
        update relList;
       
        
       
        
        List<EB_Loan_App_Collateral_Relationship__c>testRelList=[select id,Missing_Required_Fields_For_Approval__c,Missing_Required_Fields_For_Doc__c,Stage_Validation__c FROM EB_Loan_App_Collateral_Relationship__c WHERE id in: relMap.keyset() limit 2];
        System.assertEquals(2,testRelList.size());
        EB_Loan_App_Collateral_Relationship__c testrel11 = testRelList[0];//[select id,Missing_Required_Fields_For_Approval__c,Missing_Required_Fields_For_Doc__c FROM EB_Loan_App_Collateral_Relationship__c WHERE id =:lastRel.id limit 1 ];
        EB_Loan_App_Collateral_Relationship__c testrel12 = testRelList[1];//[select id,Missing_Required_Fields_For_Doc__c,Missing_Required_Fields_For_Approval__c,Stage_Validation__c FROM EB_Loan_App_Collateral_Relationship__c WHERE id =:lastRel.id limit 1 ];
        
        //Assert 1
        System.assertNotEquals('',testrel11.Stage_Validation__c);
        //col.State__c = 'MO';
        //update col;
        
        //Assert 2
        System.assertEquals(testrel12.Stage_Validation__c, null); //formula evaluates '' as null
        
        System.debug('#################' + testrel11.Missing_Required_Fields_For_Approval__c);
        System.debug('#################' + testrel11.Missing_Required_Fields_For_Doc__c);  
        System.debug('#################' + testrel12.Stage_Validation__c);
        System.debug('#################' + 'END: ' + 'verifyValidationForRelatedEntities()');  
        
	 }
}