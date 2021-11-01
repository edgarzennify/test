@isTest
public class AgreementClientRelEditDataProvTests {
	
    private static testMethod void it_should_return_the_given_AgreementClientRel_fields_and_related_Entity_fields_upon_request() {
        Account testEntity = new Account();
        testEntity.Name = 'Test Entity';
        testEntity.Type = 'Business';
        testEntity.Entities_To_Combine__c = 'me and you';
        testEntity.Pending_TaxReturns__c = 'Yes';
        insert testEntity;

        Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__c = testEntity.Id;
        agmtClientRel.Agreement__c = testAgmt.Id;
        insert agmtClientRel;

        AgreementClientRelEditDataProv sut = new AgreementClientRelEditDataProv();

        Agreement_Client_Relationships__c dataProviderResult = sut.getAgreementClientRelationshipById(agmtClientRel.ID);

        System.assertEquals(testEntity.Entities_To_Combine__c, dataProviderResult.Entity__r.Entities_To_Combine__c);
        System.assertEquals(testEntity.Pending_TaxReturns__c, dataProviderResult.Entity__r.Pending_TaxReturns__c);
        System.assertEquals(activeRecordType.Id, dataProviderResult.Agreement__r.RecordTypeID);
        System.assertEquals(agmtClientRel.ID,dataProviderResult.ID);
	}

    private static testMethod void it_should_return_the_given_Agreement_fields_upon_request() {
        TestUtilities.createLoanAppStages();
        Agreement__c testAgmt = new Agreement__c();
        testAgmt.RecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.Stage__c = TestUtilities.getStageByName('Approved').Id;
        insert testAgmt;

        AgreementClientRelEditDataProv sut = new AgreementClientRelEditDataProv();
        Agreement__c dataProviderResult = sut.getAgreementById(testAgmt.ID);

        System.assertEquals(testAgmt.ID, dataProviderResult.ID);
        Object wasFieldInSOQL;
        wasFieldInSOQL = dataProviderResult.Id;
        wasFieldInSOQL = dataProviderResult.Name;
        wasFieldInSOQL = dataProviderResult.RecordType.Name;
        wasFieldInSOQL = dataProviderResult.Stage__r.Name;
        wasFieldInSOQL = dataProviderResult.RecordTypeId;
        wasFieldInSOQL = dataProviderResult.Stage__r.Loan_App_Stage_Action_Controller__r.Name;
	}

	private static testMethod void it_should_return_Agreement_Financial_Docs_By_RecordType_upon_request() { 

        Account testEntity = new Account();
        testEntity.Name = 'Test Entity';
        testEntity.Type = 'Business';
        insert testEntity;

        Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__c = testEntity.Id;
        agmtClientRel.Agreement__c = testAgmt.Id;
        insert agmtClientRel;


        RecordType taxReturnRecordType = Utility.recordTypeObject('Agreement_Financial_Documents__c','Tax Return');
        Set<ID> recordTypeIDSet = new Set<ID>();
        recordTypeIDSet.Add(taxReturnRecordType.Id);
        
        Agreement_Financial_Documents__c financialDoc = new Agreement_Financial_Documents__c();
        financialDoc.Agreement_Client_Relationship__c = agmtClientRel.Id;
        financialDoc.RecordTypeId = taxReturnRecordType.Id;
        insert financialDoc;

        AgreementClientRelEditDataProv sut = new AgreementClientRelEditDataProv();

        List<Agreement_Financial_Documents__c> dataProviderResult = sut.getAgreementFinancialDocumentsFilteredByRecordType(agmtClientRel.ID, recordTypeIDSet);
		
		System.assertEquals(financialDoc.Id, dataProviderResult[0].Id);
	}

	private static testMethod void it_should_return_Agreement_Financial_Docs_upon_request() {
        Account testEntity = new Account();
        testEntity.Name = 'Test Entity';
        testEntity.Type = 'Business';
        insert testEntity;

        Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__c = testEntity.Id;
        agmtClientRel.Agreement__c = testAgmt.Id;
        insert agmtClientRel;
        
        RecordType taxReturnRecordType = Utility.recordTypeObject('Agreement_Financial_Documents__c','Tax Return');
        Agreement_Financial_Documents__c financialDoc = new Agreement_Financial_Documents__c();
        financialDoc.Agreement_Client_Relationship__c = agmtClientRel.Id;
        financialDoc.RecordTypeId = taxReturnRecordType.Id;
        insert financialDoc;

        AgreementClientRelEditDataProv sut = new AgreementClientRelEditDataProv();

        List<Agreement_Financial_Documents__c> dataProviderResult = sut.getAgreementFinancialDocuments(agmtClientRel.ID);
		
		System.assertEquals(financialDoc.Id, dataProviderResult[0].Id);
	}

