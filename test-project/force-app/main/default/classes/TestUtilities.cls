@isTest
public class TestUtilities {
	private static Map<String, EB_Loan_App_Stage__c> m_loanAppStages;
	private static Map<String, EB_Stage_Action_Controller__c> m_loanAppStageControllers;
	
    public static List<EB_Loan_App_Stage__c> createLoanAppStages(){
    	createLoanAppStageControllers();
        List<EB_Loan_App_Stage__c> stages = new List<EB_Loan_App_Stage__c>();
        stages.add(createLoanAppStage('Approved','Approved',4.1));
        stages.add(createLoanAppStage('Archived','Archived',9.1));
        stages.add(createLoanAppStage('Booking','Booking',6.1));
        stages.add(createLoanAppStage('Booking - On Hold','Booking',6.2));
        stages.add(createLoanAppStage('Booking Complete','Booking Complete',6.3));
        stages.add(createLoanAppStage('Checkback','Checkback',10.1));
        stages.add(createLoanAppStage('Checkback Complete','Checkback Complete',10.3));
        stages.add(createLoanAppStage('Denied','Denied',1.0));
        stages.add(createLoanAppStage('Documentation','Documentation',5.1));
        stages.add(createLoanAppStage('Documentation - On Hold','Documentation',5.2));
        stages.add(createLoanAppStage('Documentation - Review','Documentation',5.3));
        stages.add(createLoanAppStage('Documentation - Review Complete','Documentation',5.4));
        stages.add(createLoanAppStage('Documentation Complete','Documentation Complete',5.9));
        stages.add(createLoanAppStage('File Review','File Review',11.1));
        stages.add(createLoanAppStage('File Review Complete','File Review Complete',11.3));
        stages.add(createLoanAppStage('Image Prep','Image Prep',12.1));
        stages.add(createLoanAppStage('Image Prep Complete','Image Prep Complete',12.3));
        stages.add(createLoanAppStage('New','New',1.1));
        stages.add(createLoanAppStage('Pending Approval','Pending Approval',3.1));
        stages.add(createLoanAppStage('Recall Approval Request','',0.0));
        stages.add(createLoanAppStage('Shred & File','Shred & File',13.1));
        stages.add(createLoanAppStage('Shred & File Complete','Shred & File',13.3));
        stages.add(createLoanAppStage('Underwriting','Underwriting',2.1));
        stages.add(createLoanAppStage('Underwriting - On Hold','Underwriting',2.2));
        stages.add(createLoanAppStage('Underwriting Complete','Underwriting Complete',2.3));
        stages.add(createLoanAppStage('Withdrawn','Archived',8.1));
        stages.add(createLoanAppStage('Back Office Modification','Back Office Modification',14.1)); 
        stages.add(createLoanAppStage('Back Office Modification - Pending Approval','',14.2)); 
        stages.add(createLoanAppStage('Back Office Modification - Approved','',14.3)); 
        insert stages;
        createLoanAppStagesAllowedActions();
        return stages;
	}
	
    public static EB_Loan_App_Stage__c createLoanAppStage(String stageName, String stageControllerName, Decimal sortOrder){        
        EB_Loan_App_Stage__c stage = new EB_Loan_App_Stage__c();
        stage.Name = stageName;
        stage.Loan_App_Stage_Action_Controller__c = (stageControllerName == '') ? null : getStageControllerByName(stageControllerName).Id;
        stage.Sort_Order__c = sortOrder;
        return stage;
    }
    
