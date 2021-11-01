public class AgreementTestComponentController{
    public Agreement__c agmt{get;set;}
    public String AgreementPendingStatus{get;set;}
    public Agreement_Test__c test{get;set;}
    public String selectedAgreementTestId{get;set;}
    public String styleClassPanel1{get;set;}
    public String styleClassPanel2{get;set;}
    public String layout{get;set;}
    public String dropdownTestTypeId {get;set;}
         
    public AgreementTestComponentController(){
         //Agreement test
        test = new Agreement_Test__c();
       
    }
     public List<Agreement_Test__c > tests{
        get{
            
              test.Agreement__c = agmt.Id;
            try{
                test.Id = selectedAgreementTestId;
                }catch(exception ex){}
              return [SELECT Id, Name, Agreement__c, Approval_Process__c, Test_Date__c, Test_Type__c, Compliant__c, Action__c, Status__c ,Approver_One__c ,Approver_Three__c, Approver_Two__c ,Comments__c, Waiver_Fee__c    FROM Agreement_Test__c WHERE Agreement__c =: agmt.Id Order by Test_Date__c desc];
            }
    }

    public pagereference showTestFields(){

       return null;
    }
    
    public PageReference AddTest(){
          test = null;
          test = new Agreement_Test__c ();
          
          test.Agreement__c = agmt.Id;
          showDialog();
          return null;
          /*String url = Utility.getserverUrl() +'/' + test.Id; 
          PageReference newPage = new PageReference(url);
          newPage.setRedirect(true);
          return newPage;
          */
    }
    
    public pagereference EditTest(){ 
           
          test = [SELECT Id, Name, Agreement__c, Approval_Process__c, Test_Date__c, Test_Type__c, Compliant__c, Action__c, Status__c ,Approver_One__c ,Approver_Three__c, Approver_Two__c ,Comments__c ,Waiver_Fee__c  FROM Agreement_Test__c WHERE Id =: selectedAgreementTestId];

          showDialog();
         
          return null;
    }
    
     public pagereference ViewTest(){
       String url = Utility.getserverUrl() +'/' + selectedAgreementTestId; 
       PageReference newPage = new PageReference(url);
       newPage.setRedirect(true);
       return newPage;
    }
    
    public PageReference DeleteTest(){
        Agreement_Test__c  delItem = new Agreement_Test__c  (id = selectedAgreementTestId);
        delete delItem ;
          ResetClickedParameters();
        return null;
    }

    public void showDialog() {        
        displayDialog = true;    
    }
   private void ResetClickedParameters(){   
        selectedAgreementTestId = '';
       }
    
    public boolean displayDialog {get; set;}
    public PageReference cancelDialog(){
        displayDialog = false;
        return RefereshPage();
    }
    
    public pagereference closeDialog() { 
        displayDialog = false;
        //fee.Fee_Type__c = dropdownFeeTypeId;s
            
            if(test.Id != null && selectedAgreementTestId != '') {
               update test;
               }
            if(test.Id == null && test.Agreement__c != null) {
              insert test;
            }
      
        ResetClickedParameters();
        String url = Utility.getserverUrl() +'/' + test.Id; 
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(true);
        return newPage;
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
        IF( test.Status__c =='Approved' ) 
            return true;
        Else
            return false;
        }
    }  
}