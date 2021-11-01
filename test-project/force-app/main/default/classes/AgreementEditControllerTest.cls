@isTest
private class AgreementEditControllerTest {

    /*private final static AgreementMock.ofIAgreementApprovalInfo mockInfo;
    private final static AgreementMock.ofIAgreementValidator mockValidator;
    private final static AgreementMock.ofIAgreementPicker mockPicker;
    private final static AgreementMock.ofIAgreementStatusManager mockStatusManager;

    static {
        mockInfo = new AgreementMock.ofIAgreementApprovalInfo();
        mockValidator = new AgreementMock.ofIAgreementValidator();
        mockPicker = new AgreementMock.ofIAgreementPicker();
        mockStatusManager = new AgreementMock.ofIAgreementStatusManager();
        sut = new AgreementEditController(mockInfo,  validator, mockPicker,  mockStatusManager);
    }*/

    static testMethod void verifyAgreementEditPageReferences_with_agreementId_as_param(){
        
    	String url = utility.getServerUrl()+ '/apex/AgreementEdit?id=';
        Account entity = ObjectFactory.getValidEntity('Test Entity');
    	Agreement__c agmt = new Agreement__c();
        agmt.Borrower_Name__c = entity.Id;
        agmt.Name = 'test agreement';
        insert agmt;
        PageReference pr = utility.testhelper(url + agmt.Id);
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(agmt);
        AgreementEditController testcontroller = new AgreementEditController(sc);
        PageReference psave  = testcontroller.SaveClicked();
        PageReference pCancel = testcontroller.CancelClicked();    
    }

    static testMethod void verifyAgreementEditPageReferences_with_null_as_param(){
        
    	String url = utility.getServerUrl()+ '/apex/AgreementEdit';
        Account entity = ObjectFactory.getValidEntity('Test Entity');
    	Agreement__c agmt = new Agreement__c();
        agmt.Borrower_Name__c = entity.Id;
        agmt.Name = 'test agreement';
        PageReference pr = utility.testhelper(url );
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(agmt);
        AgreementEditController testcontroller = new AgreementEditController(sc);
        PageReference psave  = testcontroller.SaveClicked();
        PageReference pCancel = testcontroller.CancelClicked();  
    }

    static testMethod void verifyAgreementEdit_get_methods_with_agreementId_as_param(){
        
    	String url = utility.getServerUrl()+ '/apex/AgreementEdit?id=';
        Account entity = ObjectFactory.getValidEntity('Test Entity');
    	Agreement__c agmt = new Agreement__c();
        agmt.Borrower_Name__c = entity.Id;
        agmt.Name = 'test agreement';
        insert agmt;
        PageReference pr = utility.testhelper(url + agmt.Id);
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(agmt);
        AgreementEditController testcontroller = new AgreementEditController(sc);
		String borrowername = testcontroller.BorrowerName;
        Agreement__c agmtObj = testcontroller.getAgreementmt();
        boolean agreementStatus = testcontroller.IsActiveAgreement;
        boolean workflowApprovalAccess = testcontroller.Is_OAI;
    }

    private static testMethod void it_should_verify_that_a_llc_loan_related_was_created_when_llc_query_parameter_is_passed() {
        String loanName = 'test loan Name';
        String agmtName = 'test agreement';
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.Name = loanName;
        loan.LLC_BI__Amount__c = 123.45;
        insert loan;   
        String url = utility.getServerUrl()+ '/apex/AgreementEdit?llcid='+ loan.Id;
        Account entity = ObjectFactory.getValidEntity('Test Entity');
        Agreement__c agmt = new Agreement__c();
        agmt.Borrower_Name__c = entity.Id;
        agmt.Borrower_Name__r = entity;
        agmt.Name = agmtName;
        PageReference pr = new PageReference(url);
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(agmt);
        AgreementEditController testcontroller = new AgreementEditController(sc);

        PageReference result  = testcontroller.SaveClicked();

        List<Agreement__c> requeryAgmts = [SELECT Id, Name FROM Agreement__c];
        String testUrl = ('/'+requeryAgmts[0].Id).mid(0,16);
        List<Agreement_LLC_BI_Loan_Relationship__c> requeryRels = [SELECT Id, LLCBI_Loan__c, LLCBI_Loan__r.Name, Agreement__c, Agreement__r.Name FROM Agreement_LLC_BI_Loan_Relationship__c WHERE LLCBI_Loan__c =: loan.Id];
        System.assertEquals(1, requeryAgmts.size());
        System.assertEquals(1, requeryRels.size());
        System.assertEquals(loanName, requeryRels[0].LLCBI_Loan__r.Name);
        System.assertEquals(requeryAgmts[0].Id, requeryRels[0].Agreement__c);
        System.assertEquals(requeryAgmts[0].Name, requeryRels[0].Agreement__r.Name);
        System.assertEquals(testUrl, result.getUrl());
    } 

    private static testMethod void code_coverage(){
        Agreement__c agmt = new Agreement__c();
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(agmt);
        AgreementEditController testcontroller = new AgreementEditController(sc);
        testcontroller.listAgmt = new List<Agreement__c>{new Agreement__c()};

        String e = testController.err;
        String p = testController.PrimaryBorrowerName;
        Id n = testController.newAgreementId; 
        Agreement__c a = testController.listAgmt[0]; 
        String d = testController.dropdownRecordTypeId;
        Boolean t = testController.test;
        String db = testController.dropdownBusinessDocumentsId;
        String dg = testController.dropdownGuaranteeDocumentsId;
        String ds = testController.dropdownSubordinationDocumentsId;
        String dl = testController.dropdownLoanDocumentsPreparedById;
        Boolean c = testController.canEditAgreement;
        Boolean u = testController.IsUpdate;
    } 
}