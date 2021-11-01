@IsTest
private class TmValidatorDataProviderTests {

    private static final TmValidatorDataProvider sut;

    static {
        sut = new TmValidatorDataProvider();
    }

    private static testMethod void it_should_get_all_rule_pms() {
        TM_Service_Request_Validation_Container__c containerPm = new TM_Service_Request_Validation_Container__c();
        insert containerPm;
        TM_Validation_Rule_Definition__c defPm = new TM_Validation_Rule_Definition__c();
        defPm.TM_Service_Request_Validation_Container__c = containerPm.Id;
        insert defPm;
        TM_Service_Request_Validation_Rule__c rulePm = new TM_Service_Request_Validation_Rule__c();
        rulePm.TM_Validation_Rule_Definition__c = defPm.Id;
        insert rulePm;

        List<TmValidator.ValidationContainerPm> result =  sut.getValidationRules();

        System.assertEquals(1, result.size());
        Object soqlObj;
        soqlObj = result[0].Container.Id;
        soqlObj = result[0].Container.Name;
        soqlObj = result[0].Container.Active__c;
        soqlObj = result[0].Container.Object_Name__c;
        soqlObj = result[0].Container.Product__c;
        soqlObj = result[0].Container.TM_Service_Request_Stage__c;
    }

    //public static testmethod void it_should_get_all_rules() {
    //    TM_Service_Request_Validation_Container__c container = new TM_Service_Request_Validation_Container__c();
    //    container.Active__c = true;
    //    insert container;

    //    TM_Service_Request_Validation_Rule__c test1 =new TM_Service_Request_Validation_Rule__c();
    //    test1.Error_Text__c = 'am error';
    //    test1.Active__c = true;
    //    test1.TM_Service_Request_Validation_Container__c = container.Id;
    //    insert test1;

    //    List<TM_Service_Request_Validation_Rule__c> results = sut.GetValidationRules();

    //    Object obj;
    //    obj = results[0].Id;
    //    obj = results[0].Error_Text__c;
    //    obj = results[0].Field_Name__c;
    //    obj = results[0].Operand__c;
    //    obj = results[0].Operation__c;
    //    obj = results[0].Formula__c;
    //    obj = results[0].Formula_Token__c;
    //    obj = results[0].Rule__c;
    //    obj = results[0].TM_Service_Request_Validation_Related__c;
    //    obj = results[0].Validation_Name__c;
    //    obj = results[0].Correlated__c;
    //    obj = results[0].TM_Service_Request_Validation_Container__r.Id;
    //    obj = results[0].TM_Service_Request_Validation_Container__r.Name;
    //    obj = results[0].TM_Service_Request_Validation_Container__r.Active__c;
    //    obj = results[0].TM_Service_Request_Validation_Container__r.Object_Name__c;
    //    obj = results[0].TM_Service_Request_Validation_Container__r.Product__c;
    //    obj = results[0].TM_Service_Request_Validation_Container__r.TM_Service_Request_Stage__c;

    //    System.assertEquals('am error', results[0].Error_Text__c);
    //}

}