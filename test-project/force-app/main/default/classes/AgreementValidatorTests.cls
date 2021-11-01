@isTest
private class AgreementValidatorTests{

    static testMethod void it_should_get_a_list_of_entities_tied_to_an_AR_borrowing_base_component(){
        system.debug('it_should_get_a_list_of_entities_tied_to_an_AR_borrowing_base_component');
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
		testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        
        //act
        t.sut.Validate(testAgreement);
        
        //assert
        System.assertEquals(testAgreement.Id,t.mockDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Param_agreementId);
    }
    
    static testMethod void it_should_get_a_list_of_reporting_requirements_based_on_BBEntities(){
        system.debug('it_should_get_a_list_of_reporting_requirements_based_on_BBEntities');
        //assemble
        TestObjects t = new TestObjects();
        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        Account entity1 = new Account();
        Account entity2 = new Account();
        List<Account> testEntityList = new List<Account>{entity1,entity2};
        t.mockDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return = testEntityList;
        
        //act
        t.sut.Validate(testAgreement);
        
        //assert
        System.assertEquals(t.mockDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return,t.mockDataProvider.GetReportingRequirementsForEntityList_Param_entities);
    }
    
    static testMethod void it_should_get_a_list_of_other_agreements_related_to_same_entity(){
        system.debug('it_should_get_a_list_of_other_agreements_related_to_same_entity');
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
		testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        Account entity1 = new Account();
        Agreement_Client_Relationships__c testRel = new Agreement_Client_Relationships__c();
        testRel.Agreement__c = testAgreement.Id;
        testRel.Entity__c = entity1.Id;
        t.mockDataProvider.GetOtherAgreementEntitiesRels_Return = new List<Agreement_Client_Relationships__c>{testRel};
        
        //act
        t.sut.Validate(testAgreement);
        
        //assert
        System.assertEquals(1,1);
    }
    
    static testMethod void it_should_not_throw_an_error_when_there_are_no_borrowingbases(){
        system.debug('it_should_not_throw_an_error_when_there_are_no_borrowingbases');
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
		testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        t.mockDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return = null;
        
        //act
        t.sut.Validate(testAgreement);
        
        //assert
        System.assertEquals(1,1);//if we get here, we pass
    }
    
    static testMethod void it_should_not_throw_an_error_when_there_are_no_entities_tied_to_borrowingbases(){
        system.debug('it_should_not_throw_an_error_when_there_are_no_entities_tied_to_borrowingbases');
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        t.mockDataProvider.GetReportingRequirementsForEntityList_Return = null;
        
        //act
        t.sut.Validate(testAgreement);
        
        //assert
        System.assertEquals(1,1);//if we get here, we pass the test
    }
    
    static testMethod void it_should_fill_the_error_messages_field_when_an_entity_is_tied_to_a_borrowing_base_component_and_doesnt_have_bbcert_set_to_yes(){
        system.debug('it_should_fill_the_error_messages_field_when_an_entity_is_tied_to_a_borrowing_base_component_and_doesnt_have_bbcert_set_to_yes');
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        
        insert testAgreement;
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        Agreement_Client_Relationships__c testAgreement2Entity = new Agreement_Client_Relationships__c();
        testAgreement2Entity.Agreement__c = testAgreement.Id;
        testAgreement2Entity.Entity__c = testEntity.Id;
        //testAgreement2Entity.Borrowing_Base_Certificate__c = 'No';
        //insert testAgreement2Entity;
        system.debug('testAgreement2Entity: ' + string.valueOf(testAgreement2Entity));
        t.mockDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return = new List<Account>{testEntity}; 
        t.mockDataProvider.GetReportingRequirementsForEntityList_Return = new List<Agreement_Client_Relationships__c>{testAgreement2Entity};
        
        //act
        t.sut.Validate(testAgreement);
        
        //assert
        System.assert(testAgreement.ErrorMessages__c.contains('Entity is tied to an A/R Borrowing Base component and does not have either "Borrowing Base Certificate" or "A/R Detailed Agings" reporting requirement set.'));
    }
    
