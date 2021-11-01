public  class SynchronizeBookedLoanController extends SynchronizeLoan{
   
   	public String ShowSelectiveCollateralMerge{ 
   		get{
   			Profile pr = [SELECT name FROM Profile WHERE id =: UserInfo.getProfileId()];
            if(pr.Name == 'System Administrator' || pr.Name == 'Data Administrator') return 'true';
            return 'false'; 
   		}
   		set; 
   	}
   	public String SelectiveCollateralMergeId{get;set;}
   	
    public boolean IsAppGuidanceLine = false;
    private Id ConvertedPrimaryOwner{get;set;}
    private Agreements.IAgreementStatusManager m_agreementStatusManager;
    private ProspectToClient.IProspectToClientManager m_prospectToClientManager;

    @TestVisible
    public  class BookedData{
    	public String index{get;set;}
        public String BookedProspect{get;set;}
        public Id BookedProspectId{get;set;}
        public String dropdownOptionId{get;set;}
        public List<SelectOption> getOptions{get;set;}
    }
    public List<BookedData> booked{get;set;}
    public List<BookedData> entities{get;set;}
    public List<BookedData> collaterals{get;set;}
    
    public SynchronizeBookedLoanController(ApexPages.StandardController controller) {
        m_agreementStatusManager = new AgreementStatusManager(UserInfoService.bootstrap(), new AgreementEntityManager(new AgreementEntityManagerDataProvider()), new AgreementStatusManagerDataProvider());
        ProspectToClient.IProspectToClientDataProvider dp = new ProspectToClientDataProvider();
        m_prospectToClientManager = new ProspectToClientManager(dp,new ProspectToClientMerger(dp));
        
        if(url == '') url = Utility.getServerUrl() + '/';
        
        initialize();
        
        SetEBAccount();
        
        //rest goes to save 
        LoadProspectsForLoanApp();
        LoadCollateralData();
    }
    
    public SynchronizeBookedLoanController(Agreements.IAgreementStatusManager statusManager, ProspectToClient.IProspectToClientManager prospectToClientManager){
    	m_agreementStatusManager = statusManager;
    	m_prospectToClientManager = prospectToClientManager;
    }
    
    @TestVisible
    private void initialize(){
        try{
             this.LoanAppId = apexpages.currentpage().getparameters().get('id');
                 
        }catch(exception ex){
                this.LoanAppId = null;
        }
        initializeHelper();
    }
    
    @TestVisible
    private void EBAccountDoesNotExistsMessage(){
             ApexPages.Message myMsgebacct = new ApexPages.Message(ApexPages.Severity.ERROR, 'Account not found. Please verify the account number on Loan App.');
             ApexPages.addMessage(myMsgebacct);
             AccountMissing = true;
    }
    
    @TestVisible
    private void SetEBAccount(){
        if((app.Account_Number_Assigned__c == '' || app.Account_Number_Assigned__c == null) && (app.Account_Number__c == null) ) {EBAccountDoesNotExistsMessage(); return;}
        accts = new List<EB_Account__c>();
         
        if(app.Record_Type_Description__c != null && (app.Record_Type_Description__c.tolowercase() == 'new'  || app.Record_Type_Description__c == utility.NewGuidanceLineAdvance())){
            if(app.Account_Number_Assigned__c != '' || app.Account_Number_Assigned__c == null){
                String Accountnumber = app.Account_Number_Assigned__c.replace('-','');
                Accountnumber = Accountnumber.trim();
                if( (app.loan_type__c == utility.LoanTypeGuidanceLine() || app.loan_type__c == utility.LoanTypeGuidanceLineFixed() || app.Loan_Type__c == utility.LoanTypeGuidanceLineRevolving()) && app.Record_Type_Description__c != utility.NewGuidanceLineAdvance()){
                    IsAppGuidanceLine = true;
                    accts = [SELECT Id, Name,Archived_Loan_App__c,Primary_Owner_Id__c, (SELECT Id, Name, Account_Title__c, Client_Id__r.Id,Client_Id__r.Name,Client_Id__r.EB_Client_Name__c,Client_Id__r.createddate, EB_Account_Id__c FROM EB_Account_Relationships__r ), (SELECT EB_Collateral_ID__r.Name, EB_Collateral_ID__r.Collateral_Description__c ,EB_Collateral_ID__r.Status__c FROM EB_Collateral_Account_Relationships__r ORDER BY EB_Collateral_ID__r.Name) FROM EB_Account__c WHERE Account_Number__c =:  Accountnumber and application__c = 35];
                }else{
                    accts = [SELECT Id, Name,Archived_Loan_App__c,Primary_Owner_Id__c, (SELECT Id, Name, Account_Title__c, Client_Id__r.Id,Client_Id__r.Name,Client_Id__r.EB_Client_Name__c,Client_Id__r.createddate, EB_Account_Id__c FROM EB_Account_Relationships__r ), (SELECT EB_Collateral_ID__r.Name, EB_Collateral_ID__r.Collateral_Description__c ,EB_Collateral_ID__r.Status__c FROM EB_Collateral_Account_Relationships__r ORDER BY EB_Collateral_ID__r.Name) FROM EB_Account__c WHERE Account_Number__c =:  Accountnumber and application__c != 35 and application__c != 2 and application__c != 4 and application__c !=6  ];
                }
            }
        }else{
            accts = [SELECT Id, Name,Archived_Loan_App__c,Primary_Owner_Id__c, (SELECT Id, Account_Title__c, Name, Client_Id__r.Id,Client_Id__r.Name,Client_Id__r.EB_Client_Name__c, Client_Id__r.createddate,  EB_Account_Id__c FROM EB_Account_Relationships__r ), (SELECT EB_Collateral_ID__r.Name, EB_Collateral_ID__r.Collateral_Description__c ,EB_Collateral_ID__r.Status__c FROM EB_Collateral_Account_Relationships__r ORDER BY EB_Collateral_ID__r.Name) FROM EB_Account__c WHERE Id =: app.Account_Number__c];
        }

        if(accts.size() == 0){
             
               EBAccountDoesNotExistsMessage();
        
        }
    }
    
    @TestVisible
    private void LoadProspectsForLoanApp(){
       
        try{
        this.entities = new List<BookedData>();
        Integer counter = 0;
         for(EB_Loan_App_Entity_Relationship__c e : this.loanAppEntityRels){
                BookedData b = new BookedData();
                b.index = String.valueOf(counter);
                b.BookedProspect = e.Entity_Name__r.Name;
                b.BookedProspectId = e.Entity_Name__r.Id;
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('0', '--None--'));
                options.add(new SelectOption('1', 'Not Applicable'));

                for(EB_Account__c a : accts){
                    for(EB_Account_Relationship__c r: a.EB_Account_Relationships__r){
                        options.add(new SelectOption(r.Client_Id__r.Id,  r.Client_Id__r.EB_Client_Name__c));
                    }
                    
                    
                }
                b.getOptions = options;
                entities.add(b);
   				counter++;
         }
        }catch(exception ex){
            
        }
		
    }
    
    @TestVisible
    private void LoadCollateralData(){
        try{
         this.collaterals = new List<BookedData>();
          Integer counter = 0;
         for(EB_Loan_App_Collateral_Relationship__c c : this.loanAppCollateralRels){
                BookedData b = new BookedData();
                b.index = String.valueOf(counter);
                b.BookedProspect = c.EB_Collateral_ID__r.Collateral_Description__c;
                b.BookedProspectId = c.EB_Collateral_ID__r.Id;
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('0', '--None--'));
                options.add(new SelectOption('1', 'Not Applicable'));
                
                for(EB_Account__c a : accts){
                    for(EB_Collateral_Account_Relationship__c r: a.EB_Collateral_Account_Relationships__r){
                         String CollateralName = '';
                         String Description = '';
                         if(r.EB_Collateral_ID__r.Name != null ) CollateralName = r.EB_Collateral_ID__r.Name;
                         if(r.EB_Collateral_ID__r.Collateral_Description__c != null) Description = r.EB_Collateral_ID__r.Collateral_Description__c;
                         
                         if(r.EB_Collateral_ID__c != null) options.add(new SelectOption(r.EB_Collateral_ID__c,  CollateralName + ' ('+ Description +')'));
                    }
                }
                b.getOptions = options;
                collaterals.add(b);
                counter++;
         }
         
        }catch(exception ex){
            
        }
        
    }
        
    public PageReference CancelClicked(){        
         try{
             if(url == '') url = Utility.getServerUrl() + '/';
             String newPageUrl = url + this.app.Id;
             PageReference newPage = new PageReference(newPageUrl);
             newPage.setRedirect(true);
             return newPage;
         }catch(exception ex){
            
         }       
         return null;
    }
    
    public PageReference RunSelectiveCollateralMerge(){
    	Integer counter = 0;
    	EB_Collateral__c currentProspectiveCollateral = null;
    	EB_Collateral__c currentExistingCollateral = null;
    	
    	Map<Id,BookedData> checkDuplicateMap = new Map<Id,BookedData>();
        Map<Id,Id> bookedProspectIds = new Map<Id,Id>();
        Map<Id,Id> dropdownOptionIds = new Map<Id,Id>();
        
        for(BookedData bData : this.collaterals){
            bookedProspectIds.put(bData.BookedProspectId,bData.BookedProspectId);
            if(bData.dropdownOptionId != '0' && bData.dropdownOptionId != '1'){
                dropdownOptionIds.put(bData.dropdownOptionId,bData.dropdownOptionId);
            }
        }
    	
		Map<Id, EB_Collateral__c> prospectiveCollMap = new Map<Id,EB_Collateral__c>([SELECT Id,Name,delete_flag__c,Advance_Rate__c,
	        Application_Cross_With__c,Appraised_Value__c, City__c,Collateral_Application__c,Collateral_Code__c,Collateral_Description__c,Collateral_Number__c,Comments__c,
	        EB_Bank__c,Existing_Debt__c,Future_Advance_Amount__c,Increase_Amount__c,Increase_to_Existing_Deed__c,Key__c,Lendable_Equity__c,Lien_Position__c 
	        FROM EB_Collateral__c WHERE Id in: bookedProspectIds.keySet()]);
                
		Map<Id, EB_Collateral__c> existingCollMap = new Map<Id,EB_Collateral__c>([SELECT 
	        (SELECT Id, Name, EB_Collateral_ID__c FROM EB_Collateral_Account_Relationships__r WHERE EB_Account_ID__c =: accts[0].Id),
	        (SELECT Id, Name, EB_Collateral_ID__c FROM EB_Collateral_Client_Relationships__r WHERE Client_ID__c =: accts[0].Primary_Owner_Id__c),
	        (SELECT Id ,Name, Related_Collateral__c FROM EB_Loan_Appraisal_Orders__r),
	        Id,Name,Advance_Rate__c,Application_Cross_With__c,Appraised_Value__c,City__c,Collateral_Application__c,Collateral_Code__c,Collateral_Description__c,Collateral_Number__c,
	        Comments__c,EB_Bank__c,Existing_Debt__c,Future_Advance_Amount__c,Increase_Amount__c,Increase_to_Existing_Deed__c,Key__c,Lendable_Equity__c,Lien_Position__c 
	        FROM EB_Collateral__c WHERE Id in: dropdownOptionIds.keySet()]);
                
    	for(BookedData b : this.collaterals){
    		if(String.valueOf(counter) == SelectiveCollateralMergeId){
        		currentProspectiveCollateral = prospectiveCollMap.get(b.BookedProspectId);
            	currentExistingCollateral = existingCollMap.get(b.dropdownOptionId);
            	break;
    		}
            counter++;
    	}
    	if(currentProspectiveCollateral != null && currentExistingCollateral != null){
    		CollateralLists dmlList = MergeCollateral(currentProspectiveCollateral,currentExistingCollateral);
    		dmlList.CommitLists();
    	}    	
    	return null;
    }
    
    public PageReference SaveClicked(){
    	Savepoint sp = Database.setSavepoint();
	    try{
	        ApexPages.Message[] msgsAccount = ApexPages.getMessages();
	        if(this.AccountMissing == true) {EBAccountDoesNotExistsMessage() ; return null;}
	        if (msgsAccount.size() > 0  || accts.size() == 0){
	            if((msgsAccount.size() == 0 &&  accts.size() == 0) ){
	                EBAccountDoesNotExistsMessage(); 
	            }
	        }else{
	            PromoteProspectsToClients();
	
	            ApexPages.Message[] msgsEntity = ApexPages.getMessages();
	            if (msgsEntity.size() > 0){
	                ApexPages.Message myMsgebacct = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error converting Prospect to Client');
	                ApexPages.addMessage(myMsgebacct);
	            }else{
	                if(!IsAppGuidanceLine){
	                   //PromoteProspectiveCollateralToExistingCollateral();
                       PromoteProspectiveCollateralToExistingCollateral(this.collaterals,accts[0]);
	                }
	                ApexPages.Message[] msgsCollateral = ApexPages.getMessages();
	                if (msgsCollateral.size() > 0){
	                    ApexPages.Message myMsgebacct = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error converting Prospective collateral to Existing');
	                    ApexPages.addMessage(myMsgebacct);
	                }else{                              
	                    List<EB_Booked_Loan_App__c> duplicateBookedApps = [SELECT Id, Name FROM EB_Booked_Loan_App__c  WHERE Name =: app.Name];
	                    if(duplicateBookedApps.size() > 0) delete duplicateBookedApps;
	                    RecordType ArchiveRecordType = this.getRecordTypeIdForName('EB_Booked_Loan_App__c', 'Booked');
	
	                    app.delete_Flag__c = true;
	                    List<EB_Loan_App_Stage__c> stage = [SELECT Id, Name FROM EB_Loan_App_Stage__c WHERE Name =: 'Archived'];
	                    app.Application_Stage__c = stage[0].Id;
	                    update app;
	
	                    CreateLoanAppBooked(app, accts[0], app.Application_Stage_Reportable__c,ArchiveRecordType.Id);
	                    
	                    RewireLoanStageLogs(bookedLoanapp);
	                    
	                    attachAgreementsToAccount(accts[0].Id);
	                    
	                    RewireLoanSnapshots(bookedLoanapp, snapshots);
	                    CreateNewSnapshot(accts[0], app, bookedLoanapp, 'Booked Snapshot', 'Booked');
	                    
	                    RewireNotesAndAttachments( app, bookedLoanapp);
	                    RewireTasks(app,bookedLoanapp);
	                    
	                    ArchiveLoanPacket(packet);
	                    UpdateEbAccountArchivedLoan();
	                    
	                    String newPageUrl = url + bookedLoanapp.Id;
	                    PageReference newPage = new PageReference(newPageUrl);
	                    newPage.setRedirect(true);
	                    
	                    return newPage;
	                }
	            }
	        }
	    }catch(exception ex){
	        ApexPages.addMessages(ex);
	        Database.rollback(sp);
	    }
	    return null;
	}
    
    private void attachAgreementsToAccount(Id accountId){
    	m_agreementStatusManager.attachLoanAppAgreementsToAccount(app.Id,accountId);
    }
    
    @TestVisible
    private void UpdateEbAccountArchivedLoan(){
        if(bookedLoanapp != null){
            List<EB_Account__c> acct = [SELECT Id,Archived_Loan_App__c FROM  EB_Account__c WHERE id=: accts[0].id];
            List<EB_Booked_Loan_App__c> booked = [SELECT Id, name FROM EB_Booked_Loan_App__c WHERE id =:bookedLoanapp.id];
            acct[0].Archived_Loan_App__c = booked[0].id;
            update acct[0];
        }
    }
    
    private void PromoteProspectsToClients(){
    	Map<Id,BookedData> checkDuplicateMap = new Map<Id,BookedData>();
        List<ProspectToClient.ProspectToClientMapping> mappings = new List<ProspectToClient.ProspectToClientMapping>();
        for(BookedData b : this.entities){
            if(b.dropdownOptionId != '0' && b.dropdownOptionId != '1'){
                if(checkDuplicateMap.containskey(b.dropdownOptionId) == true){
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An Existing Entity is mapped to more than one Prospective Entity');
                     ApexPages.addMessage(myMsg);
                     return;
                }                
                
                try{
                    ProspectToClient.ProspectToClientMapping mapping = new ProspectToClient.ProspectToClientMapping();
                    mapping.prospectId = b.BookedProspectId;
                    mapping.clientId = b.dropdownOptionId;
                    mappings.add(mapping);
                    checkDuplicateMap.put(b.dropdownOptionId,b);
                }catch(exception ex){
                    
                }                
            }
            if(b.dropdownOptionId == '0'){
                 ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'An Existing Entity has not been mapped to a Prospective Entity');
                 ApexPages.addMessage(myMsg1);
                 return;
            }
        }
        
        m_prospectToClientManager.promoteProspectsToClients(mappings);
    }


    public void PromoteProspectiveCollateralToExistingCollateral(List<BookedData> collateralMergeDetails, EB_Account__c ebAccount ){
        
        List<EB_Collateral__c> deleteExistingCollateralList = new List<EB_Collateral__c>();
        List<EB_Collateral__c> collateralSaveList = new List<EB_Collateral__c>();
        List<EB_Collateral_Account_Relationship__c> accountRelationshipSaveList = new List<EB_Collateral_Account_Relationship__c>();
        List<EB_Collateral_Client_Relationship__c> clientRelationshipDeleteList = new List<EB_Collateral_Client_Relationship__c>();
        List<EB_Appraisal_Order__c> appraisalOrderSaveList = new List<EB_Appraisal_Order__c>();

        Map<Id,BookedData> checkDuplicateMap = new Map<Id,BookedData>();
        Map<Id,Id> bookedProspectIds = new Map<Id,Id>();
        Map<Id,Id> dropdownOptionIds = new Map<Id,Id>();

        for(BookedData bData : collateralMergeDetails){
             bookedProspectIds.put(bData.BookedProspectId,bData.BookedProspectId);
                if(bData.dropdownOptionId != '0' && bData.dropdownOptionId != '1'){
                    dropdownOptionIds.put(bData.dropdownOptionId,bData.dropdownOptionId);
                }
        }
        Map<Id, EB_Collateral__c> prospectiveCollMap = new Map<Id,EB_Collateral__c>([SELECT Id,Name,delete_flag__c,Advance_Rate__c,
                Application_Cross_With__c,Appraised_Value__c, City__c,Collateral_Application__c,Collateral_Code__c,Collateral_Description__c,Collateral_Number__c,Comments__c,
                EB_Bank__c,Existing_Debt__c,Future_Advance_Amount__c,Increase_Amount__c,Increase_to_Existing_Deed__c,Key__c,Lendable_Equity__c,Lien_Position__c 
                FROM EB_Collateral__c WHERE Id in: bookedProspectIds.keySet()]);
                
        Map<Id, EB_Collateral__c> existingCollMap = new Map<Id,EB_Collateral__c>([SELECT 
                (SELECT Id, Name, EB_Collateral_ID__c FROM EB_Collateral_Account_Relationships__r WHERE EB_Account_ID__c =: ebAccount.Id),
                (SELECT Id, Name, EB_Collateral_ID__c FROM EB_Collateral_Client_Relationships__r WHERE Client_ID__c =: ebAccount.Primary_Owner_Id__c),
                (SELECT Id ,Name, Related_Collateral__c FROM EB_Loan_Appraisal_Orders__r),
                Id,Name,Advance_Rate__c,Application_Cross_With__c,Appraised_Value__c,City__c,Collateral_Application__c,Collateral_Code__c,Collateral_Description__c,Collateral_Number__c,
                Comments__c,EB_Bank__c,Existing_Debt__c,Future_Advance_Amount__c,Increase_Amount__c,Increase_to_Existing_Deed__c,Key__c,Lendable_Equity__c,Lien_Position__c 
                FROM EB_Collateral__c WHERE Id in: dropdownOptionIds.keySet()]);
        

         for(BookedData b : collateralMergeDetails){
                EB_Collateral__c currentProspectiveCollateral = prospectiveCollMap.get(b.BookedProspectId);
                                
                if(b.dropdownOptionId == '1'){
                    currentProspectiveCollateral.Delete_Flag__c = true;
                    collateralSaveList.add(currentProspectiveCollateral);
                }
                else if(b.dropdownOptionId == '0'){
                     ApexPages.Message myMsg3 = new ApexPages.Message(ApexPages.Severity.ERROR, 'An Existing Collateral has not been Mapped to any Prospective Collateral');
                     ApexPages.addMessage(myMsg3);
                     return;
                }  
                else{
                    EB_Collateral__c currentExistingCollateral = existingCollMap.get(b.dropdownOptionId);
                    
                    if(checkDuplicateMap.containskey(b.dropdownOptionId) == true){
                         ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR, 'An Existing Collateral is mapped to more than one Prospective Collateral');
                         ApexPages.addMessage(myMsg2);
                         return;
                    }
                    checkDuplicateMap.put(b.dropdownOptionId,b);                    
                    updateProspectiveCollateralWithExistingData(currentProspectiveCollateral,currentExistingCollateral);
                    
                    //set the changed collateral checkbox to false
                    currentProspectiveCollateral.change_Collateral_code__c = false;
                    collateralSaveList.add(currentProspectiveCollateral);
                    
                    try{
                        List<EB_Collateral_Account_Relationship__c> acctRelList = updateRelatedCollaterals(currentProspectiveCollateral,currentExistingCollateral.EB_Collateral_Account_Relationships__r);
                        accountRelationshipSaveList.addAll(acctRelList);
                    }
                    catch(exception ex){
                    
                    }
                    
                    List<EB_Appraisal_Order__c> appOrderList = updateAppraisalOrder(currentProspectiveCollateral,currentExistingCollateral.EB_Loan_Appraisal_Orders__r);
                    appraisalOrderSaveList.addAll(appOrderList);
                    
                    clientRelationshipDeleteList.addAll(currentExistingCollateral.EB_Collateral_Client_Relationships__r);
                    deleteExistingCollateralList.add(currentExistingCollateral);
                }                             
            }

            if(collateralSaveList.size() > 0) update collateralSaveList;
            if(accountRelationshipSaveList.size() > 0) update accountRelationshipSaveList;
            if(appraisalOrderSaveList.size()>0) update appraisalOrderSaveList;
            
            if(deleteExistingCollateralList.size() > 0) delete deleteExistingCollateralList;
            if(clientRelationshipDeleteList.size() > 0) delete clientRelationshipDeleteList;
     }
    
    @TestVisible
    private class CollateralLists{
		public List<EB_Collateral__c> collateralSaveList = new List<EB_Collateral__c>();
        public List<EB_Collateral_Account_Relationship__c> accountRelationshipSaveList = new List<EB_Collateral_Account_Relationship__c>();
        public List<EB_Collateral_Client_Relationship__c> clientRelationshipDeleteList = new List<EB_Collateral_Client_Relationship__c>();
        public List<EB_Appraisal_Order__c> appraisalOrderSaveList = new List<EB_Appraisal_Order__c>();
        public List<EB_Collateral__c> deleteList = new List<EB_Collateral__c>();
        
        public void CommitLists(){
        	if(collateralSaveList.size() > 0) update collateralSaveList;
	        if(accountRelationshipSaveList.size() > 0) update accountRelationshipSaveList;
	        if(clientRelationshipDeleteList.size() > 0) delete clientRelationshipDeleteList;
	        if(appraisalOrderSaveList.size()>0) update appraisalOrderSaveList;        
	        if(deleteList.size() > 0) delete deleteList;
        }
    }

    @TestVisible
    private CollateralLists MergeCollateral(EB_Collateral__c prospectiveCollateral, EB_Collateral__c existingCollateral){ 
    	CollateralLists dmlList = new CollateralLists();
    	
    	// update the "prospective" collateral with the "existing" collateral's details                
		updateProspectiveCollateralWithExistingData(prospectiveCollateral,existingCollateral); //SOQL=OK
		
		//set the changed collateral checkbox to false
		prospectiveCollateral.change_Collateral_code__c = false;
		prospectiveCollateral.delete_flag__c = true;
		dmlList.collateralSaveList.add(prospectiveCollateral);
		
		// update Collateral to Account Relationships
		List<EB_Collateral_Account_Relationship__c> acctRelList = updateRelatedCollaterals(prospectiveCollateral,existingCollateral.EB_Collateral_Account_Relationships__r);
		dmlList.accountRelationshipSaveList.addAll(acctRelList);
		
		// update Collateral to Entity Relationships
		dmlList.clientRelationshipDeleteList.addAll(existingCollateral.EB_Collateral_Client_Relationships__r);
		
		//update Appraisal Orders
		List<EB_Appraisal_Order__c> appOrderList = updateAppraisalOrder(prospectiveCollateral,existingCollateral.EB_Loan_Appraisal_Orders__r);
		dmlList.appraisalOrderSaveList.addAll(appOrderList);
    
		// delete the old "existing" collateral    
		dmlList.deleteList.add(existingCollateral);
		
		return dmlList;
    }
}