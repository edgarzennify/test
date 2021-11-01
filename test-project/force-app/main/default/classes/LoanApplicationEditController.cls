public with sharing class LoanApplicationEditController {
    String url = '';
    public EB_Loan_Application__c loan{get;set;}
    public ApexPages.standardcontroller Controller {get;set;}
    List<RecordType> recordTypeList = null;
    public String err{get;set;}
    
    private Id RecordTypeNewForLoanApp{get;set;}
    private Id RecordTypeNewForGuidanceLoanApp{get;set;}
    public Map<String,RecordType> RenewalMap{
        get{
            if(RenewalMap == null){
                RenewalMap = new Map<String,RecordType>();
                for(RecordType r : Utility.recordTypeObjects('EB_Loan_Application__c')){
                    if(r.name.tolowercase().contains('modifi') == true || r.name.tolowercase().contains('renewal') == true)
                    RenewalMap.put(r.name,r);
                    system.debug('####RenewalMap ' + r.name);
                    if(r.name.tolowercase()== 'new') RecordTypeNewForLoanApp = r.id;
                    if(r.name.tolowercase() == utility.NewGuidanceLineAdvance().tolowercase()) RecordTypeNewForGuidanceLoanApp = r.id;
                }
            } 
            return RenewalMap;
        }
        set;
    }
    public Map<Id,RecordType> RenewalMapWithIdAsKey{
        get{
            if(RenewalMapWithIdAsKey == null){
                RenewalMapWithIdAsKey = new Map<Id,RecordType>();
                List<RecordType> recList = RenewalMap.values();
                for(RecordType r : recList){
                         RenewalMapWithIdAsKey.put(r.Id,r);
                         system.debug('####RenewalMapWithIdAsKey ' + r.name);
                }
            } 
            return RenewalMapWithIdAsKey;
        }
        set;
    }
    public String Locked{
        get{
            if(loan.id == null) locked = 'false';
            return Locked;
        }
        set;
    }
    //Specific to Letter Of Credit Loan Numbers supplied by Internaltional Dept
    public String HasPermissionToEditLoanNumber{
        get{
	        Profile pr = [select name from Profile where id =: UserInfo.getProfileId()];
	        if(pr.Name == 'System Administrator' || pr.Name == 'Data Administrator') return 'true';
	        //Put Permissionset SOQLs here.
	        List<PermissionSet> permissionsetList = [select id from PermissionSet where Label=:'Function - Generate Loan Account Numbers'];
	                if(permissionsetList.size()>0){
	                        List<PermissionSetAssignment> permissionsetassignList  = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() and PermissionSetId = :permissionsetList.get(0).id];
	                if(permissionsetassignList.size()> 0 && (loan.Record_Type_Description__c == utility.NewGuidanceLineAdvance() || loan.Loan_Type__c == utility.LoanTypeGuidanceLine() || loan.Loan_Type__c == utility.LoanTypeGuidanceLineFixed() || loan.Loan_Type__c == utility.LoanTypeGuidanceLineRevolving() ||loan.Loan_Type__c == 'Letter of Credit' ||loan.Loan_Type__c == 'SBA 504' ||loan.Loan_Type__c == 'SBA 7a')) return 'true';
	                }
            return 'false';
        }

    }
    public Boolean HasPermissionToEditLockedApplication{
        get{
            Profile pr = [select name from Profile where id =: UserInfo.getProfileId()];
            if(pr.Name == 'System Administrator' || pr.Name == 'Data Administrator') return true;
            //Put Permissionset SOQLs here.
            List<PermissionSet> permissionsetList = [select id from PermissionSet where Label=:'Role - Loan Documentation'];
                    if(permissionsetList.size()>0){
                            List<PermissionSetAssignment> permissionsetassignList  = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() and PermissionSetId = :permissionsetList.get(0).id];
                    if(permissionsetassignList.size()> 0)  return true;
                    }
            return false ;
        }

    }
   
    public LoanApplicationEditController(ApexPages.StandardController stdcontroller) {
            Locked = 'false';
            if(url == '') url = getServerUrl();
            try{
                String loanId =  apexpages.currentpage().getparameters().get('id');
                
                loan = [
                    SELECT 
                        e.Specialize_Lending__c,e.Account_Number_Guidance_Line__r.Maturity_Date__c,e.Account_Number_Guidance_Line__c
                        ,e.Account_Number_Guidance_Line__r.Available_Balance__c,e.NAICS_Code__c ,e.ShowHOEPAFields__c 
                        ,e.Loan_Type_For_Number_Generation__c,e.Loan_Doc_Comments__c,e.Use_of_Funds_Street__c,e.Use_of_Funds_City__c
                        ,e.Use_of_Funds_State__c,e.Use_of_Funds_Zip__c,e.HMDA_Rate_Spread__c,e.HOEPA_Finance_Purchase_Or_Construction__c
                        ,e.HOEPA_Secured_By_Principal_Dwelling__c,e.X364_Day_Maturity__c,e.Watch_List_Loan__c,e.Use_of_Funds__c
                        ,e.Use_Of_Funds_Address__c,e.Unsecured_Loan__c,e.Unit__c,e.Total_Net_Worth__c,e.Total_Loan_Amount__c
                        ,e.Total_Liquid_Assets__c,e.Total_Lendable_Equity__c,e.Total_Exposure__c,e.Title_Company_Phone_Number__c
                        ,e.Title_Company_Name__c,e.Title_Company_Fax__c,e.Title_Company_Email__c,e.Title_Company_Contact__c
                        ,e.Title_Company_Address__c,e.TDR_For_Approval__c,e.TDR_Determination_TWo__c,e.TDR_Determination_One__c,e.SystemModstamp
                        ,e.Stage_Explanation__c, e.Special_Instructions_to_Loan_Doc__c, e.Set_App_to_New__c, e.Revenue_Code__c
                        ,e.Rejected_by_SFDC_Approval_Process__c, e.Refinance_Type__c, e.Record_Type_Description__c, e.RecordTypeId
                        ,e.Rate_Variance__c, e.Rate_Type__c, e.Rate_Subject_to_Change__c, e.RM__c, e.Purpose_of_Loan__c, e.Prepayment_Language__c
                        ,e.Possible_TDR__c, e.Place_of_Closing__c, e.Payoff_Phone__c, e.Payoff_Loan_Number__c, e.Payoff_Institution__c
                        ,e.Payoff_Contact__c, e.Payment_Stream_Months__c, e.Payment_Stream_Equal_Maturity_Term__c, e.Participations_Total__c
                        ,e.Original_Maturity_Date__c, e.Occupancy__c, e.Number_Of_payment_Streams__c, e.Number_Of_Collateral__c
                        ,e.Number_Of_Borrowers__c, e.Name, e.Mod_by_notes_for_payment_of_interest_due__c
                        ,e.Mod_by_adding_unpaid_interest_to_balance__c, e.Mod_Without_Full_Collection_of_Interest__c
                        ,e.Missing_Required_Fields_entities__c, e.Missing_Required_Fields_Collateral__c, e.MayEdit
                        ,e.Maturity_Term_In_Months__c, e.Maturity_Date__c, e.Loan_Type__c, e.Loan_Number_for_Reporting__c
                        ,e.Loan_Number__c,  e.Loan_Coordinator__c, e.Lead_Entity__c, e.Lead_Entity_With_Link__c, e.LastModifiedDate
                        ,e.LastModifiedById, e.LastActivityDate, e.IsPurposeOfLoanToBuySecurities__c, e.IsOriginalLoanAmtOver500K__c
                        ,e.IsOriginalLoanAmtOver1M__c, e.IsNonAgriculturalCRA__c, e.IsLocked, e.IsLoanAmountOver500K__c, e.IsLoanAmountOver1M__c
                        ,e.IsLetterOfCredit__c, e.IsHMDA__c, e.IsDeleted, e.IsConstructionLandDevelopment__c, e.IsCRA__c, e.IsAgricultural__c
                        ,e.IsAgriculturalCRA__c, e.Interest_Rate_Floor__c, e.Interest_Rate_Ceiling__c, e.Index_Variance_Code__c, e.Id, e.IDLong__c
                        ,e.Has_Collateral__c, e.HasRealEstateCollateral__c, e.HasPurchasedParticipation__c
                        ,e.HasNonCommercialRealEstateCollateral__c, e.HasDwellingCollateral__c, e.ELCBoard__c, e.EB_Loan_Packet__c
                        ,e.EB_Account_Industry_Code__c, e.DocumentationRep__c, e.Disbursement_Instructions__c, e.Delete_Flag__c
                        ,e.Delete_Flag_IsSnapshotComplete__c, e.Current_R_E_Taxes__c, e.Current_Insurance__c,e.Credit_Rating__c
                        ,e.Credit_Analyst__c, e.CreatedDate, e.CreatedById, e.Committee_RM_Approved__c, e.Committee_Date__c
                        ,e.Collateral_Validation__c, e.Collateral_Review_Comments__c, e.Collateral_Missing_Fields__c, e.Co_Borrower_Sex__c
                        ,e.Co_Borrower_Race__c, e.Co_Borrower_Ethnicity__c, e.Closing_Time__c, e.Closing_Date__c, e.Business_Purpose__c
                        ,e.Borrower_Sex__c, e.Borrower_Race__c, e.Borrower_Ethnicity__c, e.Bank_Owned_Loan_Amount__c, e.Approver_Two__c
                        ,e.Approver_Three__c, e.Approver_One__c, e.Approved_by_SFDC_Approval_Process__c, e.Approval_Requirements__c
                        ,e.Approval_Path__c, e.Application_Stage__c, e.Application_Stage_Reportable__c, e.Annual_Income__c
                        ,e.Analyst_Review_Comments__c, e.Account_Number__c, e.Account_Number_Assigned__c, e.Fee_Waived__c, e.Fees_Waived_Comment__c
                        ,e.Original_Credit_Requested_Date__c, e.Is_Loan_to_Govt_Related_Entity__c, e.Is_Loan_to_Financial_Institution__c 
                        ,e.Financial_institution_accept_deposits__c, e.Is_repayment_reliant_on_agriculture__c, e.Niche_Products__c
                    FROM
                        EB_Loan_Application__c e 
                    WHERE 
                        e.Id =: loanId
                ];
                if(this.getIsRenewal() == 'true')  this.dropdownRecordTypeId = loan.RecordTypeId;
            }catch(exception ex){
               loan = new EB_Loan_Application__c();
            }
               
           if(loan.EB_Loan_Packet__c == null){
                      EB_Loan_Application__c stdControllerLoan = (EB_Loan_Application__c)stdController.getRecord();
                      if(stdControllerLoan.EB_Loan_Packet__c != null) loan.EB_Loan_Packet__c = stdControllerLoan.EB_Loan_Packet__c;  
           }
                        
           dropdownRecordTypeId = loan.RecordTypeId;
    }
    public String dropdownRecordTypeId{get;set;}
    public List<SelectOption> getRecordTypes(){
	        List<SelectOption> options = new List<SelectOption>();
	        RenewalLoanCount rcount = renewalCount();       
            Schema.Describefieldresult fieldResult = EB_Loan_Application__c.RecordTypeId.getDescribe();
                 List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
                       if(rcount.RenewalCount == 0){
                           for(RecordType r : RenewalMap.values()){
                                        if(r.name != 'Admin renewal')options.add(new SelectOption(r.id,r.name));
                           }
                           if(loan.recordtypeid == RecordTypeNewForGuidanceLoanApp) options.add(new SelectOption(RecordTypeNewForGuidanceLoanApp, utility.NewGuidanceLineAdvance()));
                           else options.add(new SelectOption(RecordTypeNewForLoanApp, 'New'));
                       }
                       if(rcount.RenewalCount == 1 && RenewalMapWithIdAsKey.containskey(loan.recordtypeId) && RenewalMapWithIdAsKey.get(loan.recordtypeId).Name != 'Admin Renewal' ){
                                   for(RecordType r : RenewalMap.values()){
                                        if(r.name != 'Admin renewal') options.add(new SelectOption(r.id,r.name));
                           }
                           if(loan.recordtypeid == RecordTypeNewForGuidanceLoanApp) options.add(new SelectOption(RecordTypeNewForGuidanceLoanApp, utility.NewGuidanceLineAdvance()));
                           else options.add(new SelectOption(RecordTypeNewForLoanApp, 'New'));
                       }
                       if(rcount.RenewalCount == 0 && rcount.AdminRenewalCount == 1){

                                options.add(new SelectOption(renewalmap.get('Admin Renewal').id, 'Admin Renewal'));
                       }
                       if(rcount.AdminRenewalCount == 0){

                                options.add(new SelectOption(renewalmap.get('Admin Renewal').id, 'Admin Renewal'));
                       }
                       if(rcount.RenewalCount == 1 && rcount.AdminRenewalCount == 1){
                                                                if(loan.recordtypeid == RecordTypeNewForGuidanceLoanApp) options.add(new SelectOption(RecordTypeNewForGuidanceLoanApp, utility.NewGuidanceLineAdvance()));
                                        else options.add(new SelectOption(RecordTypeNewForLoanApp, 'New'));
                                                        
                                options.add(new SelectOption(renewalmap.get('Admin Renewal').id, 'Admin Renewal'));
                       }
                       
          return sortSelectOptions(options);
    }
    public List<SelectOption> sortSelectOptions(List<SelectOption> sortingList) {
        for (Integer i =0; i < sortingList.size(); i++) {
            for (Integer j = i; j > 0; j--) {
                if (sortingList[j-1].getLabel() > sortingList[j].getLabel()){
                    SelectOption temp = sortingList[j];
                    sortingList[j] = sortingList[j-1];
                    sortingList[j-1] = temp;
                }
            }
        }
        return sortingList;
    }
    
    public String getRecordtypeStatus(){
        if(getIsRenewal() == 'false' || getRecordTypes().size() == 0) return 'false';
        return 'true';
    }
   
    public String getIsRenewal(){
        if(RenewalMapWithIdAsKey.containskey(loan.recordtypeId) ) return 'true';
        return 'false';
    }
    public String getIsHoepaRequired(){
       return loan.ShowHOEPAFields__c;
       
    }
    public class RenewalLoanCount{
        Integer RenewalCount;
        Integer AdminRenewalCount;
    }
    @TestVisible
    private RenewalLoanCount renewalCount(){
         RenewalLoanCount rcount = new RenewalLoanCount();
             rcount.RenewalCount = 0;
             rcount.AdminRenewalCount = 0;
             
         Map<String, EB_Loan_App_Stage__c> stageMap = new  Map<String, EB_Loan_App_Stage__c>();
         for(EB_Loan_App_Stage__c stage : [Select Name, Id From EB_Loan_App_Stage__c WHERE Name =: 'Withdrawn' or Name =: 'Booking Complete' or Name =: 'Archived']){
                stageMap.put(stage.Name , stage);
         }
         
         Map<Id,RecordType> recMap = new Map<Id,RecordType>();
         for(RecordType r : renewalMap.values()){
                if(r.Name != 'Admin Renewal') recMap.put(r.Id, r);                       
         }
         try{
                 for(EB_Loan_Application__c  l : [SELECT Id, Name  FROM EB_Loan_Application__c WHERE Account_Number__c =: loan.Account_Number__c and Application_Stage__c !=:  stageMap.get('Withdrawn').Id and Application_Stage__c !=:  stageMap.get('Booking Complete').Id and Application_Stage__c !=:  stageMap.get('Archived').Id and RecordtypeId in : recMap.KeySet() ]){
                        rcount.RenewalCount = rcount.RenewalCount + 1;
                        
                 }
                 
                 for(EB_Loan_Application__c l : [SELECT Id, Name  FROM EB_Loan_Application__c WHERE Account_Number__c =: loan.Account_Number__c and Application_Stage__c !=:  stageMap.get('Withdrawn').Id and Application_Stage__c !=:  stageMap.get('Booking Complete').Id and Application_Stage__c !=:  stageMap.get('Archived').Id and recordtypeid =: renewalMap.get('Admin Renewal').Id ]){
                         rcount.AdminRenewalCount = rcount.AdminRenewalCount + 1;
                        
                 }
                 
       }catch(exception ex){
            
       }
       return rcount;
   }
   @TestVisible
   private RecordType getRecordTypeId( String RecordTypeName){         
                
                if(recordTypeList == null)
                recordTypeList  = [SELECT Name, Id FROM RecordType WHERE SObjectType =: 'EB_Loan_Application__c'  ];

                        for (RecordType r : recordTypeList){
                                if(r != null){
                                        
                                        if(r.Name == RecordTypeName) return r;
                                }       
                        }
                
                return null;
    }
    @TestVisible
    private Boolean IsGLAdvanceAmountValid{
        get{
                decimal TotalGLAvailability = loan.Account_Number_Guidance_Line__r.Available_Balance__c;
                decimal TotalGuidanceAdvance = 0;
                for(EB_Loan_Application__c l : [SELECT Bank_Owned_Loan_Amount__c FROM EB_Loan_Application__c WHERE Account_Number_Guidance_Line__c =: loan.Account_Number_Guidance_Line__c  ]){
                        if(l.id != loan.id){
                                decimal loanamount = 0;
                                if(l.Bank_Owned_Loan_Amount__c == null) loanamount = 0; else loanamount = l.Bank_Owned_Loan_Amount__c;
                                TotalGuidanceAdvance = TotalGuidanceAdvance + loanamount;
                        }
                }
                decimal BankOwnedBalance = loan.Bank_Owned_Loan_Amount__c;
                if(BankOwnedBalance == null) BankOwnedBalance = 0;
                TotalGuidanceAdvance = TotalGuidanceAdvance +  BankOwnedBalance;                  
                return TotalGuidanceAdvance  <= TotalGLAvailability;
        }
    }
    @TestVisible
    private Boolean IsGLAdvanceClosingDateValid{
        get{
                
                if(loan.Record_Type_Description__c.tolowercase().contains('documentation') && (loan.Closing_Date__c > loan.Account_Number_Guidance_Line__r.Maturity_Date__c)) return false;
                return true;
        }
    }
    public PageReference SaveClicked(){
        try{
                
                    
                if(this.getIsRenewal() == 'true'){
                        if(dropdownRecordTypeId == RecordTypeNewForLoanApp || dropdownRecordTypeId == RecordTypeNewForGuidanceLoanApp )loan.Account_Number__c = null;
                        loan.RecordTypeId = this.dropdownRecordTypeId;
                        
                }
                if(loan.recordtypeid == RecordTypeNewForGuidanceLoanApp && !IsGLAdvanceAmountValid ) {
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation error(EBT Loan Amount): Advance amount is greater than Guidance Line Availability ' );
                        ApexPages.addMessage(myMsg);
                }else if(loan.recordtypeid == RecordTypeNewForGuidanceLoanApp && !IsGLAdvanceClosingDateValid){
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation error: Guidance Line loan advance Maturity date is greater than Guidance Line Closing Date ' );
                        ApexPages.addMessage(myMsg);
                }
                else{       
                        if(loan.id == null){
                        insert loan;
                        }else update loan;
                        controller = new ApexPages.standardController(loan);
                        return Controller.view();
                }
                
                
        }catch(exception ex){
                // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation error: ' + ex.getmessage());
           //  ApexPages.addMessage(myMsg); 
        }
        return null;
        
        
    }
    public PageReference QuickSaveClicked(){
        try{
            if(this.getIsRenewal() == 'true'){
                            if(dropdownRecordTypeId == RecordTypeNewForLoanApp || dropdownRecordTypeId == RecordTypeNewForGuidanceLoanApp)loan.Account_Number__c = null;
                            loan.RecordTypeId = this.dropdownRecordTypeId;
                            
            }
            if(loan.recordtypeid == RecordTypeNewForGuidanceLoanApp && !IsGLAdvanceAmountValid ) {
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation error(EBT Loan Amount): Advance amount is greater than Guidance Line Availability' );
                   ApexPages.addMessage(myMsg);
            }else if(loan.recordtypeid == RecordTypeNewForGuidanceLoanApp && !IsGLAdvanceClosingDateValid){
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation error: Guidance Line loan advance Maturity date is greater than Guidance Line Closing Date ' );
                   ApexPages.addMessage(myMsg);
            }
            else{ 
                    if(loan.id == null){
                    insert loan;
                    }else update loan;
            }
        }catch(exception ex){
                // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Validation error: ' + ex.getmessage());
            // ApexPages.addMessage(myMsg);
        }
    
        
        return null;
        
        
    }
     public PageReference CancelClicked(){
         if(loan.id == null) {
            try{
                    
	              String newPageUrl = this.url  + 'a0m';
	              PageReference newPage = new PageReference(newPageUrl);
	              newPage.setRedirect(true);
	              return newPage;
                    
             }catch(exception ex){
                    
             }
                
         }
         controller = new ApexPages.standardController(loan);
         return Controller.view();
        
        
    }
    public PageReference CheckLocked(){
        try{
           update loan;
        }catch(exception ex){
           Locked = 'true';
                 
        }
        return null;
    }
    @TestVisible
    private static String  getServerUrl(){
                                        
          return utility.getServerUrl() + '/';
    }
}