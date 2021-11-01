public with sharing class LoanTransactionRequestController {
                
        String url = ''; 
        String documentId = '';
        String action = '';
        PageReference thisPage = null;
        
        public LoanTransactionRequestController() {
                initialize();           
        }
        
        public String getUrl(){
        return url;
        }       
        
        private void initialize() {
                if(thisPage==null){
                        thisPage = apexpages.currentpage();
                }       
                getQueryParameters();
                
                if (documentId==''||documentId==null){
                        url = 'https://ebk.enterprisebank.com/EBLoanRequest.nsf/xMainLoanTransactions.xsp?';
                } else {
                        url = 'https://ebk.enterprisebank.com/EBLoanRequest.nsf/loanreq.xsp?documentId=' + documentId + '&action=' + action + '&';
                }
        }
                
        private void getQueryParameters(){         
        this.documentId= thisPage.getparameters().get('documentId');        
        this.action = thisPage.getParameters().get('action');
    }
    
     public static testMethod void verifyLoanTransactionRequestController(){
        String url = Utility.getServerUrl() +'/apex/LoanTransactionRequest?documentId=ABC123&action=openDocument';
        LoanTransactionRequestController controller = new LoanTransactionRequestController();
        controller.thisPage = new PageReference(url);
        controller.initialize();
        url = controller.getUrl();
        system.debug(url);
     }
     

}