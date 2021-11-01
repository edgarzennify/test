@IsTest
private class Clone_AgreementRelationshipsTests{
private static final Clone_AgreementRelationships sut;
private static final Mock.ofIUserInfoService m_mockUserInfoService;
        
    static {        
        m_mockUserInfoService = new Mock.ofIUserInfoService();
        sut = new Clone_AgreementRelationships(m_mockUserInfoService);
    }

    @IsTest
    private static void it_should_clone_a_given_AgreementRelatedBorrowingBase(){

        List<Agreement_Borrowing_Base_Relationship__c> originalList = new List<Agreement_Borrowing_Base_Relationship__c>();
        Agreement_Borrowing_Base_Relationship__c original = new Agreement_Borrowing_Base_Relationship__c();
        original.Age_of_Eligible_Accts_Less_Than_in_Days__c = 123;
        original.Eligible_Account_Adv_Rate__c = .345;
        original.Equipment_Adv_Rate__c = .111;
        original.Inventory_Adv_Rate__c = .222;
        original.Less__c = 'More';
        original.Other__c = 'ABC';
        original.Other_Percent__c = .333;
        original.Other_Restrictions__c = 'bla bla bla';
        original.Status__c = 'XYZ';
        original.Subtraction_Description__c = 'lorem ipsum';
        originalList.add(original);
        Agreement__c newAgreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        insert newAgreement;

        m_mockUserInfoService.setup('getCurrentUserId').returns(ObjectFactory.getFakeId(User.SObjectType, '1'));
        
        MAP<SObject,List<SObject>> copy = sut.Clone(originalList,newAgreement.Id);

        List<SObject> cList = new List<SObject>(copy.keySet());
        Agreement_Borrowing_Base_Relationship__c c = (Agreement_Borrowing_Base_Relationship__c)cList[0];
        System.assertEquals(123, c.Age_of_Eligible_Accts_Less_Than_in_Days__c);
        System.assertEquals(newAgreement.Id, c.Agreement__c);
        System.assertEquals(.345, c.Eligible_Account_Adv_Rate__c);
        System.assertEquals(.111, c.Equipment_Adv_Rate__c);
        System.assertEquals(.222, c.Inventory_Adv_Rate__c);
        System.assertEquals('More', c.Less__c);
        System.assertEquals('ABC', c.Other__c);
        System.assertEquals(.333, c.Other_Percent__c);
        System.assertEquals('bla bla bla', c.Other_Restrictions__c);
        System.assertEquals('XYZ', c.Status__c);
        System.assertEquals('lorem ipsum', c.Subtraction_Description__c);
    } 
    
    @IsTest
    private static void it_should_clone_a_given_AgreementFinancialCovenant(){        
        //setup
        List<Agreement_Financial_Covenant__c> originalList = new List<Agreement_Financial_Covenant__c>();
        Agreement_Financial_Covenant__c original = new Agreement_Financial_Covenant__c();
        original.Comments__c = 'Test';
        original.Covenant_Title__c = 'Title';
        original.Covenant_Type__c = 'Standard';
        original.Standard_Covenant__c = 'Standard PicList';
        original.Testing_Frequency__c = '90';
        originalList.add(original);
        
        Agreement__c newAgreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        insert newAgreement;
        m_mockUserInfoService.setup('getCurrentUserId').returns(ObjectFactory.getFakeId(User.SObjectType, '1'));
        
        //Act
        Map<SObject,List<SObject>> copy = sut.Clone(originalList,newAgreement.Id);
        
        //Assert
        List<SObject> cList = new List<SObject>(copy.keySet());
        Agreement_Financial_Covenant__c c = (Agreement_Financial_Covenant__c)cList[0];
        System.assertEquals('Test',c.Comments__c);
        System.assertEquals('Title',c.Covenant_Title__c);
        System.assertEquals('Standard',c.Covenant_Type__c);
        System.assertEquals('Standard',c.Covenant_Type__c);
        System.assertEquals('Standard PicList' ,c.Standard_Covenant__c);
        System.assertEquals('90' ,c.Testing_Frequency__c);
        System.assertEquals(newAgreement.Id, c.Agreement__c);
        
    }
    
