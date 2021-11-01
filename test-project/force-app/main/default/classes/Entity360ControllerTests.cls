@IsTest
private class Entity360ControllerTests {
    
    private static final Entity360Controller sut;
    private static final Mock.ofIApexPages m_mockApexPages;
    private static final MockofIEntity360Repository m_mockRepository;
    private static final MockofIEntity360VmBuilder m_mockVmBuilder;
    private static final Id m_entityId;

    static {
        m_entityId = '00118000003VHKS';
        m_mockApexPages = new Mock.ofIApexPages();
        m_mockApexPages.setup('getParameter', new List<object> { 'id' }).returns(m_entityId);
        m_mockRepository = new MockofIEntity360Repository();
        m_mockVmBuilder = new MockofIEntity360VmBuilder();
        sut = new Entity360Controller(m_mockApexPages, m_mockRepository, m_mockVmBuilder);
    }

    @IsTest
    static void it_should_get_the_id_from_apexpages_when_getting_entity_view_models() {
        List<Entity360.EntityViewModel> result = sut.entityViewModels;

        m_mockApexPages.verify('getParameter', new List<object> { 'id' }, Times.Once);
    }

    @IsTest
    static void it_should_call_the_repository_when_getting_entity_view_models() {
        List<Entity360.EntityViewModel> result = sut.entityViewModels;

        m_mockRepository.verify('getEntityDms', new List<object> { m_entityId }, Times.Once);
    }

    @IsTest
    static void it_should_call_the_vm_builder_with_the_list_of_DM_entities_recd_from_the_repository_when_getting_entity_view_models() {
        DmEntity entityDm = new DmEntity();
        entityDm.name = 'Test Testerson';
        List<DmEntity> entityDms = new List<DmEntity>{entityDm};
        m_mockRepository.setup('getEntityDms', new List<object> { m_entityId }).returns(entityDms);

        List<Entity360.EntityViewModel> result = sut.entityViewModels;

        m_mockVmBuilder.verify('buildEntityVms', new List<object> {entityDms}, Times.Once);
    }

    @IsTest
    static void it_should_return_the_results_of_the_vm_builder_when_getting_entity_view_models() {
        DmEntity entityDm = new DmEntity();
        entityDm.name = 'Test Testerson';
        List<DmEntity> entityDms = new List<DmEntity>{entityDm};
        Entity360.EntityViewModel entityVm = new Entity360.EntityViewModel();
        entityVm.EntityName = 'Bob';
        List<Entity360.EntityViewModel> entityVms = new List<Entity360.EntityViewModel>{entityVm};
        m_mockRepository.setup('getEntityDms', new List<object> { m_entityId }).returns(entityDms);
        m_mockVmBuilder.setup('buildEntityVms', new List<object> {entityDms}).returns(entityVms);

        List<Entity360.EntityViewModel> result = sut.entityViewModels;

        Entity360.EntityViewModel first = result[0];
        System.assertEquals(entityVm.EntityName, first.EntityName);
    }
    
    @IsTest
    static void it_should_return_the_result_of_the_vm_builder_when_getting_aggregate_entity_view_model() {
        DmEntity entityDm = new DmEntity();
        entityDm.name = 'Test Testerson';
        List<DmEntity> entityDms = new List<DmEntity>{entityDm};
        Entity360.EntityViewModel entityVm = new Entity360.EntityViewModel();
        entityVm.EntityName = 'Bob';
        List<Entity360.EntityViewModel> entityVms = new List<Entity360.EntityViewModel>{entityVm};
        m_mockRepository.setup('getRelationshipEntityDmsByEntityId', new List<object> { m_entityId }).returns(entityDms);
        m_mockVmBuilder.setup('buildAggregateEntityVm', new List<object> {entityDms}).returns(entityVm);

        Entity360.EntityViewModel aggregateResult = sut.entityAggregateViewModel;

        System.assertEquals(entityVm.EntityName, aggregateResult.EntityName);
    }
    
    @IsTest
    static void it_should_return_an_empty_of_VM_when_no_entityId_is_provided_and_aggregatevm_is_called() {
        Entity360.EntityViewModel result = sut.entityAggregateViewModel;

        System.assertNotEquals(null, result);
    }

    @IsTest
    static void code_coverage_constructor_test() {
        Entity360Controller cc = new Entity360Controller(new ApexPages.StandardController(new Account()));
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

    public class MockofIEntity360VmBuilder extends ApexMoq implements  Entity360.IEntity360VmBuilder {
        public List<Entity360.EntityViewModel> buildEntityVms(List<DmEntity> entityDms){
            return (List<Entity360.EntityViewModel>)handleMethodInvocation('buildEntityVms', new List<object> { entityDms });
        }
        public Entity360.EntityViewModel buildAggregateEntityVm(List<DmEntity> entityDms){
            return (Entity360.EntityViewModel)handleMethodInvocation('buildAggregateEntityVm', new List<object> { entityDms });
        }
    }
}