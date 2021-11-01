@IsTest
private class LoanArchiveDataProviderTests {

    private final static LoanArchiveDataProvider sut;

    static{
        sut = new LoanArchiveDataProvider();
    }

    private static testMethod void it_should_insert_an_object_when_no_id_is_present() {
        Account entity = new Account( Name = 'test');
        List<SObject> sObjects = new List<SObject>{ entity };

        sut.save(sObjects);

        System.assert(entity.Id != null);
    }

    private static testMethod void it_should_update_an_object_when_an_id_is_present() {
        Account entity = new Account( Name = 'test');
        insert entity;
        entity.Name = 'test updated name';
        List<SObject> sObjects = new List<SObject>{ entity };

        sut.save(sObjects);

        List<Account> resultRequery = [SELECT Id, Name FROM Account WHERE Id =: entity.Id];
        System.assertEquals('test updated name', resultRequery[0].Name );
    }

    private static testMethod void it_should_not_throw_an_exception_when_the_same_object_is_int_the_save_list_twice() {
        Account entity = new Account( Name = 'test');
        insert entity;
        entity.Name = 'test updated name';
        List<SObject> sObjects = new List<SObject>{ entity, entity };

        sut.save(sObjects);

        System.assert(true);
    } 

    private static testMethod void it_should_remove_sobject() {
        Account entity = new Account( Name = 'test');
        insert entity;
        List<SObject> sObjects = new List<SObject>{ entity };

        sut.remove(sObjects);

        List<Account> resultRequery = [SELECT Id, Name FROM Account WHERE Id =: entity.Id];
        System.assertEquals(0, resultRequery.size() );
    }

     private static testMethod void it_should_chunk_in_size_ten_per_object_type(){
        //List<Contact> contacts = new List<Contact>();
        List<Account> entities = new List<Account>();
        List<SObject> sObjects = new List<SObject>();

        for(integer i = 0; i < 15; i++){
            //contacts.add(new Contact(;
            entities.add(new Account(Name= 'test entity' + string.valueof(i)));
        }
        //sObjects.addall(contacts);
        sObjects.addAll((list<sobject>)entities);

        sut.save(sObjects);

        System.assert(true);
    } 

    private static testMethod void it_should_return_a_loan_object_with_related_list_info_when_loan_if_is_provided() {
        RecordType clientRecordType = Utility.RecordTypeObject('Account', 'Client');
        Account entity = new Account(Name = 'test entity', RecordTypeId = clientRecordType.Id);
        insert entity;
        LLC_BI__Collateral_Type__c colType = new LLC_BI__Collateral_Type__c();
        colType.Name = 'test collateral type';
        insert colType;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.TDR_Determination_1__c = 'Borrower is not experiencing financial difficulty';
        loan.TDR_Detail_Justification__c = 'justified';
        insert loan;
        loan = [SELECT Id, Name FROM LLC_BI__Loan__c WHERE Id =: loan.Id];
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c();
        collateral.Sync_Key__c = '1122';
        collateral.LLC_BI__Collateral_Type__c = colType.Id;
        collateral.LLC_BI__Description__c = 'test description';
        collateral.LLC_BI__Collateral_Name__c = '1122';
        insert collateral;
        LLC_BI__Loan_Collateral_Aggregate__c agg = new LLC_BI__Loan_Collateral_Aggregate__c();
        insert agg;
        LLC_BI__Loan_Collateral2__c loanCollateral = new LLC_BI__Loan_Collateral2__c();
        loanCollateral.LLC_BI__Collateral__c = collateral.Id;
        loanCollateral.LLC_BI__Loan__c = loan.Id;
        loanCollateral.LLC_BI__Loan_Collateral_Aggregate__c = agg.Id;
        insert loanCollateral;
        LLC_BI__Legal_Entities__c legalEntity = new LLC_BI__Legal_Entities__c();
        legalEntity.LLC_BI__Account__c = entity.Id;
        legalEntity.LLC_BI__Loan__c = loan.Id;
        insert legalEntity;

        LLC_BI__Loan__c result = sut.getLoanForVm(loan.Id);

        System.assertEquals(1, result.LLC_BI__Loan_Collateral__r.size());
        System.assertEquals(1, result.LLC_BI__Legal_Entities__r.size());
        System.assertEquals(loan.Id, result.Id);
        System.assertEquals(loan.Name, result.Name);
        Object fieldReturnedInSOQL = result.Id;
        List<LLC_BI__Loan_Collateral2__c> pledges = result.LLC_BI__Loan_Collateral__r;
        fieldReturnedInSOQL = result.Name;
        fieldReturnedInSOQL = result.LLC_BI__Loan_Collateral__r;
        fieldReturnedInSOQL = result.LLC_BI__Legal_Entities__r;
        fieldReturnedInSOQL = result.LLC_BI__Loan_Collateral__r[0].Id;
        fieldReturnedInSOQL = result.LLC_BI__Loan_Collateral__r[0].LLC_BI__Collateral__r.LLC_BI__Collateral_Name__c;
        fieldReturnedInSOQL = result.LLC_BI__Loan_Collateral__r[0].LLC_BI__Collateral__r.Name;
        fieldReturnedInSOQL = result.LLC_BI__Loan_Collateral__r[0].LLC_BI__Collateral__r.Sync_Key__c;
        fieldReturnedInSOQL = result.LLC_BI__Loan_Collateral__r[0].LLC_BI__Collateral__r.LLC_BI__Description__c;
        fieldReturnedInSOQL = result.LLC_BI__Loan_Collateral__r[0].LLC_BI__Collateral__r.CreatedDate;
        fieldReturnedInSOQL = result.LLC_BI__Legal_Entities__r[0].LLC_BI__Account__r.Id;
        fieldReturnedInSOQL = result.LLC_BI__Legal_Entities__r[0].LLC_BI__Account__r.Name;
        fieldReturnedInSOQL = result.LLC_BI__Legal_Entities__r[0].LLC_BI__Account__r.Entity_Name__c;
        fieldReturnedInSOQL = result.LLC_BI__Legal_Entities__r[0].LLC_BI__Account__r.RecordType.Name;
        fieldReturnedInSOQL = result.LLC_BI__Legal_Entities__r[0].LLC_BI__Account__r.CreatedDate;
        fieldReturnedInSOQL = pledges[0].Description__c;
    }

