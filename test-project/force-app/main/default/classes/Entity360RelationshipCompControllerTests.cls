@IsTest
private class Entity360RelationshipCompControllerTests {

    private static final Entity360RelationshipComponentController sut;
    private static MockofIEntity360Repository m_mockRepository;
    private static MockofIEntity360VmBuilder m_mockVmBuilder;

    static {
        m_mockRepository = new MockofIEntity360Repository();
        m_mockVmBuilder = new MockofIEntity360VmBuilder();
        sut = new Entity360RelationshipComponentController(m_mockRepository, m_mockVmBuilder);
    }

    @IsTest
    static void it_should_call_the_repository() {
        sut.entityId = '000000000000a';
        List<Entity360.EntityViewModel> results = sut.entityViewModels;

        m_mockRepository.verify('getRelationshipEntityDmsByEntityId', new List<Object>{sut.entityId}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_vm_builder_with_the_entity_DMs_returned_by_the_repository() {
        DmEntity entityDm1 = new DmEntity();
        entityDm1.name = 'Test Testerson';
        List<DmEntity> entityDms = new List<DmEntity>{entityDm1};
        m_mockRepository.setup('getRelationshipEntityDmsByEntityId', new List<Object>{'000000000000a'}).returns(entityDms);

        sut.entityId = '000000000000a';
        List<Entity360.EntityViewModel> results = sut.entityViewModels;

        m_mockVmBuilder.verify('buildEntityVms', new List<Object> {entityDms}, Times.Once);
    }

    @IsTest
    static void it_should_return_the_vm_built_by_the_vm_builder() {
        DmEntity entityDm1 = new DmEntity();
        entityDm1.name = 'Test Testerson';
        List<DmEntity> entityDms = new List<DmEntity>{entityDm1};
        m_mockRepository.setup('getRelationshipEntityDmsByEntityId', new List<Object> {'000000000000a'}).returns(entityDms);
        Entity360.EntityViewModel entityVm1 = new Entity360.EntityViewModel();
        entityVm1.EntityName = entityDm1.name;
        List<Entity360.EntityViewModel> entityVms = new List<Entity360.EntityViewModel>{entityVm1};
        m_mockVmBuilder.setup('buildEntityVms', new List<Object> {entityDms}).returns(entityVms);

        sut.entityId = '000000000000a';
        List<Entity360.EntityViewModel> results = sut.entityViewModels;

        Entity360.EntityViewModel vm = results[0];
        System.assertEquals('Test Testerson', vm.EntityName);
    }
    
    @IsTest
    static void it_should_return_the_result_of_the_vm_builder_when_getting_aggregate_entity_view_model() {
        String entityid = '000000000000a';
        DmEntity entityDm = new DmEntity();
        entityDm.name = 'Test Testerson';
        List<DmEntity> entityDms = new List<DmEntity>{entityDm};
        Entity360.EntityViewModel entityVm = new Entity360.EntityViewModel();
        entityVm.EntityName = 'Bob';
        List<Entity360.EntityViewModel> entityVms = new List<Entity360.EntityViewModel>{entityVm};
        m_mockRepository.setup('getRelationshipEntityDmsByEntityId', new List<Object> { entityid }).returns(entityDms);
        m_mockVmBuilder.setup('buildAggregateEntityVm', new List<Object> {entityDms}).returns(entityVm);
        
        sut.entityId = entityid;
        Entity360.EntityViewModel aggregateResult = sut.entityAggregateViewModel;

        System.assertEquals(entityVm.EntityName, aggregateResult.EntityName);
    }

    @IsTest
    static void it_should_return_an_empty_list_of_VMs_when_no_entityId_is_provided() {
        List<Entity360.EntityViewModel> results = sut.entityViewModels;

        System.assertEquals(0, results.size());
    }
    
    @IsTest
    static void it_should_return_an_empty_of_VM_when_no_entityId_is_provided_and_aggregatevm_is_called() {
        Entity360.EntityViewModel result = sut.entityAggregateViewModel;

        System.assertNotEquals(null, result);
    }

    @IsTest
    static void code_coverage_for_constructor() {
        Entity360RelationshipComponentController controller = new Entity360RelationshipComponentController();
    }

    public class MockofIEntity360Repository extends ApexMoq implements Entity360.IEntity360Repository {
        public List<DmEntity> getEntityDms(String entityId){
            return (List<DmEntity>)handleMethodInvocation('getEntityDms', new List<Object> { entityId });
        }
        public List<DmEntity> getEntityDms(List<String> entityIds){
            return (List<DmEntity>)handleMethodInvocation('getEntityDms', new List<Object> { entityIds });
        }
        public List<DmEntity> getRelationshipEntityDmsByEntityId(String entityId){
            return (List<DmEntity>)handleMethodInvocation('getRelationshipEntityDmsByEntityId', new List<Object> { entityId });
        }
    }

    public class MockofIEntity360VmBuilder extends ApexMoq implements  Entity360.IEntity360VmBuilder {
        public List<Entity360.EntityViewModel> buildEntityVms(List<DmEntity> entityDms){
            return (List<Entity360.EntityViewModel>)handleMethodInvocation('buildEntityVms', new List<Object> { entityDms });
        }
        public Entity360.EntityViewModel buildAggregateEntityVm(List<DmEntity> entityDms){
            return (Entity360.EntityViewModel)handleMethodInvocation('buildAggregateEntityVm', new List<Object> { entityDms });
        }
    }
}