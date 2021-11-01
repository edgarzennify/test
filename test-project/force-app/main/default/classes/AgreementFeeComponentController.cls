public class AgreementFeeComponentController{
  public Agreement__c agmt{get;set;}
    public Boolean canEdit{get;set;}
    public Boolean canEditAgreementFee{get;set;}
    public Agreement_Fee__c fee{get;set;}
    public String selectedAgreementFeeId{get;set;}
    public String styleClassPanel1{get;set;}
    public String styleClassPanel2{get;set;}
    public String layout{get;set;}
    public String dropdownFeeTypeId {get;set;}
         
    public AgreementFeeComponentController(){
         //Agreement Fee
        fee = new Agreement_Fee__c();
       
    }
     public List<Agreement_Fee__c > fees{
        get{
            
              fee.Agreement__c = agmt.Id;
            try{
                fee.Id = selectedAgreementFeeId;
                }catch(exception ex){}
              return [SELECT Id, Name, Agreement__c, Fee_Amount__c, Fee_Date__c, Fee_Type__c, Payable_To__c FROM Agreement_Fee__c WHERE Agreement__c =: agmt.Id Order by Fee_Date__c desc];
            }
    }
    
    public List<SelectOption> getFeeTypes(){
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('', '--None--'));
        Schema.Describefieldresult fieldResult = Agreement_Fee__c.Fee_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        For(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options;
    }
        
    public pagereference showFeeFields(){
           
          // fee.Fee_Type__c = dropdownFeeTypeId;
          //toggleCovenantVisibility();           

       return null;
    }
    
    public PageReference AddFee(){
          
          fee = new Agreement_Fee__c ();
          fee.Agreement__c = agmt.Id;
          showDialog();
        return null;          
    }
    
    public pagereference EditFee(){ 
           
          fee = [SELECT Id, Name, Agreement__c, Fee_Amount__c, Fee_Date__c, Fee_Type__c, Payable_To__c FROM Agreement_Fee__c WHERE Id =: selectedAgreementFeeId ];
          //dropdownFeeTypeId = fee.Fee_Type__c;
          showDialog();
         
          return null;
    }
    
     public pagereference ViewFee(){
       String url = Utility.getserverUrl() +'/' + selectedAgreementFeeId; 
       PageReference newPage = new PageReference(url);
       newPage.setRedirect(true);
       return newPage;
    }
    
    public PageReference DeleteFee(){
        Agreement_Fee__c  delItem = new Agreement_Fee__c  (id = selectedAgreementFeeId);
        delete delItem ;
          ResetClickedParameters();
        return null;
    }
    
   
   
    public void showDialog() {        
        displayDialog = true;    
    }
    @TestVisible
   private void ResetClickedParameters(){   
        selectedAgreementFeeId = '';
       }
    
    public boolean displayDialog {get; set;}
    public PageReference cancelDialog(){
        displayDialog = false;
        return RefereshPage();
    }    
    public pagereference closeDialog() { 
        displayDialog = false;
        //fee.Fee_Type__c = dropdownFeeTypeId;s
            
            if(fee.Id != null && selectedAgreementFeeId != '') {
               update fee;
               }
            if(fee.Id == null && fee.Agreement__c != null) {
              insert fee;
            }
      
        ResetClickedParameters();
       return RefereshPage(); 
    }
    public PageReference RefereshPage(){
         String url = Utility.getserverUrl() + '/apex/Agreement?id=' + agmt.Id; 
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(false);              
        return newPage;   
    }
     public boolean AgreementArchiveStatus{
        get{
            if(agmt.RecordTypeId == null) return false;
            if(Utility.RecordTypeObject('Agreement__c', agmt.RecordTypeId).Name == 'Archive'){
                return true;
            }
            return false;          
        }
    }
    
     public boolean AgreementActiveStatus{
        get{
            if(agmt.RecordTypeId == null) return false;
            if(Utility.RecordTypeObject('Agreement__c', agmt.RecordTypeId).Name == 'Active'){
                return true;
            }
            return false;          
        }
    }
     public Boolean isEditable{
        get{
        IF(!canEditAgreementFee || AgreementActiveStatus || AgreementArchiveStatus) 
            return false;
        Else
            return true;
        }
        
    }  
    
    

}