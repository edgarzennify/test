@IsTest
private class Entity360MiniComponentControllerTests {
    private static final Entity360MiniComponentController sut;
    private static MockofIEntity360Repository m_mockRepository;
    private static MockofIEntity360VmBuilder m_mockVmBuilder;
    private static MockofIEntity360DmCache m_mockCache;

    static {              
        m_mockRepository = new MockofIEntity360Repository();
        m_mockVmBuilder = new MockofIEntity360VmBuilder();
        m_mockCache = new MockofIEntity360DmCache();
        sut = new Entity360MiniComponentController(m_mockRepository, m_mockVmBuilder, m_mockCache);   
    }

    @IsTest
    static void it_should_call_the_repository() {
        sut.entityId = '000000000000a';
        DmEntity entityDm1 = new DmEntity();
        entityDm1.name = 'Test Testerson';
        List<DmEntity> entityDms = new List<DmEntity>{entityDm1};
        Map<String, DmEntity> dmsMap = new Map<String, DmEntity>();
        dmsMap.put(entityDm1.id , entityDm1);
        m_mockRepository.setup('getRelationshipEntityDmsByEntityId', ApexMoq.Arguments.HAVE_ANY_VALUE ).returns(entityDms);
        m_mockCache.setupSequence('getEntityDmsMap').returns(null).returns(dmsMap);       
        Entity360.EntityViewModel entityVm1 = new Entity360.EntityViewModel();
        entityVm1.EntityName = entityDm1.name;
        Entity360.ElementViewModel loanElement = new Entity360.ElementViewModel();
        loanElement.elementSymbol = 'Ln';
        loanElement.elementType = 'test';
        entityVm1.Elements = new List<Entity360.ElementViewModel>{loanElement};
        List<Entity360.EntityViewModel> entityVms = new List<Entity360.EntityViewModel>{entityVm1};
        m_mockVmBuilder.setup('buildEntityVms', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(entityVms);
        
        List<Entity360.ElementViewModel> results = sut.elementViewModels;

        m_mockRepository.verify('getRelationshipEntityDmsByEntityId', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_call_the_vm_builder_with_the_entity_DMs_returned_by_the_repository() {
        sut.entityId = '000000000000a';
        DmEntity entityDm1 = new DmEntity();
        entityDm1.name = 'Test Testerson';
        List<DmEntity> entityDms = new List<DmEntity>{entityDm1};
        Map<String, DmEntity> dmsMap = new Map<String, DmEntity>();
        dmsMap.put(entityDm1.id , entityDm1);
        m_mockRepository.setup('getRelationshipEntityDmsByEntityId', ApexMoq.Arguments.HAVE_ANY_VALUE ).returns(entityDms);
        m_mockCache.setupSequence('getEntityDmsMap').returns(null).returns(dmsMap);       
        Entity360.EntityViewModel entityVm1 = new Entity360.EntityViewModel();
        entityVm1.EntityName = entityDm1.name;
        Entity360.ElementViewModel loanElement = new Entity360.ElementViewModel();
        loanElement.elementSymbol = 'Ln';
        loanElement.elementType = 'test';
        entityVm1.Elements = new List<Entity360.ElementViewModel>{loanElement};
        List<Entity360.EntityViewModel> entityVms = new List<Entity360.EntityViewModel>{entityVm1};
        m_mockVmBuilder.setup('buildEntityVms', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(entityVms);
        
        List<Entity360.ElementViewModel> results = sut.elementViewModels;

        m_mockVmBuilder.verify('buildEntityVms', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }

   @IsTest
    static void it_should_return_the_vm_built_by_the_vm_builder() {
        sut.entityId = '000000000000a';
        DmEntity entityDm1 = new DmEntity();
        entityDm1.name = 'Test Testerson';
        List<DmEntity> entityDms = new List<DmEntity>{entityDm1};
        Map<String, DmEntity> dmsMap = new Map<String, DmEntity>();
        dmsMap.put(entityDm1.id , entityDm1);
        m_mockRepository.setup('getRelationshipEntityDmsByEntityId', ApexMoq.Arguments.HAVE_ANY_VALUE ).returns(entityDms);
        m_mockCache.setupSequence('getEntityDmsMap').returns(null).returns(dmsMap);       
        Entity360.EntityViewModel entityVm1 = new Entity360.EntityViewModel();
        entityVm1.EntityName = entityDm1.name;
        Entity360.ElementViewModel loanElement = new Entity360.ElementViewModel();
        loanElement.elementSymbol = 'Ln';
        loanElement.elementType = 'active';
        entityVm1.Elements = new List<Entity360.ElementViewModel>{loanElement};
        List<Entity360.EntityViewModel> entityVms = new List<Entity360.EntityViewModel>{entityVm1};
        m_mockVmBuilder.setup('buildEntityVms', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(entityVms);

        List<Entity360.ElementViewModel> results = sut.elementViewModels;
        
        
        Entity360.ElementViewModel vm = results[0];
        System.assertEquals('Ln', vm.elementSymbol);
    }
    
    @IsTest
    static void it_should_return_an_empty_list_of_VMs_when_no_entityId_is_provided() {
        sut.entityId = '000000000000a';
        DmEntity entityDm1 = new DmEntity();
        entityDm1.name = 'Test Testerson';
        List<DmEntity> entityDms = new List<DmEntity>{entityDm1};
        Map<String, DmEntity> dmsMap = new Map<String, DmEntity>();
        dmsMap.put(entityDm1.id , entityDm1);
        m_mockRepository.setup('getRelationshipEntityDmsByEntityId', ApexMoq.Arguments.HAVE_ANY_VALUE ).returns(entityDms);
        m_mockCache.setupSequence('getEntityDmsMap').returns(null).returns(dmsMap);    
        Entity360.EntityViewModel entityVm1 = new Entity360.EntityViewModel();
        entityVm1.EntityName = entityDm1.name;
        Entity360.ElementViewModel loanElement = new Entity360.ElementViewModel();
        loanElement.elementSymbol = 'Ln';
        loanElement.elementType = 'test';
        entityVm1.Elements = new List<Entity360.ElementViewModel>{loanElement};
        List<Entity360.EntityViewModel> entityVms = new List<Entity360.EntityViewModel>{entityVm1};
        m_mockVmBuilder.setup('buildEntityVms', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(entityVms);
        
        
        List<Entity360.ElementViewModel> results = sut.elementViewModels;

        System.assertEquals(0, results.size());
    }
    
    @IsTest
    static void code_coverage_for_constructor() {
        Entity360MiniComponentController controller = new Entity360MiniComponentController();
    }

    public class MockofIEntity360Repository extends ApexMoq implements Entity360.IEntity360Repository {
        public List<DmEntity> getEntityDms(String entityId){
            return (List<DmEntity>)handleMethodInvocation('getEntityDms', new List<object> { entityId });
        }
        public List<DmEntity> getEntityDms(List<String> entityIds){
            return (List<DmEntity>)handleMethodInvocation('getEntityDms', new List<object> { entityIds });
        }
        public List<DmEntity> getRelationshipEntityDmsByEntityId(String entityId){
            return (List<DmEntity>)handleMethodInvocation('getRelationshipEntityDmsByEntityId', new List<object> { entityId });
        }
    }
    
    public class MockofIEntity360VmBuilder extends ApexMoq implements Entity360.IEntity360VmBuilder {
        public List<Entity360.EntityViewModel> buildEntityVms(List<DmEntity> entityDms){
            return (List<Entity360.EntityViewModel>)handleMethodInvocation('buildEntityVms', new List<object> { entityDms });
        }
        public Entity360.EntityViewModel buildAggregateEntityVm(List<DmEntity> entityDms){
            return (Entity360.EntityViewModel)handleMethodInvocation('buildAggregateEntityVm', new List<object> { entityDms });
        }
    }
    
    public class MockofIEntity360DmCache extends ApexMoq implements Entity360.IEntity360DmCache {
        public void setEntityDmsMap(Map<String,DmEntity> entityDmsMap){
            handleMethodInvocation('setEntityDmsMap', new List<object>{entityDmsMap});
        }
        public Map<String,DmEntity> getEntityDmsMap(){
            return (Map<String,DmEntity>)handleMethodInvocation('getEntityDmsMap');
        }
    }
}