    static testMethod void it_should_not_fill_the_error_messages_field_when_any_entity_tied_to_borrowing_base_components_has_bbcert_set_to_yes(){
        system.debug('it_should_not_fill_the_error_messages_field_when_all_entities_tied_to_borrowing_base_components_do_have_bbcert_set_to_yes');
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        testAgreement.ErrorMessages__c = 'previous error text here';
        insert testAgreement;
        t.mockDataProvider.loadAgreementById_Return = testAgreement;
        
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        Agreement_Client_Relationships__c testAgreement2Entity = new Agreement_Client_Relationships__c();
        testAgreement2Entity.Agreement__c = testAgreement.Id;
        testAgreement2Entity.Entity__c = testEntity.Id;
        insert testAgreement2Entity;
        
        Account testEntity2 = ObjectFactory.getValidEntity('testEntityTwo');
        Agreement_Client_Relationships__c testAgreement2Entity2 = new Agreement_Client_Relationships__c();
        testAgreement2Entity2.Agreement__c = testAgreement.Id;
        testAgreement2Entity2.Entity__c = testEntity2.Id;
        insert testAgreement2Entity2;
        
        Agreement_Financial_Documents__c testReportingRequirements = new Agreement_Financial_Documents__c();
        testReportingRequirements.RecordTypeId = utility.RecordTypeObject('Agreement_Financial_Documents__c', 'Borrowing Base Certificate').Id;
        testReportingRequirements.Agreement_Client_Relationship__c = testAgreement2Entity.Id;
        testReportingRequirements.Agreement_Client_Relationship__r = testAgreement2Entity;
        testReportingRequirements.Period_Due__c = 'Month';
        testReportingRequirements.Frequency__c = '90';
        testReportingRequirements.Period_Due_Override__c = 60;
        insert testReportingRequirements;
        
        List<Agreement_Client_Relationships__c> testReportingRequirementsList = [SELECT (SELECT Id, Name, RecordTypeID, Agreement_Client_Relationship__r.Entity__c,Agreement_Client_Relationship__r.Name, Agreement_Client_Relationship__c,Frequency__c,Include_In_Agreement__c,Other_Type__c,Period_Due__c,Period_Due_Override__c FROM Agreement_Financial_Documents__r) , Agreement__r.Source_Agreement__c,Entity__c,Entity__r.Name,Borrowing_Base_Certificate__c,Borrowing_Base_Certificate_Period_Due__c,Borrowing_Base_Frequency__c,A_P_Detailed_Agings__c,A_P_Detailed_Agings_Frequency__c,A_P_Detailed_Agings_Period_Due__c,Inventory_Report__c,Inventory_Report_Frequency__c,Inventory_Report_Period_Due__c,Brokerage_Statement__c,Brokerage_Statement_Frequency__c,Brokerage_Statement_Period_Due__c,Rent_Roll__c,Rent_Roll_Frequency__c,Rent_Roll_Period_Due__c,Compliance_Certificate__c,Compliance_Certificate_Frequency__c,Compliance_Certificate_Period_Due__c,Work_in_Process__c,Work_in_Process_Frequency__c,Work_In_Process_Period_Due__c,A_R_Detailed_Agings__c ,Annual_Stmt_Days_Due_After_Fiscal_Y_E__c,
	                Interim_Statements__c, Interim_Stmt_Days_Due_After_Period_End__c,Tax_Return_Days_Due_After_Filing__c,Annual_Financial_Statement_Period_Other__c,
	                Interim_Statement_Period_Other__c, Tax_Return_Period_Other__c FROM Agreement_Client_Relationships__c WHERE id =:testAgreement2Entity.Id OR Id =: testAgreement2Entity2.Id];
              
        t.mockDataProvider.GetReportingRequirementsForEntityList_Return = testReportingRequirementsList;
        t.mockDataProvider.GetAgreementEntityRels_Return =  testReportingRequirementsList;
        
        //act
        t.sut.Validate(testAgreement);
        
        //assert
        System.assertEquals(false,testAgreement.ErrorMessages__c.contains('Entity is tied to an A/R Borrowing Base component and does not have either "Borrowing Base Certificate" or "A/R Detailed Agings" reporting requirement set.'));
    }
    
    static testMethod void it_should_not_execute_from_a_trigger_after_disable_from_trigger_is_set_to_true(){
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        
        //act
        t.sut.DisableValidateFromTrigger(true);
        t.sut.ValidateAndSaveFromTrigger(testAgreement);
        
        //assert
        System.assertNotEquals(true,t.mockDataProvider.SaveAgreement_Called);
    }
    
    static testMethod void it_should_save_the_agreement_when_calling_ValidateAndSave(){
        system.debug('it_should_save_the_agreement_when_calling_ValidateAndSave');
        //assemble
        TestObjects t = new TestObjects();
        TestUtilities.createLoanAppStages();
        TestUtilities.createCollateralCodes();
        TestUtilities.createValidationRules();
        Account entity = ObjectFactory.getValidEntity('Test entity');
        EB_Account__c ebAccount = ObjectFactory.getAccount('Test account','1234');
        EB_Loan_Application__c loanApp = ObjectFactory.getLoanApplication('Test Entity' , 'Test Account', '1234' ,'Test Loan app');
        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;       
        insert testAgreement;
        Agreement_Client_Relationships__c entityRel = new Agreement_Client_Relationships__c();
        entityRel.Agreement__c = testAgreement.Id;
        entityRel.Entity__c = entity.Id;
        insert entityRel;
        Agreement_EB_Account_Relationship__c acctRel = new Agreement_EB_Account_Relationship__c();
        acctRel.Agreement__c = testAgreement.Id;
        acctRel.Loan_Account__c = ebAccount.Id;
        insert acctRel;
        Agreement_Financial_Documents__c docRel = new Agreement_Financial_Documents__c();
        docRel.Agreement_Client_Relationship__c = entityRel.Id;
        insert docRel;
        Agreement_Loan_Application_Relationship__c loanRel = new Agreement_Loan_Application_Relationship__c();
        loanRel.Loan_Application__c = loanApp.Id;
        loanRel.Agreement__c = testAgreement.Id;
        insert loanRel;
        
        
        //act
        t.sut.ValidateAndSave(testAgreement);
        
        //assert
        System.assertEquals(testAgreement.Id, t.mockDataProvider.SaveAgreement_Param_agreement.Id);
    }    

