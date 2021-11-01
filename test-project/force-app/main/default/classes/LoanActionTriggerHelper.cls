public  class LoanActionTriggerHelper { 
    
    private final String BALANCE_TRX = 'Balance (16000300)';
    private final String GAIN_LOSS_TRX = 'Gain/Loss (74020300)';
    private final String ORE_VALUATION_TRX = 'ORE Valuation Expense (83002301)';
    
    public void executeBeforeInsert(List<EB_Loan_Action__c> newActions){
        
    }
    
    public void executeAfterInsert(List<EB_Loan_Action__c> newActions){
        createOREOaccountWhenReclassOreoForclosureIsInitiated(newActions);
        createEBAccountTransactionsForOREOSaleActions(newActions);
    }
    
    public void executeBeforeUpdate(List<EB_Loan_Action__c> updatedActions){
        createEBAccountTransactionsForOREOWritedown(updatedActions);
    }
    
    public void executeAfterUpdate(List<EB_Loan_Action__c> updatedActions){
        
    }
    
    private void createEBAccountTransactionsForOREOSaleActions(List<EB_Loan_Action__c> actions){
        List<EB_Account_Transaction__c> transactions = new List<EB_Account_Transaction__c>();
        List<EB_Loan_Action__c> actionsDetailed = [SELECT 
                                                       Id, Name, Partial_Sale__c, RecordTypeId, EB_Account__c, Net_Proceeds__c, Subordination_Closing_Date__c,
                                                       EB_Account__r.OREO_Balance_Rollup__c, EB_Account__r.EB_Unit__r.Center__c, 
                                                       RecordType.Name 
                                                   FROM EB_Loan_Action__c 
                                                   WHERE Id IN: actions];
        
        for(EB_Loan_Action__c action : actionsDetailed){            
            if(action.RecordTypeId == Utility.recordTypeObject('EB_Loan_Action__c', 'OREO Sale').Id){               
                if(action.Partial_Sale__c == true){                 
                    transactions.addAll(generateEBAccountTransactionsForPartialOREOSale(action));
                }else{
                    transactions.addAll(generateEBAccountTransactionsForFullOREOSale(action));
                }                
            }
        }
        
        if(transactions.size() > 0){
            insert transactions;
        }
    }
    
    private void createEBAccountTransactionsForOREOWritedown(List<EB_Loan_Action__c> actions){
        List<EB_Account_Transaction__c> transactions = new List<EB_Account_Transaction__c>();
        Map<Id,EB_Loan_Action__c> actionsDetailed = new Map<Id,EB_Loan_Action__c>(
                                                            [SELECT 
                                                                Id, Name, RecordTypeId, EB_Account__c, Net_Proceeds__c, Closing_Date__c,
                                                                Transaction_Amount__c, EB_Account__r.EB_Unit__r.Center__c, 
                                                                RecordType.Name 
                                                            FROM EB_Loan_Action__c 
                                                            WHERE Id IN: actions]);
        for(EB_Loan_Action__c action : actions){
            if(action.RecordTypeId == Utility.recordTypeObject('EB_Loan_Action__c', 'OREO-Writedown').Id){
                if(action.Status__c == 'Approved' && action.Create_Transactions_Flag__c == true){
                    action.Create_Transactions_Flag__c = false;
                    transactions.addAll(generateEBAccountTransactionsForOREOWritedown(actionsDetailed.get(action.Id)));
                }
            }
        }
        
        if(transactions.size() > 0){
            insert transactions;
        }
    }
    
    private List<EB_Account_Transaction__c> generateEBAccountTransactionsForFullOREOSale(EB_Loan_Action__c sale){
        List<EB_Account_Transaction__c> transactions = new List<EB_Account_Transaction__c>();
        Decimal currentBookBalance = sale.EB_Account__r.OREO_Balance_Rollup__c;    
          
        EB_Account_Transaction__c balanceTrx = new EB_Account_Transaction__c();
        balanceTrx.EB_Account__c = sale.EB_Account__c;
        balanceTrx.Transaction_Type__c = BALANCE_TRX;
        balanceTrx.Sub_Type__c = 'Sale';
        balanceTrx.Amount__c = utility.multiplyTwoAmounts(currentBookBalance, -1);
        balanceTrx.Cost_Center__c = sale.EB_Account__r.EB_Unit__r.Center__c;
        balanceTrx.Vendor__c = sale.RecordType.Name;
        balanceTrx.Effective_Date__c = sale.Subordination_Closing_Date__c;
        
        EB_Account_Transaction__c gainLossTrx = new EB_Account_Transaction__c();
        gainLossTrx.EB_Account__c = sale.EB_Account__c;
        gainLossTrx.Transaction_Type__c = GAIN_LOSS_TRX;         
        gainLossTrx.Amount__c = utility.subtractTwoAmounts(sale.Net_Proceeds__c, currentBookBalance) * -1;
        gainLossTrx.Sub_Type__c = (gainLossTrx.Amount__c < 0) ? 'Gain on Sale' : 'Loss on Sale';
        gainLossTrx.Cost_Center__c = sale.EB_Account__r.EB_Unit__r.Center__c;
        gainLossTrx.Vendor__c = (gainLossTrx.Amount__c < 0) ? 'Gain on Sale' : 'Loss on Sale';
        gainLossTrx.Effective_Date__c = sale.Subordination_Closing_Date__c;
        
        if(balanceTrx.Amount__c <> 0){transactions.add(balanceTrx);}
        if(gainLossTrx.Amount__c <> 0){transactions.add(gainLossTrx);}
        return transactions;
    }
    
    private List<EB_Account_Transaction__c> generateEBAccountTransactionsForPartialOREOSale(EB_Loan_Action__c sale){
        List<EB_Account_Transaction__c> transactions = new List<EB_Account_Transaction__c>();
        Decimal currentBookBalance = sale.EB_Account__r.OREO_Balance_Rollup__c;
        Decimal gainOnSale = utility.subtractTwoAmounts(sale.Net_Proceeds__c, currentBookBalance);
        if(gainOnSale > 0){
            EB_Account_Transaction__c balanceTrx = new EB_Account_Transaction__c();
            balanceTrx.EB_Account__c = sale.EB_Account__c;
            balanceTrx.Transaction_Type__c = BALANCE_TRX;
            balanceTrx.Sub_Type__c = 'Sale';            
            balanceTrx.Amount__c = utility.multiplyTwoAmounts(currentBookBalance, -1); 
            balanceTrx.Cost_Center__c = sale.EB_Account__r.EB_Unit__r.Center__c;
            balanceTrx.Vendor__c =  'Partial Sale';
            balanceTrx.Effective_Date__c = sale.Subordination_Closing_Date__c;
            
            EB_Account_Transaction__c gainTrx = new EB_Account_Transaction__c();
            gainTrx.EB_Account__c = sale.EB_Account__c;
            gainTrx.Transaction_Type__c = GAIN_LOSS_TRX;         
            gainTrx.Amount__c = gainOnSale * -1;
            gainTrx.Sub_Type__c = 'Gain on Sale';
            gainTrx.Cost_Center__c = sale.EB_Account__r.EB_Unit__r.Center__c;
            gainTrx.Vendor__c = 'Gain on Sale';
            gainTrx.Effective_Date__c = sale.Subordination_Closing_Date__c;
            
            if(balanceTrx.Amount__c <> 0){transactions.add(balanceTrx);}
            if(gainTrx.Amount__c <> 0){transactions.add(gainTrx);}
        }else{
            EB_Account_Transaction__c balanceTrx = new EB_Account_Transaction__c();
            balanceTrx.EB_Account__c = sale.EB_Account__c;
            balanceTrx.Transaction_Type__c = BALANCE_TRX;
            balanceTrx.Sub_Type__c = 'Sale';            
            balanceTrx.Amount__c = utility.multiplyTwoAmounts(sale.Net_Proceeds__c, -1); 
            balanceTrx.Cost_Center__c = sale.EB_Account__r.EB_Unit__r.Center__c;
            balanceTrx.Vendor__c =  'Partial Sale';
            balanceTrx.Effective_Date__c = sale.Subordination_Closing_Date__c;
            
            if(balanceTrx.Amount__c <> 0){transactions.add(balanceTrx);}
        }
                
        return transactions;
    }
    
    private List<EB_Account_Transaction__c> generateEBAccountTransactionsForOREOWritedown(EB_Loan_Action__c writedown){
        Date approveDate = utility.ApproveDate(writedown.Id);
        EB_Account_Transaction__c balanceTrx = new EB_Account_Transaction__c();
        balanceTrx.EB_Account__c = writedown.EB_Account__c;
        balanceTrx.Transaction_Type__c = BALANCE_TRX;
        balanceTrx.Sub_Type__c = 'Writedown';
        balanceTrx.Amount__c = utility.multiplyTwoAmounts(writedown.Transaction_Amount__c, -1);//writedown.Transaction_Amount__c * -1;
        balanceTrx.Cost_Center__c = writedown.EB_Account__r.EB_Unit__r.Center__c;
        balanceTrx.Vendor__c = writedown.RecordType.Name;
        balanceTrx.Effective_Date__c = approveDate; //writedown.Closing_Date__c;
        
        EB_Account_Transaction__c valuationTrx = new EB_Account_Transaction__c();
        valuationTrx.EB_Account__c = writedown.EB_Account__c;
        valuationTrx.Transaction_Type__c = ORE_VALUATION_TRX;
        valuationTrx.Sub_Type__c = 'Writedown';
        valuationTrx.Amount__c = writedown.Transaction_Amount__c;
        valuationTrx.Cost_Center__c = writedown.EB_Account__r.EB_Unit__r.Center__c;
        valuationTrx.Vendor__c = writedown.RecordType.Name;
        valuationTrx.Effective_Date__c = approveDate; //writedown.Closing_Date__c;
        
        return new List<EB_Account_Transaction__c>{balanceTrx, valuationTrx};
    }
    
    private void createOREOaccountWhenReclassOreoForclosureIsInitiated(List<EB_Loan_Action__c> newList){
         List<EB_Loan_Action__c> currentList = [SELECT Id, Loss_Share__c,RecordTypeId, RecordType.Name,Region__c,
                                           EB_Account__c,Bank_Owned_Balance__c,Balance__c, EB_Account__r.Account_Line_1__c,
                                           EB_Account__r.Account_Line_2__c,EB_Account__r.Account_Status__c,EB_Account__r.EB_Region__c,
                                           EB_Account__r.EB_Unit__c, Address__c, Apprasial_Date__c,Appraisal_Amount__c,Date_of_Possession__c ,
                                           Transaction_Amount__c, Loan_Category__c
                                           FROM EB_Loan_Action__c WHERE Id in :newList];                                                           
        List<EB_Account__c> OREOsListforInsert = new List<EB_Account__c>();
        for(EB_Loan_Action__c record :currentList){
            if(record.recordtype.Name == 'Reclassification to OREO' ){
                EB_Account__c oreoAccount = new EB_Account__c();
                oreoAccount.OREO_Short_Name__c = record.EB_Account__r.Account_Line_1__c;
                oreoAccount.EB_Unit__c = record.EB_Account__r.EB_Unit__c;
                oreoAccount.OREO_Loan_Number__c = record.EB_Account__c;
                oreoAccount.RecordTypeId = utility.recordTypeObject('EB_Account__c', 'OREO').Id;
                oreoAccount.OREO_Address__c=record.Address__c;
                oreoAccount.OREO_Original_Appraised_Date__c = record.Apprasial_Date__c;
                oreoAccount.OREO_Current_Appraised_Date__c = record.Apprasial_Date__c;
                oreoAccount.OREO_Original_Appraised_Value__c = record.Appraisal_Amount__c;
                oreoAccount.OREO_Current_Appraised_Value__c = record.Appraisal_Amount__c;
                oreoAccount.OREO_Acquired_Date__c = record.Date_of_Possession__c;
                oreoAccount.OREO_Acquired_Balance__c = record.Transaction_Amount__c;
                oreoAccount.OREO_Current_Book_Balance__c = record.Transaction_Amount__c;
                oreoAccount.OREO_Loss_Share_Type__c = record.Loan_Category__c;
                oreoAccount.Account_Status__c = 'O';
                
                OREOsListforInsert.add(oreoAccount);  
            }
        }
        if(OREOsListforInsert.size() > 0 )insert OREOsListforInsert;  
    }
    
    public Map<id,Recordtype> RecordTypeMap{
        get{
            if(RecordTypeMap == null){
                RecordTypeMap = new Map<id,Recordtype>();
                RecordTypeMap = new Map<Id,Recordtype>([SELECT Name, Id FROM RecordType WHERE SobjectType =: 'EB_Loan_Action__c']);
                
            }
            return RecordTypeMap;
        }
        set;         
    }

    public Map<id,Recordtype> RecordTypeLoanTransMap{
        get{
            if(RecordTypeLoanTransMap == null){
                RecordTypeLoanTransMap = new Map<id,Recordtype>();
                List<RecordType> recs =  RecordTypeMap.values();
                for(RecordType rec : recs){
                    if(rec.name== 'Loan Credit' || rec.name == 'Loan Debit')
                    RecordTypeLoanTransMap.put(rec.id,rec);
                }            
            }
            return RecordTypeLoanTransMap;
        }
        set;
    }
    
    public Map<id,Recordtype> RecordTypeChargeOffRecoveryMap{
        get{
            if(RecordTypeChargeOffRecoveryMap == null){
                RecordTypeChargeOffRecoveryMap = new Map<id,Recordtype>();
                List<RecordType> recs =  RecordTypeMap.values();
                for(RecordType rec : recs){
                    if(rec.name== 'Recovery' || rec.name == 'Charge-Off')
                    RecordTypeChargeOffRecoveryMap.put(rec.id,rec);
                }            
            }
            return RecordTypeChargeOffRecoveryMap;
        }
        set;
    }
    
    public void createCoRcvryObjects(List<EB_Loan_Action__c> newList){
        List<RecordType> CorRecordTypeList = [SELECT Name, Id FROM RecordType WHERE SobjectType =: 'Charge_Off_Recovery__c'];
        //since we're using After Insert, After Update trigger context, 
        //create a list of EB_Loan_Action__c objects and stuff the trigger.new 
        //context into them so we can update them all via DML at the end of this process.
        List<EB_Loan_Action__c> updateActions = new List<EB_Loan_Action__c>();
        List<Charge_Off_Recovery__c> insertChargeOffRecoveryList = new List<Charge_Off_Recovery__c>();
        String actionRecTypeName;
        Id corRecTypeId;
        for (EB_Loan_Action__c action : newList){           
            
            //make sure the flag is set. Flag is triggered by Approval or Workflow process...
            if (action.Chg_Off_Rec_Tracking__c==true){          
                
                //add this action to the updateActions list and turn off the Che_Off_Rec_Tracking flag...
                EB_Loan_Action__c updateAction = new EB_Loan_Action__c(id = action.id, Chg_Off_Rec_Tracking__c = false);
                updateActions.add(updateAction);

                actionRecTypeName = RecordTypeMap.get(action.RecordTypeId).Name;        
                
                //find the corresponding RecordType id of the Charge-Off/Recovery object...
                for (RecordType r : CorRecordTypeList){
                    if(r != null){
                        if(r.Name == actionRecTypeName) {
                            corRecTypeId = r.Id;
                        }
                    }
                }
                Datetime dt = System.now();
                Date d = date.newinstance(dt.year(),dt.month(),dt.day());               
                
                //Finally, create & insert the Charge-Off & Recovery object...
                Charge_Off_Recovery__c cor = new Charge_Off_Recovery__c();
                cor.RecordTypeId = corRecTypeId;
                cor.Date__c = d;
                cor.EB_Account__c = action.EB_Account__c;
                System.debug('RecType=' + actionRecTypeName);
                if (actionRecTypeName=='Recovery') {
                    cor.Recovery_Amount__c = action.Transaction_Amount__c;
                } else {
                    cor.Charge_Off_Amount__c = action.Transaction_Amount__c;
                }
                cor.Created_via_Trigger__c = true;
                //insert cor;
                insertChargeOffRecoveryList.add(cor);
                
            }
        }
        //update the actions if any have been processed
        if(updateActions.size()>0){
            update updateActions;
        }
        //insert new records
        if(insertChargeOffRecoveryList.size()> 0) insert insertChargeOffRecoveryList;        
    }

    public void BeforeInsertAccountActionForLoanTransaction(List<EB_Loan_Action__c> newList){       
        ValidateLoanTransactionSave(newList);                   
    }
    
    private void ValidateLoanTransactionSave(List<EB_Loan_Action__c> newList){
        Integer GraceDays = 15;
         
         datetime dT = system.now();
         Date d = date.newinstance(dT.year(), dT.month(), dT.day());
         
         decimal TransactionAmount = 0;
         if(newList[0].Transaction_Amount__c != null) TransactionAmount  = newList[0].Transaction_Amount__c;
        
        //Transaction  amount calculation -  Borrowing Base dependency
        decimal TotalDebitTransaction = 0;
        List<EB_Account__c> acctList = [SELECT id, name, Unadvanced_Loan_Amount__c,current_balance__c,Bank_Owned_Balance__c,Maturity_Date__c FROM EB_Account__c WHERE id =: newList[0].EB_Account__c];
        List<RecordType> recs =  RecordTypeLoanTransMap.values();
        Id recordtypeDebit ; 
        for(RecordType rec : recs){
          if(rec.name == 'Loan Debit') recordtypeDebit = rec.id ;
          
        }
        
        //only if eb account exists
        if(acctList.size() > 0 ){
            
          decimal currentTranAmount = 0;
          for(EB_Loan_Action__c action :[SELECT id,Transaction_Effective_Date__c, recordtypeid, name, transaction_Amount__c   FROM  EB_Loan_Action__c WHERE RecordCreatedDate__c = :d and EB_Account__r.id =:acctList[0].Id and recordtypeid =: recordtypeDebit and Id !=: newList[0].Id] ){
            if(action.transaction_Amount__c != 0 ) TotalDebitTransaction = TotalDebitTransaction + action.transaction_Amount__c;
          }
    
          system.debug('##TotalDebitTransaction (add tran amount)' + string.valueof(TotalDebitTransaction));
          decimal AvailableEffectiveValue = 0;
          date dateForDelinquenyCalculation;
          date TodaysDate = date.today();
          
          
          List<Borrowing_Base__c> bbaseList = [SELECT id,Schedule_Days__c,Current_Excess_Shortfall__c,Archived__c,Total_Availability_Transition__c, Other_Availability_Transition__c, name, Loan_Number__c, Total_Availability__c,Schedule__c, Unadvanced_Amount__c, Last_BBC_Date__c,Loan_Number__r.current_balance__c, Loan_Number__r.Bank_Owned_Balance__c, Loan_Number__r.Unadvanced_Loan_Amount__c  FROM Borrowing_Base__c WHERE Loan_Number__c =: acctList[0].Id and Archived__c =:false order by createddate desc limit 1];
          String ErrorTracker = '';
          String Error = '';
          if(bbaseList.size() > 0){
            for(Borrowing_Base__c bb : bbaseList){
              
              Integer Schedule = integer.valueof(bb.Schedule_Days__c);
              
              if(bb.Current_Excess_Shortfall__c < bb.Loan_Number__r.Unadvanced_Loan_Amount__c)
                AvailableEffectiveValue = bb.Current_Excess_Shortfall__c;
              else{
                AvailableEffectiveValue = bb.Loan_Number__r.Unadvanced_Loan_Amount__c;
              }
                
              //Delinquency calculation
              if(bb.Last_BBC_Date__c != null){
                 dateForDelinquenyCalculation =  bb.Last_BBC_Date__c + Schedule + GraceDays ;
              }
            }
          }else{
            AvailableEffectiveValue = acctList[0].Unadvanced_Loan_Amount__c;
          }
          if(AvailableEffectiveValue == null)  AvailableEffectiveValue = 0;
          
      
          newList[0].Availability__c = AvailableEffectiveValue - TotalDebitTransaction ;
          system.debug('##Error 1 : newList[0].Availability__c ' + string.valueof(newList[0].Availability__c) + ' Unadvanced_Loan_Amount__c ' + string.valueof(acctList[0].Unadvanced_Loan_Amount__c) + 'TotalDebitTransaction ' + string.valueof(TotalDebitTransaction) + 'Compare recordtype ' + newList[0].recordtypeid + ' == ' + recordtypeDebit + ' Transaction Approver ' + newList[0].Transaction_Approver__c );
          // Display Error on Account Action for Loan Debit/Credit
          if(acctList[0].Unadvanced_Loan_Amount__c < (TotalDebitTransaction + TransactionAmount) && newList[0].recordtypeid == recordtypeDebit && newList[0].Transaction_Approver__c == null){
              Error = 'Approval Required : Transaction will exceed unadvanced amount ($'+ string.valueof(acctList[0].Unadvanced_Loan_Amount__c) +'), Loan Transaction requires a Transaction Approver';
              newList[0].addError(Error);
                
          }if(newList[0].recordtypeid == recordtypeDebit && (newList[0].Transaction_Type__c =='Loan Advance'  || newList[0].Transaction_Type__c =='Principal reversal')){
            if(bbaseList.size() > 0){ 
              if(newList[0].Availability__c < TransactionAmount && newList[0].Transaction_Approver__c == null){
                Error = 'Approval Required : Availability - based on Borrowing Base(Total Availability) & Unadvanced Loan Amount ($'+ string.valueof(newList[0].Availability__c)+'), Loan Transaction requires a Transaction Approver';
                newList[0].addError(Error);
                
              }else if( newList[0].Transaction_Effective_Date__c  > acctList[0].Maturity_Date__c && newList[0].Transaction_Approver__c == null){
                Error = 'Approval Required : Passed Maturity Date  ('+ string.valueof(acctList[0].Maturity_Date__c)+'), Loan Transaction requires a Transaction Approver';
                newList[0].addError(Error);
                
              }else if(dateForDelinquenyCalculation!= null && dateForDelinquenyCalculation  < TodaysDate && newList[0].Transaction_Approver__c == null){
                Error = 'Approval Required : Borrowing Base (Delinquent) - Includes 15 days grace period ('+ string.valueof(dateForDelinquenyCalculation)+'), Loan Transaction requires a Transaction Approver';
                newList[0].addError(Error);
                
              }else if((newList[0].Availability__c < TransactionAmount || newList[0].Transaction_Effective_Date__c < acctList[0].Maturity_Date__c) && newList[0].Transaction_Approver__c != null){
                //SubmitForApproval(newList);
              }        
            }else if( newList[0].Transaction_Effective_Date__c  > acctList[0].Maturity_Date__c && newList[0].Transaction_Approver__c == null){
               Error = 'Approval Required : Passed Maturity Date ('+ string.valueof(acctList[0].Maturity_Date__c)+'), Loan Transaction requires a Transaction Approver' ;
               newList[0].addError(Error);
               
            }else if(newList[0].Transaction_Effective_Date__c  > acctList[0].Maturity_Date__c && newList[0].Transaction_Approver__c != null){
              //SubmitForApproval(newList);
            }
          }
          
          //Redundent code tracks error in a field for Email
          //?? Clean up task for future
          // Display Error on Account Action for Loan Debit/Credit
          if(acctList[0].Unadvanced_Loan_Amount__c < (TotalDebitTransaction + TransactionAmount) && newList[0].recordtypeid == recordtypeDebit ){
              Error = 'Approval Required : Transaction will exceed unadvanced amount ($'+ string.valueof(acctList[0].Unadvanced_Loan_Amount__c) +'), Loan Transaction requires a Transaction Approver \n';          
              ErrorTracker = ErrorTracker + Error ;   
          }if(newList[0].recordtypeid == recordtypeDebit && (newList[0].Transaction_Type__c =='Loan Advance'  || newList[0].Transaction_Type__c =='Principal reversal')){
            if(bbaseList.size() > 0){ 
              if(newList[0].Availability__c < TransactionAmount ){
                Error = 'Approval Required : Availability - based on Borrowing Base(Total Availability) & Unadvanced Loan Amount ($'+ string.valueof(newList[0].Availability__c)+'), Loan Transaction requires a Transaction Approver \n';            
                ErrorTracker = ErrorTracker + Error ;
              }else if( newList[0].Transaction_Effective_Date__c  > acctList[0].Maturity_Date__c ){
                Error = 'Approval Required : Passed Maturity Date  ('+ string.valueof(acctList[0].Maturity_Date__c)+'), Loan Transaction requires a Transaction Approver \n';            
                ErrorTracker = ErrorTracker + Error ;
              }else if(dateForDelinquenyCalculation!= null && dateForDelinquenyCalculation  < TodaysDate ){
                Error = 'Approval Required : Borrowing Base (Delinquent) - Includes 15 days grace period ('+ string.valueof(dateForDelinquenyCalculation)+'), Loan Transaction requires a Transaction Approver \n';           
                ErrorTracker = ErrorTracker + Error ;
              }else if((newList[0].Availability__c < TransactionAmount || newList[0].Transaction_Effective_Date__c < acctList[0].Maturity_Date__c) ){
                //SubmitForApproval(newList);
              }        
            }else if( newList[0].Transaction_Effective_Date__c  > acctList[0].Maturity_Date__c ){
               Error = 'Approval Required : Passed Maturity Date ('+ string.valueof(acctList[0].Maturity_Date__c)+'), Loan Transaction requires a Transaction Approver \n' ;         
               ErrorTracker = ErrorTracker + Error ;
            }else if(newList[0].Transaction_Effective_Date__c  > acctList[0].Maturity_Date__c ){
              //SubmitForApproval(newList);
            }
          }
          newList[0].Transaction_Approval_Reason__c = ErrorTracker;
        }
        
    }
    
    private Integer Schedule(Borrowing_Base__c borrowingbase){
        if(borrowingbase.Schedule__c == '7 Days')
            return 7;
        else if(borrowingbase.schedule__c == '30 Days')
            return 30;
        else if(borrowingbase.schedule__c == '60 Days')
            return 60;
        else if(borrowingbase.schedule__c == '90 Days')
            return 90;
        else if(borrowingbase.schedule__c == '180 Days')
            return 180;
        else if(borrowingbase.schedule__c == '360 Days')
            return 360;
        else
            return 0;
    }
    
    public void BeforeUpdateAccountActionForLoanTransaction(Map<id,EB_Loan_Action__c> oldMap, List<EB_Loan_Action__c> newList){
        try{
            for(EB_Loan_Action__c action : newList){
                if(action.Subordination_Stages__c == 'Completed' && action.ATE_Status__c == 'Processed'){
                    if(oldMap.get(action.id).Subordination_Stages__c == 'Completed' && oldMap.get(action.id).ATE_Status__c == 'Exclude')
                        return;
                }
            }
            ValidateLoanTransactionSave(newList);
        }catch(exception ex){
            
        }        
    }
    
    public void SubmitForApproval(List<EB_Loan_Action__c> newList){     
        if(RecordTypeLoanTransMap.containskey(newList[0].RecordTypeId)){
            Approval.Processsubmitrequest req1 = new Approval.Processsubmitrequest();
            req1.setObjectId(newList[0].Id);
            Approval.Processresult result = Approval.process(req1);
        }             
    }
    
}