	private static testMethod void it_should_update_the_Account_object() {

        Account testEntity = new Account();
        testEntity.Name = 'Test Entity';
        testEntity.Type = 'Business';
        insert testEntity;		
		List<Account> accountItemPreChange = [SELECT Id, Entities_To_Combine__c FROM Account WHERE Id =: testEntity.Id];
        AgreementClientRelEditDataProv sut = new AgreementClientRelEditDataProv();
        testEntity.Entities_To_Combine__c = 'me and you';
        sut.updateAccount(testEntity);
		List<Account> accountItemPostChange = [SELECT Id, Entities_To_Combine__c FROM Account WHERE Id =: testEntity.Id];

		System.assertNotEquals(accountItemPreChange[0].Entities_To_Combine__c, accountItemPostChange[0].Entities_To_Combine__c);
		System.assertEquals('me and you', accountItemPostChange[0].Entities_To_Combine__c);
	}

	private static testMethod void it_should_update_the_AgreementClientRelationship_object() {
        Account testEntity = new Account();
        testEntity.Name = 'Test Entity';
        testEntity.Type = 'Business';
        insert testEntity;

        Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__c = testEntity.Id;
        agmtClientRel.Agreement__c = testAgmt.Id;
        insert agmtClientRel;

		List<Agreement_Client_Relationships__c> agmtClientRelPreChange = [SELECT Id, Borrowing_Base_Certificate__c FROM Agreement_Client_Relationships__c WHERE Id =: agmtClientRel.Id];
        AgreementClientRelEditDataProv sut = new AgreementClientRelEditDataProv();
        agmtClientRel.Borrowing_Base_Certificate__c = 'Yes';
        sut.updateAgreementClientRelationships(agmtClientRel);
		List<Agreement_Client_Relationships__c> agmtClientRelPostChange = [SELECT Id, Borrowing_Base_Certificate__c FROM Agreement_Client_Relationships__c WHERE Id =: agmtClientRel.Id];

		System.assertNotEquals(agmtClientRelPreChange[0].Borrowing_Base_Certificate__c, agmtClientRelPostChange[0].Borrowing_Base_Certificate__c);
		System.assertEquals('Yes', agmtClientRelPostChange[0].Borrowing_Base_Certificate__c);
	}

	private static testMethod void it_should_update_the_requested_AgreementFinancialDocument() {
        Account testEntity = new Account();
        testEntity.Name = 'Test Entity';
        testEntity.Type = 'Business';
        insert testEntity;

        Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__c = testEntity.Id;
        agmtClientRel.Agreement__c = testAgmt.Id;
        insert agmtClientRel;
        
        RecordType taxReturnRecordType = Utility.recordTypeObject('Agreement_Financial_Documents__c','Tax Return');
        Agreement_Financial_Documents__c financialDoc = new Agreement_Financial_Documents__c();
        financialDoc.Agreement_Client_Relationship__c = agmtClientRel.Id;
        financialDoc.RecordTypeId = taxReturnRecordType.Id;
        financialDoc.Frequency__c = 'whenever';
        financialDoc.Period_Due__c = 'later';
        insert financialDoc;

		List<Agreement_Financial_Documents__c> finDocItemPreChange = [SELECT Id, Include_In_Agreement__c FROM Agreement_Financial_Documents__c WHERE Id =: financialDoc.Id];
        financialDoc.Include_In_Agreement__c = 'Yes';
        List<Agreement_Financial_Documents__c> docsToUpdate = new List<Agreement_Financial_Documents__c>();
        docsToUpdate.add(financialDoc);
        AgreementClientRelEditDataProv sut = new AgreementClientRelEditDataProv();

        sut.saveAgreementFinancialDocuments(docsToUpdate);
		List<Agreement_Financial_Documents__c> finDocItemPostChange = [SELECT Id, Include_In_Agreement__c, Frequency__c, Period_Due__c FROM Agreement_Financial_Documents__c WHERE Id =: financialDoc.Id];

		System.assertNotEquals(finDocItemPreChange[0].Include_In_Agreement__c, finDocItemPostChange[0].Include_In_Agreement__c);
		System.assertEquals('Yes', finDocItemPostChange[0].Include_In_Agreement__c);
        System.assertEquals('whenever', finDocItemPostChange[0].Frequency__c);
        System.assertEquals('later', finDocItemPostChange[0].Period_Due__c);
	}

