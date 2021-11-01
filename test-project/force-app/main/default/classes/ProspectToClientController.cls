public  class ProspectToClientController extends ProspectToClientBaseClass{
        Account Prospect;
        @TestVisible Id recId;
        
        public ProspectToClientController(ApexPages.StandardController controller){
                   
                    getRefineSearchStatus = 'false';
           this.recId = apexpages.currentpage().getparameters().get('Id');
           if(recId <> null){
                        try{
                                this.Prospect = [SELECT Id, Name, EB_Client_Name__c, RecordTypeId, TIN_SSN__c, EB_Customer_Number__c , BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity, Phone, Import_Source__c FROM Account WHERE Id =: recId];
                                if (this.prospect.RecordTypeId <> getRecordTypeIdForName('Account','Prospect').Id) this.Prospect = null ;
                        }catch(exception ex){
                        }
           }
    }         
    public String searchParam{get;set;}
    public Id dropdownClientId{get;set;}
    public List<SelectOption> getClientNames(){
        return getUnmatchedClientNameList(searchParam);
    }    
    public PageReference SetSearch(){
        return null;
    }
    public String getProspectSelected(){
        if (Prospect <> null){            
                return Prospect.name;
        }
        return '';
    }
    public String getClientSelected(){
        
        if (dropDownClientId <> null){    
                Account acctClient = getAccountObjectForId(dropDownClientId);
                return acctClient.EB_Client_Name__c;
        }
        return '';
    }  
    
     public PageReference SaveClient(){
                if(dropdownClientId<> null && this.Prospect <> null){
                        Account currentClient = getAccountObjectForId(dropdownClientId);                        
                        Account currentProspect = updateClientInfoToProspect(Prospect, currentClient);
                        if(currentProspect == null)return null;
                        if(currentProspect.RecordTypeId == getRecordTypeIdForName('Account','Client').Id){
                                update Prospect;
                                merge Prospect currentClient;
                        }
                        String newPageUrl = this.url + Prospect.Id;
                        PageReference newPage = new PageReference(newPageUrl);
                        newPage.setRedirect(true);
                        return newPage;
                }
                return null;
        }
}