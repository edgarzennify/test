public class AgreementLoanAppLink implements Agreements.IAgreementLoanAppLink{
    /*public interface IDataProvider{
        void SaveLoanAppToAgreementRelatedList(Id loanAppId, Id agmtId);
        void DeleteLoanAppFromAgreementRelatedList(Id loanAppId, Id agmtId);
        void DeleteEbAccountFromAgreementRelatedList(Id ebaccountId, Id agmtId);
        List<Agreement__c> GetListOfAgreementForEBAccount(Id ebAccountId);
    }
     */
    Agreements.IAgreementLoanAppLinkDataProvider m_dataprovider;
    
    public AgreementLoanAppLink(Agreements.IAgreementLoanAppLinkDataProvider dataprovider){
        m_dataprovider = dataprovider;        
    }
    
    public void ConnectLoanAppToAgreement(Id loanAppId,Id agmtId ){
        m_dataprovider.SaveLoanAppToAgreementRelatedList(loanAppId, agmtId);
    }
    
    public void RemoveLoanAppFromAgreement(Id loanAppId,Id agmtId){
        m_dataProvider.DeleteLoanAppFromAgreementRelatedList(loanAppId, agmtId);       
    }
    
    public void RemoveEbAccountFromAgreement(Id ebAccountId,Id agmtId){
        m_dataprovider.DeleteEbAccountFromAgreementRelatedList(ebAccountId, agmtId);      
    }
    
    public List<Agreement__c> GetActiveAgreementsForEbAccount(Id ebAccountId){
        return m_dataprovider.GetListOfAgreementForEBAccount(ebAccountId);
    }

}