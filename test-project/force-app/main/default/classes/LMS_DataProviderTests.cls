@IsTest
private class LMS_DataProviderTests {

    private static final LMS_LoanMetricSubstage.ILMS_DataProvider sut;

    static {
        sut = new LMS_DataProvider();
    }

    @IsTest
    static void it_should_return_a_list_of_active_dm_definitions() {
        LMS_Substage__c substage01 = new LMS_Substage__c(Name = 'substage01');
        LMS_Substage__c substage02 = new LMS_Substage__c(Name = 'substage02');
        insert new List<LMS_Substage__c>{substage01, substage02};        

        LMS_Definition__c definition01 = new LMS_Definition__c();
        definition01.LMS_Substage__r = substage01;
        definition01.LMS_Substage__c = substage01.Id;
        definition01.Loan_Stage__c = 'stage1';
        definition01.Loan_Status__c = 'status1';
        definition01.Details_Required__c = true;
        definition01.IsActive__c = true;
        LMS_Definition__c definition02 = new LMS_Definition__c();
        definition02.LMS_Substage__r = substage02;
        definition02.LMS_Substage__c = substage02.Id;
        definition02.Loan_Stage__c = 'stage2';
        definition02.Loan_Status__c = 'status2';
        definition02.Details_Required__c = false;
        definition02.IsActive__c = true;
        LMS_Definition__c definition03 = new LMS_Definition__c();
        definition03.LMS_Substage__r = substage02;
        definition03.LMS_Substage__c = substage02.Id;
        definition03.IsActive__c = false;
        insert new List<LMS_Definition__c>{definition01, definition02, definition03};

        LMS_Definition_Detail__c detail01 = new LMS_Definition_Detail__c();
        detail01.LMS_Definition__r = definition01;
        detail01.LMS_Definition__c = definition01.Id;
        detail01.Operator__c = '=';
        detail01.Field_Reference__c = 'some field';
        detail01.Operand__c = 'some operand';
        LMS_Definition_Detail__c detail02 = new LMS_Definition_Detail__c();
        detail02.LMS_Definition__r = definition01;
        detail02.LMS_Definition__c = definition01.Id;
        detail02.Operator__c = '<>';
        detail02.Field_Reference__c = 'some other field';
        detail02.Operand__c = 'some other operand';
        List<LMS_Definition_Detail__c> definition01details = new List<LMS_Definition_Detail__c>{detail01, detail02};
        insert new List<LMS_Definition_Detail__c>{detail01, detail02};
        
        List<LMS_LoanMetricSubstage.LMS_Definition> results = sut.getDefinitions();
        
        System.assertEquals(2, results.size());
        System.assertEquals('substage01', results[0].Substage);
        System.assertEquals('stage1', results[0].LoanStage);
        System.assertEquals('status1', results[0].LoanStatus);
        System.assertEquals(true, results[0].DetailsRequired);
        System.assertEquals(2, results[0].Details.size());
        System.assertEquals('some field', results[0].Details[0].FieldReference);
        System.assertEquals('some operand', results[0].Details[0].Operand);
        System.assertEquals('=', results[0].Details[0].Operator);
        System.assertEquals('some other field', results[0].Details[1].FieldReference);
        System.assertEquals('some other operand', results[0].Details[1].Operand);
        System.assertEquals('<>', results[0].Details[1].Operator);
        System.assertEquals('substage02', results[1].Substage);
        System.assertEquals('stage2', results[1].LoanStage);
        System.assertEquals('status2', results[1].LoanStatus);
        System.assertEquals(false, results[1].DetailsRequired);
        System.assertEquals(0, results[1].Details.size());
        System.assertNotEquals(null, results[1].Details);
    }
}