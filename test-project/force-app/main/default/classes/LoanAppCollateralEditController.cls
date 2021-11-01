public with sharing class LoanAppCollateralEditController {
  String url = Utility.getServerUrl();
 
  String LoanAppName;
  String retURL;
  Id LoanAppId;
  Id CollateralId;
  Id LoanAppCollateralId;
  Id LoanPacketId;
  Id LoanPacketEntityId;
  EB_Loan_Application__c loanApp ;
  EB_Loan_App_Collateral_Relationship__c loanAppCollateral;
  EB_Loan_Packet__c loanPacket;
  EB_Collateral__c collateral;
  List<RecordType> recordTypeList = null;
  Map<Id, String> CollateralCodeCategoryMap  = null;
  Map<Id, String> CollateralCodeSubcategoryMap  = null;
  CurrentMode Mode;
  
  //Fix for Back button on Apprasial Order
  String detectMode; 
  
  public String err{set;get;}
  public String getLoanApplicationName{get;set;}
  public EB_Collateral__c c{get;set;}
  public EB_Loan_App_Collateral_Relationship__c r{get;set;}
  public Id dropdownCollateralCodeId{get;set;}
  public Id dropdownBorrowerId{get;set;}
  public String dropdownPurposeOfCollateralId{get;set;}
  public Id selectedAppraisalId{get;set;}
  
  enum CurrentMode {Edit_Collateral_And_Relationship, Save_Relationship, Save_Collateral_And_Relationship, None}
  
   public Collateral_Code__c ccode{
    get{
        ccode = null;
        if(ccode == null) ccode = new Collateral_Code__c();
        if((c.Status__c=='Existing' && getChangeCollateralCodeStatus() == 'true') || (c.Status__c !='Existing' )){
            List<Collateral_Code__c> clist = [SELECT Id,Policy_Advance_Rate__c FROM Collateral_Code__c WHERE Id =: dropdownCollateralCodeId];
            if(clist.size() > 0) {
                ccode.Policy_Advance_Rate__c = cList[0].Policy_Advance_Rate__c;
                ccode.Name = dropdownChangeCollateralCodeId;
                
            }
            
        }
        if(c.Status__c=='Existing' && getChangeCollateralCodeStatus() != 'true'){
            
             ccode.Policy_Advance_Rate__c = c.Core_Collateral_Code__r.Policy_Advance_Rate__c;
            ccode.Name = dropdownChangeCollateralCodeId;
        }
    
        
        return ccode; 
    }
    set;
  }
   
  
  public LoanAppCollateralEditController(ApexPages.StandardController controller) {
            getQueryParameters();
            setMode();
            Initialize();
            
            if(Mode == CurrentMode.Edit_Collateral_And_Relationship ){
              setPageFieldsForCollateral();
              setPageFieldsForLoanAppCollateralRelationship();
            }else if(Mode == CurrentMode.Save_Relationship){
              setPageFieldsForCollateral();
            }else{
          
            }
  }
  
  @TestVisible  
  private void getQueryParameters(){
        try{
                      this.detectMode = apexpages.currentpage().getparameters().get('m');
                    }catch(exception ex){
                      this.detectMode = null;
                    }
                    try{
                      this.LoanAppCollateralId = apexpages.currentpage().getparameters().get('id');
                    }catch(exception ex){
                      this.LoanAppCollateralId = null;
                    }
                    try{
                       this.retURL = apexpages.currentpage().getparameters().get('retURL');
                    }catch(exception ex){
                       this.retURL = '';
                    }
                    if(this.LoanAppCollateralId != null || detectMode != null){
                        if(LoanAppCollateralId == null && detectMode != null) LoanAppCollateralId = detectMode;
                      return; //Found an edit request. So quit rest of code
                    }
                  
                    try{
                      this.LoanAppId = apexpages.currentpage().getparameters().get('aid');     
                    }catch(exception ex){
                      this.LoanAppId = null;
                    }
                  
                    try{
                      this.LoanAppCollateralId = apexpages.currentpage().getparameters().get('acid');
                    }catch(exception ex){
                      this.LoanAppCollateralId = null;
                    }
                    
                    try{
                      this.CollateralId = apexpages.currentpage().getparameters().get('cid');
                    }catch(exception ex){
                      this.CollateralId = null;
                    }  
  }
  
  private void setMode(){
    this.Mode = CurrentMode.None;
    if(this.LoanAppCollateralId != null && this.retURL != ''){
      this.Mode = CurrentMode.Edit_Collateral_And_Relationship;
    }
  
    if(this.LoanAppId != null && this.CollateralId == null && this.LoanAppCollateralId == null && this.retURL == null){
      this.Mode = CurrentMode.Save_Collateral_And_Relationship;
    }
    
    if(this.LoanAppId != null && this.CollateralId != null && this.LoanAppCollateralId == null && this.retURL == null){
      this.Mode = CurrentMode.Save_Relationship;
    }
    /*if(this.loanappid != null && this.CollateralId != null){
        List<EB_Loan_App_Collateral_Relationship__c> rel = new List<EB_Loan_App_Collateral_Relationship__c>();
        for(EB_Loan_App_Collateral_Relationship__c r : [SELECT Id FROM EB_Loan_App_Collateral_Relationship__c WHERE EB_Collateral_ID__c =: this.CollateralId and EB_Loan_Application_ID__c =: loanappid]){
                rel.add(r);
        }
        if(rel.size()> 0) this.Mode =  CurrentMode.Edit_Collateral_And_Relationship;
        
        
    }*/
  }
  
  @TestVisible
  private void Initialize(){
    this.c = new EB_Collateral__c();
    this.r = new EB_Loan_App_Collateral_Relationship__c();
    //initialize the list
    fillCollateralCodeMaps();
    //List<SelectOption> s =  getPurposeOfCollateral(); //refresh list
    if(this.LoanAppCollateralId !=null){
      try{
        this.loanAppCollateral = [SELECT Id, Collateral_Crossed_With__c , Application_Cross_With__c, EB_Collateral_ID__c, EB_Loan_Application_ID__c, Name,  Purpose_of_Collateral__c, RecordTypeId, Abundance_of_Caution__c,Requires_Centralized_Disbursing__c FROM EB_Loan_App_Collateral_Relationship__c WHERE Id =: this.LoanAppCollateralId limit 1 ];
      }catch(exception ex){
        this.loanAppCollateral = null;
      }
    }else{
      this.loanAppCollateral = null;
    }
    if(this.Mode == CurrentMode.Edit_Collateral_And_Relationship){
       CollateralId = this.loanAppCollateral.EB_Collateral_ID__c;
       this.loanAppId = this.loanAppCollateral.EB_Loan_Application_ID__c;
    }
    if(this.LoanAppId != null){
      try{
        this.loanApp = [SELECT Id, RecordtypeId , Account_Number__c, Name, Closing_Date__c, EB_Loan_Packet__c   FROM EB_Loan_Application__c WHERE Id =: this.LoanAppId limit 1 ];
        LoanPacketId = loanApp.EB_Loan_Packet__c;
        loanPacket = [SELECT Id, Lead_Entity__c, Name FROM EB_Loan_Packet__c WHERE Id =:LoanPacketId];
        LoanPacketEntityId = loanPacket.Lead_Entity__c;
        getLoanApplicationName = loanApp.Name;

      }catch(exception ex){
        loanApp = null;
      }
    }
    if(this.CollateralId !=null){
      try{
        this.collateral = [SELECT Id , R_E_Taxes_Paid__c, Application_Cross_With__c, Survey_Required_Picklist__c ,  EB_Appraisal_County__c,    
                          EB_Appraisal_County__r.Id,      EB_Appraisal_County__r.State__c , EB_Appraisal_County__r.Name , Appraised_Value__c,Appraisal_Company_Used__c, Advance_Rate__c,City__c,Collateral_Application__c, Collateral_Description__c, Collateral_Code__c, Core_Collateral_Code__c , Change_Collateral_Code__c , Collateral_Number__c,  Comments__c,EB_Bank__c,Existing_Debt__c,Future_Advance_Amount__c,Increase_Amount__c,Increase_to_Existing_Deed__c,Key__c,Lendable_Equity__c,Loan_Value__c,Market_Value__c,MayEdit,Name,Owner__c, Property_Type__c,State__c,Street__c,Survey_Required__c, Valuation_Type__c,Evaluation_Appraisal_Date__c, Status__c, Zip_Code__c, Lien_Position__c,  Total_Deed_Amount__c, Assignment_of_Rents__c, Assignment_of_Leases__c, Collateral_Code__r.Policy_Advance_Rate__c, Core_Collateral_Code__r.Policy_Advance_Rate__c, Borr_control_20_of_leasing_entities__c, Can_land_be_used_as_farmland__c,Is_prop_leased_by_borr_or_an_affiliate__c, Is_stock_publicly_traded__c, Src_of_repymt_from_50_rental_income__c,
                            FDIC_Valuation_Type__c,  Valuation_Date__c,  As_Completed_Value__c, 
                            As_Is_Value__c,  As_Liquidated_Value__c, As_Stabilized_Value__c ,
                            Oasis_Order_Number__c
                           FROM EB_Collateral__c WHERE Id =: this.CollateralId limit 1 ];
      }catch(exception ex){
        this.collateral = null;
      }
    }else{
      this.CollateralId = null;
    }
  }   

  public List<EB_Appraisal_Order__c> getAppraisals(){
        List<EB_Appraisal_Order__c> appraisals =  [SELECT Id, Name,Prior_Appraisal_Company__c,Appraisal_Company_Used__c,Appraised_Value_reviewed__c, Prior_Appraisal_Date__c, Appraisal_Order_Status__c, Appraisal_Scope__c, Collateral_Description__c, Comments__c, Contact_Address__c, Contact_Name__c, Contact_Phone__c,Engagement_Date__c,Estimated_Completion_Date__c, Fee__c,Improvements_by_Owner_or_Previous_Owner__c,Order_By__c, Order_By__r.User__r.Name, Order_By__r.User__r.Id, Order_Status__c,       Property_Ownership__c,  Related_Collateral__r.Name, Related_Collateral__r.Collateral_Description__c, Related_Collateral__r.Collateral_Number__c, Related_Collateral__r.Collateral_Code__c, Required_Attachments__c , Special_Instructions_to_Appraiser__c, Verbal_Needed_By__c, CreatedDate,
        OREO_Account__c, Order_Type__c, Date_Appraisal_Needed__c, Last_Appraisal_Date__c, Last_Appraisal_Company__c, Is_SBA__c, Relationship_Manager__r.Name, Loan_Coordinator__r.Name,  Relationship_Manager__c, Loan_Coordinator__c,  Related_Entities_to_Be_Addressed__c, Appraisal_Order_Scope__c, Is_Forclosure_or_OREO__c, Details_Related_to_Subject__c, Special_Instructions_to_Bank_Officer__c, Loan_Exceeds_2M__c, Will_RM_Seek_Waiver__c, Submit_Order__c, Tax_Increment_Financing_TIF__c, Tax_Credit_Involved__c, Related_Collateral__c, CreatedBy.Name, Oasis_Order_Number__c, LastModifiedBy.Name,FDIC_Valuation_Type__c,  Valuation_Date__c,  As_Completed_Value__c, As_Is_Value__c,  As_Liquidated_Value__c, As_Stabilized_Value__c
          FROM EB_Appraisal_Order__c WHERE Related_Collateral__c =: this.collateralid and Related_Collateral__c !=: null ORDER BY createddate desc ];
        if (appraisals.size() > 0)
        return appraisals;
        
        return null;
            
  }
  public String getReturnUrl(){
         return this.LoanAppCollateralId;  
  }
  private void setPageFieldsForCollateral(){
        c = this.collateral;
        this.dropdownCollateralCodeId = c.Collateral_Code__c ;
        this.dropdownBorrowerId = getOwnerIDForCollateralID(c.Id);
        dropdownLienId = c.Lien_Position__c;
        dropdownCountyId = c.EB_Appraisal_County__c;
        dropdownSurveyId = c.Survey_Required_Picklist__c;
        dropdownValuationTypeId = c.Valuation_Type__c ;
        
        if(c.Status__c == 'Existing'){
                if(string.valueof(c.change_Collateral_code__c) != 'Yes' && this.Mode == CurrentMode.Save_Relationship)
                 dropdownChangeCollateralCodeId = null; 
            else
             dropdownChangeCollateralCodeId = string.valueof(c.change_Collateral_code__c);
        }
                 
  }
  
  private void setPageFieldsForLoanAppCollateralRelationship(){
            r = this.loanAppCollateral;
            this.dropdownPurposeOfCollateralId = r.Purpose_of_Collateral__c ;
  }
  
  public String getReadonlyStatus(){
            if(this.Mode == CurrentMode.Save_Relationship || this.Mode == CurrentMode.Edit_Collateral_And_Relationship){  
              if(c.Status__c == 'Existing')
                return 'true';
            }
            return 'false';
  }
  public String getChangeCollateralCodeStatus(){
                 //if(c.change_Collateral_code__c == true && getReadonlyStatus == false) return 'true';
                //if(c.change_Collateral_code__c == true ) return 'true';
                //return 'false';
                //return 'true';
          
                if(dropdownChangeCollateralCodeId == 'true' && c.Status__c == 'Existing') return 'true';
                return 'false';
  }
  public String getRenewalOnly(){
            if(getLoanRecordType() == 'Renewal') return 'true';
            return 'false';
  }
  
  public String  getLoanRecordType(){
         RecordType rec = utility.RecordTypeObject('EB_Loan_Application__c' ,loanApp.RecordTypeId );
         if(rec != null) return rec.Name;
                  /* RecordType rec = [SELECT Id, Name FROM RecordType WHERE Id =: loanApp.RecordTypeId limit 1];
                   return rec.Name;
                   */
         return '';
   }
  public String getOwnerListForReadOnlyStatus(){
            String OwnerList = '';
            for(EB_Collateral_Client_Relationship__c acct : [SELECT Client_ID__c, Client_ID__r.Name, Entity_Name__c  FROM EB_Collateral_Client_Relationship__c WHERE EB_Collateral_ID__c =: this.collateral.Id]){
              OwnerList += acct.Entity_Name__c + ',';
            }
          
            try{ //Remove the last comma ;
              Integer len = OwnerList.length();
              if(len > 1 &&  OwnerList.substring(len-1) == ',') OwnerList = OwnerList.substring(0, len-1);
            }catch(exception ex){
            }
            return OwnerList;
  }
  
  public String getCollateralCodeAndName(){
            for(SelectOption o :  getCollateralCodes()){
              if(o.getValue() == string.valueOf(c.Collateral_Code__c)) return o.getLabel();
            }
            return '';
  }
  
  public List<SelectOption> getCollateralCodes(){
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '--None--'));
          
            for(Collateral_Code__c t : [SELECT Id, Name ,Category__c, Collateral_Code_ID__c, Policy_Advance_Rate__c  FROM Collateral_Code__c order by Name limit 500]){
              options.add(new SelectOption(t.Id ,  t.Name + ' - ' + t.Collateral_Code_ID__c  ));
            }
            return options;
  }
  
  private void fillCollateralCodeMaps(){
      this.CollateralCodeCategoryMap = new Map<Id, String>();
      this.CollateralCodeSubcategoryMap = new Map<Id, String>();
      for(Collateral_Code__c ccode : [SELECT Id , Category__c, Subcategory__c, Collateral_Code_ID__c FROM Collateral_Code__c LIMIT 500]){
        if (ccode.Category__c != null){
          CollateralCodeCategoryMap.put(ccode.Id , ccode.Category__c);
        }
        if (ccode.Subcategory__c != null){
          CollateralCodeSubcategoryMap.put(ccode.Id , ccode.Subcategory__c);
        }
      }
  }

  private String IsCollateralInCategoryAndSubCategory(Id collateral_Id, Set<String> isInCategories, Set<String> isInSubcategories, Set<String> notInCategories, Set<String> notInSubcategories){
      if(this.CollateralCodeCategoryMap == null){
        fillCollateralCodeMaps();
      }
      if(this.CollateralCodeCategoryMap != null){
        String categoryOfCollateral = CollateralCodeCategoryMap.get(Collateral_Id);
        String subcategoryOfCollateral = CollateralCodeSubcategoryMap.get(Collateral_Id);
        if (isInCategories.size() != 0)
        {
          if (!isInCategories.contains(categoryOfCollateral)){
            return 'false';
          }
        }
        if (isInSubcategories.size() != 0)
        {
          if (!isInSubcategories.contains(subcategoryOfCollateral)){
            return 'false';
          }
        }
        if (notInCategories.size() != 0)
        {
          if (notInCategories.contains(categoryOfCollateral)){
            return 'false';
          }
        }
        if (notInSubcategories.size() != 0)
        {
          if (notInSubcategories.contains(subcategoryOfCollateral)){
            return 'false';
          }
        }
        return 'true';        
      }
      return 'false';
  }

  public String getRealEstateRenderStatus(){
    Set<String> isInCategories = new Set<String>{'Real Estate'};
    Set<String> isInSubcategories = new Set<String>();
    Set<String> notInCategories = new Set<String>();
    Set<String> notInSubcategories = new Set<String>();
    return IsCollateralInCategoryAndSubCategory(dropdownCollateralCodeId, isInCategories, isInSubcategories, notInCategories, notInSubcategories);
  }
  
  public String getLoanDetailsRealEstateRenderStatus(){
    Set<String> isInCategories = new Set<String>{'Real Estate'};
    Set<String> isInSubcategories = new Set<String>();
    Set<String> notInCategories = new Set<String>();
    Set<String> notInSubcategories = new Set<String>{'Land', 'Construction'};
    return IsCollateralInCategoryAndSubCategory(dropdownCollateralCodeId, isInCategories, isInSubcategories, notInCategories, notInSubcategories);
  }

  public String getLoanDetailsLandRenderStatus(){
    Set<String> isInCategories = new Set<String>{'Real Estate'};
    Set<String> isInSubcategories = new Set<String>{'Land'};
    Set<String> notInCategories = new Set<String>();
    Set<String> notInSubcategories = new Set<String>();
    return IsCollateralInCategoryAndSubCategory(dropdownCollateralCodeId, isInCategories, isInSubcategories, notInCategories, notInSubcategories);
  }

  public String getLoanDetailsStockRenderStatus(){
    Set<String> isInCategories = new Set<String>();
    Set<String> isInSubcategories = new Set<String>{'Stock'};
    Set<String> notInCategories = new Set<String>();
    Set<String> notInSubcategories = new Set<String>();
    return IsCollateralInCategoryAndSubCategory(dropdownCollateralCodeId, isInCategories, isInSubcategories, notInCategories, notInSubcategories);
  }

  
  public String getCheckIncreaseToExistingDeed(){
            if(c.Increase_to_Existing_Deed__c == true) return 'true';
            return 'false';
  }
  
  public List<SelectOption> getBorrowerNames(){
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '--None--'));
            for(sObject  a : [SELECT Id Ident, Name AccountName, EB_Client_Name__c  ClientName FROM Account WHERE Id in (SELECT Entity_Name__c FROM  EB_Loan_App_Entity_Relationship__c WHERE Loan_Application_ID__c =: LoanAppId) GROUP By Id ,Name, EB_Client_Name__c]){
              String AcctName = String.valueOf(a.get('AccountName'));
              String ClientName = String.valueOf(a.get('ClientName'));
              String nm = ClientName;
              if(nm == null || nm == '') nm = AcctName;
              
              Id acctId = String.valueOf(a.get('Ident'));
              options.add(new SelectOption(acctId , nm ));
            }
            return options;
  }
  
  @TestVisible
  private Id getOwnerIDForCollateralID(Id colleteralId){
            List<EB_Collateral_Client_Relationship__c> owner = [SELECT Client_ID__c, Client_ID__r.Name FROM EB_Collateral_Client_Relationship__c WHERE EB_Collateral_ID__c =: collateralId limit 1];
            if(owner.size() > 0){
                
              return owner[0].Client_ID__c;
            }
            return '';
  }
  
  public List<SelectOption> getPurposeOfCollateral(){
            List<SelectOption> options = new List<SelectOption>();
            options.add(new Selectoption('0','--None--'));
            if(PrimaryPurposeOfCollateralExistsOnLoanApp() == false || r.Purpose_of_Collateral__c == 'Primary') {
              options.add(new Selectoption('Primary','Primary'));
            }
          
            options.add(new Selectoption('Additional','Additional'));
            return options;
  }
  public String dropdownLienId{get;set;}
   public List<SelectOption> getLienPosition(){
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '--None--'));
            Schema.Describefieldresult fieldResult = EB_Collateral__c.Lien_Position__c.getDescribe();
                 List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                 for(Schema.Picklistentry p : plist){
                        options.add(new SelectOption(p.getLabel(),p.getLabel()));
                 }
            return options;
   }
   public String dropdownValuationTypeId{get;set;}
   public List<SelectOption> getValuationType(){
                   List<SelectOption> options = new List<SelectOption>();
           options.add(new SelectOption('', '--None--'));
           Schema.Describefieldresult fieldResult = EB_Collateral__c.Valuation_Type__c.getDescribe();
           List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
           for(Schema.Picklistentry p : plist){
                options.add(new SelectOption(p.getLabel(),p.getLabel()));
           }
        return options;
   }
   public String dropdownSurveyId{get;set;}
   public List<SelectOption> getSurvey(){
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('', '--None--'));
         Schema.Describefieldresult fieldResult = EB_Collateral__c.Survey_Required_Picklist__c.getDescribe();
                         List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                         for(Schema.Picklistentry p : plist){
                                options.add(new SelectOption(p.getLabel(),p.getLabel()));
                         }
        return options;
   }
   public Id dropdownCountyId{get;set;}
   public List<SelectOption> getCounties(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        for(EB_Appraisal_County__c c : [SELECT  Id, Name, County_FIPS__c, FIPS_Class__c ,       State__c FROM EB_Appraisal_County__c ORDER BY State__c, Name ]){
                options.add(new SelectOption(c.Id, c.State__c + ' >> ' + c.Name  ));
        }
        return options;
    }
    public String dropdownChangeCollateralCodeId{get;set;}
    public List<SelectOption> getChangeCollateral(){
        List<SelectOption> options = new List<SelectOption>();
             options.add(new SelectOption('', '--None--'));
             options.add(new SelectOption('false','No'));
             options.add(new SelectOption('true','Yes'));
            
             
   
            return options;
    }
   /*public List<SelectOption> getLienPosition(){
                    List<SelectOption> options = new List<SelectOption>();
                 options.add(new SelectOption('', '--None--'));
                 Schema.Describefieldresult fieldResult = EB_Collateral__c.EB_Appraisal_County__c.getDescribe();
                                 List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                                 for(Schema.Picklistentry p : plist){
                                        options.add(new SelectOption(p.getLabel(),p.getLabel()));
                                 }

                 
                return options;
   }*/
   
   @TestVisible
    private Boolean PrimaryPurposeOfCollateralExistsOnLoanApp(){
        List<EB_Loan_App_Collateral_Relationship__c> colrel = [SELECT Id FROM EB_Loan_App_Collateral_Relationship__c WHERE EB_Loan_Application_ID__c =: loanAppId and Purpose_of_Collateral__c =: 'Primary' limit 1];
        if(colrel.size() == 0) return false;
        return true;
    } 
    
  /*public String getCurrentCrossedWith(){
         String ret = '';
         For(EB_Collateral_Account_Relationship__c rel : [SELECT Id,  EB_Account_ID__r.Name FROM EB_Collateral_Account_Relationship__c WHERE EB_Collateral_ID__c =: c.Id and EB_Collateral_ID__c != null]){
                ret = ret + rel.EB_Account_ID__r.Name + ',';
         }
         if(ret.length() > 1){
                String tempret = ret.substring(ret.length() - 1, ret.length());
                if(tempret == ',')
        ret = ret.substring(0, ret.length() - 1);
         }
         return ret;
  }*/

  public String getCurrentCrossedWithEBAccts(){
     String ret = '';
     for(EB_Collateral_Account_Relationship__c rel : [SELECT Id, EB_Account_ID__r.Name FROM EB_Collateral_Account_Relationship__c WHERE EB_Collateral_ID__c =: c.Id and EB_Collateral_ID__c != null and Inactive__c !=: true and EB_Account_ID__r.Account_Status__c =: 'A' ]){
            ret = ret + rel.EB_Account_ID__r.Name + ',';
     }
     if(ret.length() > 1){
        String tempret = ret.substring(ret.length() - 1, ret.length());
        if(tempret == ','){
            ret = ret.substring(0, ret.length() - 1);
        }
     }
     return ret;
  }
  public String getCurrentCrossedWithApps(){
     String ret = '';
     for(EB_Loan_App_Collateral_Relationship__c rel : [SELECT Id, EB_Loan_Application_ID__r.Name FROM EB_Loan_App_Collateral_Relationship__c WHERE EB_Collateral_ID__c =: c.Id and EB_Collateral_ID__c != null]){
            ret = ret + rel.EB_Loan_Application_ID__r.Name + ',';
     }
     if(ret.length() > 1){
        String tempret = ret.substring(ret.length() - 1, ret.length());
        if(tempret == ','){
            ret = ret.substring(0, ret.length() - 1);
        }
     }
     return ret;
  } 
  public String getCurrentCrossedWith(){
    String ret='';
    String retEBacct = getCurrentCrossedWithEBAccts();
    if(retEBacct == '' || retEBacct == null) 
        ret= getCurrentCrossedWithApps();
    else
        ret=getCurrentCrossedWithEBAccts() + ',' + getCurrentCrossedWithApps();
        
    if (ret.length()>1){
        String tempret = ret.substring(ret.length() - 1, ret.length());
        if(tempret == ','){
            ret = ret.substring(0, ret.length() - 1);
        }
    }
    return ret;
  }
  
  ///// End of My Krappp //////////
  public PageReference EditAppraisal(){
        
            try{
              if(this.LoanAppId == null){ 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                        ApexPages.addMessage(myMsg);
              }else{
                        if(this.Mode == CurrentMode.Save_Collateral_And_Relationship) InsertCollateralAndRelationshipData();
                        if(this.Mode == CurrentMode.Save_Relationship) InsertRelationshipData();
                        if(this.Mode == CurrentMode.Edit_Collateral_And_Relationship )  updateCollateralRelationshipData();
                        ApexPages.Message[] msgs = ApexPages.getMessages();
                         if (msgs.size() > 0){
                         }else{
                                Id lac;
                                
                                 if(loanAppCollateralId == null)
                                 {
                                        lac = loanAppCollateral.Id;
                                 }else
                                 lac = loanAppCollateralId;
                                 String newPageUrl = '/apex/AppraisalOrder?id=' + selectedAppraisalId + '&uid='+ lac;
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
  public PageReference ViewAppraisal(){
        
            try{
              if(this.LoanAppId == null){ 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                        ApexPages.addMessage(myMsg);
              }else{
                        if(this.Mode == CurrentMode.Save_Collateral_And_Relationship) InsertCollateralAndRelationshipData();
                        if(this.Mode == CurrentMode.Save_Relationship) InsertRelationshipData();
                        if(this.Mode == CurrentMode.Edit_Collateral_And_Relationship )  updateCollateralRelationshipData();
                        ApexPages.Message[] msgs = ApexPages.getMessages();
                         if (msgs.size() > 0){
                         }else{
                                Id lac;
                                
                                 if(loanAppCollateralId == null)
                                 {
                                        lac = loanAppCollateral.Id;
                                 }else
                                 lac = loanAppCollateralId;
                                 String newPageUrl = '/apex/AppraisalOrderView?id=' + selectedAppraisalId + '&uid='+ lac;
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
  public PageReference NewAppraisal(){
        if(CollateralId != null){
           String url = '/apex/AppraisalOrder?collateralId=' + String.valueOf(CollateralId);
            PageReference newPage = new PageReference(url);
            newPage.setRedirect(true);
            return newPage;
        }
        return null;             
  }
  public PageReference CancelCollateral(){
    try{
              String newPageUrl;
              if(this.LoanAppId != null){
                  //if(this.Mode == CurrentMode.Edit_Collateral_And_Relationship || this.mode == CurrentMode.Save_Collateral_And_Relationship){
                   // newPageUrl = this.url + this.retURL;
                  //}else{
                    newPageUrl = this.url + '/' +  this.LoanAppId;
                 // }
                    PageReference newPage = new PageReference(newPageUrl);
                    newPage.setRedirect(true);
                    return newPage;
              }
    }catch(exception ex){
        
    }
    return null;
  }
  
  public PageReference SaveCollateral(){
        
    try{
      if(this.LoanAppId == null){ 
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                ApexPages.addMessage(myMsg);
      }else{
                if(this.Mode == CurrentMode.Save_Collateral_And_Relationship) InsertCollateralAndRelationshipData();
                if(this.Mode == CurrentMode.Save_Relationship) InsertRelationshipData();
                if(this.Mode == CurrentMode.Edit_Collateral_And_Relationship )  updateCollateralRelationshipData();
                ApexPages.Message[] msgs = ApexPages.getMessages();
        if (msgs.size() > 0){
        }else{
          String newPageUrl;
         // if(this.Mode == CurrentMode.Edit_Collateral_And_Relationship){
          //  newPageUrl = this.url + this.retURL;
          //}else{
            newPageUrl = this.url +  '/' + this.LoanAppId;
        //  }
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
  
  public PageReference SaveQuickCollateral(){
        
    try{
      if(this.LoanAppId == null){ 
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                ApexPages.addMessage(myMsg);
      }else{
                if(this.Mode == CurrentMode.Save_Collateral_And_Relationship) InsertCollateralAndRelationshipData();
                if(this.Mode == CurrentMode.Save_Relationship) InsertRelationshipData();
                if(this.Mode == CurrentMode.Edit_Collateral_And_Relationship )  updateCollateralRelationshipData();
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
  private Boolean CheckDuplicate(){
        try{
         EB_Loan_App_Collateral_Relationship__c chk = [SELECT Id FROM EB_Loan_App_Collateral_Relationship__c WHERE EB_Collateral_ID__c =: c.Id and EB_Collateral_ID__c != null and  EB_Loan_Application_ID__c =: r.EB_Loan_Application_ID__c and EB_Loan_Application_ID__c != null];
        id i = chk.Id;
        }catch(exception ex){
                err = 'false';
                return false;
        }         
        err = 'true';
        return true;            
  }
  private void InsertCollateralAndRelationshipData(){
        
    try{
              ValidateCollateralData();
              ValidateRelationshipdata();
              ApexPages.Message[] msgs = ApexPages.getMessages();

      if (msgs.size() > 0){
    
      }else{
            if(c.Id == null)insert c;
            else
            update c;
                        //upsert c;
                // SELECT required to Get New_Collateral_Number__c due to timing issue.
                List<EB_Collateral__c> colls = [SELECT Id, New_Collateral_Number__c FROM EB_Collateral__c WHERE Id =: c.Id limit 1];
                if (colls == null){
                  delete c;
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot retirve Created Collateral Name.');
                  ApexPages.addMessage(myMsg);
                }else{
                  for(EB_Collateral__c col : colls){
                    c.Name = 'Prospective' + '-' + col.New_Collateral_Number__c;
                    c.Collateral_Number__c = col.New_Collateral_Number__c;
                    
                    update c;
                    //enter the new collateral in other relationship data.
                    EB_Collateral_Client_Relationship__c clientRel = new EB_Collateral_Client_Relationship__c();
                    clientRel.Client_ID__c = dropdownBorrowerId;
                    clientRel.EB_Collateral_ID__c = c.Id;   
                    //upsert clientRel;
                    if(clientRel.Id == null){
                        if(CheckDuplicate() == false)
                        insert clientRel;
                        else{
                                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate Collateral Record exists.');
                           ApexPages.addMessage(myMsg1);
                        }
                    }
                    else
                        update clientRel;
                  }
                  
                  r.EB_Collateral_ID__c = c.Id;
                  if(r.EB_Loan_Application_ID__c == null) r.EB_Loan_Application_ID__c = loanAppId;
                  if(r.RecordTypeId == null) r.RecordTypeId = getRecordTypeIdForName('All');
                  //upsert r;
                  if(r.Id == null) insert r;
                  else
                  update r;
                }
      }
    }catch(exception ex){
      ApexPages.addMessages(ex);
      
    }
  }

  private void InsertRelationshipData(){
        
    try{
      ValidateCollateralData();
      ValidateRelationshipdata();
      if(this.CollateralId == null){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Retriving Entity Info.');
        ApexPages.addMessage(myMsg);
      }
      ApexPages.Message[] msgs = ApexPages.getMessages();
      if (msgs.size() > 0){
      }else{
        update c;
        r.EB_Collateral_ID__c = c.Id;
        if(r.EB_Loan_Application_ID__c == null) r.EB_Loan_Application_ID__c = this.loanApp.Id;
        if(r.RecordTypeId == null) r.RecordTypeId = getRecordTypeIdForName('All');
       
       //if(r.Id == null) insert r;
       //else
       //update r;
       if(r.Id == null){
                        if(CheckDuplicate() == false)
                            insert r;
                        else{
                                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate Collateral Record exists.');
                            ApexPages.addMessage(myMsg1);
                        }
        }
        else
                update r;
      }
    }catch(exception ex){
      ApexPages.addMessages(ex);
    }
  }
  
  private void updateCollateralRelationshipData(){
        
    try{
              ValidateCollateralData();
              ValidateRelationshipdata();
              ApexPages.Message[] msgs = ApexPages.getMessages();
              if(this.CollateralId == null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Retriving Collateral Info.');
                ApexPages.addMessage(myMsg);
              }
              if(this.LoanAppCollateralId == null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Retriving Collateral and Related Loan App Info.');
                ApexPages.addMessage(myMsg);
              }
              if (msgs.size() > 0){
              }else{
                if(r.RecordTypeId == null) r.RecordTypeId = getRecordTypeIdForName('All');
                update this.r;
                List<EB_Collateral__c> colls = [SELECT Id, New_Collateral_Number__c FROM EB_Collateral__c WHERE Id =: c.Id limit 1];
                for(EB_Collateral__c col : colls){
                    
                    //update c;
                    //enter the new collateral in other relationship data.
                    id borrow = getOwnerIDForCollateralID(c.Id);
                    EB_Collateral_Client_Relationship__c clientRel = [SELECT Client_ID__c, EB_Collateral_ID__c FROM EB_Collateral_Client_Relationship__c WHERE Client_ID__c =: borrow and EB_Collateral_ID__c =: c.Id limit 1] ;
                    clientRel.Client_ID__c = dropdownBorrowerId;
                     update c; 
                    update clientRel;
                 
                  }
               
              }
    }catch(exception ex){
      ApexPages.addMessages(ex);
    }
  }
  
  public void updateValuationTypeSelection(){
     c.Valuation_Type__c = dropdownValuationTypeId;
  }
  
  private void ValidateCollateralData(){
                if(c.Status__c == 'Existing'){
                        if(dropdownChangeCollateralCodeId == null || dropdownChangeCollateralCodeId == ''){
                                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Yes or No for Change Collateral code.');
                             ApexPages.addMessage(myMsg);
                        }else{
                                c.Change_Collateral_Code__c = Boolean.valueof(dropdownChangeCollateralCodeId);
                                if(! c.Change_Collateral_Code__c ) c.Collateral_Code__c = c.Core_Collateral_Code__c;
                        }
                }
            if(this.getReadonlyStatus() == 'false'){
              
              Id CheckValidOwnerId = validateId('Owner' , dropdownBorrowerId, true);
            }
            
             if(c.Change_Collateral_Code__c == true || c.Status__c != 'Existing') c.Collateral_Code__c = dropdownCollateralCodeId ;
             
             c.EB_Appraisal_County__c = dropdownCountyId ;
              c.Survey_Required_Picklist__c = dropdownSurveyId ;
            //Validate Relationship Data
            if(getRealEstateRenderStatus() == 'false'){
              c.Future_Advance_Amount__c = 0;
              c.Property_Type__c = null;
              c.Street__c = null;
              c.City__c = null;
              c.State__c = null;
              c.Zip_Code__c = null;
              //c.Valuation_Type__c = null;
              //c.Survey_Required_Picklist__c = null;
              c.Increase_to_Existing_Deed__c = false;
              c.Increase_Amount__c = 0;
              c.EB_Appraisal_County__c = null;
              c.Survey_Required_Picklist__c = null;
            }
 //   if(getRealEstateRenderStatus() == 'true' ') c.Increase_Amount__c = null; 
            if(getRealEstateRenderStatus() == 'true'){
                c.Lien_Position__c = dropdownLienId;
                c.Valuation_Type__c = dropdownValuationTypeId;
            }
  }
    
     public String getShowAppraisalEvaluationDate(){
       if(c.Valuation_Type__c == 'Use Evaluation in File' || c.Valuation_Type__c == 'Use Appraisal in File' ) return 'true';
        return 'false';
    }
  
  private void ValidateRelationshipData(){
        
    if(dropdownPurposeOfCollateralId == '0') 
      r.Purpose_of_Collateral__c = null;
    else 
      r.Purpose_of_Collateral__c = dropdownPurposeOfCollateralId;
      
    String crossedwith = getCurrentCrossedWith();
      
    if(crossedwith == null ) r.Collateral_Crossed_With__c = '';
    else
        r.Collateral_Crossed_With__c = crossedwith;
  }
  
  private Id ValidateId(String FieldName, Id Val , Boolean IsRequired){
    if(Val != null){
    }else{
      if(IsRequired == true){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation Error : ' + FieldName + ' is Required');
        ApexPages.addMessage(myMsg);
      }
    }
    return Val;
  }
  
  public Id getRecordTypeIdForName(String RecordTypeName){
        RecordType r = utility.RecordTypeObject('EB_Loan_App_Collateral_Relationship__c',RecordTypeName);
        if(r != null)
        return utility.RecordTypeObject('EB_Loan_App_Collateral_Relationship__c',RecordTypeName).Id;
        /*if(recordTypeList == null){
          this.recordTypeList = [SELECT  Name, Id FROM RecordType WHERE SobjectType =: 'EB_Loan_App_Collateral_Relationship__c'];
        }    
        if(this.recordTypeList != null){
          for (RecordType r : this.recordTypeList){
            if(r != null){
              if(r.Name == RecordTypeName) return r.Id;
            }
          }
        }
        
        */ 
        return null;
  }

    public String getQuotes(){
       return '"';
    }
  public PageReference SetSearch(){
                return null;
  }
     
}//End Class