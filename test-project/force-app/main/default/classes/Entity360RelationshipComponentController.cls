public with sharing class Entity360RelationshipComponentController {
    
    public String entityId {get;set;}
    private final Entity360.IEntity360Repository m_repository;
    private final Entity360.IEntity360VmBuilder m_vmBuilder;
    private List<DmEntity> m_entityDms;
    
    public Entity360RelationshipComponentController (Entity360.IEntity360Repository repository, Entity360.IEntity360VmBuilder vmBuilder) {
         m_repository = repository;
         m_vmBuilder = vmBuilder;
    }

    public Entity360RelationshipComponentController () {
        Entity360.IEntity360DmBuilder dmBuilder = new Entity360DmBuilder();
        ParentRelationships.IParentRelTreeBuilder parentRelTreeBuilder = new ParentRelTreeBuilder();
        Entity360.IEntity360DataProvider dataProvider = new Entity360DataProvider(dmBuilder, parentRelTreeBuilder);
        List<Entity360.IEntity360Delegate> delegates = new List<Entity360.IEntity360Delegate> {
            new Entity360LoanDelegate(),
            new Entity360DepositDelegate(),            
            new Entity360TreasuryDelegate(),
            new Entity360CreditCardDelegate(),
            new Entity360DebitCardDelegate(),
            new Entity360WealthManagementDelegate()
        };
        List<Entity360.IEntity360VMDisplayCalc> displayCalcs = new List<Entity360.IEntity360VMDisplayCalc>{
            new Entity360VmLoanDisplayCalc(),
            new Entity360VmDepositDisplayCalc(),
            new Entity360VmTreasuryDisplayCalc(),
            new Entity360VmCreditCardDisplayCalc(),
            new Entity360VmDebitCardDisplayCalc(),
            new Entity360VmWealthManagementDisplayCalc(),
            new Entity360VmRoeDisplayCalc(),
            new Entity360VmCmDisplayCalc()
        };
        m_repository = new Entity360Repository(dataProvider, delegates);
        m_vmBuilder = new Entity360VmBuilder(displayCalcs);
    }
    
    public List<Entity360.EntityViewModel> entityViewModels{
        get{
            List<Entity360.EntityViewModel> vms = m_vmBuilder.buildEntityVms(getEntityDms());
            return (vms == null)? new List<Entity360.EntityViewModel>() : vms;
        }
    }
    
    public Entity360.EntityViewModel entityAggregateViewModel{
        get{
            Entity360.EntityViewModel vm = m_vmBuilder.buildAggregateEntityVm(getEntityDms());
            return (vm == null) ? new Entity360.EntityViewModel() : vm;        
        }
    }
    
    private List<DmEntity> getEntityDms()
    {
        if(m_entityDms == null)
        {
             m_entityDms  = m_repository.getRelationshipEntityDmsByEntityId(entityId); 
        } 
        return m_entityDms; 
    }
}