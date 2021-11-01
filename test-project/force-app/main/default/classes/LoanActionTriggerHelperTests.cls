@isTest
private class LoanActionTriggerHelperTests {
    
    static testMethod void it_should_create_2_account_transaction_when_a_full_OREO_Sale_action_is_inserted(){
        //assemble
        EB_Unit__c unit = ObjectFactory.getUnit('Test Unit', 99, '1111');
        EB_Account__c oreo = new EB_Account__c();
        //oreo.OREO_Current_Book_Balance__c = 4900;
        oreo.EB_Unit__c = unit.Id;
        insert oreo;
        EB_Loan_Action__c accountAction = new EB_Loan_Action__c();
        accountAction.RecordType = Utility.recordTypeObject('EB_Loan_Action__c', 'OREO Sale');
        accountAction.RecordTypeId = accountAction.RecordType.Id;
        accountAction.EB_Account__c = oreo.Id;
        accountAction.Net_Proceeds__c = 5000;
        accountAction.Subordination_Closing_Date__c = Date.valueOf('2013-10-25');
        EB_Account_Transaction__c beginningBal = new EB_Account_Transaction__c();
        beginningBal.Amount__c = 4900.00;
        beginningBal.Transaction_type__c = 'Balance (16000300)';
        beginningBal.EB_Account__c = oreo.Id;
        beginningBal.EB_Account__r = oreo;
        insert beginningBal;
        
        //act
        insert accountAction;
        
        //assert
        List<EB_Account_Transaction__c> transactions = [SELECT Id, Name, Transaction_Type__c, EB_Account__c, Cost_Center__c, Amount__c, Vendor__c, Effective_Date__c, Sub_Type__c FROM EB_Account_Transaction__c WHERE EB_Account__c =: oreo.Id];
        
        System.assertEquals(3, transactions.size());
        
        System.assertEquals('Balance (16000300)', transactions[1].Transaction_Type__c);
        System.assertEquals(oreo.Id, transactions[1].EB_Account__c);
        System.assertEquals(unit.Center__c, transactions[1].Cost_Center__c);
        System.assertEquals(-4900, transactions[1].Amount__c);
        System.assertEquals(accountAction.RecordType.Name, transactions[1].Vendor__c);
        System.assertEquals(accountAction.Subordination_Closing_Date__c, transactions[1].Effective_Date__c);
        System.assertEquals('Sale', transactions[1].Sub_Type__c);
        
        System.assertEquals('Gain/Loss (74020300)', transactions[2].Transaction_Type__c);
        System.assertEquals(oreo.Id, transactions[2].EB_Account__c);
        System.assertEquals(unit.Center__c, transactions[2].Cost_Center__c);
        System.assertEquals(-100, transactions[2].Amount__c);
        System.assertEquals('Gain on Sale', transactions[2].Vendor__c);
        System.assertEquals(accountAction.Subordination_Closing_Date__c, transactions[2].Effective_Date__c);
        System.assertEquals('Gain on Sale', transactions[2].Sub_Type__c);
    }
    
    static testMethod void it_should_create_1_account_transaction_when_a_partial_OREO_Sale_action_is_inserted(){
        //assemble
        EB_Unit__c unit = ObjectFactory.getUnit('Test Unit', 99, '1111');
        EB_Account__c oreo = new EB_Account__c();       
        //oreo.OREO_Current_Book_Balance__c = 4999;
        oreo.EB_Unit__c = unit.Id;
        insert oreo;
        EB_Loan_Action__c accountAction = new EB_Loan_Action__c();
        accountAction.EB_Account__c = oreo.Id;
        accountAction.RecordType = Utility.recordTypeObject('EB_Loan_Action__c', 'OREO Sale');
        accountAction.RecordTypeId = accountAction.RecordType.Id;
        accountAction.Net_Proceeds__c = 1000;
        accountAction.Subordination_Closing_Date__c = Date.valueOf('2013-10-25');
        accountAction.Partial_Sale__c = true;
        EB_Account_Transaction__c beginningBal = new EB_Account_Transaction__c();
        beginningBal.Amount__c = 4999.00;
        beginningBal.Transaction_type__c = 'Balance (16000300)';
        beginningBal.EB_Account__c = oreo.Id;
        beginningBal.EB_Account__r = oreo;
        insert beginningBal;
        
        //act
        insert accountAction;
        
        //assert
        List<EB_Account_Transaction__c> transactions = [SELECT Id, Name, Transaction_Type__c, EB_Account__c, Cost_Center__c, Amount__c, Vendor__c, Effective_Date__c, Sub_Type__c FROM EB_Account_Transaction__c WHERE EB_Account__c =: oreo.Id];
        
        System.assertEquals(2, transactions.size());
        
        System.assertEquals('Balance (16000300)', transactions[1].Transaction_Type__c);
        System.assertEquals(oreo.Id, transactions[1].EB_Account__c);
        System.assertEquals(unit.Center__c, transactions[1].Cost_Center__c);
        System.assertEquals(-1000, transactions[1].Amount__c);
        System.assertEquals('Partial Sale', transactions[1].Vendor__c);
        System.assertEquals(accountAction.Subordination_Closing_Date__c, transactions[1].Effective_Date__c);
        System.assertEquals('Sale', transactions[1].Sub_Type__c);
        
    }
       
