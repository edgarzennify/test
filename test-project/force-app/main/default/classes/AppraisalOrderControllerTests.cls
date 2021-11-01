@IsTest
private class AppraisalOrderControllerTests {
    private final static Mock.ofIApexPages mockApexPages = new Mock.ofIApexPages();
    private final static MockofIAppraisalOrderComponentFactory mockAppraisalOrderComponentFactory = new MockofIAppraisalOrderComponentFactory();
    private final static MockofIAppraisalOrderDataProvider mockAppraisalOrderDataProvider = new MockofIAppraisalOrderDataProvider();
    private final static AppraisalOrderController sut;
    private final static Id appraisalOrderId = EB_Appraisal_Order__c.sObjectType.getDescribe().getKeyPrefix() + 'f000000Qx15sAAB';
    private final static EB_Appraisal_Order__c testAppraisalOrder = new EB_Appraisal_Order__c(Id=appraisalOrderId,Cost_Center__c='1001 - testUnit');
    private final static Component.c.AppraisalOrderSub_AA testComponent = new Component.c.AppraisalOrderSub_AA();
    private final static AppraisalOrders.AppraisalOrderSummaryFieldDetails fieldSum1 = new AppraisalOrders.AppraisalOrderSummaryFieldDetails('label1 - ','value1');
    private final static List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> componentFieldList = new List<AppraisalOrders.AppraisalOrderSummaryFieldDetails>{fieldSum1};
    
    static {
        mockApexPages.setup('getParameter', new List<Object>{'Id'}).Returns(appraisalOrderId);
        mockAppraisalOrderDataProvider.setup('getAppraisalOrderForId', new List<Object>{appraisalOrderId} ).Returns(testAppraisalOrder);
        mockAppraisalOrderComponentFactory.setup('getComponentFor',new List<Object>{testAppraisalOrder}).Returns(testComponent);
        mockApexPages.setup('getParameter', ApexMoq.Arguments.HAVE_ANY_VALUE).Returns(appraisalOrderId);
        mockAppraisalOrderDataProvider.setup('getAppraisalOrderForId', ApexMoq.Arguments.HAVE_ANY_VALUE ).Returns(testAppraisalOrder);
        mockAppraisalOrderDataProvider.setup('getAppraisalOrderFromOREOId', ApexMoq.Arguments.HAVE_ANY_VALUE ).Returns(testAppraisalOrder);
        mockAppraisalOrderDataProvider.setup('getAppraisalOrderFromCollateralId', ApexMoq.Arguments.HAVE_ANY_VALUE ).Returns(testAppraisalOrder);
        mockAppraisalOrderComponentFactory.setup('getComponentFor',ApexMoq.Arguments.HAVE_ANY_VALUE).Returns(testComponent);
        mockAppraisalOrderComponentFactory.setup('getAppraisalOrderSummaryFieldDetailsList', ApexMoq.Arguments.HAVE_ANY_VALUE).Returns(componentFieldList);
        mockAppraisalOrderDataProvider.setup('collateralOwner', new List<Object>{testAppraisalOrder} ).Returns('collateralOwner');

        sut = new AppraisalOrderController(mockAppraisalOrderDataProvider, mockAppraisalOrderComponentFactory, mockApexPages);        
    }

    @IsTest
    static void it_should_call_the_default_constructor_without_error() {
        EB_Account__c oreo = new EB_Account__c();       
        insert oreo;
        ApexPages.currentPage().getParameters().put('accountId', oreo.Id);

        AppraisalOrderController sutDef = new AppraisalOrderController();
    }

    @IsTest
    static void it_should_call_the_default_constructor_for_collateral_without_error() {
        Collateral_Code__c testCollateralCode = new Collateral_Code__c(Collateral_Code_ID__c = 'AA');
        insert testCollateralCode;
        EB_Collateral__c testCollateral = new EB_Collateral__c(Collateral_Code__c = testCollateralCode.Id, Collateral_Code__r = testCollateralCode);
        testCollateral.Collateral_Owner__c=null;
        insert testCollateral;
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        testEntity.EB_Client_Name__c='testOwner';
        update testEntity;
        EB_Collateral_Client_Relationship__c testCollAcctRel = new EB_Collateral_Client_Relationship__c(EB_Collateral_ID__c = testCollateral.Id, Client_ID__c=testEntity.Id);
        insert testCollAcctRel;

        ApexPages.currentPage().getParameters().put('collateralId', testCollateral.Id);

        AppraisalOrderController sutDef = new AppraisalOrderController();
    }

