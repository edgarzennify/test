public class AgreementPicker implements Agreements.IAgreementPicker{
    Agreements.IAgreementPickerDataProvider m_dataProvider;     
    Account m_entity;
    
    public AgreementPicker(){
        m_dataProvider = new AgreementPickerDataProvider();
    }
    
    public AgreementPicker(Agreements.IAgreementPickerDataProvider dataProvider){
        m_dataProvider = dataProvider;
    }
    
    public List<EB_Loan_Application__c> getLoanObjectForLoanAppId(Id LoanAppId){
        return m_dataProvider.getLoanApplicationObjectForLoanAppId(LoanAppId);
    }
    
    public void saveAgreementLoanRel(Id AgreementId, Id LoanAppId){
        Agreement__c agmt = m_dataProvider.getAgreementFromId(AgreementId);
        if(agmt.RecordTypeDescription__c == 'Active' || agmt.RecordTypeDescription__c == 'Pending'){
            m_dataProvider.saveAgreementLoanAppRel(AgreementId, LoanAppId);
        }  
    } 

    public void saveAgreementLlcBiLoanRel(Id AgreementId, Id LlcBiLoanId){
        Agreement__c agmt = m_dataProvider.getAgreementFromId(AgreementId);
        if(agmt.RecordTypeDescription__c == 'Active' || agmt.RecordTypeDescription__c == 'Pending'){
            m_dataProvider.saveAgreementLlcBiLoanRel(AgreementId, LlcBiLoanId);
        }  
    }
    
    public List<Agreement__c> getAgreementsForLoanApp(Id LoanAppId){
        return m_dataProvider.getAgreementsForLoanApp(LoanAppId);
    }
}