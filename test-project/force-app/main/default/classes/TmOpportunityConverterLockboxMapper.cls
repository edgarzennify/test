public class TmOpportunityConverterLockboxMapper implements TmOpportunityConverter.IMapper {

	private final TmOpportunityConverter.IConfiguration m_config;

	public TmOpportunityConverterLockboxMapper(TmOpportunityConverter.IConfiguration config) {
		m_config = config;
	}

	public string handle() {
		return m_config.RECORDTYPE_LOCKBOX();
	}

	public Tm_Service_Request__c updateTmObject(TM_Service_Request__c request, List<string> opportunityProducts, Set<string> subProductsByProduct) {

		Set<string> selectedSubProducts = new Set<string>();
		if(subProductsByProduct == null || subProductsByProduct.size() == 0) {return request;}

		for(String op : opportunityProducts) {
			if(subProductsByProduct.contains(op) == true) {
				selectedSubProducts.add(op.toLowerCase());
			}
		}
		Tm_Service_Request__c updated = setSubProducts(request, selectedSubProducts);
		return updated;

	}

	private Tm_Service_Request__c setSubProducts(TM_Service_Request__c request, Set<string> selectedSubProducts) {
		if(selectedSubProducts == null || selectedSubProducts.size() == 0) return request;
		
		if(selectedSubProducts.contains(m_config.SUBTYPE_LOCKBOX_DATA_ENTRY_MODULE().toLowerCase())) {
			request.Data_Entry__c = true;
		}

		if(selectedSubProducts.contains(m_config.SUBTYPE_LOCKBOX_DATA_EXTRACT_MODULE().toLowerCase())) {
			request.Data_Extract__c = true;
		}

		if(selectedSubProducts.contains(m_config.SUBTYPE_LOCKBOX_DATA_REMITTANCE_MODULE().toLowerCase())) {
			request.Remittance_Imaging__c = true;
		}

		return request;
	}
}