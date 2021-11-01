public class TmBoardingEbAccountRelBuilder implements TmBoarding.IEbAccountRelBuilder{

    private final ParentRelationships.IParentRelTreeBuilder m_parentRelTreeBuilder;
    
    public TmBoardingEbAccountRelBuilder(ParentRelationships.IParentRelTreeBuilder parentRelTreeBuilder) {
        m_parentRelTreeBuilder = parentRelTreeBuilder;
    }

    public Map<String, DmEntity> getRelatedEntitiesIncludingParent(Account parent) {
        Map<String, DmEntity> accounts = new Map<String, DmEntity>();
        if(parent == null){return accounts;}

        DmEntity parentDm = new DmEntity();
        parentDm.id = String.valueOf(parent.id);
        parentDm.name = parent.name;
        accounts.put(parentDm.id, parentDm);

        List<Map<Id, Account>> mp = null; 

        try{
            mp = m_parentRelTreeBuilder.getRelationshipTreeForEntity(parent.id, false, null);
        }catch(exception ex){
            mp = null;
        }

        if(mp != null){
            for(Map<Id, Account> m : mp){
                for(Account a : m.values()){
                    String childId = String.valueOf(a.Id);
                    if(!accounts.containsKey(childId)){
                        DmEntity dm = new DmEntity();
                        dm.id = a.id;
                        dm.name = a.name;
                        accounts.put(dm.Id, dm);
                    }
                }
            }
        }
        return accounts;
    }
}