    private static testMethod void it_should_get_collateral_obj_form_id() {
        LLC_BI__Collateral_Type__c colType = new LLC_BI__Collateral_Type__c();
        colType.Name = 'test collateral type';
        insert colType;
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c(LLC_BI__Collateral_Type__c = colType.Id);
        insert collateral;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.TDR_Determination_1__c = 'Borrower is not experiencing financial difficulty';
        loan.TDR_Detail_Justification__c = 'justified';
        insert loan;
        LLC_BI__Loan_Collateral_Aggregate__c aggregate = new LLC_BI__Loan_Collateral_Aggregate__c();
        insert aggregate;
        LLC_BI__Loan_Collateral2__c pledge = new LLC_BI__Loan_Collateral2__c();
        pledge.LLC_BI__Collateral__c = collateral.Id;
        pledge.LLC_BI__Loan__c = loan.Id;
        pledge.LLC_BI__Loan_Collateral_Aggregate__c = aggregate.Id;
        insert pledge;
        List<Id> ids = new List<Id>{ collateral.Id };

        List<LLC_BI__Collateral__c> result =  sut.getSObjectsForCollateralMerge(ids);

        System.assertEquals(1, result.size());
        Object fieldReturnedInSOQL = result[0].Id;
        List<LLC_BI__Loan_Collateral2__c> pledges = result[0].LLC_BI__Loan_Collateral2__r;
        fieldReturnedInSOQL = result[0].Name;
        fieldReturnedInSOQL = result[0].Sync_Key__c;
        fieldReturnedInSOQL = result[0].LLC_BI__Collateral_Name__c;
        fieldReturnedInSOQL = pledges[0].Id;
        fieldReturnedInSOQL = pledges[0].Description__c;
        fieldReturnedInSOQL = pledges[0].LLC_BI__Loan__c;
        fieldReturnedInSOQL = pledges[0].LLC_BI__Collateral__c;
        fieldReturnedInSOQL = pledges[0].LLC_BI__Collateral__r.Name;
        fieldReturnedInSOQL = pledges[0].LLC_BI__Collateral__r.LLC_BI__Description__c;
        fieldReturnedInSOQL = pledges[0].LLC_BI__Collateral__r.LLC_BI__Description__c;
        fieldReturnedInSOQL = pledges[0].LLC_BI__Collateral__r.LLC_BI__Collateral_Name__c;
        fieldReturnedInSOQL = pledges[0].LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.Name;
    }

    private static testMethod void it_should_get_collateral_documents_for_collateral_id(){
        LLC_BI__Collateral_Type__c colType = new LLC_BI__Collateral_Type__c();
        colType.Name = 'test collateral type';
        insert colType;
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c(LLC_BI__Collateral_Type__c = colType.Id);
        insert collateral;
        List<Id> ids = new List<Id>{ collateral.Id };
        LLC_BI__Document_Placeholder__c collDoc = new LLC_BI__Document_Placeholder__c();
        collDoc.LLC_BI__External_Id__c=collateral.Id;
        insert collDoc;

        List<LLC_BI__Document_Placeholder__c> result = sut.getCollateralDocumentsForMerge(ids);

        System.assertEquals(1, result.size());
        System.assertEquals(collateral.Id,result[0].LLC_BI__External_Id__c);
    }

