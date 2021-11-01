public with sharing class Entity360MiniComponentController {

    public String entityId {get;set;}
    private final Entity360.IEntity360Repository m_repository;
    private final Entity360.IEntity360VmBuilder m_vmBuilder;
    private final Entity360.IEntity360DmCache m_cache;
    
    public Entity360MiniComponentController (Entity360.IEntity360Repository repository, Entity360.IEntity360VmBuilder vmBuilder, Entity360.IEntity360DmCache cache) {
        m_repository = repository;
        m_vmBuilder = vmBuilder;
        m_cache = cache;
    }

    public Entity360MiniComponentController () {
        Entity360.IEntity360DmBuilder dmBuilder = new Entity360DmBuilder();
        ParentRelationships.IParentRelTreeBuilder parentRelTreeBuilder = new ParentRelTreeBuilder();
        Entity360.IEntity360DataProvider dataProvider = new Entity360DataProvider(dmBuilder, parentRelTreeBuilder);
        Entity360.IEntity360Delegate depositDelegate  = new Entity360DepositDelegate();
        Entity360.IEntity360Delegate loanDelegate  = new Entity360LoanDelegate();
        Entity360.IEntity360Delegate treasuryDelegate  = new Entity360TreasuryDelegate();
        Entity360.IEntity360Delegate creditCardDelegate  = new Entity360CreditCardDelegate();
        Entity360.IEntity360Delegate debitCardDelegate  = new Entity360DebitCardDelegate();
        m_repository = new Entity360Repository(dataProvider, new List<Entity360.IEntity360Delegate>{ loanDelegate, depositDelegate, treasuryDelegate, creditCardDelegate, debitCardDelegate});
        
        Entity360.IEntity360VMDisplayCalc depositDisplay = new Entity360VmDepositDisplayCalc();
        Entity360.IEntity360VMDisplayCalc loanDisplay = new Entity360VmLoanDisplayCalc();
        Entity360.IEntity360VMDisplayCalc treasuryDisplay = new Entity360VmTreasuryDisplayCalc();
        Entity360.IEntity360VMDisplayCalc wmDisplay = new Entity360VmWealthManagementDisplayCalc();
        Entity360.IEntity360VMDisplayCalc creditCardDisplay = new Entity360VmCreditCardDisplayCalc();
        Entity360.IEntity360VMDisplayCalc debitCardDisplay = new Entity360VmDebitCardDisplayCalc();
        Entity360.IEntity360VMDisplayCalc roeDisplay = new Entity360VmRoeDisplayCalc();
        Entity360.IEntity360VMDisplayCalc cmDisplay = new Entity360VmCmDisplayCalc();
        m_vmBuilder = new Entity360VmBuilder(new List<Entity360.IEntity360VMDisplayCalc>{depositDisplay,loanDisplay,treasuryDisplay,wmDisplay,creditCardDisplay,debitCardDisplay,roeDisplay,cmDisplay});
        m_cache = new Entity360DmCache();
    }
    
    public List<Entity360.ElementViewModel> elementViewModels { 
        get{
            
            DmEntity entityDm = GetRelationship().get(entityId);//m_repository.getEntityDms(entityId);
            List<DmEntity> entityDms = new List<DmEntity>{entityDm};
            List<Entity360.EntityViewModel> entityVms = m_vmBuilder.buildEntityVms(entityDms);
            return justProducts(entityVms[0].Elements);
        }
    }
    
    private List<Entity360.ElementViewModel> justProducts(List<Entity360.ElementViewModel> src){
        List<Entity360.ElementViewModel> products = new List<Entity360.ElementViewModel>();
        for(Entity360.ElementViewModel vm : src){
            if(vm.elementType == 'active' || vm.elementType == 'inactive'){
                products.add(vm);
            }
        }
        return products;
    }
    
    private Map<String,DmEntity> GetRelationship()
    {
        if(m_cache.getEntityDmsMap() == null)
        {   
            Map<String, DmEntity> dmsMap = new Map<String, DmEntity>(); 
            for(DmEntity dm : m_repository.getRelationshipEntityDmsByEntityId(entityId))
            {
                dmsMap.put(dm.id , dm);
            }
            m_cache.setEntityDmsMap(dmsMap);
        }
        return m_cache.getEntityDmsMap();
    }
}