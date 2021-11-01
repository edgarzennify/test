public class TmOpportunityConverterPresenter implements TmOpportunityConverter.IPresenter {

	private final TmOpportunityConverter.IRepository m_repository;
	private final TmOpportunityConverter.IVmBuilder m_vmBuilder;

	public TmOpportunityConverterPresenter(TmOpportunityConverter.IVmBuilder vmBuilder, TmOpportunityConverter.IRepository repository) {
		m_vmBuilder = vmBuilder;
		m_repository = repository;
	}
	
    public TmOpportunityConverter.OpportunityDetails getOpportunityDetails(String opportunityId) {
		
    	DmOpportunity dm = m_repository.getOpportunity(opportunityId);
		List<DmTmPacket> packets = m_repository.getExistingTmPackets(dm.entity.Id);
		List<DmRecordType> products = m_repository.getRequestRecordTypes();
		Map<String, Set<String>> productMapping = m_repository.getOpportunityProducts(products);

    	return m_vmBuilder.buildOpportunityVm(dm, packets, products, productMapping);
    }

    public String save(TmOpportunityConverter.ConvertRequest request) {
    	String requestId = m_repository.save(request);
    	return requestId;
    }
}