    private static testMethod void it_should_get_entity_for_entity_id() {
        Account entity = new Account(Name = 'test entity');
        insert entity;
        List<Id> ids = new List<Id>{ entity.Id };

        LLC_BI__AccountDocument__c acctDoc = new LLC_BI__AccountDocument__c();
        acctDoc.LLC_BI__Account__c = entity.Id ;
        acctDoc.Name='Acct Doc';
        insert acctDoc;

        List<Account> result = sut.getSObjectsForEntityMerge(ids);

        System.assertEquals(1, result.size());
        Object fieldReturnedInSOQL = result[0].Id;
        fieldReturnedInSOQL = result[0].Name;
        fieldReturnedInSOQL = result[0].EB_Client_Name__c;
        fieldReturnedInSOQL = result[0].EB_Customer_Number__c;
        fieldReturnedInSOQL = result[0].WM_Key__c;
        fieldReturnedInSOQL = result[0].BillingStreet;
        fieldReturnedInSOQL = result[0].BillingCity;
        fieldReturnedInSOQL = result[0].BillingState;
        fieldReturnedInSOQL = result[0].BillingPostalCode;
        fieldReturnedInSOQL = result[0].Phone;
        fieldReturnedInSOQL = result[0].SSNTIN_Encrypted__c;
        fieldReturnedInSOQL = result[0].SSN_TIN_Has_Value__c;
    }

    private static testMethod void it_should_return_collateral_object_for_collateral_id() {
        LLC_BI__Collateral_Type__c colType = new LLC_BI__Collateral_Type__c();
        colType.Name = 'test collateral type';
        insert colType;
        Collateral_Code__c colCode = new Collateral_Code__c(Collateral_Code_ID__c = '9998');
        insert colCode;
        LLC_BI__Collateral__c collateral = new LLC_BI__Collateral__c(LLC_BI__Collateral_Type__c = colType.Id, Sync_Key__c = '1122');
        insert collateral;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.TDR_Determination_1__c = 'Borrower is not experiencing financial difficulty';
        loan.TDR_Detail_Justification__c = 'justified';
        insert loan;
        LLC_BI__Loan_Collateral_Aggregate__c aggregate = new LLC_BI__Loan_Collateral_Aggregate__c();
        insert aggregate;
        LLC_BI__Loan_Collateral2__c pledge = new LLC_BI__Loan_Collateral2__c();
        pledge.LLC_BI__Collateral__c = collateral.Id;
        pledge.LLC_BI__Loan__c = loan.Id;
        pledge.LLC_BI__Loan_Collateral_Aggregate__c = aggregate.Id;
        insert pledge;
        EB_Collateral__c ebCollateral = new EB_Collateral__c( Name = collateral.Name, key__c = '1122', Collateral_Code__c = colCode.Id);
        insert ebCollateral;
        List<Id> ids = new List<Id>{ collateral.Id };

        List<SObject> result = sut.getSObjectsForEbCollateralMerge(ids);

        System.assertEquals(2, result.size());
        LLC_BI__Collateral__c resultCollateral = (LLC_BI__Collateral__c)result[0];
        EB_Collateral__c resultEbCollateral = (EB_Collateral__c)result[1];
        
        Object fieldReturnedInSOQL  = resultCollateral.Id;
        fieldReturnedInSOQL = resultCollateral.Name;
        fieldReturnedInSOQL = resultCollateral.Sync_Key__c;
        fieldReturnedInSOQL = resultCollateral.LLC_BI__Collateral_Name__c;
        fieldReturnedInSOQL = resultEbCollateral.Id;
        fieldReturnedInSOQL = resultEbCollateral.Name;
        fieldReturnedInSOQL = resultEbCollateral.Key__c;
        fieldReturnedInSOQL = resultEbCollateral.Status__c;
    }

    private static testMethod void it_should_get_loan_objects_from_ids() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.TDR_Determination_1__c = 'Borrower is not experiencing financial difficulty';
        loan.TDR_Detail_Justification__c = 'justified';
        insert loan;
        Agreement__c testAgmt = ObjectFactory.getAgreement('Active', 'Test Borr', 'New Test Agmt');
        Agreement_LLC_BI_Loan_Relationship__c rel = new Agreement_LLC_BI_Loan_Relationship__c();
        rel.Agreement__c = testAgmt.Id;
        rel.LLCBI_Loan__c = loan.Id;
        insert rel;
        List<Id> loanIds = new List<Id> {loan.Id};

