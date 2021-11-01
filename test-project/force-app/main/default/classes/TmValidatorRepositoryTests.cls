@IsTest
private class TmValidatorRepositoryTests {

    private static final TmValidatorRepository sut;
    private static final TmValidatorMock.ofIDataProvider m_mockDataProvider;
    private static final TmValidatorMock.ofIDmBuilder m_mockDmBuilder;

    static {
        m_mockDataProvider = new TmValidatorMock.ofIDataProvider();
        m_mockDmBuilder = new TmValidatorMock.ofIDmBuilder();
        sut = new TmValidatorRepository(m_mockDataProvider, m_mockDmBuilder);
    } 
    
    private static testmethod void it_should_get_rules() {
        Id stageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        string product = 'Online';
        string objectName = 'tmobject';
        string fieldName = 'field-name';

        TM_Service_Request_Validation_Container__c container = new TM_Service_Request_Validation_Container__c();

        List<TM_Service_Request_Validation_Rule__c> rules = new List<TM_Service_Request_Validation_Rule__c>();

        TmValidator.ValidationContainerPm containerPm = new TmValidator.ValidationContainerPm();
        List<TmValidator.ValidationContainerPm> containerPms = new List<TmValidator.ValidationContainerPm>{containerPm};

        String key = String.Format('{0}-{1}-{2}', new List<String>{objectName, stageId, product });

        DmTmRule ruleDm = new DmTmRule();
        ruleDm.objectName = objectName;
        ruleDm.fieldName = fieldName;
        ruleDm.stageId = stageId;
        ruleDm.product = product;
        List<DmTmRule> dms = new List<DmTmRule>{ruleDm};
        m_mockDataProvider.setup('getValidationRules').returns(containerPms);
        m_mockDmBuilder.setup('build', new List<object>{containerPms}).returns(dms);

        Map<String,List<String>> results = sut.getRules();
        
        System.assertEquals(1, results.keySet().size());
        List<string> keys = new List<String>();
        keys.addAll(results.keySet());
        System.assertEquals(key, keys[0]);
    }
    
    
    private static testMethod void it_should_get_rules_by_object_and_stage() {
        string objectName = 'TM_Service_Request__c';
        string product = 'Online Banking';
        string field1 = 'ACH_Credit__c';
        string field2 = 'ACH_Daily_Limit__c';
        Id stage1 = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        Id stage2 = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '2');
        TmValidator.ValidationContainerPm containerPm1 = new TmValidator.ValidationContainerPm();
        TmValidator.ValidationContainerPm containerPm2 = new TmValidator.ValidationContainerPm();
        List<TmValidator.ValidationContainerPm> containerPms = new List<TmValidator.ValidationContainerPm>{containerPm1, containerPm2};

        DmTmRule ruleDm1 = new DmTmRule();
        ruleDm1.ObjectName = objectName;
        ruleDm1.FieldName = field1;
        ruleDm1.stageId = stage1;
        ruleDm1.product = product;
        DmTmRule ruleDm2 = new DmTmRule();
        ruleDm2.ObjectName = objectName;
        ruleDm2.FieldName = field2;
        ruleDm2.stageId = stage2;
        ruleDm2.product = product;

        List<DmTmRule> ruleDms = new List<DmTmRule>{ruleDm1, ruleDm2};
        m_mockDataProvider.setup('GetValidationRules').returns(containerPms);
        m_mockDmBuilder.setup('build', new List<Object>{containerPms}).returns(ruleDms);

        Map<string, Map<string, List<DmTmRule>>> result = sut.getRuleForObjectAndStage(objectName, product);

        system.assertEquals(2 , result.keyset().size());
        system.assertEquals(field1, result.get(stage1).get(field1.tolowercase())[0].FieldName);
        system.assertEquals(field2, result.get(stage2).get(field2.tolowercase())[0].FieldName);
    }

    private static testMethod void it_should_get_rules_by_object_and_stage_and_product(){
        string objectName = 'TM_Service_Request__c';
        string product = 'Online Banking';
        string field1 = 'ACH_Credit__c';
        string field2 = 'ACH_Daily_Limit__c';
        Id stage1 = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '1');
        Id stage2 = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SObjectType, '2');
        TmValidator.ValidationContainerPm containerPm1 = new TmValidator.ValidationContainerPm();
        TmValidator.ValidationContainerPm containerPm2 = new TmValidator.ValidationContainerPm();
        List<TmValidator.ValidationContainerPm> containerPms = new List<TmValidator.ValidationContainerPm>{containerPm1, containerPm2};

        DmTmRule ruleDm1 = new DmTmRule();
        ruleDm1.ObjectName = objectName;
        ruleDm1.FieldName = field1;
        ruleDm1.stageId = stage1;
        ruleDm1.product = product;
        DmTmRule ruleDm2 = new DmTmRule();
        ruleDm2.ObjectName = objectName;
        ruleDm2.FieldName = field2;
        ruleDm2.stageId = stage2;
        ruleDm2.product = product;

        List<DmTmRule> ruleDms = new List<DmTmRule>{ruleDm1, ruleDm2};
        m_mockDataProvider.setup('GetValidationRules').returns(containerPms);
        m_mockDmBuilder.setup('build', new List<Object>{containerPms}).returns(ruleDms);
        List<string> products = new List<string>{product, 'lockbox'};

        Map<string, Map<string, Map<string, List<DmTmRule>>>> result =  sut.getRulesByObjectByProductByStageByField(objectName, products);

        System.assertEquals(field1, result.get(product.tolowercase()).get(stage1).get(field1.tolowercase())[0].FieldName);
    }

}