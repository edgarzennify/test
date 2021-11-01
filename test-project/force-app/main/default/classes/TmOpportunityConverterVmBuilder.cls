public class TmOpportunityConverterVmBuilder implements TmOpportunityConverter.IVmBuilder {

    private Final String PACKET_FIELD_BUNDLE_TYPE = 'Bundle_Type__c';
    private Final String PACKET_FIELD_CLIENT_TYPE = 'Client_Type__c';

    private Utility.IUtility m_util;

    public TmOpportunityConverterVmBuilder(Utility.IUtility util){
        m_util = util;
    }

	public TmOpportunityConverter.OpportunityDetails buildOpportunityVm(DmOpportunity opp, List<DmTmPacket> packets, List<DmRecordType> products, Map<String, Set<String>> productMapping) {
    	TmOpportunityConverter.OpportunityDetails vm = new TmOpportunityConverter.OpportunityDetails();
        
        vm.OpportunityId = opp.Id;
    	vm.OpportunityName = opp.Name;
        vm.ServerUrl = m_util.getServerUrl();
    	vm.PotentialIncome = opp.PotentialFeeIncome + opp.PotentialDeposits; 
    	vm.BankProducts = buildBankProducts(products, productMapping);
        vm.SelectedBankProducts = buildSelectedProducts(opp.BankProducts, products, productMapping);
		vm.ExistingPacketDetails = buildExistingPackets(packets);	
        
		vm.EntityDetail = new TmOpportunityConverter.LayoutComponent();
		vm.EntityDetail.Identifier = opp.Entity.Id;
		vm.EntityDetail.Name = opp.Entity.Name;
        vm.EntityRecordType = new TmOpportunityConverter.LayoutComponent();
        vm.EntityRecordType.Identifier = opp.Entity.recordType.Id;
        vm.EntityRecordType.Name = opp.Entity.recordType.Name;
        vm.BundleTypes = GetPicklist(TmConfiguration.TM_REQUEST_PACKET, PACKET_FIELD_BUNDLE_TYPE);
        vm.ClientTypes = GetPicklist(TmConfiguration.TM_REQUEST_PACKET, PACKET_FIELD_CLIENT_TYPE);
        if(vm.BankProducts != null) vm.BankProducts.sort();
    	return vm;
    }

    private List<String> GetPicklist(String sobjectName, String fieldName){
        List<String> options = new List<string>();
        List<SelectOption> sOptions = m_util.ListValuesFromObject(sObjectName, fieldName);

        for(SelectOption s : sOptions){
            options.add(s.getLabel());
        }
        return options;
    }

    private List<TmOpportunityConverter.LayoutComponent> buildSelectedProducts(List<String> opportunityProducts, List<DmRecordType> requestProducts, Map<String, Set<String>> productMapping) {
        List<TmOpportunityConverter.LayoutComponent> vms = new List<TmOpportunityConverter.LayoutComponent>();
        Set<String> productAdded = new Set<String>();

        if(opportunityProducts == null || productMapping == null){return vms;}
        for(DmRecordType r : requestProducts) {
            String reqProd = r.name;
            Set<String> opportunityMap = productMapping.get(reqProd);
            for(String oprod : opportunityProducts) {
                if(opportunityMap != null && opportunityMap.size() > 0){
                    if(opportunityMap.contains(oprod)) {
                        if(!productAdded.contains(reqProd)) {
                            TmOpportunityConverter.LayoutComponent p = new TmOpportunityConverter.LayoutComponent();
                            p.Name = reqProd;
                            p.SubProducts = createSubType(opportunityMap,opportunityProducts, reqProd);
                            productAdded.add(reqProd);
                            vms.Add(p);
                        }
                    }
                }
            }
        }


        return vms;
    }

    private List<TmOpportunityConverter.LayoutComponent> buildBankProducts(List<DmRecordType> products , Map<String, Set<String>> productMapping) {
		List<TmOpportunityConverter.LayoutComponent> vms = new List<TmOpportunityConverter.LayoutComponent>();
    	for(DmRecordType prod : products) {
    		TmOpportunityConverter.LayoutComponent p = new TmOpportunityConverter.LayoutComponent();
    		p.Name = prod.Name;
            Set<String> opportunityMap = productMapping.get(prod.Name);
    		p.Identifier = prod.Id;
            p.SubProducts = createSubType(opportunityMap, prod.Name);
    		vms.Add(p);
    	}
    	return vms;
    }

    private List<TmOpportunityConverter.LayoutComponent> buildExistingPackets(List<DmTmPacket> packets) {
		List<TmOpportunityConverter.LayoutComponent> vms = new List<TmOpportunityConverter.LayoutComponent>();
    
    	for(DmTmPacket packet : packets) {
            if(packet != null){
                
                TmOpportunityConverter.LayoutComponent p = new TmOpportunityConverter.LayoutComponent();
                p.Name = packet.Name;
                p.Identifier = packet.Id;
                vms.Add(p);
                
            }
    	}
        
    	return vms;
    }

    private List<String> createSubType(Set<String> itemSet, string product) {
        if(itemSet == null || itemSet.size() == 0) return new List<String>();
        List<String> allSubTypes = new List<String>(itemSet);
        List<String> filteredSubTypes = new List<String>();
        for(string item: allSubTypes) {
            if(item.tolowercase() != product.tolowercase()){
                filteredSubTypes.add(item.trim());
            }
        }
        return filteredSubTypes;
    }

    private List<String> createSubType(Set<String> itemSet, List<string> selected ,string product) {
        if(itemSet == null || itemSet.size() == 0) return new List<String>();
        List<String> allSubTypes = new List<String>(itemSet);
        List<String> filteredSubTypes = new List<String>();

        Set<string> selectedSet = new Set<string>();
        for(string s : selected) {
            selectedSet.add(s.tolowercase());
        }

        for(string item: allSubTypes) {
            if(item.tolowercase() != product.tolowercase()){
                if(selectedSet.contains(item.toLowerCase())){
                    filteredSubTypes.add(item.trim());
                }
            }
        }
        return filteredSubTypes;
    } 
}