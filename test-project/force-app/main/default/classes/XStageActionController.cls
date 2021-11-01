public class XStageActionController{
    
    private Id m_objectId {get;set;}
    private String m_currentPageUrl {get;set;}
    private Map<String,String> m_objectActionPages {
        get{
            if(m_objectActionPages == null){
                m_objectActionPages = new Map<String,String>();
                m_objectActionPages.put('eb_loan_application__c','LoanAppStageAction');
                m_objectActionPages.put('eb_booked_loan_app__c','LoanArchivedStageAction');
                m_objectActionPages.put('agreement__c','AgreementStageAction');
            }
            return m_objectActionPages;
        }
        set;
    }
    
    public XStageActionController(){
        m_objectId = apexpages.currentpage().getparameters().get('id');
        m_currentPageUrl = ApexPages.currentpage().getUrl();
    }
    
    public XStageActionController(Id objectId, String currentPageUrl){
        m_objectId = objectId;
        m_currentPageUrl = currentPageUrl;
    }
       
    public PageReference RedirectAction(){
        if(!IsStageAccessible()){
            return null;
        }
        return getObjectActionPage();        
    }
    
    private PageReference getObjectActionPage(){
        String objectName = utility.getObjectNameFromId(string.valueOf(m_objectId));
        
        if(m_objectActionPages.containsKey(objectName.toLowerCase())){
            String actionPage = m_objectActionPages.get(objectName);
            return getActionPage(actionPage);    
        }        
                      
        return null;
    }
    
    private PageReference getActionPage(String pageName){
        String url = utility.getServerUrl() + '/apex/' + pageName + '?id=' + string.valueOf(m_objectId);
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(true);
        return newPage;
    }
    
    private boolean IsStageAccessible(){        
    	Schema.DescribeSObjectResult obj;
    	if(m_currentPageUrl.contains('/apex/LoanAppApprovedAction')){
    		obj = Schema.Sobjecttype.pApprovedAction__c;
    		return obj.isAccessible();
    	}
    	if(m_currentPageUrl.contains('/apex/LoanAppArchivedAction')){
    		obj = Schema.Sobjecttype.pArchivedAction__c;
    		return obj.isAccessible();
    	}
    	if(m_currentPageUrl.contains('/apex/LoanAppBookedAction')){
    		obj = Schema.Sobjecttype.pBookedAction__c;
    		return obj.isAccessible();
    	}    	
    	if(m_currentPageUrl.contains('/apex/LoanAppDocumentationAction')){
    		obj = Schema.Sobjecttype.pDocumentationAction__c;
    		return obj.isAccessible();
    	}
    	if(m_currentPageUrl.contains('/apex/LoanAppNewAction')){
    		obj = Schema.Sobjecttype.pNewAction__c;
    		return obj.isAccessible();
    	}
    	if(m_currentPageUrl.contains('/apex/LoanAppPendingApprovalAction')){
    		obj = Schema.Sobjecttype.pPendingApprovalAction__c;
    		return obj.isAccessible();
    	}
    	if(m_currentPageUrl.contains('/apex/LoanAppUnderwritingAction')){
    		obj = Schema.Sobjecttype.pUnderwritingAction__c;
    		return obj.isAccessible();
    	}    	
    	return true;
    }
}