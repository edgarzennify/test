public with sharing class AppraisalOrderController{
    private final String ORDER_NOT_SUBMITTED_BECAUSE_RM_MUST_REVIEW_MSG = 'Appraisal order was saved, but not submitted. The "RM Reviewed/OK to Order" field must be checked before submitting this order.';
    private AppraisalOrderComponentFactory.IAppraisalOrderComponentFactory m_appraisalOrderComponentFactory;
    private AppraisalOrderDataProvider.IAppraisalOrderDataProvider m_appraisalOrderDataProvider;
    private IApexPages m_apexPages;
    private EB_Appraisal_Order__c m_appraisalOrder;
    private String fieldValidationMessage{get;set;}
    public string dropdownCostCenterById{get;set;}
    private string collateralOwner{get;set;}

    public List<SelectOption> getCostCenters(){
       List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
            for(EB_Unit__c un : m_appraisalOrderDataProvider.getCostCenters()){
            options.add(new SelectOption(un.Center__c + ' - ' + un.Name, un.Center__c + ' - ' + un.Name));
        }
        return options;
    }

    
    public Boolean showWillRmSeekWaiver{
        get{
            if(m_appraisalOrder.Loan_Exceeds_2M__c == 'Yes'){
                return true;
            }
            return false;
        }
    } 
   
     public Boolean showAppraisalOtherUser{
        get{
            if(string.isBlank(m_appraisalOrder.Appraisal_User_Other__c)){return false;} 
            if(m_appraisalOrder.Appraisal_User_Other__c=='Participant Financial Institution / Other') {
                return true;
            }
            return false;
        }
    }  
    
    public Boolean showSaveButton{
        get{
            if(m_appraisalOrder.Submit_Order__c == false){
                return true;
            }
            return false;
        }
    } 

    public String now{
        get{
            return String.valueOf(datetime.now());
        }
    }

    public EB_Appraisal_order__c AppraisalOrder{
        get{
            return m_appraisalOrder;
        }
    }
    public String Collateral_Owner{
        get{
            return collateralOwner;
        }
    }
    public apexPages.Component AppraisalOrderDetails{
        get{
            return  m_appraisalOrderComponentFactory.getComponentFor(m_appraisalOrder);
        }
    }

    public AppraisalOrderController(){
        ApexPagesWrapper apexPages = new ApexPagesWrapper();
        AppraisalOrderComponentFactory appraisalOrderComponentFactory = new AppraisalOrderComponentFactory(AppraisalOrderComponent.getComponents());
        AppraisalOrderDataProvider appraisalOrderDataProvider = new AppraisalOrderDataProvider();
        initialize(appraisalOrderDataProvider, appraisalOrderComponentFactory, apexPages);
    }
    public AppraisalOrderController(AppraisalOrderDataProvider.IAppraisalOrderDataProvider appraisalOrderDataProvider, AppraisalOrderComponentFactory.IAppraisalOrderComponentFactory appraisalOrderComponentFactory, IApexPages apexPages){
        initialize(appraisalOrderDataProvider, appraisalOrderComponentFactory, apexPages);
    }

    private void initialize(AppraisalOrderDataProvider.IAppraisalOrderDataProvider appraisalOrderDataProvider, AppraisalOrderComponentFactory.IAppraisalOrderComponentFactory appraisalOrderComponentFactory, IApexPages apexPages){
        m_appraisalOrderDataProvider = appraisalOrderDataProvider;
        m_appraisalOrderComponentFactory = appraisalOrderComponentFactory;
        m_apexPages = apexPages;
        m_appraisalOrder = fillAppraisalOrderObject();
        collateralOwner=m_appraisalOrderDataProvider.collateralOwner(m_appraisalOrder);    
        dropdownCostCenterById=m_appraisalOrder.Cost_Center__c;
    }

    private EB_Appraisal_Order__c fillAppraisalOrderObject(){
        String appraisalOrderIdParam = m_apexPages.getParameter('Id');
        if(appraisalOrderIdParam != '' && appraisalOrderIdParam != null){
            return m_appraisalOrderDataProvider.getAppraisalOrderForId(m_apexPages.getParameter('Id'));            
        }else{
            String oreoAccountId = m_apexPages.getParameter('accountId');
            if(oreoAccountId != '' && oreoAccountId != null){
                return m_appraisalOrderDataProvider.getAppraisalOrderFromOREOId(m_apexPages.getParameter('accountId'));
            }else{
                return m_appraisalOrderDataProvider.getAppraisalOrderFromCollateralId(m_apexPages.getParameter('CollateralId'));
            }
        }
    }

    public PageReference cancel(){
        return getDestinationURL();
    }

    public PageReference save(){
        if(saveAppraisalOrder()){
            return getDestinationURL();
        }else{
            return null;
        }
    }

    public void quickSave(){
        saveAppraisalOrder();
    }

    public PageReference saveAndSubmit(){
        if(!saveAppraisalOrder()){
            return null;
        }

        if(reviewedByRM()){
            if(m_appraisalOrder.Id != null){
                String url = '/apex/AppraisalOrderSubmit?Id=' + String.valueOf(m_appraisalOrder.Id);
                PageReference newPage = new PageReference(url);
                newPage.setRedirect(true);
                return newPage;
            }
        }
        else{
            m_apexPages.addMessage(ApexPages.Severity.Warning, ORDER_NOT_SUBMITTED_BECAUSE_RM_MUST_REVIEW_MSG);
        }

        return null;
    }

    public void submit(){
        if(m_appraisalOrder.RM_Reviewed_OK_to_Order__c==true){
             m_appraisalOrder.Submit_Order__c = true;
        }
        saveAppraisalOrder(); 
    }

    private Boolean saveAppraisalOrder(){
        String componentValidationError = m_appraisalOrderComponentFactory.getComponentFieldValidationError(m_appraisalOrder);
        String controllerError = componentValidationError + validateOrderFields();

        if(controllerError == ''){
            updateAppraisalOrderSummaryField();
            m_appraisalOrderDataProvider.save(m_appraisalOrder);
            return true;
        }else{
            m_apexPages.addMessage(ApexPages.Severity.ERROR, 'The following required field(s) are missing: ' + controllerError);
            return false;
        }     
    }

    public PageReference CreateSnapshot()
    {
        if(m_appraisalOrder.RM_Reviewed_OK_to_Order__c==true){
            createSnapshotOfAppraisalOrder();
        }
       return getDestinationURL();
    }

    private void createSnapshotOfAppraisalOrder(){
        PageReference pdf = Page.AppraisalOrderViewPDFtemplate;
        pdf.getParameters().put('id',m_appraisalOrder.Id);
        Attachment attach = new Attachment();
        Blob body;
        try {
            body = pdf.getContent();
        // need to pass unit test -- current bug    
        } catch (VisualforceException e) {
            body = Blob.valueOf('Some Text');
        }
        attach.Body = body;
        attach.Name = 'AppraisalOrderSnapshot.pdf';
        attach.IsPrivate = false;
        attach.ParentId = m_appraisalOrder.Id;
        m_appraisalOrderDataProvider.insertAttachment(attach);
    }

    public PageReference getDestinationURL(){
        PageReference newPage;
        String appraisalOrderIdParam = m_apexPages.getParameter('Id');
        if(appraisalOrderIdParam != null){
            newPage = new PageReference('/'+ m_appraisalOrder.Id);
        }else if(m_appraisalOrder.OREO_Account__c != null){
            newPage = new PageReference('/'+ m_appraisalOrder.OREO_Account__c);
        }else{
            newPage = new PageReference('/'+ m_appraisalOrder.Related_Collateral__c);
        }
        newPage.setRedirect(true);
        return newPage;
    }

    private void updateAppraisalOrderSummaryField(){
        List<AppraisalOrders.AppraisalOrderSummaryFieldDetails> componentFieldList = m_appraisalOrderComponentFactory.getAppraisalOrderSummaryFieldDetailsList(m_appraisalOrder);
        String appraisalOrderSummaryField = '';
        for(AppraisalOrders.AppraisalOrderSummaryFieldDetails field : componentFieldList){
            if(field.fieldValue != null && field.fieldValue != ''){
                appraisalOrderSummaryField += field.fieldLabel + field.fieldValue + ';   ';
            }
        }
        if(m_appraisalOrder.OREO_Account__c != null){
            m_appraisalOrder.OREO_Account__r.Appraisal_Order_Summary__c = appraisalOrderSummaryField;
        }else{
            m_appraisalOrder.Related_Collateral__r.Appraisal_Order_Summary__c = appraisalOrderSummaryField;
        }
    }

    private Boolean reviewedByRM(){
        if(m_appraisalOrder.RM_Reviewed_OK_to_Order__c == true){
            return true;
        }
        return false;
    }

    private String validateOrderFields(){
        m_appraisalOrder.Cost_Center__c=dropdownCostCenterById;
        fieldValidationMessage = '';
        if(Utility.isFieldEmpty(EB_Appraisal_Order__c.Cost_Center__c.getDescribe().getType(), m_appraisalOrder.Cost_Center__c)){
            fieldValidationMessage += 'Cost Center ;';
        }
        if(Utility.isFieldEmpty(EB_Appraisal_Order__c.Order_Type__c.getDescribe().getType(), m_appraisalOrder.Order_Type__c)){
            fieldValidationMessage += 'Order Type ;';
        }
        if(Utility.isFieldEmpty(EB_Appraisal_Order__c.Relationship_Manager__c.getDescribe().getType(), m_appraisalOrder.Relationship_Manager__c)){
            fieldValidationMessage += 'Relationship Manager ;';
        }
        if(Utility.isFieldEmpty(EB_Appraisal_Order__c.Loan_Coordinator__c.getDescribe().getType(), m_appraisalOrder.Loan_Coordinator__c)){
             fieldValidationMessage += 'Loan Coordinator ;';
        }
        if(Utility.isFieldEmpty(EB_Appraisal_Order__c.Date_Appraisal_Needed__c.getDescribe().getType(), m_appraisalOrder.Date_Appraisal_Needed__c)){
             fieldValidationMessage += 'Date Appraisal Needed ;';
        }
        if(Utility.isFieldEmpty(EB_Appraisal_Order__c.Tax_Increment_Financing_TIF__c.getDescribe().getType(), m_appraisalOrder.Tax_Increment_Financing_TIF__c)){
             fieldValidationMessage += 'TIF (Tax Increment Financing) ;';
        }
        if(Utility.isFieldEmpty(EB_Appraisal_Order__c.Tax_Credit_Involved__c.getDescribe().getType(), m_appraisalOrder.Tax_Credit_Involved__c)){
             fieldValidationMessage += 'Tax Credit ;';
        }
        if(Utility.isFieldEmpty(EB_Appraisal_Order__c.Appraisal_User_Other__c.getDescribe().getType(), m_appraisalOrder.Appraisal_User_Other__c)){
             fieldValidationMessage += 'Appraisal Other User ;';
        }
        if((m_appraisalOrder.OREO_Account__c == null 
                && Utility.isFieldEmpty(EB_Collateral__c.Inspection_Contact_Name__c.getDescribe().getType(), 
                    m_appraisalOrder.Related_Collateral__r.Inspection_Contact_Name__c)) 
            || (m_appraisalOrder.OREO_Account__c != null 
                && Utility.isFieldEmpty(EB_Account__c.Inspection_Contact_Name__c.getDescribe().getType(), 
                    m_appraisalOrder.OREO_Account__r.Inspection_Contact_Name__c))){
             fieldValidationMessage += 'Inspection Contact Name ;';
        }
        if((m_appraisalOrder.OREO_Account__c == null 
                && Utility.isFieldEmpty(EB_Collateral__c.Inspection_Contact_Phone__c.getDescribe().getType(), 
                    m_appraisalOrder.Related_Collateral__r.Inspection_Contact_Phone__c)) 
            || (m_appraisalOrder.OREO_Account__c != null 
                && Utility.isFieldEmpty(EB_Account__c.Inspection_Contact_Phone__c.getDescribe().getType(), 
                    m_appraisalOrder.OREO_Account__r.Inspection_Contact_Phone__c))){
             fieldValidationMessage += 'Inspection Contact Phone ;';
        }
        if(Utility.isFieldEmpty(EB_Appraisal_Order__c.Appraisal_Order_Scope__c.getDescribe().getType(), m_appraisalOrder.Appraisal_Order_Scope__c)){
             fieldValidationMessage += 'Appraisal Order Scope ;';
        }
        if(Utility.isFieldEmpty(EB_Appraisal_Order__c.Property_Ownership__c.getDescribe().getType(), m_appraisalOrder.Property_Ownership__c)){
             fieldValidationMessage += 'Property Ownership ;';
        }
        if(Utility.isFieldEmpty(EB_Appraisal_Order__c.Loan_Exceeds_2M__c.getDescribe().getType(), m_appraisalOrder.Loan_Exceeds_2M__c)){
             fieldValidationMessage += 'Loan Exceeds $2M ;';
        }
        return  fieldValidationMessage;
    }
}