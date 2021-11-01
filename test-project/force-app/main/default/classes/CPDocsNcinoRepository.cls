public class CPDocsNcinoRepository implements CPDocs.INcinoRepository {
    private final CPDocs.IDmBuilder m_dmBuilder;
    private final CPDocs.INcinoDmBuilder m_ncinoDmBuilder;
    private final CPDocs.IDataProvider m_dataProvider;
    private final CPDocs.INcinoDataProvider m_ncinoDataProvider;
    
    public CPDocsNcinoRepository(CPDocs.IDmBuilder dmBuilder, CPDocs.IDataProvider dataProvider, 
    CPDocs.INcinoDataProvider ncinoDataProvider, CPDocs.INcinoDmBuilder ncinoDmBuilder){
        m_dmBuilder = dmBuilder;
        m_dataProvider = dataProvider;
        m_ncinoDataProvider = ncinoDataProvider;
        m_ncinoDmBuilder = ncinoDmBuilder;
    }

    public List<DmNcinoDocumentPlaceHolder> getAccountDocuments(List<string> entityIds){
        return m_ncinoDmBuilder.buildAccountDocuments(m_ncinoDataProvider.getAccountDocuments(entityIds));
    }

    public List<DmNcinoDocumentPlaceHolder> getLoanDocuments(List<string> loanIds){
        List<PM_LLCBI_LLC_LoanDocument_c> pms = m_ncinoDataProvider.getLoanDocuments(loanIds);   
        return m_ncinoDmBuilder.buildLoanDocuments(pms);
    }

    public List<DmNcinoDocumentPlaceHolder> getCollateralDocuments(List<string> collateralIds, Map<String,String> collateralIdtoNameMapping){
        List<PM_LLCBI_Document_PlaceHolder_c> pms = m_ncinoDataProvider.getCollateralDocuments(collateralIds);
        return m_ncinoDmBuilder.buildCollateralDocuments(pms, collateralIdtoNameMapping);
    } 

    public List<DmLoanEntityRelationship> getLoanEntityRelationship(string entityId){
        List<PM_LLCBI_Legal_Entities_c> pms =  m_ncinoDataProvider.getLegalEntities(entityId);
        return m_ncinoDmBuilder.buildLegalEntities(pms);
    }

    public List<DmLoan> getLoans(List<string> loanIds){
        List<PM_LLCBI_Loan_c> pms = m_ncinoDataProvider.getLoans(loanIds);
        return m_ncinoDmBuilder.buildLoans(pms);
    }

    public List<DmEbAccount> getRelatedEbAccounts( String entityId){
        List<PM_EB_Account_c> pms = m_ncinoDataProvider.getRelatedEbAccounts(entityId);
        return m_ncinoDmBuilder.buildEbAccounts(pms);
    }

    public List<DmLoanRenewal> getRenewals(List<string> loanIds){
        List<PM_LLCBI_LoanRenewal_c> pms = m_ncinoDataProvider.getRenewals(loanIds);
        return m_ncinoDmBuilder.buildLoanRenewals(pms);
    }

}