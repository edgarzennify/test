//CHECK URL  PageReference before publishing to PRODUCTION
//---------------------------------------------------------------
public class EBPipelineArchiveController extends ProspectToClientBaseClass{
    @TestVisible Opportunity pipeline;
    @TestVisible Account Prospect;
    @TestVisible Id recId;
    @TestVisible String ErrorMessage;
    
    String WonClientAmount ;
    String WonClientProduct ;
    String WonClientName ;
    
    public String searchParam{get;set;}
    public String lostReason{get;set;}
    public Id dropdownClientId{get;set;}
    public Boolean WonStatus{get;set;}
    public Boolean LostStatus{get;set;}
    public Boolean OtherStatus{get;set;}
    public Boolean WonClientStatus{get;set;}
    
    
    public EBPipelineArchiveController(ApexPages.StandardController controller){
        initialize();
        HandleWonOrLostCase();
        
    }
    private void initialize(){
        if(url == '') url = Utility.getServerUrl() + '/';
        getRefineSearchStatus = 'false';
        resetvariables();
        this.recId = apexpages.currentpage().getparameters().get('Id');
        if(recId <> null){
            try{
                this.pipeline = [SELECT Id,Name,AccountId, Archive__c, Archive_Date__c, StageName,Amount, Products__c, Credit_Reason_Lost__c,Reason_Lost__c,TM_Reason_Lost__c , WM_Reason_Lost__c, RecordTypeId   FROM opportunity WHERE id =:recid];
            }catch(exception ex){
                this.pipeline = null;
            }
        }
    }
    public void HandleWonOrLostCase(){
        if (this.pipeline <> null && pipeline.Archive__c == true){
            OtherStatus = true;
            this.ErrorMessage = 'Error: This Pipeline has already been archived.';
        }else{
            if(this.pipeline <> null){
                try{
                    this.Prospect = [SELECT Id, Name, EB_Client_Name__c , RecordTypeId, TIN_SSN__c, EB_Customer_Number__c , BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity, Phone, Import_Source__c, LCS_Stage__c FROM Account WHERE Id =: this.pipeline.AccountId];                  
                }catch(exception ex){
                    this.pipeline = null;
                }
                
                if(this.pipeline.StageName == 'Closed Won') WonStatus = true;
                if(this.pipeline.StageName == 'Closed Lost' ) LostStatus = true;
                if(WonStatus == false && LostStatus == false && !excludeErrorMessage()) { 
                    OtherStatus = true ;
                    this.ErrorMessage = 'Error: Please select a \"Closed Won\" or \"Closed Lost\" Pipeline Status before archiving this pipeline.';
                }
            }
            if(this.pipeline == null) {
                OtherStatus = true;
                this.ErrorMessage = 'Error retriving data. Please contact system administrator.';
            }
            handleExclusionsForClosedWon();
            
            HandleWonClientCase();
            HandleIfLostReasonExists();
            
        }
    }
    private boolean excludeErrorMessage(){
        If(pipeline.RecordTypeId == getRecordTypeIdForName('Opportunity','Paydown/Payoff').Id || pipeline.RecordTypeId == getRecordTypeIdForName('Opportunity','Draw').Id){
            return true;
        }
        return false;
    }
    private void handleExclusionsForClosedWon(){
        Id rectypeWMid = getRecordTypeIdForName('Opportunity','Wealth Management').Id;
        Id rectypePayDownPayOff = getRecordTypeIdForName('Opportunity','Paydown/Payoff').Id;
        Id recordTypeDrawId =  getRecordTypeIdForName('Opportunity','Draw').Id;
        Id recordTypeTaxCreditsId =  getRecordTypeIdForName('Opportunity','Tax Credits').Id;
        
        if((this.pipeline.StageName == 'Closed Won') 
           && (this.pipeline.recordtypeid == rectypeWMid
               || (pipeline.recordtypeId == recordTypeTaxCreditsId)
               || (String.isnotblank(pipeline.products__c) &&  pipeline.products__c.contains('Merchant Processing'))
               || (String.isnotblank(pipeline.products__c) &&  pipeline.products__c.contains('Credit Card'))
              )
          )                                                                     
        {    
            enableArchiveExceptions();
        }else if((pipeline.StageName == 'Paydown' || pipeline.StageName == 'Payoff')
                 && pipeline.recordtypeid == rectypePayDownPayOff)                      
        {
            enableArchiveExceptions();
        } else if(pipeline.StageName == 'Draw' && pipeline.recordtypeId == recordTypeDrawId ){
            enableArchiveExceptions();
        }
    }
    private void enableArchiveExceptions(){
        HandleWonClientWMCase();
        return;
    }
    private void resetvariables(){
        this.pipeline = null;
        resetStatus();
    }
    private void resetStatus(){
        WonStatus = false;
        LostStatus = false;
        OtherStatus = false;
        WonClientStatus = false;
        WonClientAmount = '';
        WonClientProduct ='';
        WonClientName = '';              
    }  
    public opportunity lostDate{
        get{return pipeline;}
        set{
            
            pipeline.Lost_Date__c = value.Lost_Date__c;
            
        }
    } 
    
