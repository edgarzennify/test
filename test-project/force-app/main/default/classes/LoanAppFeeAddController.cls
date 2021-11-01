public with sharing class LoanAppFeeAddController {
    String url = '';
    Id LoanAppId;
    Id CollateralId;
    Id LoanFeeId;
    
    EB_Loan_Application__c loanApp ;
    EB_Collateral__c collateral;
    EB_Loan_Fee__c loanFee;
    
    Map<Id, String> colMap = null;
    
    public String err{set;get;}
    
    String LoanAppName;
    String retURL;
    CurrentMode Mode;
    
    
    public EB_Loan_Application__c a{get;set;}
    public EB_Collateral__c c{get;set;}
    public EB_Loan_Fee__c r{get;set;}
    
    public String getLoanApplicationName{get;set;}
    
    enum CurrentMode {Edit_LoanFee_And_Relationship,  Save_LoanFee_And_Relationship, None}
    
    
    public LoanAppFeeAddController(ApexPages.StandardController controller) {
       if(url == '') url = utility.getServerUrl();
       getQueryParameters();
       setmode();
       initialize();
       if (mode == currentmode.Edit_LoanFee_And_Relationship) setPageFieldsForEdit();
    }
    @TestVisible
    private void getQueryParameters(){
        try{
              this.LoanFeeId = apexpages.currentpage().getparameters().get('id');
            }catch(exception ex){
              this.LoanFeeId = null;
            }
            try{
              this.retURL = apexpages.currentpage().getparameters().get('retURL');
            }catch(exception ex){
              this.retURL = '';
            }
            if(this.LoanFeeId != null){
              return; //Found an edit request. So quit rest of code
            }
        try{
                this.LoanAppId = apexpages.currentpage().getparameters().get('aid');
            }catch(exception ex){
              this.LoanAppId = null;
            }
    }
  	@TestVisible
    private void initialize(){
        this.a = new EB_Loan_Application__c();
        this.c = new EB_Collateral__c();
        this.r = new EB_Loan_Fee__c();
       
        if(this.LoanFeeId !=null){
              try{
                 this.loanFee = [SELECT Id, Name, Collateral_Description__c,Fee_Amount__c,Fee_Handling__c,Loan_Application__c,Payable_To__c,Related_Collateral__c,Type_of_Fee__c  FROM EB_Loan_Fee__c WHERE Id =: this.LoanFeeId limit 1 ];
              }catch(exception ex){
                this.loanFee = null;
              }
            }else{
              this.loanFee = null;
            }
            
            if(this.Mode == CurrentMode.Edit_LoanFee_And_Relationship){
                      this.CollateralId = this.loanfee.Related_Collateral__c;
                      this.loanAppId = this.loanfee.Loan_Application__c;
                     
                 }
                 if(this.LoanAppId != null){
              try{
                   
                this.loanApp = [SELECT Id, RecordtypeId , Account_Number__c, Name, Closing_Date__c, EB_Loan_Packet__c , (SELECT Id, Name, EB_Collateral_ID__r.Id , EB_Collateral_ID__r.Name,  EB_Collateral_ID__r.Collateral_Description__c  FROM EB_Loan_App_Collateral_Relationships__r) FROM EB_Loan_Application__c WHERE Id =: this.LoanAppId  ];
              
               List<EB_Loan_App_Collateral_Relationship__c> rels = loanApp.EB_Loan_App_Collateral_Relationships__r;
              
                colMap = new Map<Id,String>();
               for(EB_Loan_App_Collateral_Relationship__c rel : rels){
                  
                  colMap.put(rel.EB_Collateral_ID__r.Id, rel.EB_Collateral_ID__r.Name + ' >> ' + rel.EB_Collateral_ID__r.Collateral_Description__c);
                  

               }
            
                 
                getLoanApplicationName = loanApp.Name;
               
        
              }catch(exception ex){
                loanApp = null;
              }
            }
           
    }
    private void setPageFieldsForEdit(){
            c = this.collateral;
            r = this.loanFee;
            a = this.loanapp;
            dropdownCollateralId = r.Related_Collateral__c;
            dropdownTypeOfFeeId = r.Type_of_Fee__c;
            dropdownFeeHandlingId = r.Fee_Handling__c;
            
    }
    public String dropdownCollateralId{get;set;}
    public List<SelectOption> getCollateralDescs(){
        
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '--None--'));
            
            for(String key : colMap.keyset()){
                
                options.add(new SelectOption(key, colMap.get(key)));
            }

            return options;
    }
     public String dropdownTypeOfFeeId{get;set;}
     public List<SelectOption> getTypeOfFees(){
                List<SelectOption> options = new List<SelectOption>();
                 options.add(new SelectOption('', '--None--'));
                 Schema.Describefieldresult fieldResult = EB_Loan_Fee__c.Type_of_Fee__c.getDescribe();
                     List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                     for(Schema.Picklistentry p : plist){
                            options.add(new SelectOption(p.getLabel(),p.getLabel()));
                     }

                 
                return options;
      }
     public String dropdownFeeHandlingId{get;set;}
     public List<SelectOption> getFeeHandling(){
                List<SelectOption> options = new List<SelectOption>();
                 options.add(new SelectOption('', '--None--'));
                 Schema.Describefieldresult fieldResult = EB_Loan_Fee__c.Fee_Handling__c.getDescribe();
                     List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                     for(Schema.Picklistentry p : plist){
                            options.add(new SelectOption(p.getLabel(),p.getLabel()));
                     }

                 
                return options;
      }
    public PageReference CancelLoanFee(){
        try{
              String newPageUrl;
              if(this.LoanAppId != null){
                         
                            newPageUrl = this.url +  '/' + this.LoanAppId;
                        
             
                            PageReference newPage = new PageReference(newPageUrl);
                            newPage.setRedirect(true);
                            return newPage;
              }
            }catch(exception ex){
                
            }
        return null;
    }
    public PageReference SaveLoanFee(){
        try{
                      if(this.LoanAppId == null){ 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                        ApexPages.addMessage(myMsg);
                      }else{
                        InsertOrUpdateLoanFeeRelationshipData();
                       
                        ApexPages.Message[] msgs = ApexPages.getMessages();
                        if (msgs.size() > 0){
                        }else{
                          String newPageUrl;
                         
                            newPageUrl = this.url +  '/' + this.LoanAppId;
                      
                          PageReference newPage = new PageReference(newPageUrl);
                          newPage.setRedirect(true);
                          return newPage;
                        }
                      }
                    }catch(exception ex){
                      ApexPages.addMessages(ex);
                    }
                    return null;
    }
    public PageReference SaveAndNewLoanFee(){
        try{
                      if(this.LoanAppId == null){ 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                        ApexPages.addMessage(myMsg);
                      }else{
                        InsertOrUpdateLoanFeeRelationshipData();
                       
                        ApexPages.Message[] msgs = ApexPages.getMessages();
                        if (msgs.size() > 0){
                        }else{
                          String newPageUrl;
                         
                            newPageUrl =  '/apex/LoanAppFeeAdd?aid=' + this.LoanAppId;
                      
                          PageReference newPage = new PageReference(newPageUrl);
                          newPage.setRedirect(true);
                          return newPage;
                        }
                      }
                    }catch(exception ex){
                      ApexPages.addMessages(ex);
                    }
                    return null;
    }
    private void InsertOrUpdateLoanFeeRelationshipData(){
         try{
                         r.Related_Collateral__c =  dropdownCollateralId  ;
                          r.Type_of_Fee__c = dropdownTypeOfFeeId ;
                          r.Fee_Handling__c = dropdownFeeHandlingId ;
                          
                      ApexPages.Message[] msgs = ApexPages.getMessages();
                
                      if (msgs.size() > 0){
                    
                      }else{
                          if(this.Mode == CurrentMode.Save_LoanFee_And_Relationship){
                                 r.Loan_Application__c = loanapp.Id;
                                 insert r;
                          }
                        
                          if(this.Mode == CurrentMode.Edit_LoanFee_And_Relationship ) update r;
                        
                      }
         }catch(exception ex){
                 ApexPages.addMessages(ex);
                 }
    }
 
    
    public String getQuotes(){
        return '"';
    }
    @TestVisible
    private void setMode(){
            this.Mode = CurrentMode.None;
            if(this.LoanFeeId != null && this.retURL != ''){
              this.Mode = CurrentMode.Edit_LoanFee_And_Relationship;
              
            }
          
            if(this.LoanAppId != null &&  this.LoanFeeId == null && this.retURL == null){
              this.Mode = CurrentMode.Save_LoanFee_And_Relationship;
            }
            
            
   }
  

}