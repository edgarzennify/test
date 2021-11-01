public class AgreementValidator implements Agreements.IAgreementValidator{
	
	private Agreements.IAgreementValidatorDataProvider m_dataprovider;
    private Agreement__c m_agreement;
	private static AgreementValidator m_singleton;
	private Boolean m_disabledFromTrigger = false;    
 
    private List<Agreement_Client_Relationships__c> m_entityRels{
        get{
            if(m_entityRels == null){
                m_entityRels = m_dataprovider.getAgreementEntityRels(m_agreement.Id);
            }
            return m_entityRels;
        }
        set;
    }
    
    private List<Account> m_entities{
    	get{
    		List<Account> entities = new List<Account>();
    		if(m_entityRels != null){
                for(Agreement_Client_Relationships__c r : m_entityRels){
                    entities.add(r.Entity__r);
                }
    		}
            return entities;
    	}
    } 
    
    private Map<Id, Agreement__c> m_agreementsValidatedFromTrigger{
    	get{
    		if(m_agreementsValidatedFromTrigger == null){
    			m_agreementsValidatedFromTrigger = new Map<Id, Agreement__c>();
    		}
            return m_agreementsValidatedFromTrigger;
    	}
    	set;
    }
    
    private Boolean hasAlreadyBeenValidated(Agreement__c agmt){
    	return (m_agreementsValidatedFromTrigger.get(agmt.Id) != null) ? true : false;
    }
    
    private AgreementValidator(Agreements.IAgreementValidatorDataProvider dataprovider){
        m_dataprovider = dataprovider;
    }
    
    public static AgreementValidator getInstance(){
    	if(m_singleton == null){
    		m_singleton = new AgreementValidator(new AgreementValidatorDataProvider());
    	}
    	return m_singleton;
    }
    
    public static AgreementValidator getInstance(Agreements.IAgreementValidatorDataProvider dataprovider){
    	if(m_singleton == null){
            m_singleton = new AgreementValidator(dataprovider);
        }
        return m_singleton;
    }
    
    public void Validate(Agreement__c agreement){
        initialize(agreement);
        CheckForErrors();
        CheckForWarnings();
    }
    
    public void ValidateAndSave(Agreement__c agreement){
        Validate(agreement);
        m_dataprovider.SaveAgreement(m_agreement);
    }
    
    public void ValidateAndSaveFromTrigger(Agreement__c agreement){     
        if(m_disabledFromTrigger == false){
            if(!hasAlreadyBeenValidated(agreement)){
	            ValidateAndSave(agreement);
	            m_agreementsValidatedFromTrigger.put(agreement.Id, agreement);
            }	
        }
    }
    
    public void DisableValidateFromTrigger(Boolean disable){
        m_disabledFromTrigger = disable;
    } 
    
    private void initialize(Agreement__c agreement){
    	m_agreement = agreement;
    	if(m_agreement.RecordTypeId == null){
            m_agreement = m_dataprovider.loadAgreementById(m_agreement.Id);
        }
        m_entityRels = null;
    }
    
    private void CheckForErrors(){
        List<String> errors = new List<String>();
		 
        errors.addAll(ValidateARBorrowingBaseCertificateReportingRequirements());
        errors.addAll(ValidateBorrowingBaseEntitiesAreTiedToAgreement());
        errors.addAll(ValidateRelatedClientsOnOtherAgreements());
        errors.addAll(ValidateEbAccountsOnOtherAgreements());
        errors.addAll(ValidateEbLoanApplicationsOnOtherAgreements());
        errors.addAll(ValidateRequiredFieldsOnAgreement());
        
        m_agreement.ErrorMessages__c = utility.ListToDelimitedString(errors,'\n');
    }
    
    private void CheckForWarnings(){
        List<String> warnings = new List<String>();
        warnings.addAll(ValidateGracePeriodValues());
        m_agreement.WarningMessages__c = utility.ListToDelimitedString(warnings,'\n');
    } 
   
    private List<String> ValidateARBorrowingBaseCertificateReportingRequirements(){
        Map<String,String> messages = new Map<String,String>();
        String msgPostfix = 'Entity is tied to an A/R Borrowing Base component and does not have either "Borrowing Base Certificate" or "A/R Detailed Agings" reporting requirement set.';
        List<Account> accountReceivableBBEntities = m_dataprovider.GetEntitiesTiedToARBorrowingBaseComponent(m_agreement.Id);
        if(accountReceivableBBEntities != null && accountReceivableBBEntities.size() > 0){
	        List<Agreement_Client_Relationships__c> reportingRequirements = m_dataprovider.GetReportingRequirementsForEntityList(accountReceivableBBEntities,m_agreement.Id);
	        if(reportingRequirements != null && reportingRequirements.size() > 0){
	        	Boolean reportingRequirementMet = false;
	        	List<String> entityNames = new List<String>();
	            for(Agreement_Client_Relationships__c rr: reportingRequirements){      
	            	entityNames.add(rr.Entity__r.Entity_Name__c);          
	                for(Agreement_Financial_Documents__c fdoc : rr.Agreement_Financial_Documents__r){
	                    if(utility.RecordTypeObject('Agreement_Financial_Documents__c', fdoc.RecordTypeid).Name == 'Borrowing Base Certificate' || utility.RecordTypeObject('Agreement_Financial_Documents__c', fdoc.RecordTypeid).Name == 'A/R Detailed Agings'){
	                        reportingRequirementMet = true;
	                    }
	                }
	            }
	            if(!reportingRequirementMet){
	                 String msg = Utility.ListToDelimitedString(entityNames, ', ') + ': ' + msgPostfix;
	                 messages.put(msg,msg);
	            }
	        }
        }
        return messages.values();
    }
    private List<String> ValidateGracePeriodValues(){
        
        Map<String,String> messages = new Map<String,String>();
        String msgPostfix1 = ': is set to a non-standard option';
        String msgPostfix2 = ' and exceeds maximum policy value';
        String annualStatmentsMsg = ': [Annual Financial Statement - Days Due After Period End] ';
        String interimStatementsMsg = ': [Interim Statements - Days Due After Period End] ';
        String taxReturnsMsg = ': [Tax Returns - Days Due After Filing] ';
        Decimal annualStatementsThreshold = 120;
        Decimal interimStatementsThreshold = 45;
        Decimal taxReturnsThreshold = 30;
        Decimal OTHER = -1;
        
        if(m_entityRels != null){
            for(Agreement_Client_Relationships__c rel : m_entityRels){
                Boolean reportingRequirementMet = false;
                String gracePeriod = '';
                // top list
                if(m_agreement.RecordType.Name == 'Active'){
                    if(rel.Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c == OTHER){
                        String msg = rel.Entity__r.Entity_Name__c + annualStatmentsMsg + msgPostfix1;
                        if(rel.Entity__r.Annual_Financial_Statement_Period_Other__c > annualStatementsThreshold){
                            msg = msg + msgPostfix2;
                        }
                        messages.put(msg,msg);
                    }
                    if(rel.Entity__r.Interim_Statements__c <> 'Not Required' && rel.Entity__r.Interim_Stmt_Days_Due_After_Period_End__c == -1){
                        String msg = rel.Entity__r.Entity_Name__c + interimStatementsMsg + msgPostfix1;
                        if(rel.Entity__r.Interim_Statement_Period_Other__c > interimStatementsThreshold){
                            msg = msg + msgPostfix2;
                        }
                        messages.put(msg,msg);
                    }
                    if(rel.Entity__r.Tax_Return_Days_Due_After_Filing__c == OTHER){
                        String msg = rel.Entity__r.Entity_Name__c + taxReturnsMsg + msgPostfix1;
                        if(rel.Entity__r.Tax_Return_Period_Other__c > taxReturnsThreshold){
                            msg = msg + msgPostfix2;
                        }
                        messages.put(msg,msg);
                    }
                }else if(m_agreement.RecordType.Name == 'Pending'){
                    if(rel.Entity__r.Pending_AFS_Days_Due_After_FYE__c == OTHER){
                        String msg = rel.Entity__r.Entity_Name__c + annualStatmentsMsg + msgPostfix1;
                        if(rel.Entity__r.Pending_AFS_Period_Other__c > annualStatementsThreshold){
                            msg = msg + msgPostfix2;
                        }
                        messages.put(msg,msg);
                    }
                    if(rel.Entity__r.Pending_IntStmts_Days_Due_After_PE__c == OTHER){
                        String msg = rel.Entity__r.Entity_Name__c + interimStatementsMsg + msgPostfix1;
                        if(rel.Entity__r.Pending_IntStmts_Period_Other__c > interimStatementsThreshold){
                            msg = msg + msgPostfix2;
                        }
                        messages.put(msg,msg);
                    }
                    if(rel.Entity__r.Pending_TaxReturns_Days_Due_After_Filing__c == OTHER){
                        String msg = rel.Entity__r.Entity_Name__c + taxReturnsMsg + msgPostfix1;
                        if(rel.Entity__r.Pending_TaxReturns_Period_Other__c > taxReturnsThreshold){
                            msg = msg + msgPostfix2;
                        }
                        messages.put(msg,msg);
                    }
                }else {
                    if(rel.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c == OTHER){
                        String msg = rel.Entity__r.Entity_Name__c + annualStatmentsMsg + msgPostfix1;
                        if(rel.Annual_Financial_Statement_Period_Other__c > annualStatementsThreshold){
                            msg = msg + msgPostfix2;
                        }
                        messages.put(msg,msg);
                    }
                    if(rel.Interim_Statements__c <> 'Not Required' && rel.Interim_Stmt_Days_Due_After_Period_End__c == OTHER){
                        String msg = rel.Entity__r.Entity_Name__c + interimStatementsMsg + msgPostfix1;
                        if(rel.Interim_Statement_Period_Other__c > interimStatementsThreshold){
                            msg = msg + msgPostfix2;
                        }
                        messages.put(msg,msg);
                    }
                    if(rel.Tax_Return_Days_Due_After_Filing__c == OTHER){
                        String msg = rel.Entity__r.Entity_Name__c + taxReturnsMsg + msgPostfix1;
                        if(rel.Tax_Return_Period_Other__c > taxReturnsThreshold){
                            msg = msg + msgPostfix2;
                        }
                        messages.put(msg,msg);
                    }
                }

                // bottom list
                for(Agreement_Financial_Documents__c fdoc : rel.Agreement_Financial_Documents__r){
                    if(fdoc.Period_Due__c == 'Other' && fdoc.Period_Due_Override__c != null){
                    	String msg = rel.Entity__r.Entity_Name__c + ': [' + fdoc.RecordTypeDescription__c + '] ' + msgPostfix1;
                        if(fdoc.Period_Due_Override__c > fdoc.Period_Due_Maximum__c){
                        	msg = msg + msgPostfix2;
                        }
                        msg = msg + '.';
                        messages.put(msg,msg);
                    }
                }                
            }
        }
        return messages.values();
    }
    
    private List<String> ValidateBorrowingBaseEntitiesAreTiedToAgreement(){
        Map<String,String> messages = new Map<String,String>();
        String msgPostfix = 'Entity is tied to Borrowing Base component but not to this agreement.';        
        List<Account> bbEntities = m_dataprovider.GetEntitiesTiedToBorrowingBaseComponent(m_agreement.Id);
        if(bbEntities != null){
            for(Account e : bbEntities){
                boolean entityFound = false;
                if(m_entityRels != null){
                    for(Agreement_Client_Relationships__c rel : m_entityRels){
                        if(rel.Entity__c == e.Id){
                            entityFound = true;
                        }
                    }
                }
                if(entityFound == false){
                    String msg = e.Entity_Name__c + ': ' + msgPostfix;
                    messages.put(msg,msg);
                }
            }
        }
        return messages.values();
    }
    
    private List<String> ValidateRelatedClientsOnOtherAgreements(){
    	Utility.debug_Log('ValidateRelatedClientsOnOtherAgreements');
    	
    	if(m_agreement.RecordTypeId == Utility.recordTypeObject('Agreement__c', 'Archive').Id){
    		return new List<String>();
    	}
    	
        Map<String,String> messages = new Map<String,String>();
        Utility.debug_Log('m_entityRels='+m_entityRels);
        Utility.debug_Log('m_entities='+m_entities);
        if(m_entityRels != null){    	
        	List<Agreement_Client_Relationships__c> otherRels = m_dataprovider.GetOtherAgreementEntitiesRels(m_entities, m_agreement.Id, m_agreement.Source_Agreement__c);
        	Map<Account, List<Agreement_Client_Relationships__c>> entityOtherAgmtRels = new Map<Account, List<Agreement_Client_Relationships__c>>();
        	Utility.debug_Log('otherRels='+otherRels);
        	if(otherRels != null){
	        	for(Agreement_Client_Relationships__c entityRel : otherRels){
	                Account entity = entityRel.Entity__r;
	                
					if(!entityOtherAgmtRels.containsKey(entityRel.Entity__r)){
		                entityOtherAgmtRels.put(entity, new List<Agreement_Client_Relationships__c>{entityRel});
					}else{
						entityOtherAgmtRels.get(entity).add(entityRel);
					}
	        	}
	        	for(Agreement_Client_Relationships__c agmtEntityRel : m_entityRels){
	        		if(agmtEntityRel.Relationship__c != 'Guarantor'){
		        		Account entity = agmtEntityRel.Entity__r;
		        		List<Agreement_Client_Relationships__c> entityOtherRels = entityOtherAgmtRels.get(entity);
		        		Integer sameRelCounter = 0;
		                Integer otherRelCounter = 0;                
		                
		                Utility.debug_Log('entityOtherRels='+entityOtherRels);
		                if(entityOtherRels != null){
			                for(Agreement_Client_Relationships__c otherRel : entityOtherRels){
			                    if(agmtEntityRel.Relationship__c == otherRel.Relationship__c){
			                        sameRelCounter += 1;
			                    }
			                    if(agmtEntityRel.Relationship__c != otherRel.Relationship__c){
			                        otherRelCounter +=1;
			                    }
			                }
			                
			                if(sameRelCounter > 0){
			                    String msg = entity.Entity_Name__c + ' has ' + String.valueOf(sameRelCounter) + ' agreement(s) with the same relationship status of ' + agmtEntityRel.Relationship__c;
			                    messages.put(msg, msg);
			                }
			                if(otherRelCounter > 0){
			                    String msg = entity.Entity_Name__c + ' has ' + String.valueOf(otherRelCounter) + ' agreement(s) with a relationship status set to something other than ' + agmtEntityRel.Relationship__c;
			                    messages.put(msg, msg);
			                }
		                }
	        		}
	        	}
        	}
           
        }
        
        return messages.values();
    }
    private List<String> ValidateEbLoanApplicationsOnOtherAgreements(){
    	Map<String,String> messages = new Map<String,String>();
        String msgPostfix = 'Loan Application is tied to another Agreement.';
        if(String.isBlank(m_agreement.Id) || String.isBlank(m_agreement.Source_Agreement__c)) {
        }else{
            List<EB_Loan_Application__c> ebLoanAppRelList = m_dataprovider.getEbLoanApplicationsNotRelatedToCurrentAgreement(m_agreement.Id, m_agreement.Source_Agreement__c);
            for(EB_Loan_Application__c ebLoanAppRel: ebLoanAppRelList){
                String msg = ebLoanAppRel.Name + ': ' + msgPostfix;
                messages.put(msg, msg);
            }
        }
    	return messages.values();
    }
    
    private List<String> ValidateEbAccountsOnOtherAgreements(){
    	Map<String,String> messages = new Map<String,String>();
        String msgPostfix = 'Account is tied to another Agreement.';
        if(String.isBlank(m_agreement.Id) || String.isBlank(m_agreement.Source_Agreement__c)) {
        }
        else{
            List<Agreements.EBAccountWrapper> accountWrappers = m_dataprovider.getEbAccountsNotRelatedToCurrentAgreement(m_agreement.Id, m_agreement.Source_Agreement__c);
            for(Agreements.EBAccountWrapper w : accountWrappers){
            	List<String> otherAgreements = new List<String>();
            	for(Agreement__c agmt : w.relatedAgreements){
            		otherAgreements.add(agmt.Name);
            	}
            	String msg = w.Name + ': ' + msgPostfix + ' ' + String.valueOf(otherAgreements);
                messages.put(msg, msg);
            } 
        }
    	return messages.values();
		
    }
    
    private List<String> ValidateRequiredFieldsOnAgreement(){
   		List<String> messages = new List<String>();
        if(m_agreement != Null && (m_agreement.RecordTypeId == Utility.recordTypeObject('Agreement__c', 'Pending').Id)){
        	messages.addall(ValidateLoanCoordinatorOnAgreement());
        	messages.addall(ValidateBusinessLoanAgreementDocumentsOnAgreement());
        	messages.addall(ValidateGuaranteeAgreementDocumentsOnAgreement());
            messages.addall(ValidateSubordinationIntercreditorDocumentsOnAgreement());
            messages.addall(ValidateLoanDocumentsPreparedByOnAgreement());
            messages.addall(ValidateOriginalAgreementDateOnAgreement());
        }
        return messages;
    }
    
    private List<String> ValidateLoanCoordinatorOnAgreement(){
    	List<String> messages = new List<String>();
    	List<Agreement_Loan_Application_Relationship__c> loanRels = m_dataProvider.getLoanApplicationRelationshipsByAgreementId(m_agreement.Id);
    	if(loanRels == null || loanRels.size() == 0){
	        if(String.IsBlank(m_agreement.Loan_Coordinator__c)){
	        	messages.add('Loan Coordinator required.');
	        }
    	}       
        return messages; 
    }
    
    private List<String> ValidateBusinessLoanAgreementDocumentsOnAgreement(){
    	List<String> messages = new List<String>();
    	if(String.IsBlank(m_agreement.Business_Loan_Agreement_Documents__c)){
    		messages.add('Business Loan Agreement Documents required.');
    	}
    	return messages;
    }
    
    private List<String> ValidateGuaranteeAgreementDocumentsOnAgreement(){
    	List<String> messages = new List<String>();
    	if(String.IsBlank(m_agreement.Guarantee_Agreement_Documents__c)){
    		messages.add('Guarantee Agreement Documents required.');
    	}
    	return messages;
    }
    
    private List<String> ValidateSubordinationIntercreditorDocumentsOnAgreement(){
    	List<String> messages = new List<String>();
    	if(String.IsBlank(m_agreement.Subordination_Intercreditor_Documents__c)){
    		messages.add('Subordination Intercreditor Documents required.');
    	}
    	return messages;
    }
    
    private List<String> ValidateLoanDocumentsPreparedByOnAgreement(){
    	List<String> messages = new List<String>();
    	if(String.IsBlank(m_agreement.Loan_Documents_Prepared_By__c)){
    		messages.add('Loan Documents Prepared By required.');
    	}
    	return messages;
    }
    
    private List<String> ValidateOriginalAgreementDateOnAgreement(){
    	List<String> messages = new List<String>();
    	if(m_agreement.Agreement_Date__c == Null && !String.IsBlank(m_agreement.Name) && m_agreement.Name.contains('rev')){
    		messages.add('Original Agreement Date required.'); 
    	}
    	return messages;
    }
}