	private static testMethod void it_should_insert_the_requested_AgreementFinancialDocument() {
        Account testEntity = new Account();
        testEntity.Name = 'Test Entity';
        testEntity.Type = 'Business';
        insert testEntity;

        Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__c = testEntity.Id;
        agmtClientRel.Agreement__c = testAgmt.Id;
        insert agmtClientRel;
        
        RecordType taxReturnRecordType = Utility.recordTypeObject('Agreement_Financial_Documents__c','Tax Return');
        Agreement_Financial_Documents__c financialDoc = new Agreement_Financial_Documents__c();
        financialDoc.Agreement_Client_Relationship__c = agmtClientRel.Id;
        financialDoc.RecordTypeId = taxReturnRecordType.Id;
        financialDoc.Include_In_Agreement__c = 'Yes';
        financialDoc.Frequency__c = 'whenever';
        financialDoc.Period_Due__c = 'later';

        List<Agreement_Financial_Documents__c> docsToInsert = new List<Agreement_Financial_Documents__c>();
        docsToInsert.add(financialDoc);
        AgreementClientRelEditDataProv sut = new AgreementClientRelEditDataProv();

        sut.saveAgreementFinancialDocuments(docsToInsert);

        List<Agreement_Financial_Documents__c> finDocItemPostChange = [SELECT Id, Include_In_Agreement__c, Frequency__c, Period_Due__c FROM Agreement_Financial_Documents__c WHERE Agreement_Client_Relationship__c =: agmtClientRel.Id];
        System.assertEquals('Yes', finDocItemPostChange[0].Include_In_Agreement__c);
        System.assertEquals('whenever', finDocItemPostChange[0].Frequency__c);
        System.assertEquals('later', finDocItemPostChange[0].Period_Due__c);
	}

	private static testMethod void it_should_insert_and_update_the_requested_AgreementFinancialDocuments() {
	   Account testEntity = new Account();
        testEntity.Name = 'Test Entity';
        testEntity.Type = 'Business';
        insert testEntity;

        Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__c = testEntity.Id;
        agmtClientRel.Agreement__c = testAgmt.Id;
        insert agmtClientRel;

        RecordType taxReturnRecordType = Utility.recordTypeObject('Agreement_Financial_Documents__c','Tax Return');
        Agreement_Financial_Documents__c financialDocToInsert = new Agreement_Financial_Documents__c();
        financialDocToInsert.Agreement_Client_Relationship__c = agmtClientRel.Id;
        financialDocToInsert.RecordTypeId = taxReturnRecordType.Id;
        financialDocToInsert.Include_In_Agreement__c = 'Yes';
        financialDocToInsert.Frequency__c = 'often';
        financialDocToInsert.Period_Due__c = 'now';

        Agreement_Financial_Documents__c financialDocToUpdate = new Agreement_Financial_Documents__c();
        financialDocToUpdate.Agreement_Client_Relationship__c = agmtClientRel.Id;
        financialDocToUpdate.RecordTypeId = taxReturnRecordType.Id;
        financialDocToUpdate.Include_In_Agreement__c = 'Yes';
        financialDocToUpdate.Frequency__c = 'whenever';
        financialDocToUpdate.Period_Due__c = 'later';
        insert financialDocToUpdate;
        financialDocToUpdate.Include_In_Agreement__c = 'No';

        List<Agreement_Financial_Documents__c> docsToSave = new List<Agreement_Financial_Documents__c>();
        docsToSave.add(financialDocToInsert);
        docsToSave.add(financialDocToUpdate);
        AgreementClientRelEditDataProv sut = new AgreementClientRelEditDataProv();

        sut.saveAgreementFinancialDocuments(docsToSave);

        List<Agreement_Financial_Documents__c> finDocsPostChange = [SELECT Id, Include_In_Agreement__c, Frequency__c, Period_Due__c FROM Agreement_Financial_Documents__c WHERE Agreement_Client_Relationship__c =: agmtClientRel.Id];
        System.assertEquals(2, finDocsPostChange.size());

        Agreement_Financial_Documents__c docToInsertPostChange;
        Agreement_Financial_Documents__c docToUpdatePostChange;
        for(Agreement_Financial_Documents__c doc : finDocsPostChange){
            if(doc.Id == financialDocToUpdate.Id){
                docToUpdatePostChange = doc;
            }else{
                docToInsertPostChange = doc;
            }
        }

        System.assertEquals('No', docToUpdatePostChange.Include_In_Agreement__c);
        System.assertEquals('whenever', docToUpdatePostChange.Frequency__c);
        System.assertEquals('later', docToUpdatePostChange.Period_Due__c);
        System.assertEquals('Yes', docToInsertPostChange.Include_In_Agreement__c);
        System.assertEquals('often', docToInsertPostChange.Frequency__c);
        System.assertEquals('now', docToInsertPostChange.Period_Due__c);
    }

