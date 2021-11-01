public with sharing class ModifyAgreementController {
    public Agreement__c m_currentAgreement{get;set;}
    private Agreements.IClone_Agreement m_cloneAgreement;
    
    public ModifyAgreementController(Agreement__c currentAgreement, Agreements.IClone_Agreement cloneAgreement){
        m_currentAgreement = currentAgreement;
        m_cloneAgreement = cloneAgreement;
    }
        
    public ModifyAgreementController(ApexPages.StandardController controller){
        IUserInfoService userInfoService = UserInfoService.bootstrap();
        Clone_AgreementRelationships cloneAgreementRelationships = new Clone_AgreementRelationships(userInfoService);
        m_cloneAgreement = new Clone_Agreement(new Clone_AgreementDataProvider(), cloneAgreementRelationships, AgreementValidator.getInstance());
        m_currentAgreement = m_cloneAgreement.GetAgreementById(controller.getRecord().Id);
    }    
    
    public PageReference ModifyCurrentAgreement(){
        if(m_currentAgreement == null) return null;  
       
        Integer counter = m_cloneAgreement.GetPendingAgreementCount(m_currentAgreement);
        if(counter <= 0){
            Agreement__c newAgreement = m_cloneAgreement.CloneAndRemoveLoanApps(m_currentAgreement.Id);
            String newPageUrl = Utility.getServerUrl() + '/' +  newAgreement.Id;
            PageReference newPage = new PageReference(newPageUrl);
            newPage.setRedirect(true);
            return newPage;
        }
        
        m_currentAgreement.addError('[' + String.valueOf(counter) + '] modification(s) are already in process for Agreement: [' + m_currentAgreement.Name.trim() + ']');
        return null;
    }
}