    static testMethod void it_should_create_2_account_transaction_when_an_OREO_Writedown_action_is_approved(){
        //assemble
        LoanActionTriggerHelper sut = new LoanActionTriggerHelper();
        EB_Unit__c unit = ObjectFactory.getUnit('Test Unit', 99, '1111');
        EB_Account__c oreo = new EB_Account__c();
        oreo.EB_Unit__c = unit.Id;
        insert oreo;
        EB_Loan_Action__c accountAction = new EB_Loan_Action__c();
        accountAction.RecordType = Utility.recordTypeObject('EB_Loan_Action__c', 'OREO-Writedown');
        accountAction.RecordTypeId = accountAction.RecordType.Id;
        accountAction.EB_Account__c = oreo.Id;
        accountAction.Transaction_Amount__c = 50;
        insert accountAction;
        
        // mimic approval
        accountAction.Status__c = 'Approved';
        accountAction.Create_Transactions_Flag__c = true;
        
        //act
        update accountAction;
        
        //assert
        EB_Loan_Action__c requery = [SELECT Id, Name, Create_Transactions_Flag__c FROM EB_Loan_Action__c WHERE Id =: accountAction.Id];
        
        System.assertEquals(false, requery.Create_Transactions_Flag__c);
        
        List<EB_Account_Transaction__c> transactions = [SELECT Id, Name, Transaction_Type__c, EB_Account__c, Cost_Center__c, Amount__c, Vendor__c, Effective_Date__c, Sub_Type__c FROM EB_Account_Transaction__c WHERE EB_Account__c =: oreo.Id];
        
        System.assertEquals(2, transactions.size());
        
        System.assertEquals('Balance (16000300)', transactions[0].Transaction_Type__c);
        System.assertEquals(oreo.Id, transactions[0].EB_Account__c);
        System.assertEquals(unit.Center__c, transactions[0].Cost_Center__c);
        System.assertEquals(-50, transactions[0].Amount__c);
        System.assertEquals(accountAction.RecordType.Name, transactions[0].Vendor__c);
        //System.assertEquals(accountAction.Closing_Date__c, transactions[0].Effective_Date__c);
        System.assertEquals('Writedown', transactions[0].Sub_Type__c);
        
        System.assertEquals('ORE Valuation Expense (83002301)', transactions[1].Transaction_Type__c);
        System.assertEquals(oreo.Id, transactions[1].EB_Account__c);
        System.assertEquals(unit.Center__c, transactions[1].Cost_Center__c);
        System.assertEquals(50, transactions[1].Amount__c);
        System.assertEquals(accountAction.RecordType.Name, transactions[1].Vendor__c);
        //System.assertEquals(accountAction.Closing_Date__c, transactions[1].Effective_Date__c);
        System.assertEquals('Writedown', transactions[1].Sub_Type__c);
    }
    