    @IsTest
    private static void it_should_clone_a_given_AgreementClientRelationship_and_set_financial_reporting_fields_from_entity(){        
        //Assemble
        
        List<Agreement_Client_Relationships__c> originalList = new List<Agreement_Client_Relationships__c>();
        Agreement_Client_Relationships__c original = new Agreement_Client_Relationships__c();        
        Agreement__c originalAgreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        Account entity = (Account)ObjectFactory.getValidEntity('bogus');
        insert originalAgreement;

        original.Agreement__c = originalAgreement.Id;
        original.Entity__c = entity.Id;
        original.Entity__r = entity;
        insert original;
        //
        Id apAgingsTypeId = utility.RecordTypeObject('Agreement_Financial_Documents__c', 'A/P Detailed Agings').Id;
        Id arAgingsTypeId = utility.RecordTypeObject('Agreement_Financial_Documents__c', 'A/R Detailed Agings').Id;
        Agreement_Financial_Documents__c payablesAgings = new Agreement_Financial_Documents__c();
        payablesAgings.RecordTypeId = apAgingsTypeId;
        payablesAgings.Agreement_Client_Relationship__c = original.Id;
        payablesAgings.Agreement_Client_Relationship__r = original;
        payablesAgings.Frequency__c = 'A';
        payablesAgings.Period_Due__c = 'B';
        insert payablesAgings;
            
        Agreement_Financial_Documents__c receivablesAgings = new Agreement_Financial_Documents__c();
        receivablesAgings.RecordTypeId = arAgingsTypeId;
        receivablesAgings.Agreement_Client_Relationship__c = original.Id;
        receivablesAgings.Agreement_Client_Relationship__r = original;
        receivablesAgings.Frequency__c = 'C';
        receivablesAgings.Period_Due__c = 'D';
        insert receivablesAgings;
                
        entity.Tax_Returns__c = '0001';
        entity.Tax_Return_Days_Due_After_Filing__c = 2;
        entity.Annual_Financial_Statements__c = '0003';               
        entity.Annual_Statement_Quality__c = '0004';           
        entity.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = 5;
        entity.Personal_Financial_Statement__c = '0006';
        entity.Personal_Financial_Statement_Frequency__c = '0007';
        entity.Interim_Statements__c = '0008';
        entity.Interim_Stm_Prepared_By__c = '0009';
        entity.Interim_Stmt_Days_Due_After_Period_End__c = 10;      
        
        originalList = [SELECT (SELECT Id, Name, RecordTypeID, Agreement_Client_Relationship__r.Entity__c,Agreement_Client_Relationship__r.Name, Agreement_Client_Relationship__c,Frequency__c,Include_In_Agreement__c,Other_Type__c,Period_Due__c,Period_Due_Override__c FROM Agreement_Financial_Documents__r) 
                        	,Entity__c,Entity__r.Name,Entity__r.Tax_Returns__c, Entity__r.Tax_Return_Days_Due_After_Filing__c,Entity__r.Annual_Financial_Statements__c
                        	,Entity__r.Annual_Statement_Quality__c, Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c,Entity__r.Personal_Financial_Statement__c
                        	,Entity__r.Personal_Financial_Statement_Frequency__c,Entity__r.Interim_Statements__c,Entity__r.Interim_Stm_Prepared_By__c
                        	,Entity__r.Interim_Stmt_Days_Due_After_Period_End__c
                        	,Borrowing_Base_Certificate__c,Borrowing_Base_Certificate_Period_Due__c,Borrowing_Base_Frequency__c,A_P_Detailed_Agings__c,A_P_Detailed_Agings_Frequency__c,A_P_Detailed_Agings_Period_Due__c,Inventory_Report__c,Inventory_Report_Frequency__c,Inventory_Report_Period_Due__c,Brokerage_Statement__c,Brokerage_Statement_Frequency__c,Brokerage_Statement_Period_Due__c,Rent_Roll__c,Rent_Roll_Frequency__c,Rent_Roll_Period_Due__c,Compliance_Certificate__c,Compliance_Certificate_Frequency__c,Compliance_Certificate_Period_Due__c,Work_in_Process__c,Work_in_Process_Frequency__c,Work_In_Process_Period_Due__c,A_R_Detailed_Agings__c FROM Agreement_Client_Relationships__c WHERE id =: original.Id];
        
        Agreement__c newAgreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        insert newAgreement;
        m_mockUserInfoService.setup('getCurrentUserId').returns(ObjectFactory.getFakeId(User.SObjectType, '1'));
        
        //Act
        Map<SObject,List<SObject>> copyMap = sut.Clone(originalList,newAgreement.Id);
        
        //Assert
        Set<SObject> keyset = copyMap.keyset();
        List<SObject> keys = new List<SObject>();
        keys.addAll(keyset);
        Agreement_Client_Relationships__c copyRel = (Agreement_Client_Relationships__c)keys[0];
        Agreement_Financial_Documents__c copyAP;
        Agreement_Financial_Documents__c copyAR;
        for(SObject copyObject : copyMap.get(copyRel)){
            Agreement_Financial_Documents__c copyDoc = (Agreement_Financial_Documents__c)copyObject;
            if(copyDoc.RecordTypeId == apAgingsTypeId) copyAP = copyDoc;
            if(copyDoc.RecordTypeId == arAgingsTypeId) copyAR = copyDoc;
        }
        
        System.assertEquals(entity.Id, copyRel.Entity__c);
        System.assertEquals('A',copyAP.Frequency__c);
        System.assertEquals('B',copyAP.Period_Due__c);
        System.assertEquals('C',copyAR.Frequency__c);
        System.assertEquals('D',copyAR.Period_Due__c);
        System.assertEquals(newAgreement.Id, copyRel.Agreement__c);
    }
    
