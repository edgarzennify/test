public with sharing class LoanAppraisalOrderController {
  String url = '';
   
    Id collateralId;
    Id ebAppraisalOrderId;
    

    EB_Collateral__c collateral;
    EB_Appraisal_Order__c ebAppraisalOrder;
    EB_Appraisal_Company__c ebAppraisalCompany;
    EB_Appraiser__c ebAppraiser;
    
    Map<Id, String> colMap = null;
    
    public String err{set;get;}
    
    String LoanAppName;
    String retURL;
    String retURLNonVF;
   
    CurrentMode Mode;
    
    
    public EB_Appraisal_Order__c a{get;set;}
    public EB_Collateral__c c{get;set;}
    
    
    public String getLoanApplicationName{get;set;}
    
    enum CurrentMode {Edit_AppraisalOrder,  Save_AppraisalOrder, None}
    
    public LoanAppraisalOrderController(ApexPages.StandardController controller) {
                 if(url == '') url = getServerUrl();
                
         getQueryParameters();
         setmode();
         initialize();
        if (mode == currentmode.Edit_AppraisalOrder)
         setPageFieldsForEdit();
        
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
       
       
        if(this.ebAppraisalOrderId !=null){
                      try{
                          this.ebAppraisalOrder = [SELECT Id,Relationship_Manager__c,  contact_email__c ,contact_relation__c,Last_Appraisal_Company__c,Last_Appraisal_Date__c, Name,County__c ,Is_Forclosure_or_OREO__c, Prior_Appraisal_Company__c, Prior_Appraisal_Date__c, Appraisal_Company__r.Id, Appraisal_Company__r.Name ,  Appraisal_Company__r.Comment__c, Appraisal_Order_Status__c, Appraisal_Scope__c, Appraiser__r.EB_Appraisal_Company__r.Name, Appraiser__r.Email__c, Appraiser__r.Fax__c, Appraiser__r.Phone_Number__c, Collateral_Description__c, Comments__c, Contact_Address__c, Contact_Name__c, Contact_Phone__c,Engagement_Date__c,Estimated_Completion_Date__c,    Fee__c,Improvements_by_Owner_or_Previous_Owner__c,Order_By__r.User__r.Name, Order_By__r.User__r.Id, Order_Status__c,    Property_Ownership__c,  Related_Collateral__r.Name, Related_Collateral__r.Collateral_Description__c, Related_Collateral__r.Collateral_Number__c, Related_Collateral__r.Collateral_Code__c,Related_Collateral__r.Collateral_Code__r.Name ,Related_Collateral__r.Collateral_Code__r.Appraisal_Category__c,Related_Collateral__r.EB_Appraisal_County__c ,Related_Collateral__r.EB_Appraisal_County__r.Id,Related_Collateral__r.EB_Appraisal_County__r.Name,Related_Collateral__r.EB_Appraisal_County__r.State__c,Related_Collateral__r.Appraised_Value__c, Required_Attachments__c , Special_Instructions_to_Appraiser__c, Verbal_Needed_By__c  FROM EB_Appraisal_Order__c WHERE Id =: this.ebAppraisalOrderId limit 1 ];

                                  if(this.Mode == CurrentMode.Edit_AppraisalOrder){
                                        
                                        this.collateral = ebAppraisalOrder.Related_Collateral__r;
                                        this.ebAppraisalCompany = ebAppraisalOrder.Appraisal_Company__r;
                                        this.ebAppraiser = ebAppraisalOrder.Appraiser__r;
                                        
                                  }
                          }catch(exception ex){
                        this.ebAppraisalOrder = null;
                      }
             }else{
              this.ebAppraisalOrder = null;
            }
            if(this.collateral == null){
                  this.collateral = [SELECT Id, Name,EB_Appraisal_County__c,  EB_Appraisal_County__r.State__c ,EB_Appraisal_County__r.Name, Collateral_Description__c, Collateral_Code__c,Collateral_Code__r.Name, Collateral_Code__r.Appraisal_Category__c, Appraised_Value__c FROM EB_Collateral__c WHERE id =: this.collateralid];
            }
             
             
            // a.Related_Collateral__c = collateral.Id;

     }
     private void setPageFieldsForEdit(){
            c = this.collateral;
            a = this.ebAppraisalOrder;
             dropdownOrderStatusId = a.Order_Status__c ;
             dropdownPropertyOwnershipId = a.Property_Ownership__c; 
           //  dropdownAppraisalScopeId = a.Appraisal_Scope__c;
            // dropdownCountyId = a.County__c;
             dropdownCompanyId = a.Appraisal_Company__c;
             dropdownAppraisersId = a.Appraiser__c; 
           
            
     }
   
     public String getCollateralName(){
        EB_Collateral__c col = [SELECT Id, Name FROM EB_Collateral__c WHERE id = :collateral.id];
        return col.name;
     }
     public String getQuotes(){
       return '"';
     }
   
    /* public String dropdownAppraisalScopeId{get;set;}
     public List<SelectOption> getAppraisalScopes(){
                List<SelectOption> options = new List<SelectOption>();
                 options.add(new SelectOption('', '--None--'));
                 Schema.Describefieldresult fieldResult = EB_Appraisal_Order__c.Appraisal_Scope__c.getDescribe();
                     List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                     for(Schema.Picklistentry p : plist){
                            options.add(new SelectOption(p.getLabel(),p.getLabel()));
                     }

                 
                return options;
      }*/
     public String dropdownPropertyOwnershipId{get;set;}
     public List<SelectOption> getPropertyOwnerships(){
                List<SelectOption> options = new List<SelectOption>();
                 options.add(new SelectOption('', '--None--'));
                 Schema.Describefieldresult fieldResult = EB_Appraisal_Order__c.Property_Ownership__c.getDescribe();
                     List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                     for(Schema.Picklistentry p : plist){
                            options.add(new SelectOption(p.getLabel(),p.getLabel()));
                     }

                 
                return options;
      }
      public String getIsUpdatableOrderStatus(){
          Schema.Describefieldresult fieldResult = EB_Appraisal_Order__c.Order_Status__c.getDescribe();
             if(fieldResult.isUpdateable() == true) return 'true';
          return 'false';
      }
      public String dropdownOrderStatusId{get;set;}
      public List<SelectOption> getOrderStatus(){
             List<SelectOption> options = new List<SelectOption>();
             options.add(new SelectOption('', '--None--'));
             Schema.Describefieldresult fieldResult = EB_Appraisal_Order__c.Order_Status__c.getDescribe();
             List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
             for(Schema.Picklistentry p : plist){
                    options.add(new SelectOption(p.getLabel(),p.getValue()));
             }
                 
             return options;
    }
 

    public String getCountyName(){
    	if(collateral.EB_Appraisal_County__r.State__c == null) return '[Appraisal County] missing on Collateral';
        return collateral.EB_Appraisal_County__r.State__c + ' >> ' + collateral.EB_Appraisal_County__r.Name;
    }
    public String getAppraisalCoStatus(){
             Schema.Describefieldresult fieldResult = EB_Appraisal_Order__c.Appraisal_Company__c.getDescribe();
             if(fieldResult.isUpdateable() == true) return 'true';
       return 'false';
    }
    public String dropdownCompanyId{get;set;}
    public List<SelectOption> getAppraisalCompany(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        String AppraisalCategory = this.collateral.Collateral_Code__r.Appraisal_Category__c;
        for(Collateral_Code_Related__c c : [SELECT Appraisal_Company__c, Appraisal_Company__r.Name FROM Collateral_Code_Related__c WHERE Collateral_Code__c =:this.collateral.Collateral_Code__c and Appraisal_Company__c in (SELECT Appraisal_Company__c FROM EB_Appraisal_Co_Related_to_Counties__c WHERE     County__c =:collateral.EB_Appraisal_County__c  ) ORDER BY Name]){
                
                options.add(new SelectOption(c.Appraisal_Company__c, c.Appraisal_Company__r.Name));
        }
        if(options.size() < 2) dropdownCompanyId = '';
        return options;
    }
     public String getAppraiserStatus(){
             Schema.Describefieldresult fieldResult = EB_Appraisal_Order__c.Appraiser__c.getDescribe();
             if(fieldResult.isUpdateable() == true) return 'true';
       return 'false';
    }
    public Id dropdownAppraisersId{get;set;}
    public List<SelectOption> getAppraisers(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
       
        for(EB_Appraiser__c a : [SELECT Id, Name  FROM EB_Appraiser__c WHERE EB_Appraisal_Company__c =: dropdownCompanyId ORDER BY Name]){
                options.add(new SelectOption(a.Id, a.Name));
        }
        return options;
    }
    
  
    public PageReference GenerateEngagementLetter(){
        try{
                  if(this.collateral == null){ 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Collateral');
                    ApexPages.addMessage(myMsg);
                  }else{
                    InsertOrUpdateAppraisalData();
                   
                    ApexPages.Message[] msgs = ApexPages.getMessages();
                    if (msgs.size() > 0){
                        
                    }else{
                                           
                      
                    }
                  }
            }catch(exception ex){
              ApexPages.addMessages(ex);
            }
                return null;
    }
    public String getLetterURL(){
        return 'http://ebatwork/reportal/showreportfromtrustedip.aspx?id=270&P1=' + a.Id;
    }
    public PageReference SaveAppraisalOrder(){
        
         try{
                  if(this.collateral == null){ 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Collateral');
                    ApexPages.addMessage(myMsg);
                  }else{
                    InsertOrUpdateAppraisalData();
                    
                     system.debug('### url : ' + this.url);
                     system.debug('### collateralid : ' + collateralid);
                     system.debug('### retURL : ' + retURL);
                     system.debug('### retURLNonVF : ' + retURLNonVF);
                     
                    ApexPages.Message[] msgs = ApexPages.getMessages();
                    if (msgs.size() > 0){
                    }else{
                      String newPageUrl;
                      // if(retURLNonVF != '' && collateralid != null) newPageUrl  = url+ '/' + collateralid;              
                      // else{                    
                               if(apexpages.currentpage().getparameters().get('rurl')==null) newPageUrl = this.url +  '/apex/LoanAppCollateralEdit?id=' + this.retURL;
                               if(this.retURLNonVF != '' && this.retURLNonVF != null) newPageUrl = this.url + '/' +  this.retURLNonVF;
                               if(collateralid != null) newPageUrl = this.url + '/' + collateralid;
                      
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
     public PageReference SubmitOrder(){
        
         try{
                  if(this.collateral == null){ 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Collateral');
                    ApexPages.addMessage(myMsg);
                  }else{
                    InsertOrUpdateAppraisalData();
                    if(a.Id != null) {
                        a.Submitted_Flag__c = true;
                        update a;
                    }
                    ApexPages.Message[] msgs = ApexPages.getMessages();
                    if (msgs.size() > 0){
                    }else{
                      String newPageUrl;
                                       
                                           
                                if(apexpages.currentpage().getparameters().get('rurl') == null) newPageUrl = this.url +  '/apex/LoanAppCollateralEdit?id=' + this.retURL;
                                if(this.retURLNonVF != '' && this.retURLNonVF != null) newPageUrl = this.url + '/' +  this.retURLNonVF;
                                if(collateralid != null) newPageUrl = this.url + '/' + collateralid;
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
    public PageReference SaveQuickAppraisalOrder(){
         try{
                  if(this.collateral == null){ 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Collateral');
                    ApexPages.addMessage(myMsg);
                  }else{
                    InsertOrUpdateAppraisalData();
                   
                    ApexPages.Message[] msgs = ApexPages.getMessages();
                    if (msgs.size() > 0){
                    }else{
                      
                    }
                  }
            }catch(exception ex){
              ApexPages.addMessages(ex);
            }
                return null;
    }
     public PageReference CancelAppraisalOrder(){
        try{
              String newPageUrl;
             // if(this.ebAppraisalOrderId != null){
               system.debug('### url : ' + this.url);
               system.debug('### collateralid : ' + collateralid);
               system.debug('### retURL : ' + retURL);
               system.debug('### retURLNonVF : ' + retURLNonVF);           
               if(apexpages.currentpage().getparameters().get('rurl') == null) newPageUrl = this.url +  '/apex/LoanAppCollateralEdit?id=' + this.retURL;
              if(this.retURLNonVF != '' && this.retURLNonVF != null) newPageUrl = this.Url +  '/' + this.retURLNonVF;
              if(collateralid != null) newPageUrl = this.url + '/' + collateralid;
              PageReference newPage = new PageReference(newPageUrl);
              newPage.setRedirect(true);
              return newPage;
             
            }catch(exception ex){
                PageReference newPage = new PageReference(url + '/' + c.id);
              newPage.setRedirect(true);
              return newPage;
            }
        return null;
    }
    private String ValidateString(String FieldName, String Val, Boolean IsRequired){
        
                        if(Val != '' && Val != null){
                
                        }else{
                        if(IsRequired == true){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation Error : ' + FieldName + ' is Required');
                                ApexPages.addMessage(myMsg);
                    }
                        }
                         return Val;
     }
     
    private void InsertOrUpdateAppraisalData(){
         try{
              a.Order_Status__c = dropdownOrderStatusId;
              a.Property_Ownership__c = ValidateString('Property Ownership',dropdownPropertyOwnershipId,true);
              //a.Appraisal_Scope__c = ValidateString('Appraisal Scope',dropdownAppraisalScopeId, true);
          
              a.Appraisal_Company__c = dropdownCompanyId;
              a.Appraiser__c   = dropdownAppraisersId;
               
              ApexPages.Message[] msgs = ApexPages.getMessages();
        
              if (msgs.size() > 0){
            
              }else{
                  if(this.Mode == CurrentMode.Save_AppraisalOrder){
                         a.Related_Collateral__c = collateral.id;
                         upsert a;
                  }
                
                  if(this.Mode == CurrentMode.Edit_AppraisalOrder ) update a;
              
                  if(c.Appraised_Value__c != null || c.Appraised_Value__c != 0){
                         this.collateral.Appraised_Value__c = c.Appraised_Value__c;
                         update collateral;
                  }
              }
              
         }catch(exception ex){
                 ApexPages.addMessages(ex);
         }
    }
     private static String convertid15ToId18(String id15) {
        if (id15.length() != 15) return id15;
        Id currentId = id15;
        String id18 = currentId;
        return id18;
    }
   
    private static String  getServerUrl(){
                
            
            return utility.getServerUrl();
    }

}