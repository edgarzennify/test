public class TmArchivingOnlineBKMapperHelper implements TmArchiving.IOnlineBankingMapperHelper {

	private final TmArchiving.IMapper m_achMapper;
	private final TmArchiving.IMapper m_wiresMapper;
	private final TmConfiguration.IRepository m_configRepository;
	private final TmArchiving.IConfiguration m_config;	

	public TmArchivingOnlineBKMapperHelper(TmArchiving.IMapper achMapper , TmArchiving.IMapper wiresMapper , TmConfiguration.IRepository configRepository ,  TmArchiving.IConfiguration config)
	{
		m_achMapper = achMapper;
		m_wiresMapper = wiresMapper;
		m_configRepository = configRepository; 
		m_config = config;
	}

	public TmBoarding.RequestPm getAchRequestPm(TmArchiving.MapperRequestContainer container) {
		if(container == null || container.Pm == null || container.Pm.packetRequestsPm == null){return null;}
		
		Tm_Service_Request__c achRequest = null;
		for(Tm_service_Request__c req : container.Pm.packetRequestsPm){ 
			if(req.RecordTypeId != null && req.RecordType.Name.toLowerCase() == m_config.RECORDTYPE_ACH().toLowerCase()){
				achRequest = req;
			}
		}

		if(achRequest != null){
			TmArchiving.QueryFields fields = m_achMapper.build(achRequest.Id);
			return m_ConfigRepository.getRequest(achRequest.Id, fields.requestFields, new List<string>(), new List<string>(), new List<string>(), fields.contactCoreFields, fields.accountCoreFields);
		}

		return null;
	}

	public TmBoarding.RequestPm getWiresRequestPm(TmArchiving.MapperRequestContainer container) {
		if(container == null || container.Pm == null || container.Pm.packetRequestsPm == null){return null;}
		
		Tm_Service_Request__c wiresRequest = null;
		for(Tm_service_Request__c req : container.Pm.packetRequestsPm){ 
			if(req.RecordTypeId != null && req.RecordType.Name.toLowerCase() == m_config.RECORDTYPE_WIRES().toLowerCase()){
				wiresRequest = req;
			}
		}

		if(wiresRequest != null){
			TmArchiving.QueryFields fields = m_wiresMapper.build(wiresRequest.Id);
			return m_ConfigRepository.getRequest(wiresRequest.Id, fields.requestFields, new List<string>(), new List<string>(), new List<string>(), fields.contactCoreFields, fields.accountCoreFields);
		}

		return null;
	}
}