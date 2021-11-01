@IsTest
private class EbtDocManagerDataProviderTests {
    private final static EbtDocManagerDataProvider sut;
    
    private static Id objectId;
    
    static {
        objectId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        sut = new EbtDocManagerDataProvider();
    }
    
    private static testMethod void it_should_get_document_store_indexes_from_loan_documents() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(); 
        insert loan;
        LLC_BI__Document_Store__c docStore = new LLC_BI__Document_Store__c();
        insert docStore;
        LLC_BI__Document_Store_Index__c docIndex= new LLC_BI__Document_Store_Index__c();
        docIndex.LLC_BI__Document_Store__c = docStore.Id;
        insert docIndex;
        LLC_BI__LLC_LoanDocument__c loanDoc = new LLC_BI__LLC_LoanDocument__c();
        loanDoc.LLC_BI__Loan__c  = loan.Id;
        loanDoc.LLC_BI__Document_Store_Index__c = docIndex.Id;
        insert loanDoc;
        
        List<LLC_BI__Document_Store_Index__c> result = sut.getDocumentManagerLoanDocuments(loan.Id);
        
        system.assertEquals(1, result.size());
        system.assertEquals(docStore.Id, result[0].LLC_BI__Document_Store__c );
    }
    
    private static testMethod void it_should_get_document_store_indexes_from_entity_documents()
    {
        RecordType clientRecordType = Utility.recordTypeObject('Account','Client'); 
        Account entity = new Account(Name = 'test Account');
        entity.RecordTypeId = clientRecordType.Id;     
        insert entity;
        LLC_BI__Document_Store__c docStore = new LLC_BI__Document_Store__c();
        insert docStore;
        LLC_BI__Document_Store_Index__c docIndex= new LLC_BI__Document_Store_Index__c();
        docIndex.LLC_BI__Document_Store__c = docStore.Id;
        insert docIndex;
        LLC_BI__AccountDocument__c entityDoc = new LLC_BI__AccountDocument__c();
        entityDoc.LLC_BI__Account__c  = entity.Id;
        entityDoc.LLC_BI__Document_Store_Index__c = docIndex.Id;
        insert entityDoc;
        
        List<LLC_BI__Document_Store_Index__c> result = sut.getDocumentManagerEntityDocuments(entity.Id);
        
        system.assertEquals(1, result.size());
        system.assertEquals(docStore.Id, result[0].LLC_BI__Document_Store__c );
    }
    
    private static testMethod void it_should_get_document_store_indexes_from_collateral_documents()
    {
        LLC_BI__Collateral_Type__c collateralType = new LLC_BI__Collateral_Type__c();
        insert collateralType;
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
        collateral.LLC_BI__Collateral_Type__c = collateralType.Id;     
        insert collateral;
        LLC_BI__Document_Store__c docStore = new LLC_BI__Document_Store__c();
        insert docStore;
        LLC_BI__Document_Store_Index__c docIndex= new LLC_BI__Document_Store_Index__c();
        docIndex.LLC_BI__Document_Store__c = docStore.Id;
        insert docIndex;
        LLC_BI__Document_Placeholder__c collateralDoc = new LLC_BI__Document_Placeholder__c();
        collateralDoc.LLC_BI__External_Id__c  = collateral.Id;
        collateralDoc.LLC_BI__Document_Store_Index__c = docIndex.Id;
        insert collateralDoc;
        
        List<LLC_BI__Document_Store_Index__c> result = sut.getDocumentManagerCollateralDocuments(collateral.Id);
        
        System.assertEquals(1, result.size());
        System.assertEquals(docStore.Id, result[0].LLC_BI__Document_Store__c );
    }
    
    private static testMethod void it_should_insert_an_object() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
                
        sut.save(new List<SObject>{ loan });
        
        System.assertNotEquals(null, loan.Id);
    }
    
    private static testMethod void it_should_update_an_object() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        insert loan;
                
        sut.save(new List<SObject>{ loan });
        
        System.assertNotEquals(null, loan.Id);
    }
    
    private static testMethod void it_should_get_a_loan() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        insert loan;
                
        LLC_BI__Loan__c result = sut.getLoan(loan.Id);
        
        Object wasFieldInSOQL;
        wasFieldInSOQL = result.Id;
        wasFieldInSOQL = result.LLC_BI__lookupKey__c;
    }
    
    private static testMethod void it_should_get_an_entity_by_entity_id() {
        RecordType clientRecordType = Utility.recordTypeObject('Account','Client'); 
        Account entity = new Account(Name = 'test Account');
        entity.RecordTypeId = clientRecordType.Id;
        entity.RecordType = clientRecordType;  
        entity.EB_Customer_Number__c = '1234';   
        insert entity;
        
        Account result = sut.getEntity(entity.Id);
        
        System.assertEquals('Client', result.RecordType.Name);
        System.assertEquals('1234', result.EB_Customer_Number__c);
    }
    
    private static testMethod void it_should_get_a_collateral_by_collateral_id() {
        LLC_BI__Collateral_Type__c collateralType = new LLC_BI__Collateral_Type__c();
        insert collateralType;
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
        collateral.LLC_BI__Collateral_Type__c = collateralType.Id;     
        insert collateral;
        
        LLC_BI__Collateral__c result = sut.getCollateral(collateral.Id);
        
        System.assertEquals(collateral.Id, result.Id);
    }

    private static testMethod void it_should_get_the_doc_managers(){
        LLC_BI__DocManager__c newDocMan = new LLC_BI__DocManager__c(Name='TestMan');
        insert newDocMan;

        List<LLC_BI__DocManager__c> result = sut.getDocumentManagers();

        System.assertEquals(1, result.size());
        System.assertEquals(newDocMan.Id, result[0].Id);
    }

    private static testMethod void it_should_get_the_doc_manager_classes(){
        LLC_BI__DocType__c newDocType = new LLC_BI__DocType__c(Name='TestType');
        insert newDocType;
        LLC_BI__DocClass__c newDocClass = new LLC_BI__DocClass__c(Name='TestClass');
        newDocClass.LLC_BI__DocType__c = newDocType.Id;
        insert newDocClass;

        List<LLC_BI__DocClass__c> result = sut.getDocumentManagerClasses();

        System.assertEquals(1, result.size());
        System.assertEquals(newDocClass.Id, result[0].Id);
    }

}