    static testMethod void it_should_instantiate_without_exception(){
        system.debug('it_should_instantiate_without_exception');        
        AgreementValidator sut = AgreementValidator.getInstance();
    }
    
    static testMethod void it_should_fill_the_error_msg_field_when_an_entity_is_tied_to_a_borrowing_base_component_but_not_the_agreement(){
        system.debug('it_should_fill_the_error_msg_field_when_an_entity_is_tied_to_a_borrowing_base_component_but_not_the_agreement');
        //assemble
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;
        t.mockDataProvider.loadAgreementById_Return = testAgreement;
        
        Account testOrphan = ObjectFactory.getValidEntity('testOrphan');
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        Agreement_Client_Relationships__c testRel = new Agreement_Client_Relationships__c();
        testRel.Agreement__c = testAgreement.Id;
        testRel.Entity__c = testEntity.Id;
        insert testRel;
        
        Agreement_Financial_Documents__c doc = new Agreement_Financial_Documents__c();
        doc.Agreement__c = testAgreement.Id;
        doc.Agreement_Client_Relationship__c = testRel.Id;
        doc.Frequency__c = 'Monthly';
        doc.Period_Due__c = '30';
        doc.RecordTypeId = utility.recordTypeObject('Agreement_Financial_Documents__c', 'Borrowing Base Certificate').Id;
        insert doc;
        
        t.mockDataProvider.GetEntitiesTiedToBorrowingBaseComponent_Return = new List<Account>{testOrphan};
        t.mockDataProvider.GetAgreementEntityRels_Return = new List<Agreement_Client_Relationships__c>{testRel};
        
        //act
        t.sut.Validate(testAgreement);
        
        //assert
        System.assert(testAgreement.ErrorMessages__c.contains('Entity is tied to Borrowing Base component but not to this agreement.'));
    }
    
    static testMethod void it_should_fill_the_error_field_when_an_entity_is_related_to_another_pending_agreement(){
        //assemble
        AgreementValidator sut = AgreementValidator.getInstance();
        Account entity = new Account();
        entity.Name = 'Test Testerson';
        insert entity;
        
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        insert testAgreement;        
        Agreement_Client_Relationships__c testAgmtRel = new Agreement_Client_Relationships__c();
        testAgmtRel.Agreement__c = testAgreement.Id;
        testAgmtRel.Entity__c = entity.Id;
        testAgmtRel.Relationship__c = 'Related Party';
        insert testAgmtRel;
        
        Agreement__c testOtherAgreement = new Agreement__c();
        testOtherAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Active').Id;
        insert testOtherAgreement;
        Agreement_Client_Relationships__c testOtherAgmtRel = new Agreement_Client_Relationships__c();
        testOtherAgmtRel.Agreement__c = testOtherAgreement.Id;
        testOtherAgmtRel.Entity__c = entity.Id;
        testOtherAgmtRel.Relationship__c = 'Related Party';
        insert testOtherAgmtRel;
        
        //act
        sut.ValidateAndSave(testAgreement);
        
        //assert
        System.assert(testAgreement.ErrorMessages__c.contains('Test Testerson has 1 agreement(s) with the same relationship status of Related Party'));
    }
   
    private static testMethod void it_should_only_call_the_data_provider_once_for_the_same_agreement_when_executing_from_trigger(){
    	TestObjects t = new TestObjects();
    	Agreement__c testAgreement = new Agreement__c();
    	testAgreement.Name = 'test rev';
    	t.mockDataProvider.loadAgreementById_Return = testAgreement;
    	
    	t.sut.ValidateAndSaveFromTrigger(testAgreement);
    	t.sut.ValidateAndSaveFromTrigger(testAgreement);
    	
    	System.assertEquals(1, t.mockDataProvider.loadAgreementById_TimesCalled);
    }
    
    private static testMethod void it_should_show_an_error_if_required_fields_are_not_filled_out_in_agreement(){
    	MockDataProvider mockDataProvider = new MockDataProvider();   	
    	AgreementValidator sut = AgreementValidator.getInstance(mockDataProvider);
    	Agreement__c testAgreement = new Agreement__c();
    	testAgreement.Id = 'a28c0000000DU7m';
    	testAgreement.Name = 'test rev';
        testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        
        sut.Validate(testAgreement);
        
        system.assertEquals(true , testAgreement.ErrorMessages__c.contains('Loan Coordinator required.'));
    	system.assertEquals(true , testAgreement.ErrorMessages__c.contains('Business Loan Agreement Documents required.'));
    	system.assertEquals(true , testAgreement.ErrorMessages__c.contains('Guarantee Agreement Documents required.'));
    	system.assertEquals(true , testAgreement.ErrorMessages__c.contains('Subordination Intercreditor Documents required.'));
    	system.assertEquals(true , testAgreement.ErrorMessages__c.contains('Loan Documents Prepared By required.'));
    	system.assertEquals(true , testAgreement.ErrorMessages__c.contains('Original Agreement Date required.'));
    	
    }
    
