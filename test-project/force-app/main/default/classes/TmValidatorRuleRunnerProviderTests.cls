@IsTest
public class TmValidatorRuleRunnerProviderTests {

    private static TmValidatorMock.ofIRuleRunner m_mockRuleRunner;
    private static TmValidatorMock.ofIRepository m_mockRepository;
    private static TmValidatorMock.ofIRuleManager m_mockRuleManager;
    private static Mock.ofIUtility m_mockUtil;
    private static TmValidator.IRuleRunnerProvider sut;

    static {
        m_mockRepository = new TmValidatorMock.ofIRepository();
        m_mockRuleRunner = new TmValidatorMock.ofIRuleRunner();
        m_mockRuleManager = new TmValidatorMock.ofIRuleManager();
        m_mockUtil = new Mock.ofIUtility();
        sut = new TmValidatorRuleRunnerProvider(m_mockRuleRunner, m_mockRepository, m_mockRuleManager, m_mockUtil);
    }
    
    @IsTest
    static void it_should_validate_field_values_when_validation_request_is_provided_rule_runner_returns_true() {
        string objectName = 'TM_Request';
        string product = 'Online Banking';
        string stageId = 'axcd123445';
        string fieldName = 'ACH_Credit__c';
        TmValidator.ValidationRequest request = new TmValidator.ValidationRequest();
        request.ObjectName = objectName;
        request.Product = product;
        request.StageId = stageId;
        request.RequestId = 'request-id';
        TmValidator.ValidationRequestItem fld = new TmValidator.ValidationRequestItem();
        fld.FieldName = fieldName;
        fld.FieldValue = true;
        request.Fields = new List<TmValidator.ValidationRequestItem>{fld};
        List<TmValidator.ValidationRequest> requests = new List<TmValidator.ValidationRequest>{request};
        DmField achCredit = new DmField();
        achCredit.ObjectName = objectName;
        achCredit.Name = fieldName;
        achCredit.Type = DescribeFieldResultWrapper.Type.TypeBoolean;
        List<DmField> fieldDms = new List<DmField>{achCredit};

        DmTmRule rule = new DmTmRule();
        rule.FieldName = fieldName;
        rule.Operand = 'true';
        rule.Operation = '=';
        rule.Product = product;
        rule.ObjectName = objectName;
        
        Map<string, List<DmTmRule>> rulesByFieldName = new Map<string, List<DmTmRule>>();
        rulesByFieldName.put(fieldName.toLowerCase(), new List<DmTmRule>{rule});
        Map<string, Map<string, List<DmTmRule>>> rules = new Map<string, Map<string, List<DmTmRule>>>();
        rules.put(stageId, rulesByFieldName);

        List<DmTmRule> rulesConsolidated = new List<DmTmRule>{rule};
        Map<DmTmRule, List<DmTmRule>> parentChildMap = new Map<DmTmRule, List<DmTmRule>>{rule => new List<DmTmRule>()};

        m_mockRepository.setup('getRuleForObjectAndStage', new List<object>{objectName, product}).returns(rules);
        m_mockRuleRunner.setup('ValidateRule', new List<Object>{request.fields[0].fieldValue, achCredit, rule}).returns(true);
        m_mockRuleManager.setup('getGrouped', new List<Object>{rulesConsolidated}).returns(parentChildMap);
        m_mockRuleRunner.setup('ValidateCorrelatedValues' , ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(true);

        List<TmValidator.ValidationResult> result = sut.ValidateRequestForObject(request, fieldDms);

        System.assertEquals(1, result.size());
        System.assertEquals(true, result[0].IsValid);
    }

    @IsTest
    static void it_should_validate_field_values_when_validation_request_is_provided_rule_runner_returns_false() {
        string objectName = 'TM_Request';
        string product = 'Online Banking';
        string stageId = 'axcd123445';
        string fieldName = 'ACH_Credit__c';
        TmValidator.ValidationRequest request = new TmValidator.ValidationRequest();
        request.ObjectName = objectName;
        request.Product = product;
        request.StageId = stageId;
        TmValidator.ValidationRequestItem fld = new TmValidator.ValidationRequestItem();
        fld.FieldName = fieldName;
        fld.FieldValue = true;
        request.Fields = new List<TmValidator.ValidationRequestItem>{fld};
        List<TmValidator.ValidationRequest> requests = new List<TmValidator.ValidationRequest>{request};
        DmField achCredit = new DmField();
        achCredit.ObjectName = objectName;
        achCredit.Name = fieldName;
        achCredit.Type = DescribeFieldResultWrapper.Type.TypeBoolean;
        List<DmField> fieldDms = new List<DmField>{achCredit};

        DmTmRule rule = new DmTmRule();
        rule.FieldName = fieldName;
        rule.Operand = 'true';
        rule.Operation = '=';
        rule.Product = product;
        
        Map<string, List<DmTmRule>> rulesByFieldName = new Map<string, List<DmTmRule>>();
        rulesByFieldName.put(fieldName.toLowerCase(), new List<DmTmRule>{rule});
        Map<string, Map<string, List<DmTmRule>>> rules = new Map<string, Map<string, List<DmTmRule>>>();
        rules.put(stageId, rulesByFieldName);

        List<DmTmRule> rulesConsolidated = new List<DmTmRule>{rule};
        Map<DmTmRule, List<DmTmRule>> parenChildMap = new Map<DmTmRule, List<DmTmRule>>{rule => new List<DmTmRule>()};

        m_mockRepository.setup('getRuleForObjectAndStage', new List<object>{objectName, product}).returns(rules);
        m_mockRuleRunner.setup('ValidateRule', new List<Object>{achCredit, request.fields[0].fieldValue, rule}).returns(false);
        m_mockRuleManager.setup('getGrouped', new List<Object>{rulesConsolidated}).returns(parenChildMap);
        m_mockRuleRunner.setup('ValidateCorrelatedValues' , ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(false);

        List<TmValidator.ValidationResult> result = sut.ValidateRequestForObject(request, fieldDms);

        System.assertEquals(false, result[0].IsValid);
    }
    
    @IsTest
    static void it_should_validate_field_values_when_multiple_validation_request_is_provided_rule_runner_returns_true() {
        string objectName = 'TM_Request';
        string product = 'Online Banking';
        string stageId = 'axcd123445';
        string fieldName1 = 'ACH_Credit__c';
        string fieldName2 = 'ACH_Debit__c';
        TmValidator.ValidationRequest request = new TmValidator.ValidationRequest();
        request.ObjectName = objectName;
        request.Product = product;
        request.StageId = stageId;
        TmValidator.ValidationRequestItem itm1 = new TmValidator.ValidationRequestItem();
        itm1.FieldName = fieldName1;
        itm1.FieldValue = true;
        TmValidator.ValidationRequestItem itm2 = new TmValidator.ValidationRequestItem();
        itm2.FieldName = fieldName2;
        itm2.FieldValue = false;
        request.Fields = new List<TmValidator.ValidationRequestItem>{itm1, itm2};
        DmField achCredit = new DmField();
        achCredit.ObjectName = objectName;
        achCredit.Name = fieldName1;
        achCredit.Type = DescribeFieldResultWrapper.Type.TypeBoolean;

        DmField achDebit = new DmField();
        achDebit.ObjectName = objectName;
        achDebit.Name = fieldName2;
        achDebit.Type = DescribeFieldResultWrapper.Type.TypeBoolean;

        List<DmField> fieldDms = new List<DmField>{achCredit, achDebit};

        DmTmRule rule1 = new DmTmRule();
        rule1.FieldName = fieldName1;
        rule1.Operand = 'true';
        rule1.Operation = '=';
        rule1.Product = product;

        DmTmRule rule2 = new DmTmRule();
        rule2.FieldName = fieldName2;
        rule2.Operand = 'true';
        rule2.Operation = '=';
        rule2.Product = product;
        
        Map<string, List<DmTmRule>> rulesByFieldName = new Map<string, List<DmTmRule>>();
        rulesByFieldName.put(fieldName1.toLowerCase(), new List<DmTmRule>{rule1});
        rulesByFieldName.put(fieldName2.toLowerCase(), new List<DmTmRule>{rule2});
        Map<string, Map<string, List<DmTmRule>>> rules = new Map<string, Map<string, List<DmTmRule>>>();
        rules.put(stageId, rulesByFieldName);

        List<DmTmRule> rulesConsolidated = new List<DmTmRule>{rule1, rule2};
        Map<DmTmRule, List<DmTmRule>> parenChildMap = new Map<DmTmRule, List<DmTmRule>>{rule1 => new List<DmTmRule>{rule2}};

        m_mockRepository.setup('getRuleForObjectAndStage', new List<object>{objectName, product}).returns(rules);
        m_mockRuleRunner.setup('ValidateRule', new List<Object>{achCredit, request.Fields[0].fieldValue, rule1}).returns(true);
        m_mockRuleRunner.setup('ValidateRule', new List<Object>{achDebit, request.Fields[1].fieldValue, rule2}).returns(false);
        m_mockRuleManager.setup('getGrouped', new List<Object>{rulesConsolidated}).returns(parenChildMap);
        m_mockRuleRunner.setup('ValidateCorrelatedValues' , ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(true);

        List<TmValidator.ValidationResult> result = sut.ValidateRequestForObject(request, fieldDms);

        System.assertEquals(2, result.size());
        System.assertEquals(fieldName1 ,result[0].fieldName);
        System.assertEquals(fieldName2 ,result[1].fieldName);
        System.assertEquals(true, result[0].IsValid);
        System.assertEquals(false, result[1].IsValid);
    }

    @IsTest
    static void it_should_validate_field_value_is_numeric_when_validation_request_is_provided_rule_runner_returns_true() {
        string objectName = 'TM_Request';
        string product = 'Online Banking';
        string stageId = 'axcd123445';
        string fieldName = 'ACH_Credits_Daily_Limit__c';
        TmValidator.ValidationRequest request = new TmValidator.ValidationRequest();
        request.ObjectName = objectName;
        request.Product = product;
        request.StageId = stageId;
        TmValidator.ValidationRequestItem itm = new TmValidator.ValidationRequestItem();
        itm.FieldName = fieldName;
        itm.FieldValue = 25.0;
        request.Fields = new List<TmValidator.ValidationRequestItem>{itm};
        DmField achCredit = new DmField();
        achCredit.ObjectName = objectName;
        achCredit.Name = fieldName;
        achCredit.Type = DescribeFieldResultWrapper.Type.TypeDouble;
        List<DmField> fieldDms = new List<DmField>{achCredit};

        DmTmRule rule = new DmTmRule();
        rule.FieldName = fieldName;
        rule.Operand = '0';
        rule.Operation = '>';
        rule.Product = product;
        
        Map<string, List<DmTmRule>> rulesByFieldName = new Map<string, List<DmTmRule>>();
        rulesByFieldName.put(fieldName.toLowerCase(), new List<DmTmRule>{rule});
        Map<string, Map<string, List<DmTmRule>>> rules = new Map<string, Map<string, List<DmTmRule>>>();
        rules.put(stageId, rulesByFieldName);

        List<DmTmRule> rulesConsolidated = new List<DmTmRule>{rule};
        Map<DmTmRule, List<DmTmRule>> parenChildMap = new Map<DmTmRule, List<DmTmRule>>{rule => new List<DmTmRule>()};

        m_mockRepository.setup('getRuleForObjectAndStage', new List<object>{objectName, product}).returns(rules);
        m_mockRuleRunner.setup('ValidateRule', new List<Object>{request.fields[0].fieldValue, achCredit, rule}).returns(true);
        m_mockRuleManager.setup('getGrouped', new List<Object>{rulesConsolidated}).returns(parenChildMap);
        m_mockRuleRunner.setup('ValidateCorrelatedValues' , ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(false);

        List<TmValidator.ValidationResult> result = sut.ValidateRequestForObject(request, fieldDms);

        System.assertEquals(true, result[0].IsValid);
    }

    @IsTest
    static void it_should_build_the_validation_field_metadata_with_current_stage_and_rule_stage_same() {
        string objectName = 'TM_Service_Request__c';
        string product = 'Online Banking';
        string field1 = 'ACH_Credit__c';
        string field2 = 'ACH_Credits_Daily_Limit__c';
        string currentStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SOBjectType, '1');
        DmField dm = new DmField();
        dm.Name = field1;
        dm.ObjectName = objectName;
        dm.Type = DescribeFieldResultWrapper.Type.TypeBoolean;
        DmField achCreditsDailyLimit = new DmField();
        achCreditsDailyLimit.ObjectName = objectName;
        achCreditsDailyLimit.Name = field2;
        achCreditsDailyLimit.Type = DescribeFieldResultWrapper.Type.TypeDouble;
        List<DmField> fields = new List<DmField>{dm, achCreditsDailyLimit};

        Map<string, List<String>> rules = new Map<string, List<String>>();
        List<String> queryResults = new List<String>{field1, field2};
        rules.put(objectName, queryResults);
        Map<String,List<DmTmRule>> ruleMapByObject = new Map<String,List<DmTmRule>>();
        DmTmRule rule1 = new DmTmRule();
        rule1.ObjectName = objectName;
        rule1.StageID = currentStageId;
        rule1.Operation = '=';
        rule1.Operand = '1';
        rule1.FieldName = field1;
        rule1.Product = product;

        DmTmRule rule2 = new DmTmRule();
        rule2.ObjectName = objectName;
        rule2.StageID = currentStageId;
        rule2.Operation = '>';
        rule2.Operand = '0';
        rule2.FieldName = field2;
        rule2.Product = product;
        
        ruleMapByObject.put(field1.toLowerCase(), new List<DmTmRule>{rule1});
        ruleMapByObject.put(field2.toLowerCase(), new List<DmTmRule>{rule2});
        Map<string, Map<string, List<DmTmRule>>> rulesMapByStage = new Map<string, Map<string, List<DmTmRule>>>{currentStageId =>ruleMapByObject};

        m_mockRepository.setup('getRules').returns(rules);
        m_mockRepository.setup('getRuleForObjectAndStage', new List<OBject>{objectName, product}).returns(rulesMapByStage);

        Map<string, List<TmValidator.ValidationResults>> result  = sut.ValidationByStageMetadata(objectName,  currentStageId, product, fields);

        system.assertEquals(1, result.keyset().size());
        system.assertEquals(2 ,result.get(currentStageId).size());
        system.assertEquals(field1 ,result.get(currentStageId)[0].FieldName);
        system.assertEquals(field2 ,result.get(currentStageId)[1].FieldName);
    }
    
    @IsTest
    static void it_should_build_the_validation_field_metadata_with_current_stage_and_one_rule_stage_different() {
        string objectName = 'TM_Service_Request__c';
        string product = 'Online';
        string field1 = 'ACH_Credit__c';
        string field2 = 'ACH_Credits_Daily_Limit__c';
        string currentStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SOBjectType, '1');
        string futureStageId = ObjectFactory.getFakeId(TM_Service_Request_Stage__c.SOBjectType, '2');
        DmField dm = new DmField();
        dm.Name = field1;
        dm.ObjectName = objectName;
        dm.Type = DescribeFieldResultWrapper.Type.TypeBoolean;
        DmField achCreditsDailyLimit = new DmField();
        achCreditsDailyLimit.ObjectName = objectName;
        achCreditsDailyLimit.Name = field2;
        achCreditsDailyLimit.Type = DescribeFieldResultWrapper.Type.TypeDouble;
        List<DmField> fields = new List<DmField>{dm, achCreditsDailyLimit};

        Map<string, List<String>> rules = new Map<string, List<String>>();
        List<String> queryResults = new List<String>{field1, field2};
        rules.put(objectName, queryResults);

        Map<String,List<DmTmRule>> ruleMapByObject1 = new Map<String,List<DmTmRule>>();
        Map<String,List<DmTmRule>> ruleMapByObject2 = new Map<String,List<DmTmRule>>();
        DmTmRule rule1 = new DmTmRule();
        rule1.ObjectName = objectName;
        rule1.StageID = currentStageId;
        rule1.Operation = '=';
        rule1.Operand = '1';
        rule1.FieldName = field1;
        rule1.Product = product;

        DmTmRule rule2 = new DmTmRule();
        rule2.ObjectName = objectName;
        rule2.StageID = futureStageId;
        rule2.Operation = '>';
        rule2.Operand = '0';
        rule2.FieldName = field2;
        rule2.Product = product;
        
        ruleMapByObject1.put(field1.toLowerCase(), new List<DmTmRule>{rule1});
        ruleMapByObject2.put(field2.toLowerCase(), new List<DmTmRule>{rule2});
        Map<string, Map<string, List<DmTmRule>>> rulesMapByStage = new Map<string, Map<string, List<DmTmRule>>>{currentStageId =>ruleMapByObject1, futureStageId => ruleMapByObject2};

        m_mockRepository.setup('getRules').returns(rules);
        m_mockRepository.setup('getRuleForObjectAndStage', new List<OBject>{objectName, product}).returns(rulesMapByStage);

        Map<string, List<TmValidator.ValidationResults>> result  = sut.ValidationByStageMetadata(objectName,  currentStageId, product, fields);

        system.assertEquals(2, result.keyset().size());
        system.assertEquals(1, result.get(currentStageId).size());
        system.assertEquals(1, result.get(futureStageId).size());
        system.assertEquals(field1, result.get(currentStageId)[0].fieldName);
        system.assertEquals(field2, result.get(futureStageId)[0].fieldName);
        system.assertEquals(true, result.get(currentStageId)[0].IsCurrentStage);
        system.assertEquals(false, result.get(futureStageId)[0].IsCurrentStage);
    }

    @IsTest
    static void it_should_build_a_validation_lookup_with_fieldName_as_key() {
        String stageId = 'stage-id';
        String fieldName = 'field-name';
        TmValidator.ValidationResults vResult = new TmValidator.ValidationResults();
        vResult.FieldName = fieldName;
        vResult.StageId = stageId;
        List<TmValidator.ValidationResults> vResults = new List<TmValidator.ValidationResults>{vResult};

        Map<string, List<TmValidator.ValidationResults>> validationsByStage = 
                                new Map<string, List<TmValidator.ValidationResults>>{stageId => vResults};

        Map<string, TmValidator.ValidationResults> result = sut.ValidationLookup(validationsByStage);

        Set<string> fieldNameSet = result.keyset();
        List<string> fieldNameList = new List<string>();
        fieldNameList.addAll(fieldNameSet);
        TmValidator.ValidationResults testVResult = result.get(fieldName);
        System.assertEquals(fieldName, fieldNameList[0]);
        System.assertEquals(stageId, testVResult.StageId);
        System.assertEquals(fieldName, testVResult.FieldName);
    }

    @IsTest
    static void it_should_return_no_errors_when_condition_for_not_A_is_met() {

        TmValidator.ValidationRequestItem dailyLimit = new TmValidator.ValidationRequestItem();
        dailyLimit.FieldName='TM_Service_Request__c.ACH_Credits_Daily_Limit__c';
        dailyLimit.FieldValue=0;
        TmValidator.ValidationRequestItem achCredit = new TmValidator.ValidationRequestItem();
        achCredit.FieldName='TM_Service_Request__c.ACH_Credits__c';
        achCredit.FieldValue=false;

        TmValidator.ValidationRequest request = new TmValidator.ValidationRequest();
        request.ObjectName = 'TM_Service_Request__c';
        request.StageId = 'aAd1F0000008RYwSAM';
        request.Product = 'Online Banking';
        request.RequestId= 'aAg1F0000008TQWSA2';
        request.Fields = new List<TmValidator.ValidationRequestItem>{dailyLimit, achCredit};

        DmField dailyDm = new DmField();
        dailyDm.Edit=true;
        dailyDm.EditPlacement=1.00000;
        dailyDm.HelpText=null;
        dailyDm.IsAccessible=true;
        dailyDm.IsCreatable=true;
        dailyDm.IsUpdatable=true;
        dailyDm.Label='ACH Credits Daily Limit';
        dailyDm.Name='ACH_Credits_Daily_Limit__c';
        dailyDm.ObjectName='TM_Service_Request__c';
        dailyDm.Picklist=null;
        dailyDm.Report=false;
        dailyDm.ReportPlacement=null;
        dailyDm.SectionGroupName='';
        dailyDm.SectionGroupType='';
        dailyDm.SectionId=null;
        dailyDm.SortBySelectedPlacement=1.00000;
        dailyDm.Type=DescribeFieldResultWrapper.Type.TypeCurrency;
        dailyDm.View=true;
        dailyDm.ViewPlacement=1.00000;

        DmField creditDm = new DmField();
        creditDm.Edit=true;
        creditDm.EditPlacement=2.00000;
        creditDm.HelpText=null;
        creditDm.IsAccessible=true;
        creditDm.IsCreatable=true;
        creditDm.IsUpdatable=true;
        creditDm.Label='ACH Credits';
        creditDm.Name='ACH_Credits__c';
        creditDm.ObjectName='TM_Service_Request__c';
        creditDm.Picklist=null;
        creditDm.Report=false;
        creditDm.ReportPlacement=null;
        creditDm.SectionGroupName='';
        creditDm.SectionGroupType='';
        creditDm.SectionId='aAW1F0000008PyvWAE';
        creditDm.SortBySelectedPlacement=2.00000;
        creditDm.Type=DescribeFieldResultWrapper.Type.TypeBoolean;
        creditDm.View=true;
        creditDm.ViewPlacement=2.00000;

        string product = request.Product;
        string fieldName = creditDm.Name;
        string objectName = request.objectName;

        DmTmRule rule = new DmTmRule();
        rule.FieldName = fieldName;
        rule.Operand = 'true';
        rule.Operation = '=';
        rule.Product = product;
        rule.error = 'test';

        Map<string, List<DmTmRule>> rulesByFieldName = new Map<string, List<DmTmRule>>();
        rulesByFieldName.put(fieldName.toLowerCase(), new List<DmTmRule>{rule});
        Map<string, Map<string, List<DmTmRule>>> rules = new Map<string, Map<string, List<DmTmRule>>>();
        rules.put(request.StageId, rulesByFieldName);

        List<DmTmRule> rulesConsolidated = new List<DmTmRule>{rule};
        Map<DmTmRule, List<DmTmRule>> parentChildMap = new Map<DmTmRule, List<DmTmRule>>{rule => new List<DmTmRule>()};

        m_mockRepository.setup('getRuleForObjectAndStage', new List<object>{objectName, product}).returns(rules);
        m_mockRuleRunner.setup('ValidateFieldValue', new List<Object>{request.fields[0].fieldValue, achCredit, rule}).returns(false);
        m_mockRuleManager.setup('getGrouped', new List<Object>{rulesConsolidated}).returns(parentChildMap);
        m_mockRuleRunner.setup('ValidateCorrelatedValues' , ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(false);

        List<DmField> fieldDms = new List<DmField>{dailyDm, creditDm};

        List<TmValidator.ValidationResult> result = sut.ValidateRequestForObject(request,  fieldDms);
    }
    
    @IsTest
    static void it_should_call_the_repository_to_do_validation_on_existing_data_when_stage_is_provided() {
        Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SobjectType, '1');
        TM_Service_Request__c req = new TM_Service_Request__c(Id = requestId);
        RecordType rt = new RecordType();
        rt.Name = 'test-record-type';

        List<string> stageIds = new List<string>{'stage-id'};
        List<DmField> dmFields = new List<DmField>();
        m_mockRepository.setup('getRules').returns(new Map<string, List<String>>());
        m_mockRepository.setup('getRuleForObjectAndStage', new List<Object>{req, stageIds, dmFields}).returns(new Map<string, Map<string, List<DmTmRule>>>());

        Map<string, List<TmValidator.ValidationResult>> result = sut.ValidateExistingTmRequest(req, stageIds, dmFields);
        
        m_mockRepository.verify('getRules', Times.Once);
        m_mockRepository.verify('getRuleForObjectAndStage', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_the_repository_to_do_validation_on() {
        Map<Tm_Service_Request__c, List<DmField>> tmRequests = new Map<Tm_Service_Request__c, List<DmField>>();
        List<string> stageIds = new List<string>();
        Set<string> products = new Set<string>();

        List<TmValidator.ValidationResultByProductByStage> result = sut.ValidateTmRequestsByStage(tmRequests, stageIds, products);
    }

    @IsTest
    static void it_should_call_the_repository_to_get_rules_for_validating_requests_by_current_stage() {
        String ObjectName = 'TM_Service_Request__c';
        Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SOBjectType, '1');
        Tm_Service_Request__c tmRequest = new Tm_Service_Request__c();
        tmRequest.RecordType = new RecordType(Name='Ach');
        DmField fieldDm = new DmField();
        fieldDm.ObjectName = ObjectName;
        fieldDm.Name = 'RecordType.Name';
        List<DmField> fields = new List<DmField>{fieldDm};

        Map<Tm_Service_Request__c, List<DmField>> tmRequests = new Map<Tm_Service_Request__c, List<DmField>>{tmRequest => fields};
        List<string> productList = new List<string>{'ach'};
        Set<string> products = new Set<string>(productList);
        Map<string,Map<string, Map<string, List<DmTmRule>>>> rulesMapByProductByStage = new Map<string,Map<string, Map<string, List<DmTmRule>>>>();
        m_mockRepository.setup('getRulesByObjectByProductByStageByField', new List<Object>{objectName, productList}).returns(rulesMapByProductByStage);

        List<TmValidator.ValidationResultByProductByStage> result = sut.ValidateTmRequestsByCurrentStage(tmRequests, products);
        
        m_mockRepository.verify('getRulesByObjectByProductByStageByField', new List<Object>{objectName, productList}, Times.Once);
    } 

    @IsTest
    static void it_should_validate_requests_by_current_stage() {
        String ObjectName = 'TM_Service_Request__c';
        Id requestId = ObjectFactory.getFakeId(Tm_Service_Request__c.SOBjectType, '1');
        Tm_Service_Request__c tmRequest = new Tm_Service_Request__c();
        tmRequest.RecordType = new RecordType(Name='Ach');
        DmField fieldDm = new DmField();
        fieldDm.ObjectName = ObjectName;
        fieldDm.Name = 'RecordType.Name';
        List<DmField> fields = new List<DmField>{fieldDm};
        Map<string, List<String>> rules = new Map<string, List<String>>();
        Map<Tm_Service_Request__c, List<DmField>> tmRequests = new Map<Tm_Service_Request__c, List<DmField>>{tmRequest => fields};
        List<string> productList = new List<string>{'ach'};
        Set<string> products = new Set<string>(productList);
        Map<string,Map<string, Map<string, List<DmTmRule>>>> rulesMapByProductByStage = new Map<string,Map<string, Map<string, List<DmTmRule>>>>();
        m_mockRepository.setup('getRules').returns(rules);
        m_mockRepository.setup('getRulesByObjectByProductByStageByField', new List<Object>{objectName, productList}).returns(rulesMapByProductByStage);

        List<TmValidator.ValidationResultByProductByStage> result = sut.ValidateTmRequestsByCurrentStage(tmRequests, products);
        
        m_mockRepository.verify('getRulesByObjectByProductByStageByField', new List<Object>{objectName, productList}, Times.Once);
    } 
}