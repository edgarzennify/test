public virtual class ProspectToClientBaseClass {
    
    protected String url = '';
    protected Account Prospect;
    @TestVisible protected Id recId;
    protected List<RecordType> recordTypeList = null;
    public ProspectToClientBaseClass(){
        String serverUrl = Utility.getServerUrl();
        url = serverUrl + '/';
        getRefineSearchStatus = 'false';
    }
    
    public String getQuotes(){
       return '"';
    }
  
    public String getRefineSearchStatus{set;get;}

    @TestVisible protected List<SelectOption> getUnmatchedClientNameList(String currentSelectedOption){
        getRefineSearchStatus = 'false';
        List<SelectOption> options = new List<SelectOption>();
        String searchTerm = currentSelectedOption;   
       
         
        if(searchTerm == null || searchTerm == '') return options;
                        
        searchTerm = searchTerm.replace('*', ' ');                      
        searchTerm = searchTerm.trim();
        searchTerm = searchTerm.replace('  ', ' ');
        searchTerm = searchTerm.replace('  ', ' ');
        searchTerm = searchTerm.replace(' ', '%');
        searchTerm = '%' + searchTerm + '%';
        
        if(searchTerm == '%%') return options; 
        
        List<Account> accounts = [SELECT Id , EB_Client_Name__c , Name FROM Account  WHERE EB_Client_Name__c like : searchTerm and RecordTypeId =: ClientRecordType.Id limit 150];
        
        options.add(new SelectOption('--None--','--None--'));
        for(Account a : accounts){
            
                if(a.EB_Client_Name__c <>null)
                options.add(new SelectOption(a.Id , a.EB_Client_Name__c)); 
        }
    
        if(options.size() > 100) getRefineSearchStatus = 'true';
        return options;     
    }
    @TestVisible protected RecordType getRecordTypeIdForName(String SObjectType, String RecordTypeName){
        return Utility.RecordTypeObject(SObjectType,RecordTypeName);
    }
    @TestVisible protected  Account getAccountObjectForId(Id AccountID){
        Account acct = new Account();
        try{
            acct = [SELECT Id, Name, EB_Client_Name__c , RecordTypeId, TIN_SSN__c,SSNTIN_Encrypted__c, EB_Customer_Number__c , BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity, Phone,  Import_Source__c FROM Account WHERE Id =: AccountID limit 1];
        }catch(exception e){
            acct = null;
        }
        return acct;
                
    }
    @TestVisible protected  Account updateClientInfoToProspect(Account ProspectAccount, Account ClientAccount){      
        if(ProspectAccount == null || ClientAccount == null) return null;
        Id record_typeId = getRecordTypeIdForName('Account','Prospect').Id;
        if(ProspectAccount.RecordTypeId == record_typeId)
        {
            Id ClientRecordTypeID = getRecordTypeIdForName('Account' ,'Client').Id;
            if(ClientRecordTypeID <> null)
            ProspectAccount.RecordTypeId = ClientRecordTypeID;
            ProspectAccount.TIN_SSN__c = ClientAccount.TIN_SSN__c;
            ProspectAccount.EB_Customer_Number__c = ClientAccount.EB_Customer_Number__c;
            ProspectAccount.EB_Client_Name__c = ClientAccount.EB_Client_Name__c;
            ProspectAccount.BillingStreet = ClientAccount.BillingStreet;
            ProspectAccount.BillingState = ClientAccount.BillingState;
            ProspectAccount.BillingPostalCode = ClientAccount.BillingPostalCode;
            ProspectAccount.BillingCountry = ClientAccount.BillingCountry;
            ProspectAccount.BillingCity = ClientAccount.BillingCity;
            ProspectAccount.Phone = ClientAccount.Phone;
            ProspectAccount.SSNTIN_Encrypted__c = ClientAccount.SSNTIN_Encrypted__c;
            ProspectAccount.Import_Source__c = 'Prospect Promoted To Client';
            update ProspectAccount;
        }
        return ProspectAccount;
    }
    
    @TestVisible protected  void updateEB_AccountPrimaryOwner(Account ProspectAccount, Account ClientAccount){

        List<EB_Account__c> ebaccounts = [SELECT Id, Primary_Owner_Id__c FROM EB_Account__c WHERE Primary_Owner_Id__c =:ClientAccount.Id ];     
        List<EB_Account__c> ebacctsUpdate = new List<EB_Account__c>();
        for(EB_Account__c a: ebaccounts){
            a.Primary_Owner_Id__c = ProspectAccount.Id;
            ebacctsUpdate.add(a);
        }
        if (ebacctsUpdate <> null)  update ebacctsUpdate;
    }
    @TestVisible protected  void updateEB_AccountPrimaryOwner(List<EB_Account__c> ClientEBAccounts, Id ProspectId){

        List<EB_Account__c> ebacctsUpdate = new List<EB_Account__c>();
        for(EB_Account__c a: ClientEBAccounts){
            a.Primary_Owner_Id__c = ProspectId;
            ebacctsUpdate.add(a);
        }
        if (ebacctsUpdate <> null)  update ebacctsUpdate;
    }
    @TestVisible protected void updateEB_Account_RelationshipAccountId(Account ProspectAccount, Account ClientAccount){
        
        List<EB_Account_Relationship__c> ebrelaccounts = [SELECT Id, Name, Client_Id__c FROM EB_Account_Relationship__c WHERE Client_Id__c =:ClientAccount.Id limit 950];       
        List<EB_Account_Relationship__c> acctsForUpdate = new List<EB_Account_Relationship__c>();
        for(EB_Account_Relationship__c a : ebrelaccounts){
            a.Client_Id__c = ProspectAccount.Id;
            acctsForUpdate.add(a);
        }
        if (acctsForUpdate <> null) update acctsForUpdate;
    }
    @TestVisible protected void updateTMAccountId(Account ProspectAccount, Account ClientAccount){       
    
      List<Treasury_Management__c> updatetmserviceList = new List<Treasury_Management__c>();
      for(Treasury_Management__c tm : [SELECT Id, Account__c FROM Treasury_Management__c WHERE Account__c =:ClientAccount.ID limit 950]){
            tm.Account__c = ProspectAccount.Id;
            updatetmserviceList.add(tm);
      }                                             
      if(updatetmserviceList.size()>0) update updatetmserviceList;
    }
    @TestVisible protected void updateTMAccountId( List<Treasury_Management__c> ClientTM , Account ProspectAccount){     

        List<Treasury_Management__c> tmForUpdate = new List<Treasury_Management__c>();
        for(Treasury_Management__c t : ClientTM){
            t.Account__c = ProspectAccount.Id;
            tmForUpdate.add(t);         
        }
        if(tmForUpdate.size() > 0 ) update tmForUpdate;
    }

    @TestVisible protected void updateRelatedEntities(Account currentProspect, Account currentClient ,Id ebaccountId){
          
          List<EB_Account_Relationship__c> updateRels = new List<EB_Account_Relationship__c>();
          for(EB_Account_Relationship__c r : [SELECT Id, Name, Client_Id__c, EB_Account_Id__c FROM EB_Account_Relationship__c WHERE EB_Account_Id__c =: ebaccountId and Client_Id__c =: currentClient.Id]){
            r.Client_Id__c = currentProspect.Id;
            updateRels.add(r);
          }
          if(updateRels.size()> 0 ) update updateRels;
    }
    @TestVisible protected void updateRelatedEntities( List<EB_Account_Relationship__c> clientAccountRelationships , Id ProspectId){
          
          List<EB_Account_Relationship__c> updateRels = new List<EB_Account_Relationship__c>();
          for(EB_Account_Relationship__c r : clientAccountRelationships ){//[SELECT Id, Name, Client_Id__c, EB_Account_Id__c FROM EB_Account_Relationship__c WHERE EB_Account_Id__c =: ebaccountId and Client_Id__c =: currentClient.Id]){
            r.Client_Id__c = prospectId;
            updateRels.add(r);
          }
          if(updateRels.size()> 0 ) update updateRels;
    }
    @TestVisible protected void updateRelatedCollaterals(EB_Collateral__c  prospectiveCollateral, EB_Collateral__c existingCollateral, Id ebaccountId){
          List<EB_Collateral_Account_Relationship__c> updateRels = new List<EB_Collateral_Account_Relationship__c>();
          for(EB_Collateral_Account_Relationship__c r : [SELECT Id, Name, EB_Collateral_ID__c FROM EB_Collateral_Account_Relationship__c WHERE EB_Account_ID__c =: ebaccountId and EB_Collateral_ID__c =: existingCollateral.Id]){
            r.EB_Collateral_ID__c = prospectiveCollateral.Id;
            updateRels.add(r);
          }
          if(updateRels.size() > 0) update updateRels;
    }
    @TestVisible protected List<EB_Collateral_Account_Relationship__c> updateRelatedCollaterals(EB_Collateral__c  prospectiveCollateral, List<EB_Collateral_Account_Relationship__c> collateralAccountRelationships){
        List<EB_Collateral_Account_Relationship__c> updateRels = new List<EB_Collateral_Account_Relationship__c>();
        for(EB_Collateral_Account_Relationship__c collAcctRel : collateralAccountRelationships){
            collAcctRel.EB_Collateral_ID__c = prospectiveCollateral.Id;
            updateRels.add(collAcctRel);
        }
        return updateRels;
    }
    @TestVisible protected void updateRelatedEntityCollaterals(EB_Collateral__c  prospectiveCollateral, EB_Collateral__c existingCollateral, Id entityId){
         List<EB_Collateral_Client_Relationship__c> deleteRels = new List<EB_Collateral_Client_Relationship__c>();
          for(EB_Collateral_Client_Relationship__c r : [SELECT Id, Name, EB_Collateral_ID__c, Client_ID__c FROM EB_Collateral_Client_Relationship__c WHERE Client_ID__c =: entityId and EB_Collateral_ID__c =: existingCollateral.Id]){
            //r.EB_Collateral_ID__c = prospectiveCollateral.Id;
            deleteRels.add(r);
          }
          if(deleteRels.size() > 0) delete deleteRels;
    }
    @TestVisible protected void updateProspectiveCollateralWithExistingData(EB_Collateral__c prospective, EB_Collateral__c existing){
        prospective.Name = existing.Name;
        prospective.Collateral_Code__c = existing.Collateral_Code__c;
        prospective.Collateral_Description__c = existing.Collateral_Description__c;
        prospective.Key__c = existing.Key__c;
        prospective.Collateral_Number__c = existing.Collateral_Number__c;
        prospective.Collateral_Application__c = existing.Collateral_Application__c;
        prospective.EB_Bank__c = existing.EB_Bank__c;
        
        update prospective;
        
    }
    @TestVisible protected void updateAppraisalOrder(EB_Collateral__c prospective, EB_Collateral__c existing){
        List<EB_Appraisal_Order__c> updateList = new List<EB_Appraisal_Order__c>();
        for(EB_Appraisal_Order__c o : [SELECT Id ,Name, Related_Collateral__c FROM EB_Appraisal_Order__c WHERE Related_Collateral__c =: existing.Id]){
            o.Related_Collateral__c = prospective.Id;
            updateList.add(o);
        }
        if(updateList.size() > 0) update updateList;
    }
    @TestVisible protected List<EB_Appraisal_Order__c> updateAppraisalOrder(EB_Collateral__c prospectiveCollateral, List<EB_Appraisal_Order__c> existingCollateralAppraisalOrders){
        List<EB_Appraisal_Order__c> appraisalList = new List<EB_Appraisal_Order__c>();
        for(EB_Appraisal_Order__c appOrder : existingCollateralAppraisalOrders){
            appOrder.Related_Collateral__c = prospectiveCollateral.Id;
            appraisalList.add(appOrder);
        }
        return appraisalList;
    }
    @TestVisible protected void updateAttachments(Id newId , Id oldId){
        
        List<Attachment> insertList = new List<Attachment>();
        
        for(Attachment a : [SELECT Id, Name, body, BodyLength,ContentType,Description, OwnerId FROM Attachment WHERE ParentId =: oldId ]){
            Attachment aa = new Attachment();
            aa.Body = a.Body;
            //aa.BodyLength = a.BodyLength;
            aa.ContentType = a.ContentType;
            aa.Description = a.Description;
            aa.ParentId = newId;
            aa.Name = a.Name;
            //if(useractiveMap.get(a.OwnerId) == true) aa.OwnerId = a.OwnerId;
            insertList.add(aa);
        }
        if(insertList.size() > 0 ) insert insertList;
        
    }
    @TestVisible protected void updateNotes(id newId , Id oldId){
        List<Note> insertList = new List<Note>();
        for(Note a : [SELECT Id,  body, OwnerId, Title FROM Note WHERE ParentId =: oldId ]){
            Note n = new Note();
            //if(useractiveMap.get(a.OwnerId) == true) n.OwnerId = a.OwnerId;
            n.Body = a.Body;
            n.Title = a.Title;
            n.ParentId = newId;
            insertList.add(n);
        }
        if(insertList.size() > 0 ) insert insertList;
    }
    @TestVisible protected void updateEBAccountServices(Id newtmserviceId, Id oldtmserviceId){
        List<EB_Account_Service__c> aservices = [SELECT Id , name, TM_Service__c FROM EB_Account_Service__c WHERE TM_Service__c =:oldtmserviceId limit 950];
        List<EB_Account_Service__c> ebacctsupdate = new List<EB_Account_Service__c>();
        for(EB_Account_Service__c a : aservices){
                a.TM_Service__c = newtmserviceId;
                ebacctsupdate.add(a);
        }
        if (ebacctsupdate <> null) update ebacctsupdate;
    }
    @TestVisible protected void updateEBRelatedAccountOwners(Account ProspectAccount, Account ClientAccount){
        List<EB_Related_Account_Owner__c> ebrelowners = [SELECT Id, Name, Account_ID__c FROM EB_Related_Account_Owner__c WHERE Account_ID__c =:ClientAccount.ID limit 950];     
        List<EB_Related_Account_Owner__c> acctsForUpdate = new List<EB_Related_Account_Owner__c>();
        for(EB_Related_Account_Owner__c a : ebrelowners){
            a.Account_ID__c = ProspectAccount.ID;
            acctsForUpdate.add(a);
        }
        if (acctsForUpdate <> null) update acctsForUpdate;
    }
    @TestVisible protected void updateEBRelatedAccountOwners( List<EB_Related_Account_Owner__c> ebrelowners , Id ProspectId){
        //List<EB_Related_Account_Owner__c> ebrelowners = [SELECT Id, Name, Account_ID__c FROM EB_Related_Account_Owner__c WHERE Account_ID__c =:ClientAccount.ID limit 950];       
        List<EB_Related_Account_Owner__c> acctsForUpdate = new List<EB_Related_Account_Owner__c>();
        for(EB_Related_Account_Owner__c a : ebrelowners){
            a.Account_ID__c = ProspectId;
            acctsForUpdate.add(a);
        }
        if (acctsForUpdate <> null) update acctsForUpdate;
    }
    @TestVisible protected void updateTasks(Account ProspectAccount, Account ClientAccount){     
        List<Task> tasks = [SELECT Id,  AccountID, WhatId FROM Task WHERE AccountID =: ClientAccount.ID limit 10];      
        if(tasks <> null){
            List<Task> tasksForUpdate = new List<Task>();
            for(Task t : tasks){
                t.WhatId = ProspectAccount.ID;
                tasksForUpdate.add(t);
            }
            if (tasksForUpdate.size() > 0 ) update tasksForUpdate;
        }
        
    }
    @TestVisible protected void updateTasks( List<Task> tasks, Id ProspectId){       
        //List<Task> tasks = [SELECT Id,  AccountID, WhatId FROM Task WHERE AccountID =: ClientAccount.ID limit 10];        
        if(tasks <> null){
            List<Task> tasksForUpdate = new List<Task>();
            for(Task t : tasks){
                t.WhatId = ProspectId;
                tasksForUpdate.add(t);
            }
            if (tasksForUpdate.size() > 0 ) update tasksForUpdate;
        }
        
    }
    @TestVisible protected void updatePackets(Account ProspectAccount, Account ClientAccount){
        List<EB_Loan_Packet__c> updatePackets = new List<EB_Loan_Packet__c>();
        for(EB_Loan_Packet__c p : [SELECT Id, Lead_Entity__c FROM EB_Loan_Packet__c WHERE Lead_Entity__c =: ClientAccount.Id]){
            p.Lead_Entity__c = ProspectAccount.Id;
            updatePackets.add(p);
        }
        if( updatePackets.size() > 0) update updatePackets;
        
    }
    @TestVisible protected void updateRelatedEntitiesOnLoanApp(Account ProspectAccount, Account ClientAccount){
        List<EB_Loan_App_Entity_Relationship__c> updateRels = new List<EB_Loan_App_Entity_Relationship__c>();
        for(EB_Loan_App_Entity_Relationship__c r : [SELECT Id, Entity_Name__c FROM EB_Loan_App_Entity_Relationship__c WHERE Entity_Name__c =:ClientAccount.Id ]){
            r.Entity_Name__c = ProspectAccount.Id;
            updateRels.add(r);
        }
        if(updateRels.size() > 0) update updateRels;
    }
    @TestVisible protected void updateEBPipeline(Account ProspectAccount , Account ClientAccount){
        List<opportunity> pipelineList = new List<opportunity>();
        for(opportunity o : [SELECT Id, AccountId, Lost_Date__c, Reason_Lost__c,StageName  FROM opportunity WHERE AccountId =: ClientAccount.Id  limit 950]){
            o.AccountId = ProspectAccount.Id;
            pipelineList.add(o);

        }
        if(pipelineList.size() > 0) update pipelineList;
    }
                                             
        
    @TestVisible protected void updateEBPipeline( List<opportunity> ClientPipelines , Id ProspectId){
        
        if(ClientPipelines <> null){
            List<opportunity> ebpipelineForUpdate = new List<opportunity>();
            for(opportunity o : ClientPipelines){
                o.AccountId = ProspectId;
                ebpipelineForUpdate.add(o);
            }
            if (ebpipelineForUpdate.size() > 0) update ebpipelineForUpdate;
        }

    }

    private RecordType ClientRecordType{
        get{
            return utility.RecordTypeObject('Account', 'Client');
        }
    }
    
}