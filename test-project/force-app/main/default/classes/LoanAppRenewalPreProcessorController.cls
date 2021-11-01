public  class LoanAppRenewalPreProcessorController {
        
        EB_Account__c EBAccount;
        
        @TestVisible List<EB_Loan_Packet__c> activePackets;
        String url = '';
        String rectype = '';
        List<RecordType> recordTypeList = null;
        Id LoanRecTypeId ;
        public String err{set;get;}
        public Id dropdownPacketId{get;set;}
        public Id selectedEditId{get;set;}
        public String searchParam{get;set;}
        private Id Archived_PacketId = null;
        @TestVisible Id EBAccountId = null;
        
        public EB_Loan_Application__c app{get;set;}
        @TestVisible
        private Id ArchivedPackedId{
                get{
                        if(Archived_PacketId == null){
                for(RecordType r : [SELECT Id, Name FROM RecordType WHERE SObjectType =: 'EB_Loan_Packet__c' and Name = 'Archived']){
                        Archived_PacketId = r.Id;
                }
              }
              return Archived_PacketId;
                }
                set;
                }
        private Id PreenScreenOnlyId{
                get{
                        if(PreenScreenOnlyId == null){
			                for(RecordType r : [SELECT Id, Name FROM RecordType WHERE SObjectType =: 'EB_Loan_Packet__c' and Name = 'Prescreen Only']){
			                        PreenScreenOnlyId = r.Id;
			                }
              			}
              return PreenScreenOnlyId;
                }
             set;
        }
        private  static String  getServerUrl(){
               
                return utility.getServerUrl() + '/';
        }
        @TestVisible
        private RecordType  getRecordTypeNameorId(Id RecordTypeId , String RecordTypeName, boolean IsParameterName){
                  if(recordTypeList == null){
                            recordTypeList = [SELECT  Name, Id FROM RecordType WHERE SobjectType =: 'EB_Loan_Application__c' or SobjectType =: 'EB_Loan_Application_Payment_Stream__c' or SobjectType =: 'EB_Loan_Participation__c' or SobjectType =: 'EB_Loan_App_Rate_Stream__c' ];
                  }
                
                  for (RecordType r : recordTypeList){
            
                      if(IsParameterName == false){
                              if(r.Id == RecordTypeId)
                          return r;
                      }
                      if(IsParameterName == true){
                              if(r.Name == RecordTypeName) return r;
                      }
                  }
              
                return null;
        }
        public LoanAppRenewalPreProcessorController(ApexPages.StandardController controller) {
               if(url == '') url = LoanAppRenewalPreProcessorController.getServerUrl();
                       initialize();
    
        }
    	@TestVisible
        private void initialize(){
                try{
                    ///// EB Account Id
                    EBAccountId = apexpages.currentpage().getparameters().get('id');
                    /////Retrive type of Renewal.
                    rectype = apexpages.currentpage().getparameters().get('t');
                   
                    if(rectype == 'r') LoanRecTypeId = getRecordTypeNameorId(null,'Renewal', true).Id;
                    if(rectype == 'rm') LoanRecTypeId = getRecordTypeNameorId(null,'Renewal/Modification',true).Id;
                    if(rectype == 'm')
                    {
                             LoanRecTypeId = getRecordTypeNameorId(null, 'Modification - Full',true).Id;
                             dropdownRecordTypeId = LoanRecTypeId; 
                    }
                    if(rectype == 'ar') LoanRecTypeId = getRecordTypeNameorId(null, 'Admin Renewal', true).Id;
                    if(rectype == 'sa') LoanRecTypeId = getRecordTypeNameorId(null, utility.NewGuidanceLineAdvance() , true).id;
                    if (LoanRecTypeId == null) return;
                    
                  
                       
                   for(EB_Account__c a : [SELECT (SELECT Id, EB_Account_Id__c, Client_Id__c  FROM EB_Account_Relationships__r ), Id, Interest_Rate__c ,EB_Account_Type__c, Interest_Rate_Type_Description__c, Account_Industry_Code__c, Application__c, Rate_Subject_to_Change__c,  Interest_Rate_Ceiling__c , Interest_Rate_Floor__c, Interest_Rate_Variance__c, Index_Variance_Code__c,  Rate_Index__c, User_Code_1__c ,Unadvanced_Loan_Amount__c,Current_Balance__c,  Name, Account_Type__c, Primary_Owner_Id__r.Id, Primary_Owner_Id__r.Name FROM EB_Account__c WHERE Id =: EBAccountId limit 1] ){
                                EBAccount = a;
                   }
                   err = searchParam;
                   if(searchParam == null || searchParam.trim() == '')
                             CreatePacketListWithoutSearch();
                             else
                            CreatePacketListWithSearch(searchParam);
                      
                   
            }catch(exception ex){
                this.EBAccount = null;
            }
        }
        @TestVisible
        private void CreatePacketListWithoutSearch(){
               
                    activePackets = new List<EB_Loan_Packet__c>();
                    Map<Id, Id> acctIds = new Map<Id,Id>();
                     try{
                                        
                            for(EB_Account_Relationship__c rl : EBAccount.EB_Account_Relationships__r ){
                                    acctIds.put(rl.Client_Id__c,rl.Client_Id__c);
                                    
                            }
                    }catch(exception ex){
                    return;
                }
                    //Map<Id, EB_Account_Relationship__c> acctIds = new Map<Id,EB_Account_Relationship__c>([SELECT Id, Client_Id__c  FROM EB_Account_Relationship__c WHERE EB_Account_Id__c =: EBAccountId]);
                
                
                for(EB_Loan_Packet__c p : [SELECT Id, Name, Total_Requested__c, Actual_Approval_Path__c, Number_of_Applications__c, CreatedDate FROM EB_Loan_Packet__c WHERE Lead_Entity__c in: acctIds.keySet() and RecordTypeId !=: ArchivedPackedId and RecordTypeId !=: PreenScreenOnlyId]){
                    activePackets.add(p);
                } 
                  
        }
        @TestVisible
        private void CreatePacketListWithSearch(String currentSearchParam){
            activePackets = new List<EB_Loan_Packet__c>();
            String searchTerm = currentSearchParam;   
            
             
            if(searchTerm == null || searchTerm == '') return;
                            
                    searchTerm = searchTerm.replace('*', ' ');                      
                    searchTerm = searchTerm.trim();
                    searchTerm = searchTerm.replace('  ', ' ');
                    searchTerm = searchTerm.replace('  ', ' ');
                    searchTerm = searchTerm.replace(' ', '%');
                    searchTerm = '%' + searchTerm + '%';
                    
                    if(searchTerm == '%%') return;
                    
                     for(EB_Loan_Packet__c p : [SELECT Id, Name, Total_Requested__c, Actual_Approval_Path__c, Number_of_Applications__c, CreatedDate FROM EB_Loan_Packet__c WHERE RecordTypeId !=: ArchivedPackedId and RecordTypeId !=: PreenScreenOnlyId and  Name like :searchTerm ORDER BY Name Limit 500]){
                             this.activePackets.add(p);
                     }
                  if(activePackets.size() == 0) activePackets = null;
        }
        @testVisible
        private Id GetArchivedPacketId(){
              if(this.ArchivedPackedId == null){
                    for(RecordType r : [SELECT Id, Name FROM RecordType WHERE SObjectType =: 'EB_Loan_Packet__c' and Name =: 'Archived']){
                            this.ArchivedPackedId = r.Id;
                    }
              }
              return this.ArchivedPackedId;               
        }
        public List<EB_Loan_Packet__c> getActivePackets(){
            if(searchParam == null || searchParam.trim() == '')
                  CreatePacketListWithoutSearch();
             else
                 CreatePacketListWithSearch(searchParam);
            return this.activePackets;
        }
        public String getPacketListStatus(){
            if(this.activePackets.size()> 0) return 'true';
            return 'false';
        }
         public List<SelectOption> getPackets(){               
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','--None--'));
            for(EB_Loan_Packet__c p : this.activePackets ){
                    
                    options.add(new SelectOption(p.Id, p.Name + ' << ' + 'Approval_Path : ' + p.Actual_Approval_Path__c + ' << # of Apps: ' + String.valueof(p.Number_of_Applications__c) + ' << Request Amount: ' + String.valueof(p.Total_Requested__c)));
            }
            return options;
         }
             
             
             //Mini Mod case
         public Map<id,RecordType> minModMap{
            get{
                    if(minModMap == null){
                             minModMap = new  Map<id,RecordType>();
                         for (RecordType r : utility.recordTypeObjects('EB_Loan_Application__c')){
                                if (r.name.tolowercase().contains('modification -') ) minModMap.put(r.id,r);                    
                         }
                    }
                    return minModMap;
            }
            set;
         }
         public Map<String,RecordType> minModByNameMap{
            get{
                    
            
                    if(minModByNameMap == null){
                            minModByNameMap = new Map<String,RecordType>();
                            for(recordtype r : minModMap.values()){
                                    minModByNameMap.put(r.name,r);
                            }
                    }
                    return minModByNameMap;
            }
            set;
         }       
         public String dropdownRecordTypeId{get;set;}
         public List<SelectOption> getModRecordTypes(){
                 List<SelectOption> options = new List<SelectOption>();
                 
                 for(recordtype r : minModMap.values()){
                        options.add(new SelectOption(r.id, r.name));
                 }
                
                 return sortSelectOptions(options);
         }
	     public List<SelectOption> sortSelectOptions(List<SelectOption> sortingList) {
	            for (Integer i =0; i < sortingList.size(); i++) {
	                for (Integer j = i; j > 0; j--) {
	                    if (sortingList[j-1].getLabel() > sortingList[j].getLabel()){
	                        SelectOption temp = sortingList[j];
	                        sortingList[j] = sortingList[j-1];
	                        sortingList[j-1] = temp;
	                    }
	                }
	            }
	                return sortingList;
	     }
         public String IsMod{
            get{                    
                    if(rectype == 'm') return 'true';
                    return 'false';                 
            }
         }
         public PageReference AutoForward(){
            if(IsMod == 'true'){
                    try{
                      String newPageUrl;
                      Id rectid = this.minModByNameMap.get('Modification - Full').id;
                      newPageUrl = this.url +  'apex/LoanAppRenewal?id=' + ebaccount.id + '&t=' + rectid; //'/' + this.LoanAppId;
                      PageReference newPage = new PageReference(newPageUrl);
                      newPage.setRedirect(true);
                      return newPage;
                    }catch(exception ex){
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Account or Renewal Type');
                        ApexPages.addMessage(myMsg);
                    }
            }
              return null;
         }
         public PageReference NewPacket(){
            try{
              String newPageUrl;
              Id rectid;
              if(rectype == 'm') rectid = dropdownRecordTypeId;
              else rectid = this.LoanRecTypeId;
              
              newPageUrl = this.url +  'apex/LoanAppRenewal?id=' + ebaccount.id + '&t=' + rectid; //'/' + this.LoanAppId;
              PageReference newPage = new PageReference(newPageUrl);
              newPage.setRedirect(true);
              return newPage;
            }catch(exception ex){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Account or Renewal Type');
                ApexPages.addMessage(myMsg);
            }
              return null;
        }
        public PageReference SearchPacket(){
             initialize();
             return null;
        }
        public PageReference SelectPacket(){
              String newPageUrl;
              Id rectid;
                  if(rectype == 'm') rectid = dropdownRecordTypeId;
                  else rectid = this.LoanRecTypeId;
              newPageUrl = this.url +  'apex/LoanAppRenewal?id=' + ebaccount.id + '&t=' + rectid + '&p=' + selectedEditId; //'/' + this.LoanAppId;
              PageReference newPage = new PageReference(newPageUrl);
              newPage.setRedirect(true);
              return newPage;
              return null;
           
        }
    
           
}