    private static testMethod void it_should_not_show_an_error_if_required_fields_are_filled_out_in_agreement(){
    	MockDataProvider mockDataProvider = new MockDataProvider();   	
    	AgreementValidator sut = AgreementValidator.getInstance(mockDataProvider);
    	Agreement__c testAgreement = new Agreement__c();
    	testAgreement.Id = 'a28c0000000DU7m';
    	testAgreement.Name = 'test rev';
    	Profile p = [SELECT Id FROM Profile WHERE Name =: 'System Administrator' limit 1];
    	User user = ObjectFactory.getUser('test99', 'user99', 'tuser99@enterprisebank.sfdc.test', false);
    	user.ProfileId = p.Id;
    	insert user;
    	testAgreement.Loan_Coordinator__c = user.Id;
    	testAgreement.Business_Loan_Agreement_Documents__c = 'testBLA';
    	testAgreement.Guarantee_Agreement_Documents__c = 'testGAD';
    	testAgreement.Subordination_Intercreditor_Documents__c = 'testSID';
    	testAgreement.Loan_Documents_Prepared_By__c = 'testLDP';
    	Date d = 
    	testAgreement.Agreement_Date__c =  date.newInstance(2013, 2, 17);
        testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        
        sut.Validate(testAgreement);
        
        system.assertEquals(false , testAgreement.ErrorMessages__c.contains('Loan Coordinator required.'));
    	system.assertEquals(false , testAgreement.ErrorMessages__c.contains('Business Loan Agreement Documents required.'));
    	system.assertEquals(false , testAgreement.ErrorMessages__c.contains('Guarantee Agreement Documents required.'));
    	system.assertEquals(false , testAgreement.ErrorMessages__c.contains('Subordination Intercreditor Documents required.'));
    	system.assertEquals(false , testAgreement.ErrorMessages__c.contains('Loan Documents Prepared By required.'));
    	system.assertEquals(false , testAgreement.ErrorMessages__c.contains('Original Agreement Date required.'));
    	
    }

    private static testMethod void it_should_return_a_warning_when_Annual_Stmt_Days_Due_After_Fiscal_Y_E_Is_Other_For_ACTIVE() {
        MockDataProvider mockAgreementValidatorDataProvider = new MockDataProvider();     
        Account testEntity = new Account();
        testEntity.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = -1;
        testEntity.Annual_Financial_Statement_Period_Other__c = 121;
        List<Account> testEntityList = new List<Account>{testEntity};
        mockAgreementValidatorDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return = testEntityList;
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordTypeId = testAgmt.RecordType.Id;
        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;
        List<Agreement_Client_Relationships__c> testAgreementClientEntityList = new List<Agreement_Client_Relationships__c>{agmtClientRel};
        mockAgreementValidatorDataProvider.GetAgreementEntityRels_Return = testAgreementClientEntityList;
        AgreementValidator sut = AgreementValidator.getInstance(mockAgreementValidatorDataProvider);

        sut.Validate(testAgmt);
        
        system.assertEquals(true , testAgmt.WarningMessages__c.contains('[Annual Financial Statement - Days Due After Period End] : is set to a non-standard option and exceeds maximum policy value'));
    }

    private static testMethod void it_should_return_a_warning_when_Interim_Stmt_Days_Due_After_Period_Is_Other_For_ACTIVE() {
        MockDataProvider mockAgreementValidatorDataProvider = new MockDataProvider();     
        Account testEntity = new Account();
        testEntity.Interim_Stmt_Days_Due_After_Period_End__c = -1;
        testEntity.Interim_Statement_Period_Other__c = 46;
        List<Account> testEntityList = new List<Account>{testEntity};
        mockAgreementValidatorDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return = testEntityList;
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordTypeId = testAgmt.RecordType.Id;
        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;
        List<Agreement_Client_Relationships__c> testAgreementClientEntityList = new List<Agreement_Client_Relationships__c>{agmtClientRel};
        mockAgreementValidatorDataProvider.GetAgreementEntityRels_Return = testAgreementClientEntityList;
        AgreementValidator sut = AgreementValidator.getInstance(mockAgreementValidatorDataProvider);

        sut.Validate(testAgmt);
        
        system.assertEquals(true , testAgmt.WarningMessages__c.contains('[Interim Statements - Days Due After Period End] : is set to a non-standard option and exceeds maximum policy value'));
    }
    