	private static testMethod void it_should_Delete_the_requested_AgreementFinancialDocument() {
        Account testEntity = new Account();
        testEntity.Name = 'Test Entity';
        testEntity.Type = 'Business';
        insert testEntity;

        Agreement__c testAgmt = new Agreement__c();
        RecordType activeRecordType = Utility.recordTypeObject('Agreement__c','Active');
        testAgmt.RecordType = activeRecordType;
        insert testAgmt;

        Agreement_Client_Relationships__c agmtClientRel = new Agreement_Client_Relationships__c();
        agmtClientRel.Entity__c = testEntity.Id;
        agmtClientRel.Agreement__c = testAgmt.Id;
        insert agmtClientRel;
        
        RecordType taxReturnRecordType = Utility.recordTypeObject('Agreement_Financial_Documents__c','Tax Return');
        Agreement_Financial_Documents__c financialDoc = new Agreement_Financial_Documents__c();
        financialDoc.Agreement_Client_Relationship__c = agmtClientRel.Id;
        financialDoc.RecordTypeId = taxReturnRecordType.Id;
        insert financialDoc;
		
        List<Agreement_Financial_Documents__c> finDocsToDelete = new List<Agreement_Financial_Documents__c>();
        finDocsToDelete.add(financialDoc);

		Integer totalAgmtFinancialDocsPreCall = [SELECT Id FROM Agreement_Financial_Documents__c WHERE Id =: financialDoc.Id].size();
        AgreementClientRelEditDataProv sut = new AgreementClientRelEditDataProv();
        sut.deleteAgreementFinancialDocuments(finDocsToDelete);
		Integer totalAgmtFinancialDocsPostCall = [SELECT Id FROM Agreement_Financial_Documents__c WHERE Id =: financialDoc.Id].size();
		
		//assert
		System.assertEquals(1, totalAgmtFinancialDocsPreCall);
		System.assertEquals(0, totalAgmtFinancialDocsPostCall);
	}

    private static testMethod void it_should_return_an_empty_list_when_getting_financial_docs_and_none_exists(){
        AgreementClientRelEditDataProv sut = new AgreementClientRelEditDataProv();

        List<Agreement_Financial_Documents__c> receivedDocs = sut.getAgreementFinancialDocuments('a24a0000002yq8IAAQ');

        System.assertNotEquals(null, receivedDocs);
        System.assertEquals(0, receivedDocs.size());
    }
	
    private static testMethod void it_should_return_an_empty_list_when_getting_financial_docs_by_record_type_and_none_exists(){
        AgreementClientRelEditDataProv sut = new AgreementClientRelEditDataProv();
        RecordType taxReturnRecordType = Utility.recordTypeObject('Agreement_Financial_Documents__c','Tax Return');
        Set<Id> recordTypes = new Set<Id>();
        recordTypes.add(taxReturnRecordType.Id);

        List<Agreement_Financial_Documents__c> receivedDocs = sut.getAgreementFinancialDocumentsFilteredByRecordType('a24a0000002yq8IAAQ', recordTypes);

        System.assertNotEquals(null, receivedDocs);
        System.assertEquals(0, receivedDocs.size());
    }
}