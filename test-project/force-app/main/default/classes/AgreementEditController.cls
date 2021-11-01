public with sharing class AgreementEditController {
  String url = Utility.getServerUrl() + '/';
  public ApexPages.standardcontroller Controller {get;set;}
  public String err{get;set;}
  public String PrimaryBorrowerName{get;set;}
  public Agreement__c agmt{get;set;}
  String agmtId = '';
  public Id newAgreementId {get;set;}
  PageReference thisPage = null;
  public List<Agreement__c> listAgmt {get; set;}
  public String dropdownRecordTypeId{get;set;}
  public Boolean test{get;set;}
  private String LoanAppId{get;set;}
  private String LlcBiLoanId{get;set;}
  public string dropdownBusinessDocumentsId{get;set;}
  public string dropdownGuaranteeDocumentsId{get;set;}
  public string dropdownSubordinationDocumentsId{get;set;}
  public string dropdownLoanDocumentsPreparedById{get;set;}
  public Id PendingStatusId{
      get{
          return Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
      }
  }
  private Agreements.IAgreementApprovalInfo m_agreementApprovalInfo;
  private Agreements.IAgreementValidator m_agreementValidator;
  private Agreements.IAgreementPicker m_agreementPicker;
  private Agreements.IAgreementStatusManager m_agreementStatusManager;
  
  public AgreementEditController(ApexPages.StandardController stdController) {  
      if(thisPage==null) thisPage = apexpages.currentpage();
      try{
          agmtId =  apexpages.currentpage().getparameters().get('id');
          m_agreementApprovalInfo = new AgreementApprovalInfo();
          m_agreementValidator = AgreementValidator.getInstance();
          m_agreementpicker = new AgreementPicker(new AgreementPickerDataProvider());
          m_agreementStatusManager = new AgreementStatusManager(new UserInfoService(Configurations.bootstrap(), new UserInfoServiceDataProv()), new AgreementEntityManager(new AgreementEntityManagerDataProvider()), new AgreementStatusManagerDataProvider());
          
          if(agmtId == '' || agmtid == null){
              agmt = new Agreement__c();
          }else{               
              agmt = [SELECT 
                          a.Name,
                          a.Borrower_Name__c,
                          a.Borrower__c,
                          a.Comments__c,
                          a.Agreement_Date__c,
                          a.Primary_Borrower__c, 
                          a.Last_Amendment_Date__c,
                          a.Approval_Status__c,
                          a.Status__c,
                          a.Approver_One__c, 
                          a.Approver_Two__c,
                          a.Approver_Three__c,
                          a.Actual_Approval_Process__c,
                          a.RecordType.Name,
                          a.RecordTypeId, 
                          a.Stage__c,
                          a.Credit_Analyst__c,
                          a.Booking_Rep__c,
                          a.Checkback_Rep__c,
                          a.File_Review_Rep__c,
                          a.Image_Prep_Rep__c,
                          a.Shred_File_Rep__c,
                          a.DocumentationRep__c,
                          a.Loan_Coordinator__c,
                          a.Source_Agreement__c,
                          a.RecordTypeDescription__c,
                          a.Business_Loan_Agreement_Documents__c,
                          a.Guarantee_Agreement_Documents__c,
                          a.Subordination_Intercreditor_Documents__c,
                          a.Loan_Documents_Prepared_By__c,
                          a.Law_Firm__c,
                          a.Stage__r.Name,
                          Stage__r.Loan_App_Stage_Action_Controller__r.Name
                      FROM Agreement__c a 
                      WHERE a.Id =: agmtId];
          }
      }catch(exception ex){
          agmt = null;
      }
      LoanAppId =  apexpages.currentpage().getparameters().get('lid');
      LlcBiLoanId =  apexpages.currentpage().getparameters().get('llcid');
      setDefaultValueToFields();  
  }

  public AgreementEditController(Agreements.IAgreementApprovalInfo approvalInfo, Agreements.IAgreementValidator validator, Agreements.IAgreementPicker picker, Agreements.IAgreementStatusManager statusManager){
      m_agreementApprovalInfo = approvalInfo;
      m_agreementValidator = validator;
      m_agreementpicker = picker;
      m_agreementStatusManager = statusManager;
  }
    
    private void setDefaultValueToFields(){
        if(agmt != null){
            if(String.IsBlank(agmt.Business_Loan_Agreement_Documents__c)){
                agmt.Business_Loan_Agreement_Documents__c = 'N/A';
                agmt.Guarantee_Agreement_Documents__c = 'N/A';
                agmt.Subordination_Intercreditor_Documents__c = 'N/A';
                agmt.Loan_Documents_Prepared_By__c = 'N/A';
            }
        }
    }

  public boolean canEditAgreement{
    get{
        return m_agreementStatusManager.isAgreementEditable(agmt,UserInfo.getUserId());
    }   
  }
    
  public Boolean IsUpdate{
      get{
          if(agmt <> null && agmt.Id <> null) return true;
          return false;
      }
  }

  public String BorrowerName{
    get{ return agmt.Borrower__c ;}
  }
  
  public Agreement__c getAgreementmt() {
    return agmt;
  }

  public Boolean IsActiveAgreement{
    get{
       if(agmt.RecordTypeDescription__c=='Active') return true;
        return false;
    }
  }
   
  public Boolean Is_OAI{
    get{
        if(m_agreementStatusManager.getRecordType(agmt) == Utility.recordTypeObject('Agreement__c','Pending')){
        if(m_agreementApprovalInfo.wasIndependentlyApproved(agmt.Id)){
          return true;
        }
        return !m_agreementStatusManager.hasLoanApps(agmt);
      }
      return m_agreementApprovalInfo.wasIndependentlyApproved(agmt.Id);
    }
  }

  public PageReference saveclicked() {
          if(validateLawFirm()){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Law Firm required');
                ApexPages.addMessage(myMsg);
          }
          if(String.IsBlank(agmtId)){
            agmt.RecordTypeId=PendingStatusId;
            agmt.Name='AGMT';
            agmt.Primary_Borrower__c = agmt.Borrower_Name__r.Name;

            insert agmt;

            if(!String.isBlank(LoanAppId)){                 
                m_agreementPicker.SaveAgreementLoanRel(agmt.Id,LoanAppId);
            }else if(!String.isBlank(LlcBiLoanId)){                 
                m_agreementPicker.SaveAgreementLlcBiLoanRel(agmt.Id,LlcBiLoanId);
            }
            
            //Insert first Relationship for new Primary Owner
            Agreement_Client_Relationships__c newRel = new Agreement_Client_Relationships__c();
            newRel.Entity__c = agmt.Borrower_Name__c;
            newRel.Relationship__c = 'Primary Borrower';
            newRel.Agreement__c = agmt.Id;
            
            insert newRel;
            
            AgreementSummaryUpdater.updateSummaries(agmt.Id);
        }
        else{  
            try{
              m_agreementValidator.Validate(agmt);
              update agmt;
            }
            catch(exception ex){
                ApexPages.addMessages(ex);
                return null;
            }
        }
        ApexPages.Message[] msgs = ApexPages.getMessages();
        if (msgs.size() > 0){
            return null;
        }
        controller = new ApexPages.standardController(agmt);
        return Controller.view();
    }

  public boolean isAgreementNew{
    get{
      return agmt.Name.contains('rev')? false:true;
    }
  }
       
  public PageReference CancelClicked(){
      if(String.IsEmpty(agmtId)){
          try{
              
              String newPageUrl = this.url  + 'a28';
              PageReference newPage = new PageReference(newPageUrl);
              newPage.setRedirect(true);
              return newPage;
              
          }catch(exception ex){
              
          }
                
      }else{
          if(agmt != null){
                controller = new ApexPages.standardController(agmt);
                return Controller.view();
          }
      }
      return null;
    }
    
  public boolean showLawFirm{
    get{
        if(agmt != null){
            if(agmt.Loan_Documents_Prepared_By__c=='Hybrid' || agmt.Loan_Documents_Prepared_By__c=='Attorney Prepared'){
                return true;
            }
        }
        return false;
    }
  }
  
  private boolean validateLawFirm(){
    if(agmt != null && (agmt.Loan_Documents_Prepared_By__c=='Hybrid' || agmt.Loan_Documents_Prepared_By__c=='Attorney Prepared') && String.IsBlank(agmt.Law_Firm__c) == true){
        //agmt.Law_Firm__c.addError('Error : Law firm Required');
        return true;
    }
      return false;
  }
  
  public PageReference bogus(){
    return null;
  }
}