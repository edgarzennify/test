@IsTest
private class TmValidatorDmBuilderTests {
	
    private static TmValidatorDmBuilder sut;
    
    static {
        sut = new TmValidatorDmBuilder();
    }
    
    private static testMethod void it_should_build_dms_when_pms_are_provided() {
        
        Id parentRuleId = ObjectFactory.getFakeId(TM_Service_request_Validation_Rule__c.SObjectType, '1');
    	Id childRuleId = ObjectFactory.getFakeId(TM_Service_request_Validation_Rule__c.SObjectType, '2');
    	TM_Service_Request_Validation_Rule__c pmParentRule = new TM_Service_Request_Validation_Rule__c();
        pmParentRule.Id = parentRuleId;
        pmParentRule.Error_Text__c = 'Error on required field';
        pmParentRule.Operation__c = '>';
        pmParentRule.Operand__c = '3.0';

        TM_Service_Request_Validation_Rule__c pmChildRule = new TM_Service_Request_Validation_Rule__c();
        pmChildRule.Id = childRuleId;
        pmChildRule.Error_Text__c = 'Error on required field';
        pmChildRule.Operation__c = '=';
        pmChildRule.Operand__c = '0.0';
        
        TmValidator.ValidationContainerPm pm1 = new TmValidator.ValidationContainerPm();
        
        TM_Service_Request_Validation_Container__c cnt1 = new TM_Service_Request_Validation_Container__c();
        TM_Service_Request_Validation_Container__c cnt2 = new TM_Service_Request_Validation_Container__c();
        TmValidator.ValidationDefinationPm defPm1 = new TmValidator.ValidationDefinationPm();
        defPm1.RuleDefinition = new TM_Validation_Rule_Definition__c();
        defPm1.RuleArtifacts = new List<TM_Service_Request_Validation_Rule__c>{pmParentRule};
        TmValidator.ValidationDefinationPm defPm2 = new TmValidator.ValidationDefinationPm();
        defPm2.RuleDefinition = new TM_Validation_Rule_Definition__c();
        defPm2.RuleArtifacts = new List<TM_Service_Request_Validation_Rule__c>{pmChildRule};
        pm1.Container = cnt1;
        pm1.Rules = new List<TmValidator.ValidationDefinationPm>{defPm1};
            
        TmValidator.ValidationContainerPm pm2 = new TmValidator.ValidationContainerPm();
        pm2.Container = cnt2;
        pm2.Rules = new List<TmValidator.ValidationDefinationPm>{defPm2};
        List<TmValidator.ValidationContainerPm> pms = new List<TmValidator.ValidationContainerPm>{pm1, pm2};
        
        List<DmTmRule> result = sut.build(pms);
        
        //System.assertEquals(2, result.size());

    }
}