    public String getMessage(){
        return ErrorMessage;
    }
    
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
    
    
    public String getAmount(){ return WonClientAmount;}
    public String getProduct(){ return WonClientProduct;}
    public String getName(){ return WonClientName;}
    public String Products{
        get{ 
            if (pipeline.Products__c == null) return Products;
            String[] productList = pipeline.Products__c.split(',');
            for(String s : productList){
                Products += s;
            }
            return Products;
        }
        set;
    }
    public void HandleWonClientWMCase(){
        WonClientStatus = true;                     
        WonStatus = false;
        String amount = '';
        WonClientAmount = String.valueOf(this.pipeline.Amount);
        if (WonClientAmount == null) WonClientAmount = '0';
        WonClientProduct = Products;
        if (WonClientProduct == null) WonClientProduct = '';
        WonClientName = this.Prospect.Name;
        if (WonClientName == null) { WonClientName = '';}                              
    }
    
    public void HandleWonClientCase(){
        try{
            if((this.Prospect.RecordTypeId <> getRecordTypeIdForName('Account','Prospect').Id) && WonStatus == true){
                
                HandleWonClientCaseHelper();
                
            }
            
        }catch(exception ex){
            this.pipeline = null;
        }
    }
    
    public void HandleWonClientCaseHelper(){
        WonClientStatus = true;
        WonStatus = false;
        String amount = '';
        WonClientAmount = String.valueOf(this.pipeline.Amount);
        if (WonClientAmount == null) WonClientAmount = '0';
        WonClientProduct = Products;
        if (WonClientProduct == null) WonClientProduct = '';
        WonClientName = this.Prospect.Name;
        if (WonClientName == null) { WonClientName = '';}
    }
    
    public void HandleIfLostReasonExists(){
        if ( LostStatus == true){
            if (pipeline.Reason_Lost__c  <> null || pipeline.Reason_Lost__c <> ''){
                resetStatus();
                HandleWonClientCaseHelper();
            }else
            {
                
            }
        }
    }
    
    
    public PageReference SaveLost(){
        try
        {
            this.pipeline.Reason_Lost__c = lostReason;
            update this.pipeline;
            updateEBPipelineArchiveStatus(pipeline);
            
            String newPageUrl = this.url + recId;
            PageReference newPage = new PageReference(newPageUrl);
            newPage.setRedirect(true);
            return newPage;
        }catch(exception ex){
            
        }
        return null;
    }
    public  void updateEBPipelineArchiveStatus(opportunity mypipeline){
        
        try{
            if (mypipeline <> null){
                if(mypipeline.Archive__c == true){
                    
                }else{
                    mypipeline.Archive__c = true;
                    Datetime dT = System.now();
                    Date d = date.newinstance(dT.year(), dT.month(), dT.day());
                    mypipeline.Archive_Date__c = d;
                    update mypipeline;
                }
            }
        }catch(exception ex){
            
        }
        
    }
    
    public PageReference ArchiveClient(){
        try{
            updateEBPipelineArchiveStatus(pipeline);
            String newPageUrl = this.url + recId;
            PageReference newPage = new PageReference(newPageUrl);
            newPage.setRedirect(true);
            return newPage;
        }catch(exception ex){
            this.pipeline = null;
        }
        return null;
    }
    
    public PageReference SaveClient(){
        if(string.isNotBlank(dropdownClientId) && this.pipeline <> null){
            updateEBPipelineArchiveStatus(pipeline);
            Account client = new Account(Id=dropdownClientId);
            merge client Prospect;            
            String newPageUrl = this.url + recId;
            PageReference newPage = new PageReference(newPageUrl);
            newPage.setRedirect(true);
            return newPage;
        }
        return null;
    }    
}