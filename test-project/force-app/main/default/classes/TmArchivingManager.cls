public class TmArchivingManager implements TmArchiving.IManager {

	private final List<TmArchiving.IMapper> m_mappers;
	private final Utility.IUtility m_util;
	private final TmBoarding.IRepository m_repository;
	private final TmConfiguration.IRepository m_ConfigRepository;
	private final TmArchiving.ISmManager m_smManager;
	private final TmArchiving.IConfiguration m_config;
	private final TmArchiving.IRepository m_archiveRepository;
	private final TmArchiving.IVmBuilder m_vmBuilder;

	public TmArchivingManager(List<TmArchiving.IMapper> mappers, Utility.IUtility util, TmBoarding.IRepository repository, TmConfiguration.IRepository configRepository, TmArchiving.ISmManager smManager, TmArchiving.IConfiguration config, TmArchiving.IRepository archiveRepository , TmArchiving.IVmBuilder vmBuilder) {
		m_mappers = mappers;
		m_util = util;
		m_repository = repository;
		m_ConfigRepository = configRepository;
		m_smManager = smManager;
		m_config = config;
		m_archiveRepository = archiveRepository;
		m_vmBuilder = vmBuilder;
	}

	public List<TmArchiving.ArchiveReturn> buildTM(Tm_service_Request__c request) {
		
		TmBoarding.requestPm requestPm = new TmBoarding.requestPm();
		String productName = m_ConfigRepository.getRecordTypeName(request);

		List<TmArchiving.IMapper> mappers = getMapper(productName);

		if (mappers == null) {return null;}

		List<Treasury_Management__c> tmObjects = new List<Treasury_Management__c>();
		List<TM_Service_Contact__c> contactsList = new List<TM_Service_Contact__c>();
		List<EB_Account_Service__c> accountList = new List<EB_Account_Service__c>();
		List<TmArchiving.TreasuryManagementSm> saveReqs = new List<TmArchiving.TreasuryManagementSm>();

		List<RecordType> recordTypes = m_util.recordTypeObjects(TmConfiguration.TREASURY_MANAGEMENT);

		for(TmArchiving.IMapper mapper: mappers) {
			TmArchiving.QueryFields qr = mapper.build(request.Id);
			requestPm = m_ConfigRepository.getRequest(qr.requestId, qr.requestFields, qr.contactFields, qr.accountFields, qr.contactAccountFields, qr.contactCoreFields, qr.accountCoreFields);
			TmArchiving.MapperRequestContainer container = new TmArchiving.MapperRequestContainer();
			container.Pm = requestPm;
			container.recordTypes = recordTypes;

			TmArchiving.TreasuryManagementSm sr = buildSm(container,requestPm
														,contactsList,accountList,mapper);
			
			List<TmArchiving.TreasuryManagementSm> srs = mapper.postProcess(new List<TmArchiving.TreasuryManagementSm>{sr}, requestPm);
			if(srs != null){
				for(TmArchiving.TreasuryManagementSm sm : srs){
					if(sm != null){saveReqs.add(sm);}
				}				
			}
		}
		
		m_repository.save(m_smManager.getTms(saveReqs));

		m_repository.save(m_smManager.getContactsAndAccounts(saveReqs));

		m_repository.save(m_smManager.getEntities(saveReqs));

		List<Treasury_Management__c> tmObjs = new List<Treasury_Management__c>();
		for (TmArchiving.TreasuryManagementSm sm: saveReqs) {
			tmObjs.add(sm.core);
		}

		if(request != null && request.id != null) {m_repository.save(m_smManager.getArchives(request.id, tmObjs));}

		List<TmArchiving.ArchiveReturn> returnObjs = new List<TmArchiving.ArchiveReturn>();
		for(Treasury_Management__c obj: tmObjs) {
			TmArchiving.ArchiveReturn rObj = new TmArchiving.ArchiveReturn();
			rObj.archiveId = String.valueOf(obj.Id);
			returnObjs.add(rObj);
		}
		
		return returnObjs;
	}

	public List<TmArchiving.ArchiveLayout> getArchives(Tm_Service_Request__c request){
		if(request == null){ return null;}
		List<DmTmArchive> dms =  m_archiveRepository.getArchives(request.id);
		List<TmArchiving.ArchiveLayout> vms =  m_vmBuilder.build(dms); 
		return vms;
	}

	private List<TmArchiving.IMapper> getMapper(String recordTypeName) {
		List<TmArchiving.IMapper> rMappers = new List<TmArchiving.IMapper>();
		for(TmArchiving.IMapper mapper: m_mappers) {
			if(mapper.handle().tolowercase() == recordTypeName.toLowerCase()){
				rMappers.add(mapper);
			}
		}
		if (rMappers.size() == 0) {return null;}		
		return rMappers;
	}

	private TmArchiving.TreasuryManagementSm buildSm(TmArchiving.MapperRequestContainer container,
						 TMBoarding.RequestPm requestPm, List<TM_Service_Contact__c> contactsList,
						 List<EB_Account_Service__c> accountList, TmArchiving.IMapper mapper) {
		Treasury_Management__c tmObject = mapper.buildTmService(container);
		
		if(tmObject == null){return null;}

		List<TM_Service_Contact__c> contacts = mapper.buildContacts(requestPm, tmObject);
		List<EB_Account_Service__c> accounts = mapper.buildAccounts(requestPm, tmObject);

		TmArchiving.TreasuryManagementSm sr = new TmArchiving.TreasuryManagementSm();
		sr.core = tmObject;
		sr.contacts = contacts;
		sr.accounts = accounts;

		return sr;
	}
}