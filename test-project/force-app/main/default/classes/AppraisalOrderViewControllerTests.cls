@IsTest
private class AppraisalOrderViewControllerTests {
    private final static Mock.ofIApexPages mockApexPages = new Mock.ofIApexPages();
    private final static MockofIAppraisalOrderViewDataProvider mockAppraisalOrderViewDataProvider = new MockofIAppraisalOrderViewDataProvider();
    private final static Mock.ofIUserInfoService mockUserInfoService = new  Mock.ofIUserInfoService();
    private final static User testUser = new User(Id='005a00000000001');
    private final static AppraisalOrderViewController sut;
    private final static Id appraisalOrderId = EB_Appraisal_Order__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15sAAB';
    private final static EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c(Id=appraisalOrderId);
   
    static {
        mockApexPages.setup('getParameter', new List<Object>{'Id'}).Returns(appraisalOrderId);
        mockAppraisalOrderViewDataProvider.setup('getAppraisalOrderForId', new List<Object>{appraisalOrderId} ).Returns(testAppraisalOrder);
        mockApexPages.setup('getParameter', ApexMoq.Arguments.HAVE_ANY_VALUE).Returns(appraisalOrderId);
        mockAppraisalOrderViewDataProvider.setup('getAppraisalOrderForId', ApexMoq.Arguments.HAVE_ANY_VALUE ).Returns(testAppraisalOrder);
        mockUserInfoService.setup('getCurrentUserId').Returns(testUser.Id);
        mockAppraisalOrderViewDataProvider.setup('collateralOwner', new List<Object>{testAppraisalOrder} ).Returns('collateralOwner');
        sut = new AppraisalOrderViewController(mockAppraisalOrderViewDataProvider, mockApexPages,mockUserInfoService);
    }
    
    @IsTest
    static void it_should_call_the_default_constructor_without_error() {
        EB_Appraisal_Order__c testApprOrder = new EB_Appraisal_Order__c();
        insert testApprOrder;
        ApexPages.currentPage().getParameters().put('Id', testApprOrder.Id);
        AppraisalOrderViewController sutDef = new AppraisalOrderViewController();
    }

    @IsTest
    static void it_should_return_true_if_user_is_admin() {
        mockUserInfoService.setup('isSystemAdministrator', new List<Object>{testUser.Id}).returns(true);
        mockUserInfoService.setup('hasPermissionSet', new List<Object>{testUser.Id, 'Function - Appraisal Request Admin'}).returns(false);

        System.assertEquals(true, sut.canEdit);
    }

    @IsTest
    static void it_should_return_true_if_user_is_appraisal_admin() {
        mockUserInfoService.setup('isSystemAdministrator', new List<Object>{testUser.Id}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<Object>{testUser.Id, 'Function - Appraisal Request Admin'}).returns(true);

        System.assertEquals(true, sut.canEdit);
    }

    @IsTest
    static void it_should_return_false_if_user_is_not_appraisal_admin_and_not_admin() {
        mockUserInfoService.setup('isSystemAdministrator', new List<Object>{testUser.Id}).returns(false);
        mockUserInfoService.setup('hasPermissionSet', new List<Object>{testUser.Id, 'Function - Appraisal Request Admin'}).returns(false);

        System.assertEquals(false, sut.canEdit);
    }

    @IsTest
    static void it_should_have_a_value_for_collateral_owner_when_appraisal_order_is_tied_to_collateral() {
        system.assertEquals('collateralOwner', sut.Collateral_Owner);
    }

    @IsTest
    static void it_should_save_the_appraisal_order_oasis_returned_data_if_user_has_admin_rights() {
        EB_Collateral__c coll = new EB_Collateral__c(Id='a0a000000000000');
        mockUserInfoService.setup('hasPermissionSet', new List<Object>{testUser.Id, 'Function - Appraisal Request Admin'}).returns(true);

        Date testDate = Date.today();
        testAppraisalOrder.Related_Collateral__c = coll.Id;
        testAppraisalOrder.Related_Collateral__r = coll;
        testAppraisalOrder.Submit_Order__c = true;
        testAppraisalOrder.As_Is_Value__c=1500;
        testAppraisalOrder.As_Completed_Value__c=250;
        testAppraisalOrder.As_Stabilized_Value__c=350;
        testAppraisalOrder.As_Liquidated_Value__c=100;
        testAppraisalOrder.FDIC_Valuation_Type__c='INT';
        testAppraisalOrder.Valuation_Date__c = testDate;
       
        sut.AppraisalOrder = testAppraisalOrder;
        sut.save();

        mockAppraisalOrderViewDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        system.assertEquals(true, sut.AppraisalOrder.Submit_Order__c);
        system.assertEquals(1500, sut.AppraisalOrder.As_Is_Value__c);
        system.assertEquals(250, sut.AppraisalOrder.As_Completed_Value__c);
        system.assertEquals(350, sut.AppraisalOrder.As_Stabilized_Value__c);
        system.assertEquals(100, sut.AppraisalOrder.As_Liquidated_Value__c);
        system.assertEquals('INT', sut.AppraisalOrder.FDIC_Valuation_Type__c);
        system.assertEquals(Date.today(), sut.AppraisalOrder.Valuation_Date__c);
        
    }

    @IsTest
    static void it_should_not_save_the_appraisal_order_oasis_returned_data() {   
        EB_Collateral__c coll = new EB_Collateral__c(Id='a0a000000000000');
        Date testDate = Date.today();
        testAppraisalOrder.Related_Collateral__c = coll.Id;
        testAppraisalOrder.Related_Collateral__r = coll;
        testAppraisalOrder.Submit_Order__c = true;
        testAppraisalOrder.As_Is_Value__c=1500;
        testAppraisalOrder.As_Completed_Value__c=250;
        testAppraisalOrder.As_Stabilized_Value__c=350;
        testAppraisalOrder.As_Liquidated_Value__c=100;
        testAppraisalOrder.FDIC_Valuation_Type__c='INT';
        testAppraisalOrder.Valuation_Date__c = testDate;

        sut.AppraisalOrder = testAppraisalOrder;
        sut.cancel();

        mockAppraisalOrderViewDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Never);
    }

    private class MockofIAppraisalOrderViewDataProvider extends ApexMoq implements AppraisalOrderViewDataProvider.IAppraisalOrderViewDataProvider{
        public EB_Appraisal_Order__c getAppraisalOrderForId(Id orderId){
            return (EB_Appraisal_Order__c)handleMethodInvocation('getAppraisalOrderForId', new List<Object>{orderId});
        }
        public EB_Appraisal_Order__c getAppraisalOrderFromCollateralId(Id collateralId){
            return (EB_Appraisal_Order__c)handleMethodInvocation('getAppraisalOrderFromCollateralId', new List<Object>{collateralId});
        }
        public EB_Appraisal_Order__c getAppraisalOrderFromOREOId(Id oreoId){
            return (EB_Appraisal_Order__c)handleMethodInvocation('getAppraisalOrderFromOREOId', new List<Object>{oreoId});
        }
        public void save(EB_Appraisal_Order__c appraisalOrder){
            handleMethodInvocation('save', new List<Object>{appraisalOrder});
        }
        public String collateralOwner(EB_Appraisal_Order__c appraisalOrder){
            return (String)handleMethodInvocation('collateralOwner', new List<Object>{appraisalOrder});
        }
    }
}