    @IsTest
    private static void it_should_clone_a_given_AgreementEBAccountRelationship(){        
        //Assemble
        
        List<Agreement_EB_Account_Relationship__c> originalList = new List<Agreement_EB_Account_Relationship__c>();
        Agreement_EB_Account_Relationship__c original = new Agreement_EB_Account_Relationship__c();        
        Agreement__c newAgreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        EB_Account__c ebAccount = (EB_Account__c)SmartFactory.createSObject('EB_Account__c');
        insert newAgreement;
        insert ebAccount;
        
        original.Loan_Account__c = ebAccount.Id;
        originalList.add(original);
        m_mockUserInfoService.setup('getCurrentUserId').returns(ObjectFactory.getFakeId(User.SObjectType, '1'));
        
        //Act
        List<Agreement_EB_Account_Relationship__c> copyList = sut.Clone(originalList,newAgreement.Id);
        
        //Assert
        System.assertEquals(ebAccount.Id, copyList[0].Loan_Account__c);
        System.assertEquals(newAgreement.Id, copyList[0].Agreement__c);
    }
    
    @IsTest
    private static void it_should_clone_a_given_AgreementLoanApplicationRelationship(){
        //setup
        List<Agreement_Loan_Application_Relationship__c> originalList = new List<Agreement_Loan_Application_Relationship__c>();
        Agreement_Loan_Application_Relationship__c original = new Agreement_Loan_Application_Relationship__c();       

        EB_Loan_Application__c newLoanApplication = ObjectFactory.getLoanApplication('Test Entity', 'Test EBAccount','1234', 'Loan1234');       
        original.Loan_Application__c = newLoanApplication.Id;
        
        originalList.add(original);        
        Agreement__c newAgreement = (Agreement__c)SmartFactory.createSObject('Agreement__c');
        insert newAgreement;
        m_mockUserInfoService.setup('getCurrentUserId').returns(ObjectFactory.getFakeId(User.SObjectType, '1'));
        
        //Act
        List<Agreement_Loan_Application_Relationship__c> copyList = sut.Clone(originalList,newAgreement.Id);
        
        //Assert
        System.assertEquals(original.Loan_Application__c,copyList[0].Loan_Application__c);
    }
    
    @IsTest
    private static void it_should_clone_a_given_agreement_subordination_relationship(){
        Agreement__c testAgreement = new Agreement__C();
        testAgreement.RecordTypeId = utility.recordTypeObject('Agreement__c', 'Active').Id;
        insert testAgreement;
        List<Agreement_Subordination__c> originalList = new List<Agreement_Subordination__c>();
        Agreement_Subordination__c original = new Agreement_Subordination__c();
        original.Agreement__c = testAgreement.Id;
        original.Creditor__c = ObjectFactory.getValidEntity('Test Entity').Id;
        insert original;
        originalList.add(original);
        m_mockUserInfoService.setup('getCurrentUserId').returns(ObjectFactory.getFakeId(User.SObjectType, '1'));
        
        MAP<SObject,List<SObject>> copy = sut.Clone(originalList,testAgreement.Id);
        
        system.assertEquals(1, copy.values().size());

    }

}