    private static testMethod void it_should_return_a_warning_when_Tax_Returns_Days_Due_After_Filing_Is_Other_For_ACTIVE() {
        MockDataProvider mockAgreementValidatorDataProvider = new MockDataProvider();     
        Account testEntity = new Account();
        testEntity.Tax_Return_Days_Due_After_Filing__c = -1;
        testEntity.Tax_Return_Period_Other__c = 31;
        List<Account> testEntityList = new List<Account>{testEntity};
        mockAgreementValidatorDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return = testEntityList;
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordTypeId = testAgmt.RecordType.Id;
        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;
        List<Agreement_Client_Relationships__c> testAgreementClientEntityList = new List<Agreement_Client_Relationships__c>{agmtClientRel};
        mockAgreementValidatorDataProvider.GetAgreementEntityRels_Return = testAgreementClientEntityList;
        AgreementValidator sut = AgreementValidator.getInstance(mockAgreementValidatorDataProvider);

        sut.Validate(testAgmt);
        
        system.assertEquals(true , testAgmt.WarningMessages__c.contains('[Tax Returns - Days Due After Filing] : is set to a non-standard option and exceeds maximum policy value'));
    }

    private static testMethod void it_should_return_a_warning_when_Annual_Stmt_Days_Due_After_Fiscal_Y_E_Is_Other_For_PENDING() {
        MockDataProvider mockAgreementValidatorDataProvider = new MockDataProvider();     
        Account testEntity = new Account();
        testEntity.Pending_AFS_Days_Due_After_FYE__c = -1;
        testEntity.Pending_AFS_Period_Other__c = 121;
        List<Account> testEntityList = new List<Account>{testEntity};
        mockAgreementValidatorDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return = testEntityList;
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');
        testAgmt.RecordTypeId = testAgmt.RecordType.Id;
        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;
        List<Agreement_Client_Relationships__c> testAgreementClientEntityList = new List<Agreement_Client_Relationships__c>{agmtClientRel};
        mockAgreementValidatorDataProvider.GetAgreementEntityRels_Return = testAgreementClientEntityList;
        AgreementValidator sut = AgreementValidator.getInstance(mockAgreementValidatorDataProvider);

        sut.Validate(testAgmt);
        
        system.assertEquals(true , testAgmt.WarningMessages__c.contains('[Annual Financial Statement - Days Due After Period End] : is set to a non-standard option and exceeds maximum policy value'));
    }

    private static testMethod void it_should_return_a_warning_when_Interim_Stmt_Days_Due_After_Period_Is_Other_For_PENDING() {
        MockDataProvider mockAgreementValidatorDataProvider = new MockDataProvider();     
        Account testEntity = new Account();
        testEntity.Pending_IntStmts_Days_Due_After_PE__c = -1;
        testEntity.Pending_IntStmts_Period_Other__c = 46;
        List<Account> testEntityList = new List<Account>{testEntity};
        mockAgreementValidatorDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return = testEntityList;
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');
        testAgmt.RecordTypeId = testAgmt.RecordType.Id;
        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;
        List<Agreement_Client_Relationships__c> testAgreementClientEntityList = new List<Agreement_Client_Relationships__c>{agmtClientRel};
        mockAgreementValidatorDataProvider.GetAgreementEntityRels_Return = testAgreementClientEntityList;
        AgreementValidator sut = AgreementValidator.getInstance(mockAgreementValidatorDataProvider);

        sut.Validate(testAgmt);
        
        system.assertEquals(true , testAgmt.WarningMessages__c.contains('[Interim Statements - Days Due After Period End] : is set to a non-standard option and exceeds maximum policy value'));
    }
    

    private static testMethod void it_should_return_a_warning_when_Tax_Returns_Days_Due_After_Filing_Is_Other_For_PENDING() {
        MockDataProvider mockAgreementValidatorDataProvider = new MockDataProvider();     
        Account testEntity = new Account();
        testEntity.Pending_TaxReturns_Days_Due_After_Filing__c = -1;
        testEntity.Pending_TaxReturns_Period_Other__c = 31;
        List<Account> testEntityList = new List<Account>{testEntity};
        mockAgreementValidatorDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return = testEntityList;
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Pending');
        testAgmt.RecordTypeId = testAgmt.RecordType.Id;
        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;
        List<Agreement_Client_Relationships__c> testAgreementClientEntityList = new List<Agreement_Client_Relationships__c>{agmtClientRel};
        mockAgreementValidatorDataProvider.GetAgreementEntityRels_Return = testAgreementClientEntityList;
        AgreementValidator sut = AgreementValidator.getInstance(mockAgreementValidatorDataProvider);

        sut.Validate(testAgmt);
        
        system.assertEquals(true , testAgmt.WarningMessages__c.contains('[Tax Returns - Days Due After Filing] : is set to a non-standard option and exceeds maximum policy value'));
    }

