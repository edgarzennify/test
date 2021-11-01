public class CPDocsRelatedObjectsProvider implements CPDocs.IRelatedObjectsProvider {

    private string SOURCE_DOCMAN = 'DocMan';
    private string SOURCE_INTERNAL = 'Internal';
    private final CPDocs.INcinoRepository m_ncinoRepo;

    public CPDocsRelatedObjectsProvider(CPDocs.INcinoRepository ncinoRepo){
        m_ncinoRepo = ncinoRepo;
    }
    
    public Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> getRelatedObjects(DmUser userDm){      
        return buildRelatedObjects(userDm);
    }

    public Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> getRelatedObjectsByAccessObjects(DmUser userDm, List<DmCpDocumentAccess> accessObjects){
        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> relatedObjsAccessBased = new Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>>();
        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> relatedObjs = buildRelatedObjectsX(userDm);

        Map<string, DmCpDocumentAccess> accessLookup = new Map<string, DmCpDocumentAccess>();
        for(DmCpDocumentAccess a: accessObjects){
            String key = getKey(a.PortalUser.id, a.objectId);
            if(!accessLookup.containsKey(key)){
                accessLookup.put(key, a);
            }
        }

        for(CPDocs.ObjectType o : relatedObjs.keySet()){
            List<CPDocs.RelatedObject> objs = relatedObjs.get(o);
            if(!relatedObjsAccessBased.containsKey(o)){
                relatedObjsAccessBased.put(o,new List<CPDocs.RelatedObject>());
            }
            for(CPDocs.RelatedObject obj : objs){
                String key = getKey(userDm.id, obj.objectId);
                if(accessLookup.containsKey(key) ){
                    relatedObjsAccessBased.get(o).add(obj);
                }
            }
        }

        return relatedObjsAccessBased;
    }

    public Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> getRelatedObjectsByObjectName(DmUser userDm, String objectName){
        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> filtered = new Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>>();
        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> items =  buildRelatedObjects(userDm);
        for(CPDocs.ObjectType otype : items.keySet()){
            List<CPDocs.RelatedObject> objs =  items.get(otype);
            for(CPDocs.RelatedObject rel : objs){
                if(rel.objectName == objectName){
                    if(!filtered.containsKey(otype)){
                        filtered.put(otype, new List<CPDocs.RelatedObject>());
                    }              
                    filtered.get(otype).add(rel);
                }
            }
        }

        return filtered;
    }

    private Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> buildRelatedObjects(DmUser userDm){
        List<DmLoan> loanDms = new List<DmLoan>();  
        List<DmCollateral> collateralDms = new List<DmCollateral>();      
        List<DmLoanEntityRelationship> entityRels = m_ncinoRepo.getLoanEntityRelationship(userDm.Entity.Id);
        List<string> loanIds = getLoanIds(entityRels);
        if(loanIds.size() > 0){
            loanDms = m_ncinoRepo.getLoans(loanIds);
            collateralDms.addAll(getCollaterals(loanDms));
        }

        List<DmEbAccount> ebAccountDms = m_ncinoRepo.getRelatedEbAccounts( userDm.Entity.Id); 
        return buildRelatedObjects(userDm, loanDms, collateralDms, ebAccountDms);
    }

    private Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> buildRelatedObjectsX(DmUser userDm){
        List<DmLoan> loanDms = new List<DmLoan>();  
        List<DmCollateral> collateralDms = new List<DmCollateral>();      
        List<DmLoanEntityRelationship> entityRels = m_ncinoRepo.getLoanEntityRelationship(userDm.Entity.Id);
        List<string> loanIds = getLoanIds(entityRels);

        //List<DmLoanRenewal> getRenewals(loanIds)
        //run the List<DmLoanRenewal> through CPDocsRelatedNcinoLoans to get Renewals and Orig Loans;
        //get loanids for orig and renewals

        if(loanIds.size() > 0){
            loanDms = m_ncinoRepo.getLoans(loanIds);
            collateralDms.addAll(getCollaterals(loanDms));
        }

        List<DmEbAccount> ebAccountDms = m_ncinoRepo.getRelatedEbAccounts( userDm.Entity.Id); 
        return buildRelatedObjects(userDm, loanDms, collateralDms, ebAccountDms);
    }

    private Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> buildRelatedObjects(DmUser userDm, List<DmLoan> loanDms,List<DmCollateral> colDms, List<DmEbAccount> ebAccountDms){
        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> relObjs = new Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>>();
        List<CPDocs.RelatedObject> entityObjs = new List<CPDocs.RelatedObject>();
        List<CPDocs.RelatedObject> lnObjs = new List<CPDocs.RelatedObject>();
        List<CPDocs.RelatedObject> colObjs = new List<CPDocs.RelatedObject>();
        List<CPDocs.RelatedObject> accountObjs = new List<CPDocs.RelatedObject>();
        
        CPDocs.RelatedObject entityObj = new CPDocs.RelatedObject();
        entityObj.objectId = userDm.Entity.Id;
        entityObj.objectName = userDm.Entity.Name;
        entityObj.objectType = CPDocs.ObjectType.Entity;
        entityObj.source = SOURCE_DOCMAN;
        entityObjs.add(entityObj);
        relObjs.put(CPDocs.ObjectType.Entity,entityObjs);
        for(DmLoan ldm : loanDms){
            CPDocs.RelatedObject lnObj = new CPDocs.RelatedObject();
            lnObj.objectId = ldm.Id;
            lnObj.objectName = ldm.Name;
            lnObj.objectType = CPDocs.ObjectType.Loan;
            lnObj.source = SOURCE_DOCMAN;
            lnObjs.add(lnObj);
        }

        if(lnObjs.size() > 0) relObjs.put(CPDocs.ObjectType.Loan, lnObjs);

        for(DmCollateral cDm : colDms){
            CPDocs.RelatedObject colObj = new CPDocs.RelatedObject();
            colObj.objectId = cDm.Id;
            colObj.objectName = cDm.Name;
            colObj.objectType = CPDocs.ObjectType.Collateral;
            colObj.source = SOURCE_DOCMAN;
            colObjs.add(colObj);
        }

        if(colObjs.size() > 0) relObjs.put(CPDocs.ObjectType.Collateral, colObjs);

        if(ebAccountDms !=null){
            for(DmEbAccount acct: ebAccountDms){
                CPDocs.RelatedObject acctObj = new CPDocs.RelatedObject();
                acctObj.objectId = acct.id;
                acctObj.objectName = acct.name;
                acctObj.objectType = CPDocs.ObjectType.Account;
                acctObj.source = SOURCE_INTERNAL;
                accountObjs.add(acctObj);
            }
        }

        if(accountObjs.size()>0) relObjs.put(CPDocs.ObjectType.Account, accountObjs);
        return relObjs;
    }

    private List<string> getLoanIds(List<DmLoanEntityRelationship> entityRels){
        List<string> loanIds = new List<string>();
        if(entityRels == null || entityRels.size() == 0) return loanIds;
        for(DmLoanEntityRelationship r: entityRels){
            loanIds.add(r.loan.id);
        }
        return loanIds;
    }

    private List<DmCollateral> getCollaterals(List<DmLoan> loanDms){
        List<DmCollateral> dmCollaterals = new List<DmCollateral>();
        if(loanDms == null || loanDms.size() == 0)return dmCollaterals;
        for(DmLoan dm : loanDms){
            if(dm != null && dm.PledgedCollateral != null){
                for(DmLoanCollateralRelationship cplrel: dm.PledgedCollateral){
                    dmCollaterals.add(cplrel.Collateral);
                }
            }
        }
        return dmCollaterals;
    }

    private string getKey(string userId, string objectId){
        return String.format('{0}-{1}', new List<string>{userId, objectId});
    }
}