        List<LLC_BI__Loan__c> result = sut.getSObjectsForLoanMerge(loanIds);

        System.assertEquals(1, result.size());
        Object fieldReturnedInSOQL = result[0].Id;
        fieldReturnedInSOQL = result[0].Name;
        fieldReturnedInSOQL = result[0].LLC_BI__lookupKey__c;
        fieldReturnedInSOQL = result[0].Agreement_LLC_BI_Loan_Relationships__r[0].Id;
        fieldReturnedInSOQL = result[0].Agreement_LLC_BI_Loan_Relationships__r[0].Agreement__c;
        fieldReturnedInSOQL = result[0].Agreement_LLC_BI_Loan_Relationships__r[0].LLCBI_Loan__c;
    }

    private static testMethod void it_should_return_a_valid_savepoint() {

        Savepoint result = sut.setSavepoint();

        System.assert(result != null);
    }

    private static testMethod void it_should_rollback_the_changes_made_between_set_savepoint_and_rollback() {
        RecordType clientRecordType = Utility.RecordTypeObject('Account', 'Client');
        Account test = new Account(Name = 'test entity', RecordTypeId = clientRecordType.Id);
        insert test;

        Savepoint sp = sut.setSavepoint();
        test.Name = 'bogus';
        update test;
     
        sut.rollback(sp);

        Account requeried = [SELECT Id, Name FROM Account WHERE Id=: test.Id];
        System.assertEquals('test entity', requeried.Name);
    }

    private static testMethod void it_should_find_the_corresponding_eb_account_given_a_llc_bi_loan(){
        LLC_BI__Loan__c llcBiLoan = new LLC_BI__Loan__c();
        llcBiLoan.LLC_BI__lookupKey__c = '12345-15';
        llcBiLoan.TDR_Determination_1__c = 'Borrower is not experiencing financial difficulty';
        llcBiLoan.TDR_Detail_Justification__c = 'justified';
        insert llcBiLoan;
        
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        EB_Account__c  ebAccount = ObjectFactory.getEBAccount('Test Account Title', '12345-15', testEntity);
        ebAccount.Key__c = '12345-15';
        update ebAccount;

        EB_Account__c result = sut.findEbAcctTwin(llcBiLoan);

        System.assertEquals('12345-15', result.Key__c);
    }

    private static testMethod void it_should_find_the_corresponding_eb_accounts_given_llc_bi_loan_lookup_keys(){
        LLC_BI__Loan__c llcBiLoan = new LLC_BI__Loan__c();
        llcBiLoan.LLC_BI__lookupKey__c = '12345-15';
        llcBiLoan.TDR_Determination_1__c = 'Borrower is not experiencing financial difficulty';
        llcBiLoan.TDR_Detail_Justification__c = 'justified';
        LLC_BI__Loan__c llcBiLoan2 = new LLC_BI__Loan__c();
        llcBiLoan2.LLC_BI__lookupKey__c = '22222-15';
        llcBiLoan2.TDR_Determination_1__c = 'Borrower is not experiencing financial difficulty';
        llcBiLoan2.TDR_Detail_Justification__c = 'justified';

        insert new List<LLC_BI__Loan__c>{llcBiLoan,llcBiLoan2};
        
        Account testEntity = ObjectFactory.getValidEntity('testEntity');
        EB_Account__c  ebAccount = ObjectFactory.getEBAccount('Test Account Title', '12345-15', testEntity);
        ebAccount.Key__c = '12345-15';
        EB_Account__c  ebAccount2 = ObjectFactory.getEBAccount('Test Account Title2', '22222-15', testEntity);
        ebAccount2.Key__c = '22222-15';
        EB_Account__c  ebAccount3 = ObjectFactory.getEBAccount('Test Account Title3', '33333-15', testEntity);
        ebAccount3.Key__c = '33333-15';

        update new List<EB_Account__C>{ebAccount,ebAccount2,ebAccount3};

        List<String> llcBiLoanLookupKeys = new List<String>{llcBiLoan.LLC_BI__lookupKey__c, llcBiLoan2.LLC_BI__lookupKey__c};

        List<EB_Account__c> result = sut.findEbAcctTwins(llcBiLoanLookupKeys);

        System.assertEquals(2, result.size());
        System.assertEquals('12345-15', result[0].Key__c);
        System.assertEquals('22222-15', result[1].Key__c);
    }
}