    static testMethod void it_should_create_an_oreo_account_when_a_reclass_account_action_is_saved(){
        Eb_Account__c testEBAccount = ObjectFactory.getAccount('testEbAccount','1234');
        RecordType actionRecordType =Utility.recordTypeObject('EB_Loan_Action__c', 'Reclassification to OREO');
        
        
        //act
        test.startTest();
        EB_Loan_Action__c testReclassAction = ObjectFactory.getAccountActionObj(testEBAccount,actionRecordType);
        test.stopTest();

        //assert
        List<EB_Account__c> accounts = [SELECT id, Name FROM EB_Account__c WHERE Id!=:testEBAccount.Id];
        EB_Loan_Action__c requery = [SELECT Id, Name, RecordTypeId FROM EB_Loan_Action__c WHERE Id=:testReclassAction.Id];
        system.assertEquals(1, accounts.size());
        system.assertEquals(actionRecordType.Id, requery.RecordTypeId);
    }
    
    static testMethod void it_should_not_create_an_oreo_account_when_a_reclass_account_action_is_saved_and_recordtype_is_not_reclasstooreo(){
        Eb_Account__c testEBAccount = ObjectFactory.getAccount('testEbAccount','1234');
        RecordType actionRecordType =Utility.recordTypeObject('EB_Loan_Action__c', 'Return to Accrual');        
        
        //act
        test.starttest();
        EB_Loan_Action__c testReclassAction = ObjectFactory.getAccountActionObj(testEBAccount,actionRecordType);
        test.stoptest();

        //assert
        List<EB_Account__c> accounts = [SELECT Id, Name FROM EB_Account__c WHERE Id!=:testEBAccount.Id];
        EB_Loan_Action__c requery = [SELECT Id, Name, RecordTypeId FROM EB_Loan_Action__c WHERE Id=:testReclassAction.Id];
        system.assertEquals(0, accounts.size());
        system.assertEquals(actionRecordType.Id, requery.RecordTypeId);
    }
    
