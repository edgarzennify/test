public class CPDocsRelatedNcinoLoans implements CPDocsAdmin.IRelatedNcinoLoans{
    
    private string STATUS_WITHDRAWN = 'Withdrawn';

    public Map<DmLoan,List<DmLoan>> getRelatedLoanRenewals(List<DmLoanRenewal> relatedDms){
        List<DmLoan> rootLoans = new List<DmLoan>();
        Map<string,string> relToRoot = new Map<string,string>();

        for(DmLoanRenewal rel : relatedDms){
            if(rel.revisionStatus <> STATUS_WITHDRAWN){
                if(rel.renewalOrder == 0 || rel.rootLoan.id == rel.renewalLoan.id ){
                    rootLoans.add(rel.renewalLoan);
                }
                relToRoot.put(rel.renewalLoan.id,rel.rootLoan.id);
            }
        }

        Map<DmLoan,List<DmLoan>> rels = new Map<DmLoan,List<DmLoan>>();

        for(DmLoan ln : rootLoans){
            for(DmLoanRenewal dm : relatedDms){
                if(ln.id <> dm.renewalLoan.id && ln.id == dm.rootLoan.id){
                    if(!rels.containsKey(ln)){
                        rels.put(ln, new List<DmLoan>());
                    }
                    rels.get(ln).add(dm.renewalLoan);
                }
            }
        }

        return rels;
    }

}