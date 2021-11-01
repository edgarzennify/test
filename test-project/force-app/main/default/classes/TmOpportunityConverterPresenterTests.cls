@IsTest
private class TmOpportunityConverterPresenterTests { 

    private static TmOpportunityConverterPresenter sut;
    private final static TmOpportunityConverterMock.ofIVmBuilder m_vmBuilder;
    private final static TmOpportunityConverterMock.ofIRepository m_repository;

    static {
            m_vmBuilder = new TmOpportunityConverterMock.ofIVmBuilder();
            m_repository = new TmOpportunityConverterMock.ofIRepository();
            sut = new TmOpportunityConverterPresenter(m_vmBuilder, m_repository);
        }

    @IsTest
    static void it_should_call_repository_to_get_opportunity_dm() {
        String opportunityId = '1234';
        DmOpportunity dm = new DmOpportunity();
        dm.entity = new DmEntity();
        m_repository.setup('getOpportunity', new List<Object>{opportunityId}).returns(dm);

        sut.getOpportunityDetails(opportunityId);

        m_repository.verify('getOpportunity', new List<Object>{opportunityId}, Times.Once);
    }

    @IsTest
    static void it_should_call_repository_to_get_existing_packet() {
        String opportunityId = '1234';
        String entityId = '3435';
        DmOpportunity dm = new DmOpportunity();
        dm.entity = new DmEntity();
        dm.entity.Id = entityId;
        m_repository.setup('getOpportunity', new List<Object>{opportunityId}).returns(dm);

        sut.getOpportunityDetails(opportunityId);

        m_repository.verify('getExistingTmPackets', new List<Object>{dm.entity.Id}, Times.Once);
    }

    @IsTest
    static void it_should_call_repository_to_get_products() {
        String opportunityId = '1234';
        String entityId = '3435';
        DmOpportunity dm = new DmOpportunity();
        dm.entity = new DmEntity();
        dm.entity.Id = entityId;
        m_repository.setup('getOpportunity', new List<Object>{opportunityId}).returns(dm);
        m_repository.setup('getExistingTmPackets', new List<Object>{dm.entity.Id}).returns(new List<DmTmPacket>());

        sut.getOpportunityDetails(opportunityId);

        m_repository.verify('getRequestRecordTypes', Times.Once);
    }

    @IsTest
    static void it_should_call_the_vmbuilder_to_build_opportunity_vm() {
        String opportunityId = '1234';
        String entityId = '3435';
        DmOpportunity opportunityDm = new DmOpportunity();
        opportunityDm.entity = new DmEntity();
        opportunityDm.entity.Id = entityId;
        List<DmRecordType> products = new List<DmRecordType>();
        List<DmTmPacket> packets = new List<DmTmPacket>();
        m_repository.setup('getOpportunity', new List<Object>{opportunityId}).returns(opportunityDm);
        m_repository.setup('getExistingTmPackets', new List<Object>{opportunityDm.entity.Id}).returns(packets);
        m_repository.setup('getRequestRecordTypes').returns(products);

        sut.getOpportunityDetails(opportunityId);

        m_vmBuilder.verify('buildOpportunityVm', new List<Object>{opportunityDm, packets, products}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_save() {
        TmOpportunityConverter.ConvertRequest convertRequest = new TmOpportunityConverter.ConvertRequest();
        String returnId = '5435';

        m_repository.setup('save', new List<Object>{convertRequest}).returns(returnId);

        String results = sut.save(convertRequest);

        m_repository.verify('save', new List<Object>{convertRequest}, Times.Once);
        System.assertEquals(returnId, results);
    }
}