    static testMethod void it_should_be_able_to_bulk_insert_2_oreo_accounts(){
        Eb_Account__c testEBAccount = ObjectFactory.getAccount('testEbAccount','1234');
        RecordType actionRecordType = Utility.recordTypeObject('EB_Loan_Action__c', 'Reclassification to OREO');
        
        //act
        test.startTest(); 
        List<EB_Loan_Action__c> testListOfActions = ObjectFactory.getAccountActionObj(testEBAccount, actionRecordType, 2);     
        test.stopTest();

        //assert
        List<EB_Account__c> accounts = [SELECT id, Name FROM EB_Account__c WHERE Id!=:testEBAccount.Id];
        system.assertEquals(2, accounts.size());
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    // legacy tests
    private static testMethod void verifyLoanActionChgOffAndRecTrackingTrigger(){        
        //this will test the LoanActionChgOffAndRecTracking trigger.
        //get a list of EB_Account__c objects and create a loan action for them
        
        try{
            Id recoveryId = objectFactory.getRecordTypeIdByNameAndObject('Recovery', 'EB_Loan_Action__c');
            Id chargeOffId = objectFactory.getRecordTypeIdByNameAndObject('Charge-Off', 'EB_Loan_Action__c');
            
            EB_Team_Member__c team = objectFactory.getTeamMember('Team1');
            Integer numEntities = 1;
            Integer numCollateral = 50;
            Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
            Id ProspectRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Prospect', 'Account');
            Account LeadEntity = objectFactory.getEntity('Test Entity',ClientRecordTypeId, team);
            List<EB_Account__c> accounts = new List<EB_Account__c>();
            
            
            for(integer i = 0; i < 1; i++){
                String title = 'test';
                String accnum = '999';
                title += i.format();
                accnum += i.format();
                System.debug('title='+title + 'accnum='+accnum);
                EB_Account__c account = objectFactory.getEBAccount(title, accnum, leadEntity);
                account.Account_Status__c = 'A';
                System.assert(account!=null);
                accounts.add(account);
            }
            System.debug('Number of accounts: ' + accounts.size());
            
            for (EB_Account__c a: accounts){
                //create an Account Action
                EB_Loan_Action__c action1 = new EB_Loan_Action__c();
                EB_Loan_Action__c action2 = new EB_Loan_Action__c();                
                
                //insert Recovery record to test its trigger
                action1.RecordTypeId = recoveryId;
                action1.EB_Account__c = a.Id;
                action1.Transaction_Amount__c = 1000;
                action1.Transaction_Type__c = 'Post Closing';
                System.assert(action1!=null);
                insert action1;
                
                //verify the trigger created the COR object
                Charge_Off_Recovery__c cor = new Charge_Off_Recovery__c();
                cor = [SELECT id, Name from Charge_Off_Recovery__c c WHERE c.EB_Account__c =: a.Id  ];
                System.assert(cor!=null);
                //delete cor;
                
                //insert Charge-Off record
                action2.RecordTypeId = chargeOffId;
                action2.EB_Account__c = a.Id;
                action2.Transaction_Amount__c = 1000;               
                action2.Transaction_Type__c = 'Post Closing';
                
                //verify the trigger created the COR object
                insert action2;
                Charge_Off_Recovery__c cor2 = new Charge_Off_Recovery__c();
                cor2 = [SELECT id, Name from Charge_Off_Recovery__c c WHERE c.EB_Account__c =: a.Id  ];
                System.assert(cor2!=null);    
                update action2;
            }
        }catch(exception ex){
        
        }       
    }
        
    private static testMethod void verifyLoanActionCreditDebit(){   
        EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);  
        Id recoveryId = objectFactory.getRecordTypeIdByNameAndObject('Recovery', 'EB_Loan_Action__c');
        Id chargeOffId = objectFactory.getRecordTypeIdByNameAndObject('Charge-Off', 'EB_Loan_Action__c');
        
        EB_Team_Member__c team = objectFactory.getTeamMember('Team1');
        Integer numEntities = 1;
        Integer numCollateral = 50;
        Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
        Id ProspectRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Prospect', 'Account');
        
        Account LeadEntity = objectFactory.getEntity('Test Entity',ClientRecordTypeId, team);
        List<EB_Account__c> accounts = new List<EB_Account__c>();
        
        EB_Account__c ebaccount = ObjectFactory.getEBAccount('Account Title', '14500010-15', leadEntity);
        ebaccount.EB_Unit__c = branch.Id;
        ebaccount.Account_Status__c = 'A';
        ebaccount.Application__c = 15;
        ebaccount.Unadvanced_Loan_Amount__c = 1000000;
        update ebaccount;
        EB_Account__c offsetAcct = (EB_Account__c)SmartFactory.createSObject('EB_Account__c');
        offsetAcct.Account_Line_1__c = 'Test';
        offsetAcct.Account_Status__c = 'A';
        offsetAcct.Account_Number__c = '10120300';
        offsetAcct.Primary_Owner_Id__c = leadEntity.Id;
        offsetAcct.EB_Unit__c = objectfactory.getUnit('Test', 4001).Id;
        offsetAcct.name = '10120300-GL';
        insert offsetAcct;
        
        
        
        EB_Account__c offset_Account = new EB_Account__c(Name='14500010-GL', Account_Status__c = 'A');
        insert offset_Account;
        
        Borrowing_Base__c bb = new Borrowing_Base__c();
        bb.Loan_Number__c =ebaccount.id;
        insert bb;
        Borrowing_Base_Collateral__c bbc = new Borrowing_Base_Collateral__c();
        bbc.Borrowing_Base_Report__c = bb.id;
        bbc.Advance_Rate__c = 70;
        bbc.Eligible_Amount__c=100000;
        bbc.Details__c = 'This is only a test.';
        insert bbc;
        Borrowing_Base__c updatedBB = [SELECT Id, Total_Availability_Transition__c FROM Borrowing_Base__c WHERE id =: bb.id];
        system.debug('##Total'  +string.valueof(updatedBB.Total_Availability_Transition__c));
        RecordType rectype = ObjectFactory.getRecordTypeObjByNameAndObject('Loan Debit', 'EB_Loan_Action__c');
        EB_Loan_Action__c  newObj = (EB_Loan_Action__c)SmartFactory.createSObject('EB_Loan_Action__c');
        newObj.EB_Account__c = ebaccount.id;
        newObj.RecordTypeId = rectype.id;
        newObj.Transaction_Type__c = 'Loan Advance';
        datetime dT = system.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        newObj.Transaction_Effective_Date__c = d;
        newObj.Wire_Transaction__c = 'Yes';
        newObj.Offset_Account__c = offset_Account.Id;
        newObj.center_Num__c = '2001';
        
        newObj.Transaction_Amount__c = 1000;    
        insert newObj;
    }
}