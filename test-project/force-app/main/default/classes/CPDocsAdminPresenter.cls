public  class CPDocsAdminPresenter {
    
    private CPDocs.INcinoRepository m_ncinoRepo;
    private CPDocsAdmin.IRelatedNcinoLoans m_loanRelated;
    private CPDocsAdmin.IRepository m_adminRepo;
    private CPDocsAdmin.IVmBuilder m_vmBuilder;
    public CPDocsAdminPresenter(CPDocs.INcinoRepository ncinoRepo, CPDocsAdmin.IRepository adminRepo,
        CPDocsAdmin.IRelatedNcinoLoans loanRelated, CPDocsAdmin.IVmBuilder vmBuilder){
        m_ncinoRepo = ncinoRepo;
        m_adminRepo = adminRepo;
        m_loanRelated = loanRelated;
        m_vmBuilder = vmBuilder;
    }

    public List<CPDocsAdmin.DocumentAdminRequest> getRequests(string contactId){
        DmUser userDm = m_adminRepo.getUserFromContact(contactId);

        List<CPDocsAdmin.DocumentAdminRequest> requests = new List<CPDocsAdmin.DocumentAdminRequest>();
        Map<DmLoan, List<DmLoan>> loanRels= new Map<DmLoan, List<DmLoan>>();
        List<DmLoanEntityRelationship> entityRels = m_ncinoRepo.getLoanEntityRelationship(userDm.Entity.Id);
        if(entityRels == null || entityRels.size() == 0) return requests;

        List<string> loanIds = getLoanIds(entityRels);
        if(loanIds.size() > 0){
            List<DmLoanRenewal> loanRenewalDms = m_ncinoRepo.getRenewals(loanIds);
            loanRels = m_loanRelated.getRelatedLoanRenewals(loanRenewalDms);
        }

        List<string> allObjectIds = new List<string>();
        allObjectIds.add(entityRels[0].Entity.Id);
        allObjectIds.addall(loanIds);

        List<DmCpDocumentAccess> allAccessObject =  m_adminRepo.getObjectsForObjectIdsAndUser(allObjectIds, userDm.Id);
        
        return m_vmBuilder.buildVms(loanRels,  allAccessObject, userDm);
    }

    private List<string> getLoanIds(List<DmLoanEntityRelationship> entityRels){
        List<string> loanIds = new List<string>();
        if(entityRels == null || entityRels.size() == 0) return loanIds;
        for(DmLoanEntityRelationship r: entityRels){
            loanIds.add(r.loan.id);
        }
        
        return loanIds;
    }
}