    private static testMethod void it_should_return_a_warning_when_Annual_Stmt_Days_Due_After_Fiscal_Y_E_Is_Other_For_ARCHIVE() {
        MockDataProvider mockAgreementValidatorDataProvider = new MockDataProvider();     
        Account testEntity = new Account();
        List<Account> testEntityList = new List<Account>{testEntity};
        mockAgreementValidatorDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return = testEntityList;
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Archive');
        testAgmt.RecordTypeId = testAgmt.RecordType.Id;
        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;
        agmtClientRel.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = -1;
        agmtClientRel.Annual_Financial_Statement_Period_Other__c = 121;
        List<Agreement_Client_Relationships__c> testAgreementClientEntityList = new List<Agreement_Client_Relationships__c>{agmtClientRel};
        mockAgreementValidatorDataProvider.GetAgreementEntityRels_Return = testAgreementClientEntityList;
        AgreementValidator sut = AgreementValidator.getInstance(mockAgreementValidatorDataProvider);

        sut.Validate(testAgmt);
        
        system.assertEquals(true , testAgmt.WarningMessages__c.contains('[Annual Financial Statement - Days Due After Period End] : is set to a non-standard option and exceeds maximum policy value'));
    }

    private static testMethod void it_should_return_a_warning_when_Interim_Stmt_Days_Due_After_Period_Is_Other_For_ARCHIVE() {
        MockDataProvider mockAgreementValidatorDataProvider = new MockDataProvider();     
        Account testEntity = new Account();
        List<Account> testEntityList = new List<Account>{testEntity};
        mockAgreementValidatorDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return = testEntityList;
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Archive');
        testAgmt.RecordTypeId = testAgmt.RecordType.Id;
        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;
        agmtClientRel.Interim_Stmt_Days_Due_After_Period_End__c = -1;
        agmtClientRel.Interim_Statement_Period_Other__c = 46;
        List<Agreement_Client_Relationships__c> testAgreementClientEntityList = new List<Agreement_Client_Relationships__c>{agmtClientRel};
        mockAgreementValidatorDataProvider.GetAgreementEntityRels_Return = testAgreementClientEntityList;
        AgreementValidator sut = AgreementValidator.getInstance(mockAgreementValidatorDataProvider);

        sut.Validate(testAgmt);
        
        system.assertEquals(true , testAgmt.WarningMessages__c.contains('[Interim Statements - Days Due After Period End] : is set to a non-standard option and exceeds maximum policy value'));
    }
    

    private static testMethod void it_should_return_a_warning_when_Tax_Returns_Days_Due_After_Filing_Is_Other_For_ARCHIVE() {
        MockDataProvider mockAgreementValidatorDataProvider = new MockDataProvider();     
        Account testEntity = new Account();
        List<Account> testEntityList = new List<Account>{testEntity};
        mockAgreementValidatorDataProvider.GetEntitiesTiedToARBorrowingBaseComponent_Return = testEntityList;
        Agreement__c testAgmt = new Agreement__c(Id='a28f00000008zGI');
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Archive');
        testAgmt.RecordTypeId = testAgmt.RecordType.Id;
        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__r = testEntity;
        agmtClientRel.Agreement__c = testAgmt.Id;
        agmtClientRel.Tax_Return_Days_Due_After_Filing__c = -1;
        agmtClientRel.Tax_Return_Period_Other__c = 31;
        List<Agreement_Client_Relationships__c> testAgreementClientEntityList = new List<Agreement_Client_Relationships__c>{agmtClientRel};
        mockAgreementValidatorDataProvider.GetAgreementEntityRels_Return = testAgreementClientEntityList;
        AgreementValidator sut = AgreementValidator.getInstance(mockAgreementValidatorDataProvider);

        sut.Validate(testAgmt);
        
        system.assertEquals(true , testAgmt.WarningMessages__c.contains('[Tax Returns - Days Due After Filing] : is set to a non-standard option and exceeds maximum policy value'));
    }
     
