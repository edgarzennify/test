public class TmOpportunityConverterRepository implements TmOpportunityConverter.IRepository{
	private String PRODUCT_DELIM = ';';

	private final TmBoarding.IDataProvider m_dataProvider;
	private final TmOpportunityConverter.IDmBuilder m_dmBuilder;
	private final TmOpportunityConverter.IOpportunityBuilder m_opportunityBuilder;
	private final TmConfiguration.IStageRepository m_stageRepository;
	private final Utility.IUtility m_util;
	private final List<TmOpportunityConverter.IMapper> m_mappers;
	private final List<TmOpportunityConverter.IOpportunityMapper> m_opportunityMappers;


	public TmOpportunityConverterRepository(TmBoarding.IDataProvider dataProvider, TmOpportunityConverter.IDmBuilder dmBuilder,
	 TmOpportunityConverter.IOpportunityBuilder opportunityBuilder ,Utility.IUtility util,
	  TmConfiguration.IStageRepository stageRepository, List<TmOpportunityConverter.IMapper> mappers, List<TmOpportunityConverter.IOpportunityMapper> opportunityMappers) {
		m_dataProvider = dataProvider;
		m_dmBuilder = dmBuilder;
		m_opportunityBuilder = opportunityBuilder;
		m_util = util;
		m_stageRepository = stageRepository;
		m_mappers = mappers;
		m_opportunityMappers = opportunityMappers;
	}

	public DmOpportunity getOpportunity(String opportunityId) {
		Opportunity op = m_dataProvider.getOpportunity(opportunityId);
		return m_dmBuilder.build(op);
	}

	public List<DmTmPacket> getExistingTmPackets(String entityId) {
		List<Tm_Service_Request_Packet__c> packetPms = m_dataProvider.getPacketsFromEntity(entityId);
		return build(packetPms);
	}

	public List<DmRecordType> getRequestRecordTypes() {
		List<DmRecordType> dms = new List<DmRecordType>();
		for(RecordType r : m_util.recordTypeObjects(TmConfiguration.TM_REQUEST)) {
			DmRecordType dm = m_dmBuilder.build(r);
			if(dm.IsActive){
				dms.add(dm);
			}
		}
		return dms;
	} 

	public Map<String, Set<String>> getOpportunityProducts(List<DmRecordType>  products) {
		List<String> productNames = new List<String>();
		Map<String, TmBoarding.RequestConfigPm> configMap = new Map<String, TmBoarding.RequestConfigPm>();
		Map<string, TmBoarding.RequestConfigPm> configPmByService = m_dataprovider.getAllPageFieldConfigurationsByServiceType();
		for(DmRecordType dm : products) {
			productNames.add(dm.name);
			if(!configMap.containsKey(dm.name)) {
				try{
					TmBoarding.RequestConfigPm cfg = configPmByService.get(dm.name);	
					configMap.put(dm.name,  cfg);
				}catch(exception ex){

				}
			}
		}
		
		return m_opportunityBuilder.getOpportunityProducts(productNames, configMap);
	}

	public Opportunity updateOpportunityOnPacket(TM_Service_Request__c record, String product) {
		Tm_Service_Request_Packet__c packet = m_dataprovider.getPacket(record);
		DmOpportunity opportunityDm = getOpportunity(packet.Opportunity__c);
		List<String> products = new List<String>();
		products.add(product);
		Map<String, TmBoarding.RequestConfigPm> configMap = getConfigMap(products);
		Map<String, Set<String>> productMap = m_opportunityBuilder.getOpportunityProducts(products, configMap);
		return m_opportunityBuilder.getUpdatedOpportunity(opportunityDm, productMap, products);
	}

	public String save(TmOpportunityConverter.ConvertRequest request) {
		Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c();
		if(String.isNotBlank(request.OpportunityId)) {
			packet.Opportunity__c = request.OpportunityId;
		}
		if(String.isNotBlank(request.packetId)) {
			packet.Id = request.packetId;
		}else {
			packet.Entity__c = request.EntityId;
			packet.name = request.PacketName;
			packet.Bundle_Type__c = request.BundleType;
			packet.Client_Type__c = request.ClientType;
		    m_dataProvider.save(new List<SObject>{packet});
		}

		Map<String, TmBoarding.RequestConfigPm> configMap = getConfigMap(request.Products);
		Map<String, Set<String>> productMap = m_opportunityBuilder.getOpportunityProducts(request.Products, configMap);
		List<DmRecordType> recordTypes = getRequestRecordTypes();
		List<TM_Service_Request__c> newRequests = buildNewRequests(request, packet, recordTypes);
		DmOpportunity opportunityDm = getOpportunity(request.OpportunityId);
		Opportunity o = m_opportunityBuilder.getUpdatedOpportunity(opportunityDm, productMap, request.Products);
	
		if(o!= null && o.id != null) {
			List<SObject> sobj = new List<SObject>();
			sobj.add(o);
			m_dataprovider.save(sobj);
		}
	
		return saveTmRequests(newRequests, opportunityDm, productMap, recordTypes);
	}

	public void updateOpportunityForWithdrawnProduct(TmBoarding.RequestPm requestPm) {
		String opportunityId = requestPm.packetPm.Opportunity__c;
		String product = requestPm.requestPm.RecordType.Name;
		Id requestId = requestPm.requestPm.Id;

		DmTmRequestStage stageDm = m_stageRepository.getStageDetail(requestId);
		if(String.isBlank(stageDm.Type) || stageDm.Type.tolowercase() !=  'withdraw') {return; }

		Opportunity opp = m_dataProvider.getOpportunity(opportunityId);
		Map<String, TmBoarding.RequestConfigPm> configMap = getConfigMap(new List<string>{product});
		String relatedToProduct = configMap.values()[0].productPm.Related_To_Opportunity_Products__c;
		if(String.isBlank(relatedToProduct) ||string.isBlank(opp.Products__c) ){ return; }

		List<string> related = relatedToProduct.split('\\,');
		Set<string> relatedSet = new Set<string>();
		relatedSet.addAll(related);

		List<String> opportunityProduct = opp.Products__c.split(';');

		List<String> updatedOpportunityProduct = new List<String>();
		for(String r : opportunityProduct) {
			if(!relatedSet.contains(r)){
				updatedOpportunityProduct.add(r);
			}
		}
		if(updatedOpportunityProduct.size() > 0) {
			opp.Products__c = String.Join(updatedOpportunityProduct, ';');
			update opp;	
		}
	}

	private List<TM_Service_Request__c> buildNewRequests(TmOpportunityConverter.ConvertRequest request, Tm_Service_Request_Packet__c packet, List<DmRecordType> recordTypes) {
		Set<String> existingProducts = getExistingProductsFromPacket(request.PacketId);
		List<TM_Service_Request__c> newRequests = new List<TM_Service_Request__c>();
		String stageId = m_stageRepository.getDefaultStage().Id;
		for(String product : request.Products) {
			for(DmRecordType rec : recordTypes) {
				String recName = rec.name.tolowercase();
				if(recName == product.toLowerCase()) {
					if(!existingProducts.contains(recName)) {
						TM_Service_Request__c r = new TM_Service_Request__c();
						r.RecordTypeId = rec.Id;
						r.TM_Service_Request_Packet__c = packet.Id;					
						if(!String.isBlank(stageId)) {
							r.Stage__c = stageId;
						}
						newRequests.add(r);
					}
				}
			}
		}
		return newRequests;
	}

	private List<DmTmPacket> build(List<Tm_Service_Request_Packet__c> packetPms) {
		List<DmTmPacket> packetDms = new List<DmTmPacket>();
		if(packetPms == null || packetPms.size() == 0){return packetDms;}

		for(Tm_Service_Request_Packet__c p : packetPms) {
			packetDms.add(m_DmBuilder.build(p));
		}
		return packetDms;
	}

	private Set<String> getExistingProductsFromPacket(String packetId) {
		Set<String> products = new Set<String>();
		if(string.isBlank(packetId)) {return products;}
		List<Tm_Service_Request__c> requests = m_dataProvider.getRequestsForPacket(packetId);
		if(requests == null || requests.size() == 0) {return products;}

		for(Tm_Service_Request__c req : m_dataProvider.getRequestsForPacket(packetId)) {
			products.add(req.RecordType.Name.toLowerCase());
		}
		return products;
	}

	private Map<String, TmBoarding.RequestConfigPm> getConfigMap(List<String> products) {
		Map<String , TmBoarding.RequestConfigPm> configMap = new Map<String, TmBoarding.RequestConfigPm>();
		Map<string, TmBoarding.RequestConfigPm> configPmByService = m_dataprovider.getAllPageFieldConfigurationsByServiceType();
		for(String product : products) {
			if(!configMap.containsKey(product)) {
				try{
					TmBoarding.RequestConfigPm cfg = configPmByService.get(product);
					configMap.put(product,  cfg);
				}catch(Exception ex){
					
				}
				
			}
		}
		return configMap;
	}

	private string saveTmRequests(List<TM_Service_Request__c> requests, DmOpportunity opportunityDm, Map<string, Set<string>> productMapping, List<DmRecordType> recordTypes) {

		if(requests == null || requests.size() == 0) return '';

		Map<Id,string> recordTypeMap = new Map<Id, string>();
		List<Tm_Service_Request__c> updatedRequestsBasedOnTmRequest = new List<Tm_Service_Request__c>();
		List<Tm_Service_Request__c> updatedRequestsBasedOnOpportunity = new List<Tm_Service_Request__c>();

		for(DmRecordType r : recordTypes) {
			recordTypeMap.put(r.id, r.Name);
		}

		for(Tm_Service_Request__c r : requests) {
			string product = recordTypeMap.get(r.RecordTypeId);
			TmOpportunityConverter.IMapper m = findTmRequestHandler(product);
		
			Set<string> subProducts = productMapping.get(product);
			if(m != null){
				List<string> bankProducts = opportunityDm.BankProducts;
				Tm_Service_Request__c updatedRequest = m.updateTmObject(r, bankProducts , subProducts);			
				updatedRequestsBasedOnTmRequest.add(updatedRequest);
			}else{
				updatedRequestsBasedOnTmRequest.add(r);
			}


		}

		String opportunityRecordTypeName = opportunityDm.RecordType == null?'':opportunityDm.RecordType.Name;
		TmOpportunityConverter.IOpportunityMapper opp = findOpportunityHandler(opportunityRecordTypeName);

		if( opp!= null){
			for(Tm_Service_Request__c r: updatedRequestsBasedOnTmRequest){
				Tm_Service_Request__c updatedBasedOnOpportunity = opp.updateTmObject(r, opportunityDm);
				updatedRequestsBasedOnOpportunity.add(updatedBasedOnOpportunity);
			}

			if(updatedRequestsBasedOnOpportunity.size() > 0){
				m_dataProvider.save(updatedRequestsBasedOnOpportunity);
				return updatedRequestsBasedOnOpportunity[0].Id;
			}
		}	

		if(updatedRequestsBasedOnTmRequest.size() > 0){
			m_dataProvider.save(updatedRequestsBasedOnTmRequest);
			return updatedRequestsBasedOnTmRequest[0].Id;
		}
		return '';
	}

	private TmOpportunityConverter.IMapper findTmRequestHandler(string product) {
		for(TmOpportunityConverter.IMapper m: m_mappers) {
			if(m != null && m.handle().tolowercase() == product.tolowercase()) {
				return m;
			}
		}
		return null;
	}

	private TmOpportunityConverter.IOpportunityMapper findOpportunityHandler(string opportunityRecordType){
		for(TmOpportunityConverter.IOpportunityMapper o: m_opportunityMappers){
			if(o != null && o.handle().toLowerCase() == opportunityRecordType.tolowerCase()){
				return o;
			}
		}
		return null;
	}
}