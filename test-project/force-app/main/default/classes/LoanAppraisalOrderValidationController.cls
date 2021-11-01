public with sharing class LoanAppraisalOrderValidationController {
    String url = '';
    Id collateralId;
    Id ebAppraisalOrderId;
    

    EB_Collateral__c collateral;
    EB_Appraisal_Order__c ebAppraisalOrder;
    EB_Appraisal_Company__c ebAppraisalCompany;
    EB_Appraiser__c ebAppraiser;
    
    String retURL;
    String retURLNonVF;
   
    CurrentMode Mode;
    enum CurrentMode {Edit_AppraisalOrder,  Save_AppraisalOrder, None}
    
    public EB_Appraisal_Order__c a{get;set;}
    public EB_Collateral__c c{get;set;}
    
    public LoanAppraisalOrderValidationController(ApexPages.StandardController controller) {
			 if(url == '') url = getServerUrl();
		
             getQueryParameters();
             initialize();
             setmode();
    }
    @TestVisible
     private void getQueryParameters(){
        try{
              this.ebAppraisalOrderId = apexpages.currentpage().getparameters().get('id');
            }catch(exception ex){
              this.ebAppraisalOrderId = null;
            }
            try{
              this.retURL = apexpages.currentpage().getparameters().get('uid');
            }catch(exception ex){
              this.retURL = '';
            }
            try{
              this.retURLNonVF = apexpages.currentpage().getparameters().get('retURL');
            }catch(exception ex){
              this.retURLNonVF = '';
            }
            try{
            if( this.retURLNonVF  == '')	
              this.retURLNonVF = apexpages.currentpage().getparameters().get('rurl');
            }catch(exception ex){
              this.retURLNonVF = '';
            }
            if(this.ebAppraisalOrderId != null){
              return; //Found an edit request. So quit rest of code
            }
        try{
                this.collateralId = apexpages.currentpage().getparameters().get('aid');
            }catch(exception ex){
              this.collateralId = null;
            }
     }
     @TestVisible
     private void setMode(){
            this.Mode = CurrentMode.None;
            if(this.ebAppraisalOrderId != null ){
              this.Mode = CurrentMode.Edit_AppraisalOrder;
                 
            }
          
            if(this.collateralId != null &&  this.ebAppraisalOrderId == null ){
              this.Mode = CurrentMode.Save_AppraisalOrder;
            }

    }
    @TestVisible
    private void initialize(){
        this.a = new EB_Appraisal_Order__c();
        
        this.c = new EB_Collateral__c();
       
       
          if(this.collateral == null){
                      this.collateral = [SELECT Id, Name, EB_Appraisal_County__c, Collateral_Description__c, Collateral_Code__c,Collateral_Code__r.Name, Collateral_Code__r.Appraisal_Category__c, State__c,Street__c,Zip_Code__c, City__c FROM EB_Collateral__c WHERE id =: this.collateralid];
            }
             

     }
     public String err{get;set;}
     public PageReference ValidateAppraisalOrderEntry(){
     	
     	if(this.collateral != null){
     		if(collateral.City__c == '' || collateral.Street__c == '' || collateral.State__c == '' || collateral.Zip_Code__c == '' || collateral.City__c == null || collateral.Street__c == null || collateral.State__c == null || collateral.Zip_Code__c == null || collateral.EB_Appraisal_County__c == null){
     		//if(collateral.EB_Appraisal_County__c == null){	
     			 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation Error : ' + 'Appraisal County , Street, City, State and Zip are required field on Collateral if an Appraisal Order is initiated');
     			// ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation Error : ' + 'Appraisal County is a required field on Collateral if an Appraisal Order is initiated');
                 ApexPages.addMessage(myMsg);
                 
     		}else{

                 String newPageUrl = '/apex/AppraisalOrder?aid=' + collateral.Id + '&uid='+ this.retURL;
	  	         PageReference newPage = new PageReference(newPageUrl);
	             newPage.setRedirect(true);
	             return newPage;
	             
                 
     		}
     		
     	}
     	return null;
     }
     public PageReference BackToCollateralRelationship(){
     	 String newPageUrl;
                     
        newPageUrl = this.url +  '/apex/LoanAppCollateralEdit?id=' + this.retURL;
       // if(this.retURLNonVF != '') newPageUrl = this.Url + this.collateral.Id;
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
     }
     private static String  getServerUrl(){
            
            return utility.getServerUrl();
    }
     
}