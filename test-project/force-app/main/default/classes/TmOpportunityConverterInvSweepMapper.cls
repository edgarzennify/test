public class TmOpportunityConverterInvSweepMapper implements TmOpportunityConverter.IMapper {
	private final TmOpportunityConverter.IConfiguration m_config;

	public TmOpportunityConverterInvSweepMapper(TmOpportunityConverter.IConfiguration config) {
		m_config = config;
	}

	public string handle() {
		return m_config.RECORDTYPE_INVESTMENT_SWEEP();
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
		
		if(selectedSubProducts.contains(m_config.SUBTYPE_INVESTMENT_SWEEP_GOLDMAN_SACHS().toLowerCase())) {
			request.Sweep_Type__c = 'Goldman Sachs';
		}

		if(selectedSubProducts.contains(m_config.SUBTYPE_INVESTMENT_SWEEP_MONEY_MARKET().toLowerCase())) {
			request.Sweep_Type__c = 'Money Market';
		}

		if(selectedSubProducts.contains(m_config.SUBTYPE_INVESTMENT_SWEEP_OPTIMA_PLUS().toLowerCase())) {
			request.Sweep_Type__c = 'Optima Plus';
		}

		if(selectedSubProducts.contains(m_config.SUBTYPE_INVESTMENT_SWEEP_REPO().toLowerCase())) {
			request.Sweep_Type__c = 'Repo';
		}

		return request;
	}
}