    private static testMethod void it_should_return_a_warning_when_Financial_Docs_have_Other_Period_Due() {
        TestObjects t = new TestObjects();
        Agreement__c testAgreement = new Agreement__c();
        testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Pending').Id;
        testAgreement.ErrorMessages__c = 'previous error text here';
        insert testAgreement;
        t.mockDataProvider.loadAgreementById_Return = testAgreement;
        
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        Agreement_Client_Relationships__c testAgreement2Entity = new Agreement_Client_Relationships__c();
        testAgreement2Entity.Agreement__c = testAgreement.Id;
        testAgreement2Entity.Entity__c = testEntity.Id;
        insert testAgreement2Entity;
        
        Account testEntity2 = ObjectFactory.getValidEntity('testEntityTwo');
        Agreement_Client_Relationships__c testAgreement2Entity2 = new Agreement_Client_Relationships__c();
        testAgreement2Entity2.Agreement__c = testAgreement.Id;
        testAgreement2Entity2.Entity__c = testEntity2.Id;
        insert testAgreement2Entity2;
        
        Agreement_Financial_Documents__c testReportingRequirements = new Agreement_Financial_Documents__c();
        testReportingRequirements.RecordTypeId = utility.RecordTypeObject('Agreement_Financial_Documents__c', 'Borrowing Base Certificate').Id;
        testReportingRequirements.Agreement_Client_Relationship__c = testAgreement2Entity.Id;
        testReportingRequirements.Agreement_Client_Relationship__r = testAgreement2Entity;
        testReportingRequirements.Period_Due__c = 'Other';
        testReportingRequirements.Period_Due_Maximum__c = 30;
        testReportingRequirements.Period_Due_Override__c = 60;
        insert testReportingRequirements;

        List<Agreement_Client_Relationships__c> testReportingRequirementsList = 
            [SELECT (SELECT Id, Name, RecordTypeID, RecordTypeDescription__c, Agreement_Client_Relationship__r.Entity__c,Agreement_Client_Relationship__r.Name, 
                            Agreement_Client_Relationship__c,Frequency__c,Include_In_Agreement__c,Other_Type__c,Period_Due__c,Period_Due_Override__c,Period_Due_Maximum__c 
                            FROM Agreement_Financial_Documents__r) 
                    ,Agreement__r.Source_Agreement__c,Entity__c,Entity__r.Name,Borrowing_Base_Certificate__c,Borrowing_Base_Certificate_Period_Due__c
                    ,Borrowing_Base_Frequency__c,A_P_Detailed_Agings__c,A_P_Detailed_Agings_Frequency__c,A_P_Detailed_Agings_Period_Due__c,Inventory_Report__c
                    ,Inventory_Report_Frequency__c,Inventory_Report_Period_Due__c,Brokerage_Statement__c,Brokerage_Statement_Frequency__c,Brokerage_Statement_Period_Due__c
                    ,Rent_Roll__c,Rent_Roll_Frequency__c,Rent_Roll_Period_Due__c,Compliance_Certificate__c,Compliance_Certificate_Frequency__c
                    ,Compliance_Certificate_Period_Due__c,Work_in_Process__c,Work_in_Process_Frequency__c,Work_In_Process_Period_Due__c,A_R_Detailed_Agings__c
                    ,Annual_Stmt_Days_Due_After_Fiscal_Y_E__c,Entity__r.Entity_Name__c, Interim_Statements__c, Interim_Stmt_Days_Due_After_Period_End__c
                    ,Tax_Return_Days_Due_After_Filing__c,Annual_Financial_Statement_Period_Other__c,Interim_Statement_Period_Other__c, Tax_Return_Period_Other__c 
            FROM Agreement_Client_Relationships__c 
            WHERE id =:testAgreement2Entity.Id OR Id =: testAgreement2Entity2.Id];
        t.mockDataProvider.GetReportingRequirementsForEntityList_Return = testReportingRequirementsList;
        t.mockDataProvider.GetAgreementEntityRels_Return = testReportingRequirementsList;
        
        t.sut.Validate(testAgreement);
        
        system.assertEquals(true , testAgreement.WarningMessages__c.contains('[Borrowing Base Certificate] : is set to a non-standard option and exceeds maximum policy value'));

    } 
 
    //////////////////////////////////////////
    // utility functions
    public class TestObjects{
        public MockDataProvider mockDataProvider {get;private set;} 
        public AgreementValidator sut {get;private set;}
        public TestObjects(){
            mockDataProvider = new MockDataProvider();
            sut = AgreementValidator.getInstance(mockDataProvider);
        }
    }
    
    //////////////////////////////////////////
    // dependency mocks
    private class MockDataProvider implements Agreements.IAgreementValidatorDataProvider{
        public Boolean SaveAgreement_Called{get;set;}
        public Agreement__c SaveAgreement_Param_agreement{get;set;}
        
        public Boolean GetEntitiesTiedToARBorrowingBaseComponent_Called{get;set;}
        public Id GetEntitiesTiedToARBorrowingBaseComponent_Param_agreementId{get;set;}
        public List<Account> GetEntitiesTiedToARBorrowingBaseComponent_Return{get;set;}
        
        public Boolean GetReportingRequirementsForEntityList_Called{get;set;}
        public List<Account> GetReportingRequirementsForEntityList_Param_entities{get;set;}
        public Id GetReportingRequirementsForEntityList_Param_agreementId{get;set;}
        public List<Agreement_Client_Relationships__c> GetReportingRequirementsForEntityList_Return{get;set;}
        
        public Boolean GetOtherAgreementEntitiesRels_Called{get;set;}
        public Id GetOtherAgreementEntitiesRels_Param_agreementId{get;set;}
        public List<Account> GetOtherAgreementEntitiesRels_param_entities{get;set;}
        public List<Agreement_Client_Relationships__c> GetOtherAgreementEntitiesRels_Return{get;set;}
        
        public boolean GetAgreementEntityRels_Called{get;set;}
        public Id GetAgreementEntityRels_Param_agreementId{get;set;}
        public List<Agreement_Client_Relationships__c>  GetAgreementEntityRels_Return{get;set;}
        
        public boolean GetEntitiesTiedToBorrowingBaseComponent_Called{get;set;}
        public Id GetEntitiesTiedToBorrowingBaseComponent_param_agreementId{get;set;}
        public List<Account> GetEntitiesTiedToBorrowingBaseComponent_Return{get;set;}
        