    private static List<EB_Stage_Action_Controller__c> createLoanAppStageControllers(){
        List<EB_Stage_Action_Controller__c> controllers = new List<EB_Stage_Action_Controller__c>();
        controllers.add(createLoanAppStageController('Approved','/apex/LoanAppApprovedAction'));
        controllers.add(createLoanAppStageController('Archived','/apex/LoanAppArchivedAction'));
        controllers.add(createLoanAppStageController('Booking','/apex/LoanAppArchivedAction'));
        controllers.add(createLoanAppStageController('Booking Complete','/apex/LoanAppArchivedAction'));
        controllers.add(createLoanAppStageController('Checkback','/apex/LoanArchivedCheckbackAction'));
        controllers.add(createLoanAppStageController('Checkback Complete','/apex/LoanArchivedCheckbackAction'));
        controllers.add(createLoanAppStageController('Denied','/apex/LoanAppNewAction'));
        controllers.add(createLoanAppStageController('Documentation','/apex/LoanAppDocumentationAction'));
        controllers.add(createLoanAppStageController('Documentation Complete','/apex/LoanAppArchivedAction'));
        controllers.add(createLoanAppStageController('File Review','/apex/LoanArchivedFileReviewAction'));
        controllers.add(createLoanAppStageController('File Review Complete','/apex/LoanArchivedFileReviewAction'));
        controllers.add(createLoanAppStageController('Image Prep','/apex/LoanArchivedImagePrepAction'));
        controllers.add(createLoanAppStageController('Image Prep Complete','/apex/LoanArchivedImagePrepAction'));
        controllers.add(createLoanAppStageController('New','/apex/LoanAppNewAction'));
        controllers.add(createLoanAppStageController('Pending Approval','/apex/LoanAppPendingApprovalAction'));
        controllers.add(createLoanAppStageController('Shred & File','/apex/LoanArchivedShredFileAction'));
        controllers.add(createLoanAppStageController('Underwriting','/apex/LoanAppUnderwritingAction'));
        controllers.add(createLoanAppStageController('Underwriting Complete','/apex/LoanAppNewAction'));
        controllers.add(createLoanAppStageController('Back Office Modification','/apex/LoanAppArchivedAction'));
        insert controllers;
        return controllers;
    }
    
    private static EB_Stage_Action_Controller__c createLoanAppStageController(String stageControllerName, String actionPage){
        EB_Stage_Action_Controller__c controller = new EB_Stage_Action_Controller__c();
        controller.Name = stageControllerName;
        controller.Visual_Force_Action_Page__c = actionPage;
        return controller;
    }
    
