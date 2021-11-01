public with sharing class Entity360Controller {
    
    private IApexPages m_apexPages;
    private final Entity360.IEntity360Repository m_repository;
    private final Entity360.IEntity360VmBuilder m_vmBuilder;

    public Entity360Controller(IApexPages apexPages, Entity360.IEntity360Repository repository, Entity360.IEntity360VmBuilder vmBuilder) {
        m_apexPages = apexPages;
        m_repository = repository;
        m_vmBuilder = vmBuilder;
    }

    public Entity360Controller(ApexPages.StandardController controller) {
        m_apexPages = new ApexPagesWrapper();
        Entity360.IEntity360DmBuilder dmBuilder = new Entity360DmBuilder();
        ParentRelationships.IParentRelTreeBuilder parentRelTreeBuilder = new ParentRelTreeBuilder();
        Entity360.IEntity360DataProvider dataProvider = new Entity360DataProvider(dmBuilder, parentRelTreeBuilder);
        Entity360.IEntity360Delegate depositDelegate  = new Entity360DepositDelegate();
        Entity360.IEntity360Delegate loanDelegate  = new Entity360LoanDelegate();
        Entity360.IEntity360Delegate treasuryDelegate  = new Entity360TreasuryDelegate();
        Entity360.IEntity360Delegate creditCardDelegate  = new Entity360CreditCardDelegate();
        Entity360.IEntity360Delegate debitCardDelegate  = new Entity360DebitCardDelegate();
        Entity360.IEntity360Delegate wmDelegate  = new Entity360WealthManagementDelegate();
        m_repository = new Entity360Repository(dataProvider, new List<Entity360.IEntity360Delegate>{ loanDelegate, depositDelegate, treasuryDelegate, creditCardDelegate, debitCardDelegate, wmDelegate});
        
        Entity360.IEntity360VMDisplayCalc depositDisplay = new Entity360VmDepositDisplayCalc();
        Entity360.IEntity360VMDisplayCalc loanDisplay = new Entity360VmLoanDisplayCalc();
        Entity360.IEntity360VMDisplayCalc treasuryDisplay = new Entity360VmTreasuryDisplayCalc();
        Entity360.IEntity360VMDisplayCalc wmDisplay = new Entity360VmWealthManagementDisplayCalc();
        Entity360.IEntity360VMDisplayCalc creditCardDisplay = new Entity360VmCreditCardDisplayCalc();
        Entity360.IEntity360VMDisplayCalc debitCardDisplay = new Entity360VmDebitCardDisplayCalc();
        Entity360.IEntity360VMDisplayCalc roeDisplay = new Entity360VmRoeDisplayCalc();
        Entity360.IEntity360VMDisplayCalc cmDisplay = new Entity360VmCmDisplayCalc();
        m_vmBuilder = new Entity360VmBuilder(new List<Entity360.IEntity360VMDisplayCalc>{depositDisplay,loanDisplay,treasuryDisplay,wmDisplay,creditCardDisplay,debitCardDisplay,roeDisplay,cmDisplay});
    }
    
    public List<Entity360.EntityViewModel> entityViewModels{
        get{
             List<DmEntity> entityDms = m_repository.getEntityDms(entityId);
             return m_vmBuilder.buildEntityVms(entityDms );
        }
    }
    
    public Entity360.EntityViewModel entityAggregateViewModel{
        get{
            List<DmEntity> entityDms = m_repository.getRelationshipEntityDmsByEntityId(entityId);
            Entity360.EntityViewModel vm = m_vmBuilder.buildAggregateEntityVm(entityDms);
            return (vm == null )? new Entity360.EntityViewModel() : vm;         
        }
    }
    
    private String entityId{
        get{
            return m_apexPages.getParameter('id');
        }
    }    
    
}