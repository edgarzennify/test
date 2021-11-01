public  virtual class SynchronizeLoan extends ProspectToClientBaseClass{
    @TestVisible protected Id LoanAppId;
    @TestVisible protected EB_Loan_Application__c app;
    protected EB_Loan_Packet__c packet;
    @TestVisible protected List<EB_Account__c> accts;
    protected EB_Loan_App_Stage__c stage;
    @TestVisible protected EB_Booked_Loan_App__c bookedLoanapp;
    @TestVisible protected List<EB_Loan_App_Minute__c> snapshots;
    @TestVisible protected List<EB_Loan_Application_Stage_Log__c> stagelogs;
    public String getLoanApplicationName{get;set;}
    protected List<EB_Loan_App_Entity_Relationship__c> loanAppEntityRels;
    protected List<EB_Loan_App_Collateral_Relationship__c> loanAppCollateralRels;
        
    @TestVisible protected Boolean AccountMissing = false; 
    @TestVisible 
    protected void initializeHelper(){

        if(this.LoanAppId != null){
                try{                    
                    Id rectype = getRecordTypeIdForName('Account','Prospect').Id;
                    this.app = [Select Packet_Doc_Rep_ID__c,Account_Number_Guidance_Line__c, Specialize_Lending__c, Original_Credit_Requested_Date__c, Original_Withdrawn_Date__c, Booking_Rep__r.Name, Requires_Centralized_Disbursing__c ,EB_Loan_Packet__r.Number_of_Packets__c, 
                                Is_Advance_Rate_Greater_Than_policy__c, Is_Real_Estate_Advance_Gr_Than_Pol__c, Is_Real_Estate_Collateral_Crossed__c, Sum_Of_Real_Estate_Collateral_Value__c, Is_Collateral_Real_Estate__c, Possible_FIRREA__c, X364_Day_Maturity__c, Watch_List_Loan__c, 
                                Use_of_Funds__c, Use_of_Funds_Zip__c, Use_of_Funds_Street__c, Use_of_Funds_State__c, Use_of_Funds_City__c, Use_Of_Funds_Address__c, Unsecured_Loan__c, Unit__c, Total_Net_Worth__c, Total_Loan_Amount__c, Total_Liquid_Assets__c, Total_Lendable_Equity__c, 
                                Total_Exposure__c, Title_Company_Phone_Number__c, Title_Company_Name__c, Title_Company_Fax__c, Title_Company_Email__c, Title_Company_Contact__c, Title_Company_Address__c, TDR_For_Approval__c, TDR_Determination_TWo__c, TDR_Determination_One__c, TDR_Detail_Justification__c, TDR_Concession_Justification__c,
                                SystemModstamp, Stage_Explanation__c, Stage_Comment__c, Special_Instructions_to_Loan_Doc__c, ShowHOEPAFields__c, Set_App_to_New__c, Revenue_Code__c, Rejected_by_SFDC_Approval_Process__c, Refinance_Type__c, Record_Type_Description__c, RecordTypeId, 
                                Rate_Variance__c, Rate_Type__c, Rate_Subject_to_Change__c, RM__c, Purpose_of_Loan__c, Primary_Borrower__c, Prepayment_Language__c, Possible_TDR__c, Place_of_Closing__c, Payoff_Phone__c, Payoff_Loan_Number__c, Payoff_Institution__c, Payoff_Contact__c, 
                                Payment_Stream_Months__c, Payment_Stream_Equal_Maturity_Term__c, Participations_Total__c, Original_Maturity_Date__c, Occupancy__c, Number_of_Applications__c, Number_Of_payment_Streams__c, Number_Of_Collateral__c, Number_Of_Borrowers__c, Name, Mod_by_notes_for_payment_of_interest_due__c, 
                                Mod_by_adding_unpaid_interest_to_balance__c, Mod_Without_Full_Collection_of_Interest__c, Missing_Required_Fields_entities__c, Missing_Required_Fields_Packet__c, Missing_Required_Fields_Collateral__c, MayEdit, Maturity_Term_In_Months__c, Maturity_Date__c, Loan_Type__c, 
                                Loan_Number_for_Reporting__c, Loan_Number__c, Loan_Doc_Comments__c, Loan_Coordinator__c, Lead_Entity__c, Lead_Entity_With_Link__c, LastModifiedDate, LastModifiedById, LastActivityDate, Is_HOEPA_email_sent__c, Is_HOEPA__c, IsUseOfFundsValid__c, IsPurposeOfLoanToBuySecurities__c, 
                                IsOriginalLoanAmtOver500K__c, IsOriginalLoanAmtOver1M__c, IsNonAgriculturalCRA__c, IsLocked, IsLoanAmountOver500K__c, IsLoanAmountOver1M__c, IsLetterOfCredit__c, IsHOEPADetailsValid__c, IsHMDA__c, IsDeleted, IsConstructionLandDevelopment__c, IsCRA__c, IsCRADetailsValid__c, IsAgricultural__c, 
                                IsAgriculturalCRA__c, Interest_Rate_Floor__c, Interest_Rate_Ceiling__c, Index_Variance_Code__c, Increase_on_Loan_Amount__c, Id, IDLong__c, Has_Collateral__c, HasRealEstateCollateral__c, HasPurchasedParticipation__c, HasNonCommercialRealEstateCollateral__c, HasDwellingCollateral__c, 
                                HOEPA_Secured_By_Principal_Dwelling__c, HOEPA_Finance_Purchase_Or_Construction__c, HMDA_Rate_Spread__c, ELCBoard__c, EB_Loan_Packet__c, EB_Loan_Packet__r.Region__c, EB_Account_Industry_Code__c, Documentation_Rep__c, DocumentationRep__c, Disbursement_Instructions__c, Delete_Flag__c, 
                                Delete_Flag_IsSnapshotComplete__c, Current_R_E_Taxes__c, Current_Insurance__c, Credit_Rating__c, Credit_Analyst__c, CreatedDate, CreatedById, Create_Minute__c, Committee_RM_Approved__c, Committee_Date__c, Collateral_Validation__c, Collateral_Review_Comments__c, 
                                Collateral_Missing_Fields__c, Co_Borrower_Sex__c, Co_Borrower_Race__c, Co_Borrower_Ethnicity__c, Closing_Time__c, Closing_Date__c, Business_Purpose__c, Borrower_Sex__c, Borrower_Race__c, Borrower_Ethnicity__c, Bank_Owned_Loan_Amount__c, Approver_Two__c, Approver_Three__c, 
                                Approver_One__c, Approved_by_SFDC_Approval_Process__c, Approval_Requirements__c, Approval_Path__c, Application_Stage__c, Application_Stage_Sorted__c, Application_Stage_Reportable__c, Annual_Income__c, Analyst_Review_Comments__c, Account_Number__c, Account_Number_Assigned__c,
                                EB_Loan_Packet__r.Id, EB_Loan_Packet__r.RecordTypeId,  Approver_One__r.alias,Approver_Two__r.alias,Approver_Three__r.alias, Application_Stage__r.Name,Application_Stage__r.CreatedDate,  
                                Is_Loan_to_Financial_Institution__c, Is_Loan_to_Govt_Related_Entity__c, Is_repayment_reliant_on_agriculture__c, Financial_institution_accept_deposits__c, Niche_Products__c
                    ,(SELECT Id, Name, Application_Type__c,Loan_Application_ID__c, Entity_Name__r.EB_Client_Name__c,Entity_Name__r.Id, Entity_Name__r.Name FROM EB_Loan_App_Entity_Relationships__r WHERE Entity_Name__r.recordtypeid =: rectype) 
                    ,(SELECT Id, Name, EB_Collateral_ID__r.Id, EB_Collateral_ID__r.Name, EB_Collateral_ID__r.Collateral_Description__c, EB_Loan_Application_ID__c FROM EB_Loan_App_Collateral_Relationships__r WHERE EB_Collateral_ID__r.Status__c =: 'Prospective' ORDER BY EB_Collateral_ID__r.Name)
                    ,(SELECT Id, Name, Approval_Path__c,Credit_Analyst__c,Credit_Rating__c,Decision__c,Decision_Date__c,Document_Type__c,IDLong__c,Index_Rate_at_Time_of_Decision__c,Industry_Code__c,Issues__c,Lead_Entity__c,Loan_Amount__c,Loan_Doc_Comments__c,Loan_Number__c,Number_Against__c,Number_For__c,Number_of_Payment_Streams__c,Number_of_Related_Borrowers__c,Number_of_Related_Collateral__c,Number_Payment_Stream_Months__c,Post_Approval_Notes__c,Purpose__c,Rate_Index_Variance__c,Rate_Type__c,Refresh_Snapshot__c,Relationship_Manager__c,Request_Date__c,Requirements__c,Return_on_Equity__c,Signers__c,Minute_URL__c,Total_Lendable_Equity__c,Total_Liquid_Assets__c,Total_Net_Worth__c,Total_Participation_Amount__c,Type_of_Loan__c,Type_of_Snapshot__c,Unit__c,  Who_s_Against__c,Who_Abstained__c FROM EB_Loan_App_Committee_Decisions__r)
                    ,(SELECT Id, Name, EB_Loan_Application_Stage__c, Explanation__c, Stage_Text__c FROM EB_Loan_Application_Stage_Logs__r) 
                    FROM EB_Loan_Application__c WHERE id =: this.LoanAppId];
                    
                    this.packet = app.EB_Loan_Packet__r;
                    this.stage = app.Application_Stage__r ;
                    this.loanAppEntityRels = app.EB_Loan_App_Entity_Relationships__r;
                    this.loanAppCollateralRels = app.EB_Loan_App_Collateral_Relationships__r;
                    this.snapshots = app.EB_Loan_App_Committee_Decisions__r;
                    this.stagelogs = app.EB_Loan_Application_Stage_Logs__r;
                    
                    getLoanApplicationName = app.Name;
                               
                }catch(exception ex){
                        app = null;
                        getLoanApplicationName = ' error';
                       
                }
        }
    }
    @TestVisible
    protected void CreateLoanAppBooked(EB_Loan_Application__c app, EB_Account__c ebaccount, String StageText, Id ArchiveRecordTypeId){

        bookedLoanapp = new EB_Booked_Loan_App__c();
        if(ebaccount != null) bookedLoanapp.Account__c = ebaccount.id;
        
        List<EB_Loan_Application_Stage_Log__c> stagelogs = [SELECT Stage_Text__c, createddate FROM EB_Loan_Application_Stage_Log__c WHERE EB_Loan_Application__c =:app.Id and Stage_Text__c =: StageText order by createddate desc limit 1];
        
        if(stagelogs.size()> 0 ){
            Datetime dT = stagelogs[0].createddate;
            Date bookeddate = date.newinstance(dT.year(), dT.month(), dT.day()); 
            bookedLoanapp.Date_Booked__c = bookeddate ;
            
        }  
        bookedLoanapp.Loan_App_Type__c = app.Record_Type_Description__c;
        bookedLoanapp.Loan_Packet__c = app.EB_Loan_Packet__c;
        bookedLoanapp.Name = app.Name;
        bookedLoanapp.RecordTypeId = ArchiveRecordTypeId;
        
        //added 9/15
        bookedLoanapp.Annual_Income__c = app.Annual_Income__c;
        bookedLoanapp.Borrower_Ethnicity__c = app.Borrower_Ethnicity__c;
        bookedLoanapp.Borrower_Race__c = app.Borrower_Race__c;
        bookedLoanapp.Borrower_Sex__c = app.Borrower_Sex__c;
        bookedLoanapp.Closing_Date__c = app.Closing_Date__c;
        bookedLoanapp.Co_Borrower_Ethnicity__c = app.Co_Borrower_Ethnicity__c;
        bookedLoanapp.Co_Borrower_Race__c = app.Co_Borrower_Race__c;
        bookedLoanapp.Co_Borrower_Sex__c = app.Co_Borrower_Sex__c;
        bookedLoanapp.CRA_Eligible__c = app.IsCRA__c;
        try{
        
            Datetime dTcreateddate = app.createddate;
            Date loancreateddate = date.newinstance(dTcreateddate.year(), dTcreateddate.month(), dTcreateddate.day()); 
            bookedLoanapp.Loan_App_Created_Date__c = loancreateddate;
        }catch(exception ex){
            
        }
        bookedLoanapp.HMDA_Eligible__c = app.IsHMDA__c;
        bookedLoanapp.EBT_Loan_Amount__c = app.Bank_Owned_Loan_Amount__c;
        bookedLoanapp.HMDA_Rate_Spread__c = app.HMDA_Rate_Spread__c;
        bookedLoanApp.Increase_on_Loan_Amount__c = app.Increase_on_Loan_Amount__c;
        bookedLoanapp.Is_HOEPA__c = app.Is_HOEPA__c;
        bookedLoanapp.Loan_Coordinator__c = app.Loan_Coordinator__c;
        bookedLoanapp.Occupancy__c = app.Occupancy__c;
        bookedLoanapp.Revenue_Code__c = app.Revenue_Code__c;
        bookedLoanapp.Unit__c = app.Unit__c;
        bookedLoanapp.Region__c = app.EB_Loan_Packet__r.Region__c;
        bookedLoanapp.Use_of_Funds__c = app.Use_of_Funds__c;
        bookedLoanapp.Use_Of_Funds_Address__c = app.Use_Of_Funds_Address__c;
        
        //added 9/29/2011
        bookedLoanapp.Use_of_Funds_Street__c = app.Use_of_Funds_Street__c;
        bookedLoanapp.Use_of_Funds_City__c = app.Use_of_Funds_City__c;
        bookedLoanapp.Use_of_Funds_State__c = app.Use_of_Funds_State__c;
        bookedLoanapp.Use_of_Funds_Zip__c = app.Use_of_Funds_Zip__c;
        
        //added 10/5/2011
        bookedLoanapp.DocumentationRep__c = app.DocumentationRep__c;
        
        for(EB_Loan_App_Collateral_Relationship__c rel : [SELECT Id, EB_Collateral_ID__r.Lien_Position__c , EB_Collateral_ID__r.Collateral_Code__r.Collateral_Code_ID__c, Purpose_of_Collateral__c FROM EB_Loan_App_Collateral_Relationship__c WHERE EB_Loan_Application_ID__c =:app.Id and Purpose_of_Collateral__c =: 'Primary']){
            bookedLoanapp.Lien_Position__c = rel.EB_Collateral_ID__r.Lien_Position__c;
            bookedLoanapp.Primary_Collateral_Code_ID__c = rel.EB_Collateral_ID__r.Collateral_Code__r.Collateral_Code_ID__c;
        } 

        //added 05/01/2014
        bookedloanapp.Is_Loan_to_Financial_Institution__c = app.Is_Loan_to_Financial_Institution__c;
        bookedloanapp.Is_Loan_to_Govt_Related_Entity__c = app.Is_Loan_to_Govt_Related_Entity__c;
        bookedloanapp.Is_repayment_reliant_on_agriculture__c = app.Is_repayment_reliant_on_agriculture__c;
        bookedloanapp.Financial_institution_accept_deposits__c = app.Financial_institution_accept_deposits__c;
        bookedloanapp.Niche_Products__c=app.Niche_Products__c;  
        
        //added 10/26/2011          
        bookedLoanapp.Account_Number_Assigned__c = app.Account_Number_Assigned__c;
        bookedLoanapp.Account_Number__c = app.Account_Number__c;
        bookedLoanapp.Analyst_Review_Comments__c = app.Analyst_Review_Comments__c;
        List<EB_Loan_App_Stage__c> archiveStage = [Select Id, name FROM EB_Loan_App_Stage__c WHERE name =: 'Archived'];
        if(archiveStage.size() > 0){
            bookedLoanapp.Application_Stage__c  = archiveStage.get(0).id;
        }
        bookedLoanapp.Approved_by_SFDC_Approval_Process__c = app.Approved_by_SFDC_Approval_Process__c;
        bookedLoanapp.Approver_One__c = app.Approver_One__c;
        bookedLoanapp.Approver_Two__c = app.Approver_Two__c;
        bookedLoanapp.Approver_Three__c = app.Approver_Three__c;
        bookedLoanapp.Business_Purpose__c = app.Business_Purpose__c;
        bookedLoanapp.Closing_Time__c = app.Closing_Time__c;
        bookedLoanapp.Collateral_Review_Comments__c = app.Collateral_Review_Comments__c;      
        bookedLoanapp.Committee_RM_Approved__c = app.Committee_RM_Approved__c;
        bookedLoanapp.Create_Minute__c = app.Create_Minute__c;        
        bookedLoanapp.Credit_Rating__c = app.Credit_Rating__c;
        bookedLoanapp.Current_Insurance__c = app.Current_Insurance__c;
        bookedLoanapp.Current_R_E_Taxes__c = app.Current_R_E_Taxes__c;
        //bookedLoanapp.Delete_Flag__c = app.Delete_Flag__c;
        //bookedLoanapp.Delete_Flag_IsSnapshotComplete__c = app.Delete_Flag_IsSnapshotComplete__c;
        bookedLoanapp.Disbursement_Instructions__c = app.Disbursement_Instructions__c;
        bookedLoanapp.ELC_Board__c = app.ELCBoard__c;
        bookedLoanapp.Has_Collateral__c = app.Has_Collateral__c;
        bookedLoanapp.HasDwellingCollateral__c = app.HasDwellingCollateral__c;
        bookedLoanapp.HasNonCommercialRealEstateCollateral__c = app.HasNonCommercialRealEstateCollateral__c;
        bookedLoanapp.HasPurchasedParticipation__c = app.HasPurchasedParticipation__c;
        bookedLoanapp.HasRealEstateCollateral__c = app.HasRealEstateCollateral__c;
        bookedLoanapp.HOEPA_Finance_Purchase_Or_Construction__c = app.HOEPA_Finance_Purchase_Or_Construction__c;
        bookedLoanapp.HOEPA_Secured_By_Principal_Dwelling__c = app.HOEPA_Secured_By_Principal_Dwelling__c;
        bookedLoanapp.Index_Variance_Code__c = app.Index_Variance_Code__c;
        bookedLoanapp.EB_Account_Industry_Code__c = app.EB_Account_Industry_Code__c;
        bookedLoanapp.Interest_Rate_Ceiling__c = app.Interest_Rate_Ceiling__c;
        bookedLoanapp.Interest_Rate_Floor__c = app.Interest_Rate_Floor__c;
        bookedLoanapp.Is_HOEPA_email_sent__c = app.Is_HOEPA_email_sent__c;
        bookedLoanapp.Loan_Doc_Comments__c = app.Loan_Doc_Comments__c;
        bookedLoanapp.Loan_Type__c = app.Loan_Type__c;
        bookedLoanapp.Maturity_Date__c = app.Maturity_Date__c;
        bookedLoanapp.Maturity_Term_In_Months__c = app.Maturity_Term_In_Months__c;
        bookedLoanapp.Missing_Required_Fields_Collateral__c = app.Missing_Required_Fields_Collateral__c;
        bookedLoanapp.Missing_Required_Fields_Entities__c = app.Missing_Required_Fields_entities__c;
        bookedLoanapp.Mod_by_adding_unpaid_interest_to_balance__c = app.Mod_by_adding_unpaid_interest_to_balance__c;
        bookedLoanapp.Mod_by_notes_for_payment_of_interest_due__c = app.Mod_by_notes_for_payment_of_interest_due__c;
        bookedLoanapp.Mod_without_full_collection_of_interest__c = app.Mod_Without_Full_Collection_of_Interest__c;
        bookedLoanapp.Number_Of_Borrowers__c = app.Number_Of_Borrowers__c;
        bookedLoanapp.Number_Of_Collateral__c = app.Number_Of_Collateral__c;
        bookedLoanapp.Number_Of_payment_Streams__c = app.Number_Of_payment_Streams__c;
        bookedLoanapp.Participations_Total__c = app.Participations_Total__c;
        bookedLoanapp.Payment_Stream_Months__c = app.Payment_Stream_Months__c;
        bookedLoanapp.Payoff_Contact__c = app.Payoff_Contact__c;
        bookedLoanapp.Payoff_Institution__c = app.Payoff_Institution__c;
        bookedLoanapp.Payoff_Loan_Number__c = app.Payoff_Loan_Number__c;
        bookedLoanapp.Payoff_Phone__c = app.Payoff_Phone__c;
        bookedLoanapp.Place_of_Closing__c = app.Place_of_Closing__c;
        bookedLoanapp.Possible_FIRREA__c = app.Possible_FIRREA__c;
        bookedLoanapp.Prepayment_Language__c = app.Prepayment_Language__c;
        bookedLoanapp.Primary_Borrower__c = app.Primary_Borrower__c;
        bookedLoanapp.Purpose_of_Loan__c = app.Purpose_of_Loan__c;
        bookedLoanapp.Original_Maturity_Date__c = app.Original_Maturity_Date__c;
        bookedLoanapp.Rate_Index_Variance__c = app.Rate_Variance__c;
        bookedLoanapp.Rate_Subject_to_Change__c = app.Rate_Subject_to_Change__c;
        bookedLoanapp.Rate_Type__c = app.Rate_Type__c;
        bookedLoanapp.Record_Type_Description__c = app.Record_Type_Description__c;
        bookedLoanapp.Refinance_Type__c = app.Refinance_Type__c;    
        bookedLoanapp.Rejected_by_SFDC_Approval_Process__c = app.Rejected_by_SFDC_Approval_Process__c;
        bookedLoanapp.Set_App_to_New__c = app.Set_App_to_New__c;
        bookedLoanapp.Special_Instructions_to_Loan_Doc__c = app.Special_Instructions_to_Loan_Doc__c;
        bookedLoanapp.Stage_Comment__c = app.Stage_Comment__c;
        bookedLoanapp.Stage_Explanation__c = app.Stage_Explanation__c;
        bookedLoanapp.TDR_Determination_One__c = app.TDR_Determination_One__c;
        bookedLoanapp.TDR_Determination_Two__c = app.TDR_Determination_Two__c;
        bookedloanapp.TDR_Detail_Justification__c = app.TDR_Detail_Justification__c;
        bookedloanapp.TDR_Concession_Justification__c = app.TDR_Concession_Justification__c;
        bookedLoanapp.Title_Company_Address__c = app.Title_Company_Address__c;
        bookedLoanapp.Title_Company_Contact__c = app.Title_Company_Contact__c;
        bookedLoanapp.Title_Company_Email__c = app.Title_Company_Email__c;
        bookedLoanapp.Title_Company_Fax__c = app.Title_Company_Fax__c;
        bookedLoanapp.Title_Company_Name__c = app.Title_Company_Name__c;
        bookedLoanapp.Title_Company_Phone_Number__c = app.Title_Company_Phone_Number__c;
        bookedLoanapp.Total_Lendable_Equity__c = app.Total_Lendable_Equity__c;
        bookedLoanapp.Total_Liquid_Assets__c = app.Total_Liquid_Assets__c;
        bookedLoanapp.Total_Net_Worth__c = app.Total_Net_Worth__c;
        bookedLoanapp.Unsecured_Loan__c = app.Unsecured_Loan__c;
        bookedLoanapp.Watch_List_Loan__c = app.Watch_List_Loan__c;
        
        //added 06/06/2012 
        bookedLoanapp.Approval_Path_Txt__c = app.Approval_path__c;
        bookedLoanapp.Committee_Date_txt__c = app.Committee_Date__c;
        bookedLoanapp.Credit_Analyst_txt__c = app.Credit_Analyst__c;
        bookedLoanapp.Missing_Required_Fields_Packet_Txt__c = app.Missing_Required_Fields_Packet__c;
        bookedLoanapp.RM_txt__c=app.RM__c;
        bookedloanapp.Total_Exposure_Txt__c = app.Total_Exposure__c;
        bookedloanapp.Number_Of_Loan_Packets_Txt__c = app.EB_Loan_Packet__r.Number_of_Packets__c;
        bookedloanapp.Packed_Doc_Rep_Id_txt__c = app.Packet_Doc_Rep_ID__c;
        
        
        //added 11/07/2011 
        bookedLoanapp.Is_Advance_Rate_Greater_Than_policy__c = app.Is_Advance_Rate_Greater_Than_policy__c;
        bookedLoanapp.Is_Real_Estate_Advance_Gr_Than_Pol__c = app.Is_Real_Estate_Advance_Gr_Than_Pol__c;
        bookedLoanapp.Is_Real_Estate_Collateral_Crossed__c = app.Is_Real_Estate_Collateral_Crossed__c; 
        bookedLoanapp.Sum_Of_Real_Estate_Collateral_Value__c = app.Sum_Of_Real_Estate_Collateral_Value__c;
        bookedLoanapp.Is_Collateral_Real_Estate__c = app.Is_Collateral_Real_Estate__c; 
        
        //added 07/03/2012
        bookedLoanapp.Booking_Rep__c=app.Booking_Rep__r.Name;
        //added 07/12/2012 & 08/16/2012
        bookedLoanapp.Requires_Centralized_Disbursing__c=app.Requires_Centralized_Disbursing__c;
        bookedLoanapp.Specialize_Lending__c=app.Specialize_Lending__c;
        
        //added 10/3/2012
        bookedLoanapp.Account_Number_Guidance_Line__c = app.Account_Number_Guidance_Line__c;
        //added 10/09/2012
        bookedLoanapp.Original_Credit_Requested_Date__c=app.Original_Credit_Requested_Date__c;
        bookedLoanapp.Original_Withdrawn_Date__c=app.Original_Withdrawn_Date__c;
        
        insert bookedLoanapp;
        
        //added 02/03/2012 :Next two lines of code is required to fire update trigger on Archived Loan Object.
        bookedLoanapp.Is_Collateral_Real_Estate__c = app.Is_Collateral_Real_Estate__c; 
        update bookedLoanapp;

        
        
    }
    @TestVisible
    protected void RewireLoanStageLogs(EB_Booked_Loan_App__c bookedLoanapp,List<EB_Loan_Application_Stage_Log__c> stagelogs){
        
        List<EB_Loan_Application_Stage_Log__c> updateList = new List<EB_Loan_Application_Stage_Log__c>();
        for(EB_Loan_Application_Stage_Log__c l : stagelogs){
            l.EB_Booked_Loan_App__c = bookedLoanapp.id;
            updateList.add(l);
        }
        if(updateList.size() > 0) update updateList;
    }
    @TestVisible
     protected void RewireLoanStageLogs(EB_Booked_Loan_App__c bookedLoanapp){

        List<EB_Loan_Application_Stage_Log__c> stagelogs = [SELECT id,EB_Loan_Application__c,EB_Booked_Loan_App__c FROM EB_Loan_Application_Stage_Log__c WHERE EB_Loan_Application__c =:app.id ];
        
        List<EB_Loan_Application_Stage_Log__c> updateList = new List<EB_Loan_Application_Stage_Log__c>();

        for(EB_Loan_Application_Stage_Log__c l : stagelogs){
            l.EB_Booked_Loan_App__c = bookedLoanapp.id;
            updateList.add(l);
        }

        if(updateList.size() > 0) update updateList;
        
    }
    @TestVisible
    protected void RewireLoanSnapshots(EB_Booked_Loan_App__c bookedLoanapp, List<EB_Loan_App_Minute__c> snapshots){
        List<EB_Loan_App_Minute__c> updateList = new List<EB_Loan_App_Minute__c>();
        for(EB_Loan_App_Minute__c s : snapshots){
            s.Booked_Loan_Application__c = bookedLoanapp.Id;
            updateList.add( s);
        }
        if(updateList.size() > 0) update updateList;
        
    }
    @TestVisible//Added JB 05/22/2013 -- BEGIN
    protected void RewireAgreements(EB_Loan_Application__c app,EB_Account__c ebaccount){
    	List<Agreement_Loan_Application_Relationship__c> deleteList = [SELECT Id, Name, Agreement__c, EB_Loan_Application__c FROM Agreement_Loan_Application_Relationship__c WHERE Loan_Application__c =: app.Id ];
    	List<Agreement_EB_Account_Relationship__c> insertList = new List<Agreement_EB_Account_Relationship__c>(); 
    	
    	if(deleteList.size() > 0){
	    	for(Agreement_Loan_Application_Relationship__c loanAppRel : deleteList){
	    		Agreement_EB_Account_Relationship__c newEbAccount = new Agreement_EB_Account_Relationship__c();
	    		newEbAccount.Agreement__c = loanAppRel.Agreement__c;
	    		newEbAccount.Loan_Account__c = ebaccount.Id;
	    		insertList.add(newEbAccount);
	    	}
	    	
	    	if(insertList.size() > 0){ insert insertList;}
	    	delete deleteList;
    	}

    }
    @TestVisible
    protected void updateAgreementClientRelationships(Account prospect,Account client){

     	List<Agreement__c> updatedAgreements = new List<Agreement__c>();
     	List<Agreement_Client_Relationships__c> agreementClientRels = [SELECT Id, Name, Agreement__c, Entity__c FROM Agreement_Client_Relationships__c WHERE Entity__c =: prospect.Id ];
     	List<Agreement_Client_Relationships__c> updateAgreementClientRels = new List<Agreement_Client_Relationships__c>();
     	Map<Id,Id> loanAgreements = new Map<Id,Id> ();

     	for(Agreement_Client_Relationships__c agreeClientRel : agreementClientRels){
     		loanAgreements.put(agreeClientRel.Agreement__c,agreeClientRel.Agreement__c);
     		agreeClientRel.Entity__c = client.Id;
     		updateAgreementClientRels.add(agreeClientRel);
     	}
     	
     	for( Agreement__c agreemnt : [SELECT Id, Name, Borrower_Name__c,Agreement_Status__c FROM Agreement__c WHERE Id in: loanAgreements.keyset()]){
     		if(agreemnt.Borrower_Name__c == prospect.Id){
				agreemnt.Borrower_Name__c = client.Id;
				agreemnt.Agreement_Status__c = 'Approved';
				updatedAgreements.add(agreemnt);     			
     		}
     	}
     	
     	if(updatedAgreements.size() > 0){update updatedAgreements;}
     	if(updateAgreementClientRels.size() > 0){update updateAgreementClientRels;}
     	
    
    }
    @TestVisible//Added JB 05/22/2013 -- END
    protected void CreateNewSnapshot(EB_Account__c ebaccount, EB_Loan_Application__c app, EB_Booked_Loan_App__c bookedLoanapp , String typeOfSnapshot, String snapshotRecordtypeName){
            //try{
                    EB_Loan_App_Minute__c snpshot = new EB_Loan_App_Minute__c();
                    

                    snpshot.Booked_Loan_Application__c = bookedLoanapp.Id;
                    snpshot.EB_Loan_Application__c = app.id;
                    snpshot.Type_of_Snapshot__c = typeOfSnapshot ; //'Booked Snapshot';
                    
                    RecordType rectype = utility.RecordTypeObject('EB_Loan_Application__c', app.RecordTypeId);
                    if( rectype != null) snpshot.Document_Type__c = rectype.Name;
                    		
                    if(ebaccount != null) snpshot.Loan_Number__c = ebaccount.Name; 
                    snpshot.Relationship_Manager__c = app.RM__c;
                    snpshot.Request_Date__c = app.CreatedDate;
                    snpshot.Credit_Analyst__c = app.Credit_Analyst__c;
                    Datetime dT = System.now();
                    Date d = date.newinstance(dT.year(), dT.month(), dT.day()); 
                        
                    snpshot.Decision_Date__c = d;
                    snpshot.Original_Maturity_Date__c = app.Original_Maturity_Date__c;
                    snpshot.Maturity_Date__c = app.Maturity_Date__c;
                    snpshot.Unit__c = app.Unit__c;
                    snpshot.Lead_Entity__c = app.Lead_Entity__c;
                    snpshot.Rate_Type__c = app.Rate_Type__c;
                    snpshot.Type_of_Loan__c = app.Loan_Type__c;
                    snpshot.Loan_Amount__c = app.Total_Loan_Amount__c;
                    snpshot.Rate_Index_Variance__c = app.Rate_Variance__c;
                    snpshot.Credit_Rating__c = app.Credit_Rating__c;                   
                    snpshot.Total_Lendable_Equity__c = app.Total_Lendable_Equity__c;
                    snpshot.Total_Liquid_Assets__c = app.Total_Liquid_Assets__c;
                    snpshot.Total_Participation_Amount__c = app.Participations_Total__c;
                    snpshot.Total_Net_Worth__c = app.Total_Net_Worth__c;
                    
                    snpshot.Number_Payment_Stream_Months__c = app.Payment_Stream_Months__c;

                    
                    RecordType signerrtype =  this.getRecordTypeIdForName('EB_Loan_App_Minute__c', snapshotRecordtypeName); //'Booked');
                    snpshot.RecordTypeId = signerrtype.Id;
                    

                    insert snpshot;
                    CallSDFCServiceURL(snpshot.Id, app.ID);
           // }catch(exception ex){
                
           // }
                
    }
    @future(callout=true)
    public static void CallSDFCServiceURL(String  idlong1, String idlong2){
            if(!Test.isRunningTest())Restutility.GenerateArchivedLoanApplicationSnapshot(idlong1, idlong2);
            
    }
    @TestVisible
    protected void RewireNotesAndAttachments( EB_Loan_Application__c app, EB_Booked_Loan_App__c bookedLoanapp){
        this.updateAttachments(bookedLoanapp.Id, app.Id);
    }
    @TestVisible
    protected void RewireTasks(EB_Loan_Application__c app, EB_Booked_Loan_App__c bookedapp){
        for(List<Task> tasks : [SELECT ID, WhatId FROM Task WHERE WhatId =: app.Id]){
            for(Task t : tasks){
                t.WhatId = bookedapp.Id;
            }
            update tasks;
        }
    }
    @TestVisible
    protected  void ArchiveLoanPacket(EB_Loan_Packet__c packet){      
           
        Boolean checkIfPackedNeedToArchive = false;
        integer TotalApps = 0;
        integer TotalWithdrawns = 0;
        integer TotalArchived = 0;
        integer TotalActiveApps = 0;
       
        for(EB_Loan_Application__c loanapp : [Select  id, Name , Application_stage__r.Name FROM EB_Loan_Application__c where EB_Loan_Packet__c =:packet.id]){           
            
            if(loanapp.id != app.id){
                
                TotalApps = TotalApps + 1;
                
                if(loanapp.Application_stage__r.Name == 'Withdrawn' )
                    TotalWithdrawns = TotalWithdrawns + 1;
                else if(  loanapp.Application_stage__r.Name == 'Archived' )
                    TotalArchived = TotalArchived + 1;
                else{}          
                            
            }
        }
        
       
        if(TotalApps == TotalWithdrawns + TotalArchived  )
        checkIfPackedNeedToArchive = true;
       
        if(checkIfPackedNeedToArchive == true) {
            RecordType archivedType =  getRecordTypeIdForName('EB_Loan_Packet__c','Archived');
            packet.RecordTypeId = archivedType.Id;
            update packet;

        }

    } 

}