    @IsTest
    static void it_should_get_a_componentobject_from_factory_when_appraisalorderdetails_is_called() {
        apexPages.Component returnedComponent = sut.AppraisalOrderDetails;

        mockAppraisalOrderComponentFactory.verify('getComponentFor',ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        system.assertEquals(testComponent, returnedComponent);
    }

    @IsTest
    static void it_should_have_a_value_for_collateral_owner_when_appraisal_order_is_tied_to_collateral() {
        system.assertEquals('collateralOwner', sut.Collateral_Owner);
    }

    @IsTest
    static void it_should_set_the_default_in_cost_center_to_value_from_appr_order() {
        system.assertEquals('1001 - testUnit',sut.dropdownCostCenterById);
    }

    @IsTest
    static void it_should_return_a_list_of_cost_centers() {
        EB_Unit__c testUnit1 = ObjectFactory.getUnit('name1', 1, '1001');
        EB_Unit__c testUnit2 = ObjectFactory.getUnit('name2', 2, '1002');
        EB_Unit__c testUnit3 = ObjectFactory.getUnit('name3', 3, '1003');
        List<EB_Unit__c> returnList = new List<EB_Unit__c>{testUnit1, testUnit2, testUnit3}; 
        mockAppraisalOrderDataProvider.setup('getCostCenters').Returns(returnList);

        List<SelectOption> costCentersReturned = sut.getCostCenters();

        mockAppraisalOrderDataProvider.verify('getCostCenters', Times.Once);
        System.assertEquals(4, costCentersReturned.size());
    }

    @IsTest
    static void it_should_save_the_appraisal_order_for_oreo_without_updating_submitted_flag() {   
        EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
        testAppraisalOrder.OREO_Account__c = oreo.Id;
        testAppraisalOrder.OREO_Account__r = oreo;
        testAppraisalOrder.Submit_Order__c = false;
        testAppraisalOrder.Order_Type__c = 'xx';
        testAppraisalOrder.Relationship_Manager__c = '005000000000000';
        testAppraisalOrder.Loan_Coordinator__c = '005000000000000';
        testAppraisalOrder.Date_Appraisal_Needed__c = Date.today();
        testAppraisalOrder.Tax_Increment_Financing_TIF__c = 'Yes';
        testAppraisalOrder.Tax_Credit_Involved__c = 'Yes';
        testAppraisalOrder.Appraisal_User_Other__c = 'Yes';
        testAppraisalOrder.OREO_Account__r.Inspection_Contact_Name__c = 'xx';
        testAppraisalOrder.OREO_Account__r.Inspection_Contact_Phone__c = 'xx';
        testAppraisalOrder.Appraisal_Order_Scope__c = 'xx';
        testAppraisalOrder.Property_Ownership__c = 'xx';
        testAppraisalOrder.Loan_Exceeds_2M__c = 'Yes';
        mockAppraisalOrderComponentFactory.setup('getComponentFieldValidationError',ApexMoq.Arguments.HAVE_ANY_VALUE).Returns('');

        sut.save();

        mockAppraisalOrderDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        system.assertEquals(false, sut.AppraisalOrder.Submit_Order__c);
        system.assert(sut.AppraisalOrder.OREO_Account__r.Appraisal_Order_Summary__c.contains('label1 - value1;'));
    }


    @IsTest
    static void it_should_save_the_appraisal_order_without_updating_submitted_flag_on_quicksave() {   
        EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
        testAppraisalOrder.OREO_Account__c = oreo.Id;
        testAppraisalOrder.OREO_Account__r = oreo;
        testAppraisalOrder.Submit_Order__c = false;
        testAppraisalOrder.Order_Type__c = 'xx';
        testAppraisalOrder.Relationship_Manager__c = '005000000000000';
        testAppraisalOrder.Loan_Coordinator__c = '005000000000000';
        testAppraisalOrder.Date_Appraisal_Needed__c = Date.today();
        testAppraisalOrder.Tax_Increment_Financing_TIF__c = 'Yes';
        testAppraisalOrder.Tax_Credit_Involved__c = 'Yes';
        testAppraisalOrder.Appraisal_User_Other__c = 'Yes';
        testAppraisalOrder.OREO_Account__r.Inspection_Contact_Name__c = 'xx';
        testAppraisalOrder.OREO_Account__r.Inspection_Contact_Phone__c = 'xx';
        testAppraisalOrder.Appraisal_Order_Scope__c = 'xx';
        testAppraisalOrder.Property_Ownership__c = 'xx';
        testAppraisalOrder.Loan_Exceeds_2M__c = 'Yes';
        mockAppraisalOrderComponentFactory.setup('getComponentFieldValidationError',ApexMoq.Arguments.HAVE_ANY_VALUE).Returns('');

        sut.quicksave();

        mockAppraisalOrderDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        system.assertEquals(false, sut.AppraisalOrder.Submit_Order__c);
        system.assert(sut.AppraisalOrder.OREO_Account__r.Appraisal_Order_Summary__c.contains('label1 - value1;'));
    }

    @IsTest
    static void it_should_save_the_appraisal_order_for_collateral_without_updating_submitted_flag() {   
        EB_Collateral__c coll = new EB_Collateral__c(Id='a0a000000000000');
        testAppraisalOrder.Related_Collateral__c = coll.Id;
        testAppraisalOrder.Related_Collateral__r = coll;
        testAppraisalOrder.Submit_Order__c = false;
        testAppraisalOrder.Order_Type__c = 'xx';
        testAppraisalOrder.Relationship_Manager__c = '005000000000000';
        testAppraisalOrder.Loan_Coordinator__c = '005000000000000';
        testAppraisalOrder.Date_Appraisal_Needed__c = Date.today();
        testAppraisalOrder.Tax_Increment_Financing_TIF__c = 'Yes';
        testAppraisalOrder.Tax_Credit_Involved__c = 'Yes';
        testAppraisalOrder.Appraisal_User_Other__c = 'Yes';
        testAppraisalOrder.Related_Collateral__r.Inspection_Contact_Name__c = 'xx';
        testAppraisalOrder.Related_Collateral__r.Inspection_Contact_Phone__c = 'xx';
        testAppraisalOrder.Appraisal_Order_Scope__c = 'xx';
        testAppraisalOrder.Property_Ownership__c = 'xx';
        testAppraisalOrder.Loan_Exceeds_2M__c = 'Yes';
        mockAppraisalOrderComponentFactory.setup('getComponentFieldValidationError',ApexMoq.Arguments.HAVE_ANY_VALUE).Returns('');

        sut.save();

        mockAppraisalOrderDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        system.assertEquals(false, sut.AppraisalOrder.Submit_Order__c);
        system.assert(sut.AppraisalOrder.Related_Collateral__r.Appraisal_Order_Summary__c.contains('label1 - value1;'));
    }

    @IsTest
    static void it_should_save_the_appraisal_order_for_collateral_and_update_submit_order_ckbox() {   
        EB_Collateral__c coll = new EB_Collateral__c(Id='a0a000000000000');
        testAppraisalOrder.Related_Collateral__c = coll.Id;
        testAppraisalOrder.Related_Collateral__r = coll;
        testAppraisalOrder.RM_Reviewed_OK_to_Order__c=true;
        testAppraisalOrder.Submit_Order__c = false;
        testAppraisalOrder.Order_Type__c = 'xx';
        testAppraisalOrder.Relationship_Manager__c = '005000000000000';
        testAppraisalOrder.Loan_Coordinator__c = '005000000000000';
        testAppraisalOrder.Date_Appraisal_Needed__c = Date.today();
        testAppraisalOrder.Tax_Increment_Financing_TIF__c = 'Yes';
        testAppraisalOrder.Tax_Credit_Involved__c = 'Yes';
     	testAppraisalOrder.Appraisal_User_Other__c = 'None-NA';
        testAppraisalOrder.Related_Collateral__r.Inspection_Contact_Name__c = 'xx';
        testAppraisalOrder.Related_Collateral__r.Inspection_Contact_Phone__c = 'xx';
        testAppraisalOrder.Appraisal_Order_Scope__c = 'xx';
        testAppraisalOrder.Property_Ownership__c = 'xx';
        testAppraisalOrder.Loan_Exceeds_2M__c = 'Yes';
        mockAppraisalOrderComponentFactory.setup('getComponentFieldValidationError',ApexMoq.Arguments.HAVE_ANY_VALUE).Returns('');

        sut.Submit();

        mockAppraisalOrderDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        system.assertEquals(true, sut.AppraisalOrder.Submit_Order__c);
    }

    @IsTest
    static void it_should_save_the_appraisal_order_for_collateral_when_save_and_submit_is_clicked_but_show_warning_and_not_submit_order_when_rm_reviewed_is_not_ckd() {   
        EB_Collateral__c coll = new EB_Collateral__c(Id='a0a000000000000');
        testAppraisalOrder.Related_Collateral__c = coll.Id;
        testAppraisalOrder.Related_Collateral__r = coll;
        testAppraisalOrder.RM_Reviewed_OK_to_Order__c=false;
        testAppraisalOrder.Submit_Order__c = false;
        testAppraisalOrder.Order_Type__c = 'xx';
        testAppraisalOrder.Relationship_Manager__c = '005000000000000';
        testAppraisalOrder.Loan_Coordinator__c = '005000000000000';
        testAppraisalOrder.Date_Appraisal_Needed__c = Date.today();
        testAppraisalOrder.Tax_Increment_Financing_TIF__c = 'Yes';
        testAppraisalOrder.Tax_Credit_Involved__c = 'Yes';
        testAppraisalOrder.Appraisal_User_Other__c = 'Yes';
        testAppraisalOrder.Related_Collateral__r.Inspection_Contact_Name__c = 'xx';
        testAppraisalOrder.Related_Collateral__r.Inspection_Contact_Phone__c = 'xx';
        testAppraisalOrder.Appraisal_Order_Scope__c = 'xx';
        testAppraisalOrder.Property_Ownership__c = 'xx';
        testAppraisalOrder.Loan_Exceeds_2M__c = 'Yes';
        mockAppraisalOrderComponentFactory.setup('getComponentFieldValidationError',ApexMoq.Arguments.HAVE_ANY_VALUE).Returns('');

        sut.saveAndSubmit();

        mockAppraisalOrderDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        system.assertEquals(false, sut.AppraisalOrder.Submit_Order__c);
        mockApexPages.verify('addMessage', new List<Object>{ApexPages.Severity.WARNING,'Appraisal order was saved, but not submitted. The "RM Reviewed/OK to Order" field must be checked before submitting this order.'}, Times.Once);
    }

    @IsTest
    static void it_should_not_save_the_appraisal_order_and_show_a_message_for_oreo_when_fieldValidation_fails() {   
        EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
        testAppraisalOrder.OREO_Account__c = oreo.Id;
        testAppraisalOrder.OREO_Account__r = oreo;
        testAppraisalOrder.Submit_Order__c = false;
       
        mockAppraisalOrderComponentFactory.setup('getComponentFieldValidationError',ApexMoq.Arguments.HAVE_ANY_VALUE).Returns('Error');
        sut.save();

        mockAppraisalOrderDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Never);
        mockApexPages.verify('addMessage', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_not_save_the_appraisal_order_and_show_a_message_for_collateral_when_fieldValidation_fails() {   
        EB_Collateral__c coll = new EB_Collateral__c(Id='a0a000000000000');
        testAppraisalOrder.Related_Collateral__c = coll.Id;
        testAppraisalOrder.Related_Collateral__r = coll;
        testAppraisalOrder.Submit_Order__c = false;
       
        mockAppraisalOrderComponentFactory.setup('getComponentFieldValidationError',ApexMoq.Arguments.HAVE_ANY_VALUE).Returns('Error');
        sut.save();

        mockAppraisalOrderDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Never);
        mockApexPages.verify('addMessage', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_not_show_the_rm_reviewed_warning_message_for_collateral_when_fieldValidation_fails() {   
        EB_Collateral__c coll = new EB_Collateral__c(Id='a0a000000000000');
        testAppraisalOrder.Related_Collateral__c = coll.Id;
        testAppraisalOrder.Related_Collateral__r = coll;
        testAppraisalOrder.Submit_Order__c = false;       
        mockAppraisalOrderComponentFactory.setup('getComponentFieldValidationError',ApexMoq.Arguments.HAVE_ANY_VALUE).Returns('Error');
        
        sut.saveAndSubmit();

        mockApexPages.verify('addMessage', new List<Object>{ApexPages.Severity.WARNING,'Appraisal order was saved, but not submitted. The "RM Reviewed/OK to Order" field must be checked before submitting this order.'}, Times.Never);
    }

    @IsTest
    static void it_should_save_the_appraisal_order_for_oreo_and_flag_as_submitted_and_create_snapshot() {   
        EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
        testAppraisalOrder.OREO_Account__c = oreo.Id;
        testAppraisalOrder.OREO_Account__r = oreo;
        testAppraisalOrder.Submit_Order__c = false;
        testAppraisalOrder.Order_Type__c = 'xx';
        testAppraisalOrder.Relationship_Manager__c = '005000000000000';
        testAppraisalOrder.Loan_Coordinator__c = '005000000000000';
        testAppraisalOrder.Date_Appraisal_Needed__c = Date.today();
        testAppraisalOrder.Tax_Increment_Financing_TIF__c = 'Yes';
        testAppraisalOrder.Tax_Credit_Involved__c = 'Yes';
        testAppraisalOrder.Appraisal_User_Other__c = 'Yes';
        testAppraisalOrder.OREO_Account__r.Inspection_Contact_Name__c = 'xx';
        testAppraisalOrder.OREO_Account__r.Inspection_Contact_Phone__c = 'xx';
        testAppraisalOrder.Appraisal_Order_Scope__c = 'xx';
        testAppraisalOrder.Property_Ownership__c = 'xx';
        testAppraisalOrder.Loan_Exceeds_2M__c = 'Yes';
        testAppraisalOrder.RM_Reviewed_OK_to_Order__c=true;
        mockAppraisalOrderComponentFactory.setup('getComponentFieldValidationError',ApexMoq.Arguments.HAVE_ANY_VALUE).Returns('');
       
        sut.Submit();
        sut.CreateSnapshot();

        mockAppraisalOrderDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        system.assertEquals(true, sut.AppraisalOrder.Submit_Order__c);
        mockAppraisalOrderDataProvider.verify('insertAttachment', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_save_the_appraisal_order_for_collateral_and_flag_as_submitted_and_create_snapshot() {   
        EB_Collateral__c coll = new EB_Collateral__c(Id='a0a000000000000');
        testAppraisalOrder.Related_Collateral__c = coll.Id;
        testAppraisalOrder.Related_Collateral__r = coll;
        testAppraisalOrder.Submit_Order__c = false;
        testAppraisalOrder.RM_Reviewed_OK_to_Order__c=true;
        testAppraisalOrder.Order_Type__c = 'xx';
        testAppraisalOrder.Relationship_Manager__c = '005000000000000';
        testAppraisalOrder.Loan_Coordinator__c = '005000000000000';
        testAppraisalOrder.Date_Appraisal_Needed__c = Date.today();
        testAppraisalOrder.Tax_Increment_Financing_TIF__c = 'Yes';
        testAppraisalOrder.Tax_Credit_Involved__c = 'Yes';
        testAppraisalOrder.Appraisal_User_Other__c = 'Yes';
        testAppraisalOrder.Related_Collateral__r.Inspection_Contact_Name__c = 'xx';
        testAppraisalOrder.Related_Collateral__r.Inspection_Contact_Phone__c = 'xx';
        testAppraisalOrder.Appraisal_Order_Scope__c = 'xx';
        testAppraisalOrder.Property_Ownership__c = 'xx';
        testAppraisalOrder.Loan_Exceeds_2M__c = 'Yes';
        mockAppraisalOrderComponentFactory.setup('getComponentFieldValidationError',ApexMoq.Arguments.HAVE_ANY_VALUE).Returns('');
       
        sut.Submit();
        sut.CreateSnapshot();

        mockAppraisalOrderDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        system.assertEquals(true, sut.AppraisalOrder.Submit_Order__c);
        mockAppraisalOrderDataProvider.verify('insertAttachment', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_save_changes_and_return_page_ref_to_appraisal_order_submit() {
        EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
        testAppraisalOrder.OREO_Account__c = oreo.Id;
        testAppraisalOrder.OREO_Account__r = oreo;
        testAppraisalOrder.Submit_Order__c = false;
        testAppraisalOrder.RM_Reviewed_OK_to_Order__c = true;
        testAppraisalOrder.Order_Type__c = 'xx';
        testAppraisalOrder.Relationship_Manager__c = '005000000000000';
        testAppraisalOrder.Loan_Coordinator__c = '005000000000000';
        testAppraisalOrder.Date_Appraisal_Needed__c = Date.today();
        testAppraisalOrder.Tax_Increment_Financing_TIF__c = 'Yes';
        testAppraisalOrder.Tax_Credit_Involved__c = 'Yes';
        testAppraisalOrder.Appraisal_User_Other__c = 'Yes';
        testAppraisalOrder.OREO_Account__r.Inspection_Contact_Name__c = 'xx';
        testAppraisalOrder.OREO_Account__r.Inspection_Contact_Phone__c = 'xx';
        testAppraisalOrder.Appraisal_Order_Scope__c = 'xx';
        testAppraisalOrder.Property_Ownership__c = 'xx';
        testAppraisalOrder.Loan_Exceeds_2M__c = 'Yes';
        mockAppraisalOrderComponentFactory.setup('getComponentFieldValidationError',ApexMoq.Arguments.HAVE_ANY_VALUE).Returns('');

        PageReference returnedRef = sut.saveAndSubmit();

        mockAppraisalOrderDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        system.assertEquals('/apex/AppraisalOrderSubmit?Id=' + String.valueOf(testAppraisalOrder.Id), returnedRef.getUrl());
    }

    @IsTest
    static void it_should_not_save_the_appraisal_order_for_oreo() {   
        EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
        testAppraisalOrder.OREO_Account__c = oreo.Id;
        testAppraisalOrder.OREO_Account__r = oreo;
        testAppraisalOrder.Submit_Order__c = false;
     
        sut.cancel();

        mockAppraisalOrderDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Never);
    }

    @IsTest
    static void it_should_not_save_the_appraisal_order_for_collateral() {   
        EB_Collateral__c coll = new EB_Collateral__c(Id='a0a000000000000');
        testAppraisalOrder.Related_Collateral__c = coll.Id;
        testAppraisalOrder.Related_Collateral__r = coll;
        testAppraisalOrder.Submit_Order__c = false;
     
        sut.cancel();

        mockAppraisalOrderDataProvider.verify('save', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Never);
    }

    @IsTest
    static void it_should_not_show_specify_appraisal_other_user() {
        EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
        testAppraisalOrder.Appraisal_User_Other__c = 'Small Business Administration';

        Boolean showAppraisalOtherUser = sut.showAppraisalOtherUser;

        system.assertEquals(false,showAppraisalOtherUser);
    }

    @IsTest
    static void it_should_show_specify_appraisal_other_user_when_participant_inst_is_selected() {
        EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
        testAppraisalOrder.Appraisal_User_Other__c = 'Participant Financial Institution / Other';

        Boolean showAppraisalOtherUser = sut.showAppraisalOtherUser;

        system.assertEquals(true,showAppraisalOtherUser);
    }

    @IsTest
    static void it_should_show_specify_appraisal_other_user_null() {
        EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
       
        Boolean showAppraisalOtherUser = sut.showAppraisalOtherUser;

        system.assertEquals(false,showAppraisalOtherUser);
    }
      
    @IsTest
    static void it_should_show_save_button() {
        EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
        testAppraisalOrder.Submit_Order__c = false;

        Boolean showSaveButton = sut.showSaveButton;

        system.assertEquals(true,showSaveButton);
    }

    @IsTest
    static void it_should_not_show_save_button(){
        EB_Account__c oreo = new EB_Account__c(Id='a02000000000000');
        testAppraisalOrder.Submit_Order__c = true;

        Boolean showSaveButton = sut.showSaveButton;

        system.assertEquals(false,showSaveButton);
    }

    private class MockofIAppraisalOrderComponentFactory extends ApexMoq implements AppraisalOrderComponentFactory.IAppraisalOrderComponentFactory{
        public ApexPages.Component getComponentFor(EB_Appraisal_Order__c appraisalOrder){
            return (ApexPages.Component)handleMethodInvocation('getComponentFor', new List<Object>{appraisalOrder});
        }
        public List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> getAppraisalOrderSummaryFieldDetailsList(EB_Appraisal_Order__c appraisalOrder){
            return (List<AppraisalOrders.AppraisalOrderSummaryFieldDetails>)handleMethodInvocation('getAppraisalOrderSummaryFieldDetailsList', new List<Object>{appraisalOrder});
        }
        public String getComponentFieldValidationError(EB_Appraisal_Order__c appraisalOrder){
            return (String)handleMethodInvocation('getComponentFieldValidationError', new List<Object>{appraisalOrder});
        }
    }

    private class MockofIAppraisalOrderDataProvider extends ApexMoq implements AppraisalOrderDataProvider.IAppraisalOrderDataProvider{
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
        public void insertAttachment(Attachment attach){
            handleMethodInvocation('insertAttachment', new List<Object>{attach});
        }
        public String collateralOwner(EB_Appraisal_Order__c appraisalOrder){
            return (String)handleMethodInvocation('collateralOwner', new List<Object>{appraisalOrder});
        }
        public List<EB_Unit__c> getCostCenters(){
            return (List<EB_Unit__c>)handleMethodInvocation('getCostCenters');
        }
    }
}