public class LoanAppAgreementAddController{
	Id LoanAppId;
    public EB_Loan_Application__c loanApp{get;set;} 
    Agreements.IAgreementPicker m_agreementpicker;
    public String getLoanApplicationName{
        get{
            if(loanApp != null)
            return loanApp.Name; 
            return '';
    	}
    }
       
    public Id selectedAgreementId{get;set;}
    
    public LoanAppAgreementAddController(ApexPages.StandardController controller) {
        m_agreementpicker = new AgreementPicker(new AgreementPickerDataProvider());
        
        this.LoanAppId = apexpages.currentpage().getparameters().get('id');
	    initialize(LoanAppId);
	}
    
    public LoanAppAgreementAddController(Id LoanAppId,Agreements.IAgreementPicker agreementpicker){
         m_agreementpicker = agreementpicker;
         system.debug('## LoanAppAgreementAddController 1 : LoanApp ' + LoanAppId);
         initialize(LoanAppId);
         system.debug('## LoanAppAgreementAddController 2 : LoanApp ' + LoanAppId);
    }
    private void initialize(Id LoanAppId){
        
	     try{  
            
            List<EB_Loan_Application__c> loanAppList = m_agreementpicker.GetLoanObjectForLoanAppId(LoanAppId);
            loanApp = loanAppList[0];
	     }catch(exception ex){
            this.LoanAppId = null;
            loanApp = null;
         }	    
    }
    
    public List<Agreement__c> AgreementLinkList{
        get{
             AgreementLinkList = m_agreementpicker.GetAgreementsForLoanApp(loanApp.Id);
             return AgreementLinkList;
    	}
        set;
    }
    
    public boolean ContainsAgreements{
        get{
            if(AgreementLinkList.size() > 0) return true;
            return false;
        }
    }
    
    public PageReference AddNewAgreement(){
        return ReturnUrl(utility.getServerUrl() + '/'  + 'apex/AgreementEdit?lid=' + loanApp.Id);
    }

    public PageReference SaveExistingAgreement(){
        m_agreementpicker.SaveAgreementLoanRel(selectedAgreementId,LoanAppId);         
        return ReturnUrl(utility.getServerUrl() + '/'  + loanApp.Id);
    }
    
    public PageReference CancelAgreement(){
        return ReturnUrl(utility.getServerUrl() + '/'  + loanApp.Id);        	 
    }
    
    private PageReference ReturnUrl(string url){
        try{
         	 	if(loanApp != null){
         	 	  String newPageUrl = url;
                  PageReference newPage = new PageReference(newPageUrl);
                  newPage.setRedirect(true);
                  return newPage;
         	 	}
        }catch(exception ex){
            
        }
        return null;
    }
}