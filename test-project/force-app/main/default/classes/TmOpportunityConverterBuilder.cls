public class TmOpportunityConverterBuilder implements TmOpportunityConverter.IOpportunityBuilder {

	public Map<String, Set<String>> getOpportunityProducts(List<String>  products, Map<String,TmBoarding.RequestConfigPm> cfgMap) {
		Map<String, Set<String>> productMappings = new Map<String, Set<String>>();
		for(String productName : products) {
			if(!productMappings.containsKey(productName)){
				productMappings.put(productName, new Set<String>());
			}
			TmBoarding.RequestConfigPm cfg = cfgMap.get(productName);
			if(cfg != null){
				List<String> opportunityProducts = String.isBlank(cfg.productPm.Related_To_Opportunity_Products__c) ?
												   new List<String>() 
												   : cfg.productPm.Related_To_Opportunity_Products__c.split('\\,');
				productMappings.get(productName).addAll(opportunityProducts);
			}
		}
		return productMappings;
	}

	public Opportunity getUpdatedOpportunity(DmOpportunity opportunityDm, Map<String, Set<String>> productMap, List<string> selectedProducts) {
		if(selectedProducts == null || selectedProducts.size() == 0){return null;}
		Set<String> bankProducts = new Set<String>();
		List<String> newProducts = new List<String>();
        if(opportunityDm.BankProducts != null){
            for(String prod : opportunityDm.BankProducts) {
                bankProducts.add(prod);
            }
        }
		
		Set<String> validKeys = opportunityDm.BankProducts == null? new Set<string>(): getExistingKeys(productMap, opportunityDm.BankProducts);
		List<String> newKeys = new List<String>();
		for(String p : selectedProducts) {
			if(!validKeys.contains(p)) {
				newKeys.add(p);
			}
		}
		
		List<String> itemsToUpdate = new List<String>();
		for(String p : newKeys) {
			Set<String> allOpportunityProductOptions = productMap.get(p);

			if(allOpportunityProductOptions != null && allOpportunityProductOptions.size() > 0) {
				List<String> items = new List<String>();
				items.addAll(allOpportunityProductOptions);
				itemsToUpdate.add(items[0]);
			}
		}

		List<String> updateProducts = new List<String>();
        
        if(opportunityDm.BankProducts != null){updateProducts.addAll(opportunityDm.BankProducts);}
		updateProducts.addAll(itemsToUpdate);
		String newBankProducts = String.Join(updateProducts, ';');

		return new Opportunity(Id=opportunityDm.id, Products__c = newBankProducts);
	}

	private Set<String> getExistingKeys(Map<String, Set<String>> productMap, List<String> BankProducts) {
		Set<String> keys = new Set<String>();
		
		for(String k : productMap.keyset()) {
			Set<String> products = productMap.get(k);
			for(String bp : BankProducts) {
				if(products.contains(bp)){
					keys.add(k);
				}
			}
		}
		return keys;
	}

}