public class AgreementLoanAppRepository implements Agreements.ILoanAppRepository {
    private final Agreements.IAgreementControllerDataProvider m_dataProvider;
    private final Agreements.IDmLoanAppBuilder m_dmBuilder;
    private final Agreements.ILoanAppRepositoryHelper m_repoHelper;
    
    public AgreementLoanAppRepository(Agreements.IAgreementControllerDataProvider dataProvider, Agreements.IDmLoanAppBuilder dmBuilder, Agreements.ILoanAppRepositoryHelper repoHelper) {
        m_dataProvider = dataProvider;
        m_dmBuilder = dmBuilder;
        m_repoHelper = repoHelper;
    }
    
    public List<DmLoanApp> getIncludedLoanApps(Id agreementId) {
        List<Agreement_Loan_Application_Relationship__c> inclLoanAppRels = m_dataProvider.getIncludedLoanAppRelationshipsByAgreementId(agreementId);
        List<Agreement_LLC_BI_Loan_Relationship__c> inclLlcBiLoanRels = m_dataProvider.getIncludedLlcBiLoanRelationshipsByAgreementId(agreementId);

        List<DmLoanApp> dms = new List<DmLoanApp>();
        dms.addAll(m_dmBuilder.build(inclLoanAppRels));
        dms.addAll(m_dmBuilder.build(inclLlcBiLoanRels));

        return dms;
    }
    
    public List<DmLoanApp> getExcludedLoanApps(Set<Id> includedEntitiesSet, List<DmLoanApp> includedLoanApps, List<EB_Account__c> IncludedEbAccounts) {
        List<EB_Loan_App_Entity_Relationship__c> entityAppRels = m_dataProvider.getEntityLoanAppRelationshipsByEntityIds(includedEntitiesSet);
        List<LLC_BI__Legal_Entities__c> entityInvolvements = m_dataProvider.getLlcBiEntityInvolvementsByEntityIds(includedEntitiesSet);
        
        Set<Id> includedAppIds = setify(includedLoanApps);
        List<EB_Loan_Application__c> unfilteredExcludedLoanApps = m_repoHelper.getExcludedLoanApps(entityAppRels, includedAppIds);
        List<LLC_BI__Loan__c> unfilteredExcludedLoans = m_repoHelper.getExcludedLlcBiLoans(entityInvolvements, includedAppIds);
        List<LLC_BI__Loan__c> filteredExcludedLoans = m_repoHelper.filterExcludedLlcBiLoans(unfilteredExcludedLoans, IncludedEbAccounts);

        List<DmLoanApp> dms = new List<DmLoanApp>();
        dms.addAll(m_dmBuilder.build(unfilteredExcludedLoanApps));
        dms.addAll(m_dmBuilder.build(filteredExcludedLoans));
        
        return dms;
    }
    
    public List<Agreements.LoanAppEntityRelationship> getExcludedLoanApplicationRelationships(List<DmLoanApp> allLoanApps, Set<Id> includedEntitiesSet) {
        Set<Id> includedAppIds = setify(allLoanApps);
        List<EB_Loan_App_Entity_Relationship__c> loanAppEntityRels = m_dataProvider.getEntityLoanAppRelationshipsByAppIds(includedAppIds);
        List<LLC_BI__Legal_Entities__c> entityInvolvements = m_dataProvider.getLlcBiEntityInvolvementsByAppIds(includedAppIds);
        return getExcludedRelationships(loanAppEntityRels, entityInvolvements, allLoanApps, includedEntitiesSet);
    }

    public void includeLoanApp(Id agreementId, Id loanAppId) {
        if (loanAppId.getSobjectType() == Schema.EB_Loan_Application__c.SObjectType) {
            Agreement_Loan_Application_Relationship__c objectToInsert = new Agreement_Loan_Application_Relationship__c(Agreement__c = agreementId, Loan_Application__c = loanAppId);
            m_dataProvider.save(objectToInsert);
        }    
        if (loanAppId.getSobjectType() == Schema.LLC_BI__Loan__c.SObjectType) {
            Agreement_LLC_BI_Loan_Relationship__c objectToInsert = new Agreement_LLC_BI_Loan_Relationship__c(Agreement__c = agreementId, LLCBI_Loan__c = loanAppId);        
            m_dataProvider.save(objectToInsert);
        }           
    }

