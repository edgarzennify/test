@IsTest
private class Entity360RepositoryTests {

    private static Entity360Repository sut;
    private static MockofIEntity360DataProvider m_mockEntity360DataProvider;
    private static MockofIEntity360Delegate m_mockLoanDelegate;
    private static MockofIEntity360Delegate m_mockDepositDelegate;
    private static MockofIEntity360Delegate m_mockTreasuryDelegate;
    private static DmProductOverview m_loanProductOverview = new DmProductOverview();
    private static DmProductOverview m_depositProductOverview = new DmProductOverview();
    private static DmProductOverview m_treasuryProductOverview = new DmProductOverview();

      static {
        m_loanProductOverview.type = Entity360.ElementType.LOAN;
        m_depositProductOverview.type = Entity360.ElementType.DEPOSIT;
        m_treasuryProductOverview.type = Entity360.ElementType.TREASURY;
        m_mockEntity360DataProvider = new MockofIEntity360DataProvider();
        m_mockLoanDelegate = new MockofIEntity360Delegate();
        m_mockLoanDelegate.setup('assembleFrom', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(m_loanProductOverview);
        m_mockDepositDelegate = new MockofIEntity360Delegate();
        m_mockDepositDelegate.setup('assembleFrom', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(m_depositProductOverview);
        m_mockTreasuryDelegate = new MockofIEntity360Delegate();
        m_mockTreasuryDelegate.setup('assembleFrom', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(m_treasuryProductOverview);
        sut = new Entity360Repository(m_mockEntity360DataProvider, new List<Entity360.IEntity360Delegate> { m_mockLoanDelegate, m_mockDepositDelegate, m_mockTreasuryDelegate});
    }

    @IsTest
    static void it_should_call_the_dataprovider_and_delegates_when_getting_entity_DMs_and_entityId_is_provided() {
        DmEntity entity = new DmEntity();
        m_mockEntity360DataProvider.setup('GetDmEntities', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<DmEntity> { entity });

        List<DmEntity> result = sut.getEntityDms('123');

        System.assertEquals(1, result.size());
        m_mockEntity360DataProvider.verify('GetDmEntities', new List<object> { new List<String> { '123' } }, Times.Once);
        m_mockLoanDelegate.verify('assembleFrom', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        m_mockDepositDelegate.verify('assembleFrom', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        m_mockTreasuryDelegate.verify('assembleFrom', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        DmEntity eResult = result[0];
        System.assertEquals(m_loanProductOverview, eResult.productOverviews[0]);
        System.assertEquals(m_depositProductOverview, eResult.productOverviews[1]);
        System.assertEquals(m_treasuryProductOverview, eResult.productOverviews[2]);
    }

    @IsTest
    static void it_should_calculate_the_total_entity_cm_when_getting_entity_DMs_and_entityId_is_provided() {
        DmEbAccount acct1 = new DmEbAccount();
        acct1.ytdContributionMargin = 123.45;
        DmEbAccount acct2 = new DmEbAccount();
        acct2.ytdContributionMargin = 876.54;       
        DmEntity entity = new DmEntity();
        entity.ownedAccounts = new List<DmEbAccount>{ acct1, acct2 };
        m_mockEntity360DataProvider.setup('GetDmEntities', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<DmEntity> { entity });

        List<DmEntity> result = sut.getEntityDms('123');

        DmEntity eResult = result[0];
        System.assertEquals(999.99, eResult.cm);
    }

    @IsTest
    static void it_should_call_the_dataprovider_and_delegates_when_getting_entity_DMs_and_entities_are_provided() {
        DmEntity e1 = new DmEntity();
        DmEntity e2 = new DmEntity();
        m_mockEntity360DataProvider.setup('GetDmEntities', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<DmEntity> { e1, e2 });
        List<String> entityIds = new List<String> { '123', '234' };

        List<DmEntity> result = sut.getEntityDms(entityIds);

        System.assertEquals(2, result.size());
        m_mockEntity360DataProvider.verify('GetDmEntities', new List<object> { entityIds }, Times.Once);
        m_mockLoanDelegate.verify('assembleFrom', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Twice);
        m_mockDepositDelegate.verify('assembleFrom', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Twice);
        m_mockTreasuryDelegate.verify('assembleFrom', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Twice);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_get_all_relationship_entities_given_an_entityId() {
        String entityId = '000000000000a';

        DmEntity entityDm = new DmEntity();
        entityDm.id = entityId;
        entityDm.name = 'Mr. Testerson';
        List<DmEntity> entityDms = new List<DmEntity>{entityDm};
        
        m_mockEntity360DataProvider.setup('getAllRelationshipEntitiesBySingleEntityId', new List<object> { entityId }).returns(entityDms);

        List<DmEntity> result = sut.getRelationshipEntityDmsByEntityId(entityId);

        m_mockEntity360DataProvider.verify('getAllRelationshipEntitiesBySingleEntityId', new List<object> { entityId }, Times.Once);
    }

    @IsTest
    static void it_should_return_all_the_entities_for_the_relationship() {
        String entityId = '000000000000a';
        String otherEntityId = '00000000000b';

        DmEntity entityDm = new DmEntity();
        entityDm.id = otherEntityId;
        entityDm.name = 'Mr. Bob Testerson';
        DmEntity entityDm2 = new DmEntity();
        entityDm2.id = entityId;
        entityDm2.name = 'Mr. Testerson';
        List<DmEntity> entityDms = new List<DmEntity>{entityDm, entityDm2};

        DmEbAccount ebAccount1 = new DmEbAccount();
        ebAccount1.application = 11;
        ebAccount1.ytdContributionMargin = 123.45;
        DmEbAccount ebAccount2 = new DmEbAccount();
        ebAccount2.application = 2;
        ebAccount2.ytdContributionMargin = 876.54;
        entityDm.ownedAccounts = new List<DmEbAccount>{ebAccount1, ebAccount2};

        m_mockEntity360DataProvider.setup('getAllRelationshipEntitiesBySingleEntityId', new List<object> { entityId }).returns(entityDms);

        List<DmEntity> result = sut.getRelationshipEntityDmsByEntityId(entityId);

        m_mockLoanDelegate.verify('assembleFrom', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Twice);
        m_mockDepositDelegate.verify('assembleFrom', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Twice);
        m_mockTreasuryDelegate.verify('assembleFrom', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Twice);
        DmEntity dm = result[0];
        System.assertEquals('00000000000b', dm.id);
        System.assertEquals('Mr. Bob Testerson', dm.name);
        System.assertEquals(999.99,dm.cm);
    }

    public class MockofIEntity360DataProvider extends ApexMoq implements Entity360.IEntity360DataProvider {
        public List<DmEntity> GetDmEntities(List<String> entityIds) {
            return (List<DmEntity>)handleMethodInvocation('GetDmEntities', new List<Object>{entityIds});
        }
        public List<DmEntity> getAllRelationshipEntitiesBySingleEntityId(String entityId) {
            return (List<DmEntity>)handleMethodInvocation('getAllRelationshipEntitiesBySingleEntityId', new List<Object>{entityId});
        }
    }

    public class MockofIEntity360Delegate extends ApexMoq implements Entity360.IEntity360Delegate {
        public DmProductOverview assembleFrom(DmEntity entityDm) {
            return (DmProductOverview)handleMethodInvocation('assembleFrom', new List<object> { entityDm });
        }
    }
}