    private static List<EB_Loan_App_Stage_Allowed_Action__c> createLoanAppStagesAllowedActions(){
        List<EB_Loan_App_Stage_Allowed_Action__c> actions = new List<EB_Loan_App_Stage_Allowed_Action__c>();
        actions.add(createLoanAppStagesAllowedAction('Pending Approval','Documentation','Prior Action'));
		actions.add(createLoanAppStagesAllowedAction('Archived','Archived','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Recall Approval Request','Pending Approval','Prior Action'));
		actions.add(createLoanAppStagesAllowedAction('Documentation','Booking','Prior Action'));
		actions.add(createLoanAppStagesAllowedAction('Archived','Booking Complete','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Booking','Documentation Complete','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Booking','Booking','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Documentation Complete','Documentation Complete','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Booking Complete','Booking','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Booking - On Hold','Booking','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('File Review Complete','File Review','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Checkback','Checkback Complete','Prior Action'));
		actions.add(createLoanAppStagesAllowedAction('Shred & File Complete','Shred & File','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Shred & File','Image Prep Complete','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('File Review','Checkback Complete','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Image Prep Complete','Image Prep','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Image Prep','File Review Complete','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Withdrawn','Booking','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Documentation - Review','Documentation','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Documentation - Review Complete','Documentation','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Checkback Complete','Checkback','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Underwriting','Documentation','Prior Action'));
		actions.add(createLoanAppStagesAllowedAction('New','Underwriting Complete','Prior Action'));
		actions.add(createLoanAppStagesAllowedAction('Underwriting Complete','Underwriting','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Documentation Complete','Documentation','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Pending Approval','Underwriting Complete','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Documentation','Documentation','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Underwriting','New','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Documentation','Approved','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Withdrawn','Approved','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Documentation - On Hold','Documentation','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Withdrawn','New','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('New','Approved','Prior Action'));
		actions.add(createLoanAppStagesAllowedAction('Withdrawn','Underwriting Complete','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Pending Approval','New','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Underwriting','Approved','Prior Action'));
		actions.add(createLoanAppStagesAllowedAction('Underwriting','Underwriting','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('New','Documentation','Prior Action'));
		actions.add(createLoanAppStagesAllowedAction('Withdrawn','Underwriting','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('New','Underwriting','Prior Action'));
		actions.add(createLoanAppStagesAllowedAction('Underwriting - On Hold','Underwriting','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Booking Complete','Documentation Complete','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Documentation','Documentation Complete','Prior Action'));
		actions.add(createLoanAppStagesAllowedAction('New','Denied','Prior Action'));
		actions.add(createLoanAppStagesAllowedAction('Withdrawn','Denied','Next Action'));
		actions.add(createLoanAppStagesAllowedAction('Checkback','Archived','Next Action'));
        actions.add(createLoanAppStagesAllowedAction('Back Office Modification - Pending Approval','Back Office Modification','Next Action'));
        insert actions;
        return actions;
    }
    
    private static EB_Loan_App_Stage_Allowed_Action__c createLoanAppStagesAllowedAction(String stageName, String stageControllerName, String recordTypeName){
    	EB_Loan_App_Stage_Allowed_Action__c action = new EB_Loan_App_Stage_Allowed_Action__c();
    	action.Stage__c = getStageByName(stageName).Id;
    	action.Controller__c = getStageControllerByName(stageControllerName).Id;
    	action.RecordTypeId = Utility.recordTypeObject('EB_Loan_App_Stage_Allowed_Action__c',recordTypeName).Id;
    	return action;
    }
    
    public static List<Collateral_Code__c> createCollateralCodes(){
        List<Collateral_Code__c> codes = new List<Collateral_Code__c>();
        codes.add(createCollateralCode('32','Brokerage Accounts-(Assignments from Brokerage firms)',75));
        insert codes;
        return codes;
    }
    
    private static Collateral_Code__c createCollateralCode(String id, String name, Decimal policyAdvanceRate){
    	Collateral_Code__c code = new Collateral_Code__c();
    	code.Collateral_Code_ID__c = id;
    	code.Name = name;
    	code.Policy_Advance_Rate__c = policyAdvanceRate;
    	return code;
    }
    
    public static List<EB_Loan_App_Stage_Validation_Rule__c> createValidationRules(){
        List<EB_Loan_App_Stage_Validation_Rule__c> rules = new List<EB_Loan_App_Stage_Validation_Rule__c>();
        rules.add(createValidationRule('Pending Approval','At least one collateral item is required','EB_Loan_Application__c','Collateral_Validation__c','<>','2'));
		rules.add(createValidationRule('Pending Approval','Unsecured selected and collateral was added','EB_Loan_Application__c','Collateral_Validation__c','<>','1'));
		rules.add(createValidationRule('Documentation','Collateral: One or more Collateral Items missing required fields','EB_Loan_Application__c','Collateral_Missing_Fields__c','<','1'));
		rules.add(createValidationRule('Pending Approval','Collateral: One or more Collateral Items missing required fields','EB_Loan_Application__c','Collateral_Missing_Fields__c','<','2'));
		rules.add(createValidationRule('Pending Approval','Loan Details: Business Purpose is required','EB_Loan_Application__c','Business_Purpose__c','<>',''));
		rules.add(createValidationRule('Pending Approval','Loan Details: EB Loan Amount is required','EB_Loan_Application__c','Bank_Owned_Loan_Amount__c','<>',''));
		rules.add(createValidationRule('Documentation','Documentation Details: Closing Date is required','EB_Loan_Application__c','Closing_Date__c','<>',''));
		rules.add(createValidationRule('Documentation','Documentation Details: Closing Time is required','EB_Loan_Application__c','Closing_Time__c','<>',''));
		rules.add(createValidationRule('Pending Approval','Loan Details: Credit Rating is required','EB_Loan_Application__c','Credit_Rating__c','<>',''));
		rules.add(createValidationRule('Pending Approval','Loan Details: Loan Purpose is required','EB_Loan_Application__c','Purpose_of_Loan__c','<>',''));
		rules.add(createValidationRule('Documentation','Documentation Details: Place of Closing is required','EB_Loan_Application__c','Place_of_Closing__c','<>',''));
		rules.add(createValidationRule('Pending Approval','Loan Details: Revenue Code is required','EB_Loan_Application__c','Revenue_Code__c','<>',''));
		rules.add(createValidationRule('Pending Approval','Loan Details: Loan Type is required','EB_Loan_Application__c','Loan_Type__c','<>',''));
		rules.add(createValidationRule('Documentation','Documentation Details: Disbursement Instructions is required','EB_Loan_Application__c','Disbursement_Instructions__c','<>',''));
		rules.add(createValidationRule('Pending Approval','Loan Details: Maturity Term (In Months) is required','EB_Loan_Application__c','Maturity_Term_In_Months__c','<>',''));
		rules.add(createValidationRule('Pending Approval','Loan Details: Industry Code is required','EB_Loan_Application__c','EB_Account_Industry_Code__c','<>',''));
		rules.add(createValidationRule('Pending Approval','Related Entities: One or more Related Entities missing required fields','EB_Loan_Application__c','Missing_Required_Fields_entities__c','<','2'));
		rules.add(createValidationRule('Documentation','Related Entities: One or more Related Entities missing required fields','EB_Loan_Application__c','Missing_Required_Fields_entities__c','<','1'));
		rules.add(createValidationRule('Pending Approval','Packet: "Documentation Path" Required','EB_Loan_Packet__c','Documentation_Path__c','<>',''));
		rules.add(createValidationRule('Documentation','Loan Details: Payment Stream Months Not Equal to Maturity Term Months','EB_Loan_Application__c','Payment_Stream_Equal_Maturity_Term__c','=','1'));
		rules.add(createValidationRule('Pending Approval','Loan Details: Annual Income is required','EB_Loan_Application__c','Annual_Income__c','<>',''));
		rules.add(createValidationRule('Documentation Complete','Loan number required before documentation complete.','EB_Loan_Application__c','Loan_Number__c','<>','N/A'));
		rules.add(createValidationRule('Documentation','Compliance Details required for HMDA eligible loans','EB_Loan_Application__c','IsUseOfFundsValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Compliance Details required for CRA eligible loans','EB_Loan_Application__c','IsCRADetailsValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Compliance Details required for HOEPA eligible loans','EB_Loan_Application__c','IsHOEPADetailsValid__c','=','1'));
		rules.add(createValidationRule('Pending Approval','Fee Waived mismatch','EB_Loan_Application__c','Fee_Waived_Indicator__c','<>','2'));
		rules.add(createValidationRule('Underwriting','Actual Approval Path required','EB_Loan_Packet__c','Actual_Approval_Path__c','<>',''));
		rules.add(createValidationRule('Underwriting','Packet: Complete the necessary fields to determine the Recommended Approval Path','EB_Loan_Application__c','Missing_Required_Fields_Packet__c','<>','1'));
		rules.add(createValidationRule('Pending Approval','Fee is missing on Loan Application','EB_Loan_Application__c','Fee_Waived_Indicator__c','<>','1'));
		rules.add(createValidationRule('Underwriting','Packet: "Total Committed Loan Exposure" required','EB_Loan_Packet__c','AppPathQ1__c','<>',''));
		rules.add(createValidationRule('Pending Approval','Packet: Complete the necessary fields to determine the Recommended Approval Path','EB_Loan_Application__c','Missing_Required_Fields_Packet__c','<>','1'));
		rules.add(createValidationRule('Pending Approval','Loan Details: Payment Stream Months Not Equal to Maturity Term Months','EB_Loan_Application__c','Payment_Stream_Equal_Maturity_Term__c','=','1'));
		rules.add(createValidationRule('Documentation','Zipcode is required','EB_Loan_App_Collateral_Relationship__c','IsZipcodeValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Future Advance Amount is required','EB_Loan_App_Collateral_Relationship__c','IsFutureAdvanceAmountValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Valuation Type is required','EB_Loan_App_Collateral_Relationship__c','IsValuationTypeValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Required Centralized Disbursing is required','EB_Loan_App_Collateral_Relationship__c','IsCentralizedDisbursingVaid__c','=','1'));
		rules.add(createValidationRule('Documentation','State is required','EB_Loan_App_Collateral_Relationship__c','IsStateValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Appraisal County is required','EB_Loan_App_Collateral_Relationship__c','IsAppraisalCountyValid__c','=','1'));
		rules.add(createValidationRule('Documentation','City is required','EB_Loan_App_Collateral_Relationship__c','IsCityValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Lien Position required','EB_Loan_App_Collateral_Relationship__c','IsLienPositionValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Survey is required','EB_Loan_App_Collateral_Relationship__c','IsSurveyRequiredValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Street is required','EB_Loan_App_Collateral_Relationship__c','IsStreetValid__c','=','1'));
		rules.add(createValidationRule('Documentation','SSN/TIN is required','EB_Loan_App_Entity_Relationship__c','IsSSNValid__c','=','1'));
		rules.add(createValidationRule('Pending Approval','Liquid Assets are required','EB_Loan_App_Entity_Relationship__c','Entity_Name__r.Liquid_Assets__c','<>',''));
		rules.add(createValidationRule('Pending Approval','Net Worth is required','EB_Loan_App_Entity_Relationship__c','Entity_Name__r.Net_Worth__c','<>',''));
		rules.add(createValidationRule('Documentation','Billing State is required','EB_Loan_App_Entity_Relationship__c','Entity_Name__r.BillingState','<>',''));
		rules.add(createValidationRule('Pending Approval','Limited or Unlimited is required','EB_Loan_App_Entity_Relationship__c','IsLimitedUnlimitedValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Reg O Institution Title is requied','EB_Loan_App_Entity_Relationship__c','IsRegOInstitutionTitleValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Phone is required','EB_Loan_App_Entity_Relationship__c','IsPhoneValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Billing Street is required','EB_Loan_App_Entity_Relationship__c','Entity_Name__r.BillingStreet','<>',''));
		rules.add(createValidationRule('Documentation','Reg O Qualifications are required','EB_Loan_App_Entity_Relationship__c','Entity_Name__r.Reg_O_Qualifications__c','<>',''));
		rules.add(createValidationRule('Documentation','Reg O Institution is required','EB_Loan_App_Entity_Relationship__c','IsRegOInstitutionValid__c','=','1'));
		rules.add(createValidationRule('Pending Approval','OFAC Verified is required','EB_Loan_App_Entity_Relationship__c','Entity_Name__r.OFAC_Verified__c','<>',''));
		rules.add(createValidationRule('Pending Approval','State Of Incorporation is required','EB_Loan_App_Entity_Relationship__c','IsStateOfIncorporationValid__c','=','1'));
		rules.add(createValidationRule('Documentation','Billing Postal Code is required','EB_Loan_App_Entity_Relationship__c','Entity_Name__r.BillingPostalcode','<>',''));
		rules.add(createValidationRule('Documentation','Billing City is required','EB_Loan_App_Entity_Relationship__c','Entity_Name__r.BillingCity','<>',''));
		rules.add(createValidationRule('Pending Approval','Limited is required','EB_Loan_App_Entity_Relationship__c','IsLimitationValid__c','=','1'));
        insert rules;
        return rules;
    }
    
    private static EB_Loan_App_Stage_Validation_Rule__c createValidationRule(String stageName, String name, String objectName, String fieldName, String operation, String operand){
    	EB_Loan_App_Stage_Validation_Rule__c rule = new EB_Loan_App_Stage_Validation_Rule__c();
    	EB_Loan_App_Stage__c stage = getStageByName(stageName);
    	rule.EB_Loan_App_Stage__c = stage.Id;
    	rule.Name = name;
    	rule.Object_Name__c = objectName;
    	rule.Field_Name__c = fieldName;
    	rule.Operation__c = operation;
    	rule.Operand__c = operand;
    	return rule;
    }
    
    public static List<Account_Team_Role__c> createAccountTeamRoles(){
    	List<Account_Team_Role__c> roles = new List<Account_Team_Role__c>();
    	roles.add(createAccountTeamRole('Commercial Relationship Manager', 'Yes', '1'));
    	insert roles;
    	return roles;
    }
    
    private static Account_Team_Role__c createAccountTeamRole(String roleName, String canApproveLoan, String approvalAuthOrder){
    	Account_Team_Role__c role = new Account_Team_Role__c();
    	role.Name = roleName;
    	role.Can_Approve_Loan__c = canApproveLoan;
        role.Approval_Authority_Order__c = approvalAuthOrder;
        return role;
    }
    
    public static EB_Loan_App_Stage__c getStageByName(String name){
    	return loanAppStages.get(name);
    }
    
    public static EB_Loan_App_Stage__c getStageById(Id stageId){
        for(EB_Loan_App_Stage__c stage : loanAppStages.values()){
        	if(stage.Id == stageId){
        		return stage;
        	}
        }
        return null;
    }
    
    private static Map<String,EB_Loan_App_Stage__c> loanAppStages{
    	get{
	        if(m_loanAppStages == null){
	            m_loanAppStages = new Map<String, EB_Loan_App_Stage__c>();
	            for(EB_Loan_App_Stage__c stage : [SELECT Id, Name, Loan_App_Stage_Action_Controller__c FROM EB_Loan_App_Stage__c]){
	                m_loanAppStages.put(stage.Name,stage);
	            }
	        }
	        return m_loanAppStages;
    	}
    }
    
    public static EB_Stage_Action_Controller__c getStageControllerByName(String name){
        return loanAppStageControllers.get(name);
    }
    
    private static Map<String,EB_Stage_Action_Controller__c> loanAppStageControllers{
        get{
            if(m_loanAppStageControllers == null){
                m_loanAppStageControllers = new Map<String, EB_Stage_Action_Controller__c>();
                for(EB_Stage_Action_Controller__c stage : [SELECT Id, Name FROM EB_Stage_Action_Controller__c]){
                    m_loanAppStageControllers.put(stage.Name,stage);
                }
            }
            return m_loanAppStageControllers;
        }
    }
    
    public static EB_Unit__c getUnitBeforeInsert(String name, String phoneNumber){
    	EB_Unit__c u = new EB_Unit__c();
    	u.Name = name;
    	u.Unit_Reporting_Label__c = name; 
    	u.Phone_Number__c = phoneNumber;
    	return u;
    }
    
    public static EB_Unit__c getUnitAfterInsert(String name, String phoneNumber){
    	EB_Unit__c u = getUnitBeforeInsert(name,phoneNumber);
    	insert u;
    	return u;
    }
    
    public static Account getEntity(String name, Boolean saveReturnObject){
    	Account entity = new Account();
    	entity.Name = name;
        entity.Reg_O_Qualifications__c = null;
        entity.Reg_O_Foreign_Insitution__c = null;
        entity.Reg_O_Foreign_Insitution_Title__c = null;
        if(saveReturnObject){insert entity;}        
        return entity;      
    }
    
    public static Lead getLeadBeforeInsert(String company, Id unitId){
        Lead testLead = new Lead();
        testLead.RecordTypeId = utility.recordTypeObject('Lead', 'Lead').Id;
        testLead.Status = 'Closed - Converted';
        testLead.LeadSource = 'Cold Call';
        testLead.Company = company;
        testLead.LastName = 'Doe'; 
        testlead.Email = 'test@test.com';
        testlead.Opportunity_Type__c = 'Consumer Banking';
        testlead.Client_Preferred_Branch__c = 'St Louis - Clayton';
        testlead.EB_Branch__c = unitId;
        return testLead;
    }
    
    public static Lead getLeadAfterInsert(String company, Id unitId){
    	Lead testLead = getLeadBeforeInsert(company,unitId);
		insert testLead;
		return testLead;
    }
    
    public static Contact getContactBeforeInsert(String firstName, String lastName, Id entityId){
    	Contact testContact = new Contact();
		testContact.FirstName = firstName;
		testContact.LastName = lastName;
		testContact.AccountId = entityId;
		return testContact;
    }
    
    public static Contact getContactAfterInsert(String firstName, String lastName, Id entityId){
    	Contact testContact = getContactBeforeInsert(firstName, lastName, entityId);
		insert testContact;
		return testContact;
    }
    
    public static Opportunity getOpportunityBeforeInsert(String Name, Id EntityId){
    	Opportunity opportunity = new Opportunity();
    	opportunity.Name = Name;
    	opportunity.AccountId = EntityId;
    	opportunity.Amount = 1000;
    	opportunity.RecordTypeId = Utility.recordTypeObject('Opportunity', 'Commercial Lending').Id;
    	opportunity.StageName = 'Discovery';  	
    	Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day());
        opportunity.CloseDate = d;
    	opportunity.Probability = 25;
    	opportunity.Priority_O__c = 'A';
    	opportunity.Will_this_loan_fully_fund_at_Closing__c = 'No';
    	opportunity.January_Amount__c = 1.00;
    	opportunity.February_Amount__c = 1.01;
    	opportunity.March_Amount__c = 1.02;
    	return opportunity;
    }
    
    public static Opportunity getOpportunityAfterInsert(String Name, Id EntityId){
    	Opportunity opportunity = getOpportunityBeforeInsert(Name, EntityId);
    	insert opportunity;
    	return opportunity;
    }

    public static Eb_Floating_Rate__c getLoanIndexRates(String description, String rateChangeFrequency, Date effectiveDate, decimal rate){
        Eb_Floating_Rate__c idxRate = new Eb_Floating_Rate__c();
        idxRate.Floating_Rate__c = rate;
        idxRate.Floating_Rate_Code__c = '1';
        idxRate.Prior_Rate__c = 1.0;
        idxRate.Rate_Change_Frequency__c = rateChangeFrequency;
        idxRate.Website__c = 'http://www.enterprisebank.com';
        idxRate.Updated_On__c = EffectiveDate;
        return idxRate;
    }
}