    public void excludeLoanApp(Id agreementId, Id loanAppId) {
        if (loanAppId.getSobjectType() == Schema.EB_Loan_Application__c.SObjectType) {
            Agreement_Loan_Application_Relationship__c relToRemove = m_dataProvider.findAgreementLoanApplicationRelationship(agreementId, loanAppId);
            m_dataProvider.remove(relToRemove);
        }
        if (loanAppId.getSobjectType() == Schema.LLC_BI__Loan__c.SObjectType) {
            Agreement_LLC_BI_Loan_Relationship__c relToRemove = m_dataProvider.findAgreementLlcBiLoanRelationship(agreementId, loanAppId);
            m_dataProvider.remove(relToRemove);
        }
    }

    private List<Agreements.LoanAppEntityRelationship> getExcludedRelationships(List<EB_Loan_App_Entity_Relationship__c> loanAppRels, List<LLC_BI__Legal_Entities__c> entityInvolvements, List<DmLoanApp> allLoanApps, Set<Id> includedEntitiesSet) {
        List<Agreements.LoanAppEntityRelationship> dms = new List<Agreements.LoanAppEntityRelationship>();

        Map<String, DmLoanApp> appDms = mapify(allLoanApps);
        dms.addAll(getExcludedLoanAppEntityRelationships(loanAppRels, appDms, includedEntitiesSet));
        dms.addAll(getExcludedLoanAppEntityRelationships(entityInvolvements, appDms, includedEntitiesSet));
       
        return dms;
    }

    private List<Agreements.LoanAppEntityRelationship> getExcludedLoanAppEntityRelationships(List<EB_Loan_App_Entity_Relationship__c> loanAppRels, Map<String, DmLoanApp> appDms, Set<Id> includedEntitiesSet) {
        List<Agreements.LoanAppEntityRelationship> dms = new List<Agreements.LoanAppEntityRelationship>();
        if (loanAppRels != null) {
            for (EB_Loan_App_Entity_Relationship__c rel : loanAppRels) {
                if (!includedEntitiesSet.contains(rel.Entity_Name__r.Id) && appDms.containsKey(rel.Loan_Application_ID__c)) {
                        Agreements.LoanAppEntityRelationship dm = m_dmBuilder.build(appDms.get(rel.Loan_Application_ID__c), rel.Entity_Name__r);
                        dms.add(dm);
                }
            }
        }
        return dms;
    }

    private List<Agreements.LoanAppEntityRelationship> getExcludedLoanAppEntityRelationships(List<LLC_BI__Legal_Entities__c> entityInvolvements, Map<String, DmLoanApp> appDms, Set<Id> includedEntitiesSet) {
        List<Agreements.LoanAppEntityRelationship> dms = new List<Agreements.LoanAppEntityRelationship>();
        if (entityInvolvements != null){
            for (LLC_BI__Legal_Entities__c ei : entityInvolvements) {
                if (!includedEntitiesSet.contains(ei.LLC_BI__Account__r.Id) && appDms.containsKey(ei.LLC_BI__Loan__c)) {
                    Agreements.LoanAppEntityRelationship dm = m_dmBuilder.build(appDms.get(ei.LLC_BI__Loan__c), ei.LLC_BI__Account__r);
                    dms.add(dm);
                }
            }
        }
        return dms;
    }

    private Map<String, DmLoanApp> mapify(List<DmLoanApp> loanApps) {
        Map<String, DmLoanApp> dms = new Map<String, DmLoanApp>();
        for (DmLoanApp dm : loanApps) {
            dms.put(dm.id,dm);
        }
        return dms;
    }

    private Set<Id> setify(List<DmLoanApp> dms) {
        Set<Id> ids = new Set<Id>();
        for (DmLoanApp dm : dms) {
            ids.add(dm.id);
        }
        return ids;
    }
}