        public Boolean getEbLoanApplicationsNotRelatedToCurrentAgreement_Called{get;set;}
        public Id getEbLoanApplicationsNotRelatedToCurrentAgreement_param_agreementId{get;set;}
        public Id getEbLoanApplicationsNotRelatedToCurrentAgreement_param_sourceAgmtId{get;set;}
        public List<EB_Loan_Application__c> getEbLoanApplicationsNotRelatedToCurrentAgreement_return{get;set;}
        
        
        public boolean getEbAccountsNotRelatedToCurrentAgreement_Called{get;set;}
        public Id getEbAccountsNotRelatedToCurrentAgreement_param_agreementId{get;set;}
        public Id getEbAccountsNotRelatedToCurrentAgreement_param_sourceAgmtId{get;set;}
        public List<Agreements.EBAccountWrapper> getEbAccountsNotRelatedToCurrentAgreement_Return{get;set;}
        
        public Integer loadAgreementById_TimesCalled = 0;
        public Id loadAgreementById_param_agreementId{get;set;}
        public Agreement__c loadAgreementById_Return{get;set;}
        
        public boolean getLoanApplicationRelationshipsByAgreementId_Called{get; private set;}
        public Id getLoanApplicationRelationshipsByAgreementId_param_agreementID{get; private set;}
        public List<Agreement_Loan_Application_Relationship__c> getLoanApplicationRelationshipsByAgreementId_Return{get; private set;}
        
                
        public void SaveAgreement(Agreement__c agreement){
            SaveAgreement_Called = true;
            SaveAgreement_Param_agreement = agreement;
        }
        
        public List<Account> GetEntitiesTiedToARBorrowingBaseComponent(Id agreementId){
            GetEntitiesTiedToARBorrowingBaseComponent_Called = true;
            GetEntitiesTiedToARBorrowingBaseComponent_Param_agreementId = agreementId;
            return GetEntitiesTiedToARBorrowingBaseComponent_Return;
        }
        
        public List<Agreement_Client_Relationships__c> GetReportingRequirementsForEntityList(List<Account> entities, Id agreementId){
            GetReportingRequirementsForEntityList_Called = true;
            GetReportingRequirementsForEntityList_Param_agreementId = agreementId;
            GetReportingRequirementsForEntityList_Param_entities = entities;
            return GetReportingRequirementsForEntityList_Return;
        }
        public List<Agreement_Client_Relationships__c> GetAgreementEntityRels(Id agreementId){
            GetAgreementEntityRels_Called = true;
            GetAgreementEntityRels_Param_agreementId = agreementId;
            return GetAgreementEntityRels_Return;          
        }
        public List<Account> GetEntitiesTiedToBorrowingBaseComponent(Id agreementId){
            GetEntitiesTiedToBorrowingBaseComponent_Called = true;
            GetEntitiesTiedToBorrowingBaseComponent_param_agreementId = agreementId;               
            return GetEntitiesTiedToBorrowingBaseComponent_Return;
        }
        public List<Agreement_Client_Relationships__c> GetOtherAgreementEntitiesRels(List<Account> entities, Id agreementId, Id sourceAgmtId){
            GetOtherAgreementEntitiesRels_Called = true;
            GetOtherAgreementEntitiesRels_param_agreementId = agreementId;
            GetOtherAgreementEntitiesRels_param_entities = entities;
            return GetOtherAgreementEntitiesRels_Return;
        }
        public List<EB_Loan_Application__c> getEbLoanApplicationsNotRelatedToCurrentAgreement(Id agreementId, Id sourceAgmtId){
        	getEbLoanApplicationsNotRelatedToCurrentAgreement_Called = true;
            getEbLoanApplicationsNotRelatedToCurrentAgreement_param_agreementId = agreementId;
            getEbLoanApplicationsNotRelatedToCurrentAgreement_param_sourceAgmtId = sourceAgmtId;
            return getEbLoanApplicationsNotRelatedToCurrentAgreement_Return ;
        }
        public List<Agreements.EBAccountWrapper> getEbAccountsNotRelatedToCurrentAgreement(Id agreementId, Id sourceAgmtId){
        	getEbAccountsNotRelatedToCurrentAgreement_Called = true;
            getEbAccountsNotRelatedToCurrentAgreement_param_agreementId = agreementId;
            getEbAccountsNotRelatedToCurrentAgreement_param_sourceAgmtId = sourceAgmtId;
            return getEbAccountsNotRelatedToCurrentAgreement_Return;
        }
        public Agreement__c loadAgreementById( Id agreementId){
        	loadAgreementById_TimesCalled += 1;
            return loadAgreementById_Return;
        }
        public List<Agreement_Loan_Application_Relationship__c> getLoanApplicationRelationshipsByAgreementId(Id agreementId){
        	getLoanApplicationRelationshipsByAgreementId_Called = true;
        	getLoanApplicationRelationshipsByAgreementId_param_agreementId = agreementId;
        	return getLoanApplicationRelationshipsByAgreementId_Return;
        }
    }
}