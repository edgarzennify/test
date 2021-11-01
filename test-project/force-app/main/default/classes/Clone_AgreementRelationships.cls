public class Clone_AgreementRelationships implements Agreements.IClone_AgreementRelationships{
	
    private IUserInfoService m_userInfoService;

    public Clone_AgreementRelationships(IUserInfoService userInfoService){
        m_userInfoService = userInfoService;
    }

    public Map<SObject,List<SObject>> Clone(List<Agreement_Borrowing_Base_Relationship__c> origList, Id newAgreementId){
    	Map<SObject,List<SObject>> copyMap = new Map<SObject,List<SObject>>();
        for(Agreement_Borrowing_Base_Relationship__c currOrig : origList){
            Agreement_Borrowing_Base_Relationship__c bbClone = currOrig.clone(false,false,false,false);
            bbClone.OwnerId = m_userInfoService.getCurrentUserId();
            bbClone.Agreement__c = newAgreementId;
            //copyList.add(copy);
            
            //clone related entities child list
            List<SObject> children = new List<SObject>();
            for(Agreement_Borrowing_Base_Entity_Rel__c origRel : currOrig.Agreement_Borrowing_Base_Entity_Rels__r){                
                Agreement_Borrowing_Base_Entity_Rel__c bbRelClone = origRel.clone(false,false,false,false);
                bbRelClone.Entity__c = origRel.Entity__c;
                children.add((SObject)bbRelClone);
            }
            
            copyMap.put((SObject)bbClone,children);
        }
        return copyMap;
    }
    
    public Map<SObject,List<SObject>> Clone(List<Agreement_Financial_Covenant__c> origList, Id newAgreementId){
        Map<SObject,List<SObject>> copyMap = new Map<SObject,List<SObject>>();
        for(Agreement_Financial_Covenant__c currOrig : origList){
        	Agreement_Financial_Covenant__c covClone = currOrig.clone(false,false,false,false);
            covClone.OwnerId = m_userInfoService.getCurrentUserId();
        	covClone.Agreement__c = newAgreementId;
            //copyList.add(copy);
            
            //clone related entities child list
            List<SObject> children = new List<SObject>();
            for(Agreement_Financial_Covenant_Entity_Rel__c origRel : currOrig.Agreement_Financial_Covenant_Entity_Rels__r){                
                Agreement_Financial_Covenant_Entity_Rel__c bbRelClone = origRel.clone(false,false,false,false);
                bbRelClone.Entity__c = origRel.Entity__c;
                children.add(bbRelClone);
            }
            
            copyMap.put(covClone,children);
        }
        return copyMap;
    }
    public Map<SObject,List<SObject>> Clone(List<Agreement_Subordination__c> origList, Id newAgreementId){
        Map<SObject,List<SObject>> copyMap = new Map<SObject,List<SObject>>();
        for(Agreement_Subordination__c currOrig : origList){
        	Agreement_Subordination__c subordinateClone = currOrig.clone(false,false,false,false);
        	subordinateClone.Agreement__c = newAgreementId;
            
            //clone related entities child list
            List<SObject> children = new List<SObject>();
            for(Agreement_Subordination_Entity_Rel__c origRel : currOrig.Agreement_Subordination_Entity_Rels__r){                
                Agreement_Subordination_Entity_Rel__c bbRelClone = origRel.clone(false,false,false,false);
                bbRelClone.Entity__c = origRel.Entity__c;
                children.add(bbRelClone);
            }
            
            copyMap.put(subordinateClone,children);
        }
        return copyMap;
    }
    public Map<SObject,List<SObject>> Clone(List<Agreement_Client_Relationships__c> origList, Id newAgreementId){
        Map<SObject,List<SObject>> copyMap = new Map<SObject,List<SObject>>();system.debug('######Clone_AgreementRel(): line23');
        for(Agreement_Client_Relationships__c currOrig : origList){            
        	Agreement_Client_Relationships__c clientRelClone = currOrig.clone(false,false,false,false);system.debug('######Clone_AgreementRel(): line25');
            clientRelClone.OwnerId = m_userInfoService.getCurrentUserId();
        	clientRelClone.Agreement__c = newAgreementId;
            clientRelClone.Tax_Returns__c = currOrig.Entity__r.Tax_Returns__c;
            clientRelClone.Tax_Return_Days_Due_After_Filing__c = currOrig.Entity__r.Tax_Return_Days_Due_After_Filing__c;

            clientRelClone.Annual_Financial_Statements__c = currOrig.Entity__r.Annual_Financial_Statements__c;               
            clientRelClone.Annual_Statement_Quality__c = currOrig.Entity__r.Annual_Statement_Quality__c;           
            clientRelClone.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = currOrig.Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c;

            clientRelClone.Personal_Financial_Statement__c = currOrig.Entity__r.Personal_Financial_Statement__c;
            clientRelClone.Personal_Financial_Statement_Frequency__c = currOrig.Entity__r.Personal_Financial_Statement_Frequency__c;

            clientRelClone.Interim_Statements__c = currOrig.Entity__r.Interim_Statements__c;
            clientRelClone.Interim_Stm_Prepared_By__c = currOrig.Entity__r.Interim_Stm_Prepared_By__c;
            clientRelClone.Interim_Stmt_Days_Due_After_Period_End__c = currOrig.Entity__r.Interim_Stmt_Days_Due_After_Period_End__c;          
            
            //clone financial documents child list
            List<SObject> children = new List<SObject>();
            for(Agreement_Financial_Documents__c origDoc : currOrig.Agreement_Financial_Documents__r){                
                Agreement_Financial_Documents__c docClone = origDoc.clone(false,false,false,false);system.debug('######Clone_AgreementRel(): line30');
                docClone.Agreement__c = newAgreementId;
                children.add(docClone);
            }
            
            system.debug('######Clone_AgreementRel children.size(): ' + string.valueOf(children.size()));
            copyMap.put(clientRelClone,children);
        }
        System.debug('###pos0:' + copyMap);
        return copyMap;
    }
    
    public List<Agreement_EB_Account_Relationship__c> Clone(List<Agreement_EB_Account_Relationship__c> origList, Id newAgreementId){
        List<Agreement_EB_Account_Relationship__c> copyList = new List<Agreement_EB_Account_Relationship__c>();
        for(Agreement_EB_Account_Relationship__c currOrig : origList){
        	Agreement_EB_Account_Relationship__c copy = currOrig.clone(false,false,false,false);
            copy.OwnerId = m_userInfoService.getCurrentUserId();
        	copy.Agreement__c = newAgreementId;
            copyList.add(copy);
        }
        return copyList;
    }
    
    public List<Agreement_Loan_Application_Relationship__c> Clone(List<Agreement_Loan_Application_Relationship__c> origList, Id newAgreementId){
        List<Agreement_Loan_Application_Relationship__c> copyList = new List<Agreement_Loan_Application_Relationship__c>();
        for(Agreement_Loan_Application_Relationship__c currOrig : origList){
        	Agreement_Loan_Application_Relationship__c copy = currOrig.clone(false,false,false,false);
        	copy.Agreement__c = newAgreementId;
            copyList.add(copy);
        }
        return copyList;
    }    
}