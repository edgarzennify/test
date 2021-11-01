@IsTest
private class AppraisalOrderComponentFactoryTests {
    private final static MockofIAppraisalOrderComponent mockAppraisalOrderComponentAA = new MockofIAppraisalOrderComponent();
    private final static MockofIAppraisalOrderComponent mockAppraisalOrderComponentXX = new MockofIAppraisalOrderComponent();

    @IsTest
    static void it_should_call_the_constructor() {
        List<AppraisalOrderComponent.IAppraisalOrderComponent> testComponents = new List<AppraisalOrderComponent.IAppraisalOrderComponent>{mockAppraisalOrderComponentAA};
        
        AppraisalOrderComponentFactory sut = new AppraisalOrderComponentFactory(testComponents);

        system.assertNotEquals(null, sut);
    }

    @IsTest
    static void it_should_get_a_component_that_has_the_same_collateral_code_that_was_passed_through_appraisalorderobject() {
        Id appraisalOrderId = EB_Appraisal_Order__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
        Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
        Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'AA');
        EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__r = testCollateralCode);
        EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c(Id = appraisalOrderId, Related_Collateral__r = testCollateral);
        Component.c.AppraisalOrderSub_AA testComponentAA = new Component.c.AppraisalOrderSub_AA();

        mockAppraisalOrderComponentXX.setup('handlesCollateralCode', new List<Object>{'AA'}).returns(false);
        mockAppraisalOrderComponentAA.setup('handlesCollateralCode', new List<Object>{'AA'}).returns(true);
        mockAppraisalOrderComponentAA.setup('getComponentFor', new List<Object>{testAppraisalOrder}).returns(testComponentAA);
        
        List<AppraisalOrderComponent.IAppraisalOrderComponent> testComponents = new List<AppraisalOrderComponent.IAppraisalOrderComponent>{mockAppraisalOrderComponentXX,mockAppraisalOrderComponentAA};
        AppraisalOrderComponentFactory sut = new AppraisalOrderComponentFactory(testComponents);

        ApexPages.Component returnedComponent = sut.getComponentFor(testAppraisalOrder);

        mockAppraisalOrderComponentAA.verify('handlesCollateralCode', new List<Object>{'AA'}, Times.Once);
        mockAppraisalOrderComponentAA.verify('getComponentFor', new List<Object>{testAppraisalOrder}, Times.Once);
        system.assertEquals(testComponentAA, returnedComponent);
    }

    @IsTest
    static void it_should_get_a_list_of_the_summary_fields_for_a_given_collateral_code() {
        AppraisalOrders.AppraisalOrderSummaryFieldDetails sumDet1 = new AppraisalOrders.AppraisalOrderSummaryFieldDetails('label1', 'fieldval1');
        AppraisalOrders.AppraisalOrderSummaryFieldDetails sumDet2 = new AppraisalOrders.AppraisalOrderSummaryFieldDetails('label2', 'fieldval2');
        List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> sumDetList = new List<AppraisalOrders.AppraisalOrderSummaryFieldDetails>{sumDet1, sumDet2};
        Id appraisalOrderId = EB_Appraisal_Order__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
        Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
        Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'AA');
        EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__r = testCollateralCode);
        EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c(Id = appraisalOrderId, Related_Collateral__r = testCollateral);
        mockAppraisalOrderComponentXX.setup('handlesCollateralCode', new List<Object>{'AA'}).returns(false);
        mockAppraisalOrderComponentAA.setup('handlesCollateralCode', new List<Object>{'AA'}).returns(true);
        mockAppraisalOrderComponentAA.setup('getAppraisalOrderSummary', new List<Object>{testAppraisalOrder}).returns(sumDetList);
        List<AppraisalOrderComponent.IAppraisalOrderComponent> testComponents = new List<AppraisalOrderComponent.IAppraisalOrderComponent>{mockAppraisalOrderComponentXX,mockAppraisalOrderComponentAA};
        AppraisalOrderComponentFactory sut = new AppraisalOrderComponentFactory(testComponents);

        List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> returnedDetList = sut.getAppraisalOrderSummaryFieldDetailsList(testAppraisalOrder);
    
        mockAppraisalOrderComponentAA.verify('handlesCollateralCode', new List<Object>{'AA'}, Times.Once);
        mockAppraisalOrderComponentAA.verify('getAppraisalOrderSummary', new List<Object>{testAppraisalOrder}, Times.Once);
        system.assertEquals(sumDetList, returnedDetList);
    }

    @IsTest
    static void it_should_get_validation_error_for_given_collateral_code() {
        String expectedValidationError = 'MyError';
        Id appraisalOrderId = EB_Appraisal_Order__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
        Id collateralCodeId = Collateral_Code__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15s';
        Account testAcct = new Account(Id='001f000000GsU5a');
        EB_Account__c ebAccount = ObjectFactory.getEBAccountWithoutInsert('Test Account','12345',testAcct);
        ebAccount.Id = 'a02000000000000';
        Collateral_Code__c testCollateralCode = new Collateral_Code__c(Id = collateralCodeId, Collateral_Code_ID__c = 'AA');
        ebAccount.OREO_Collateral_Code__r = testCollateralCode;
        EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c(Id = appraisalOrderId, OREO_Account__r = ebAccount, OREO_Account__c = ebAccount.Id);
        mockAppraisalOrderComponentXX.setup('handlesCollateralCode', new List<Object>{'AA'}).returns(false);
        mockAppraisalOrderComponentAA.setup('handlesCollateralCode', new List<Object>{'AA'}).returns(true);
        mockAppraisalOrderComponentAA.setup('getComponentFieldValidationError', new List<Object>{testAppraisalOrder}).returns(expectedValidationError);
        List<AppraisalOrderComponent.IAppraisalOrderComponent> testComponents = new List<AppraisalOrderComponent.IAppraisalOrderComponent>{mockAppraisalOrderComponentXX,mockAppraisalOrderComponentAA};
        AppraisalOrderComponentFactory sut = new AppraisalOrderComponentFactory(testComponents);

        String returnedError = sut.getComponentFieldValidationError(testAppraisalOrder);
    
        mockAppraisalOrderComponentAA.verify('handlesCollateralCode', new List<Object>{'AA'}, Times.Once);
        mockAppraisalOrderComponentAA.verify('getComponentFieldValidationError', new List<Object>{testAppraisalOrder}, Times.Once);
        system.assertEquals(expectedValidationError, returnedError);
    }

    private class MockofIAppraisalOrderComponent extends ApexMoq implements AppraisalOrderComponent.IAppraisalOrderComponent{
        public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){
            return (ApexPages.Component)handleMethodInvocation('getComponentFor', new List<Object>{appraisalOrder});
        }
        public Boolean handlesCollateralCode(String collateralCode){
            return (Boolean)handleMethodInvocation('handlesCollateralCode', new List<Object>{collateralCode});
        }
        public List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> getAppraisalOrderSummary(EB_Appraisal_Order__c appraisalOrder){
            return (List<AppraisalOrders.AppraisalOrderSummaryFieldDetails>)handleMethodInvocation('getAppraisalOrderSummary', new List<Object>{appraisalOrder});
        }
        public String getComponentFieldValidationError(EB_Appraisal_Order__c appraisalOrder){
            return (String)handleMethodInvocation('getComponentFieldValidationError', new List<Object>{appraisalOrder});
        }
    }
}