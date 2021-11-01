public with sharing class PricingWkstComponentAcctRemovals extends PricingWkstComponentBase {
	
	public List<Pricing_Proposed_Account_Removal__c> existingItems {
		get	{
			return pricingRequest.proposedAccountRemovals.values();
		}
		set;
	}

	public List<String> accountsSelectedToRemove {get;set;}
	public List<SelectOption> m_accountsAvailableToRemove;
	public List<SelectOption> accountsAvailableToRemove {
		get	{			
				if(m_accountsAvailableToRemove == null){
					m_accountsAvailableToRemove = getAccountsAvailableToRemove();
				}
				return m_accountsAvailableToRemove;
			}
		set;
	}


	public List<Pricing_Proposed_Account_Removal__c> popupData {get;set;}

	public PricingWkstComponentAcctRemovals() {
		m_apexPages = new ApexPagesWrapper();
		m_dataProvider = new PricingWkstDataProv();
	}

	public PricingWkstComponentAcctRemovals(IApexPages apexPages, PricingWkst.IPricingWkstDataProv dataProvider) {
		m_apexPages = apexPages;
		m_dataProvider = dataProvider;
	}

	public override PageReference addNewItems(){
		popupData = new List<Pricing_Proposed_Account_Removal__c>();
		for(String optionSelected : accountsSelectedToRemove){
			Pricing_Proposed_Account_Removal__c newItem = new Pricing_Proposed_Account_Removal__c();
			newItem.EB_Account__c = optionSelected;
			newItem.Pricing_Worksheet__c = currentWorksheet.Id;
			popupData.add(newItem);
		}
		m_dataProvider.addPricingProposedAcctRemovals(popupData);
		return refreshPage();
	}

	public override PageReference deleteItems(){
		m_dataProvider.deletePricingProposedAcctRemovals(popupData);
		return refreshPage();
	}

	public override void setPopupToAllItems(){
		popupData = existingItems;
	}

	public override void setPopupToNewItem(){
		popupData = new List<Pricing_Proposed_Account_Removal__c>();
		createNewItem();
	}

	public override void setPopupToSelectedItem(){
		popupData = new List<Pricing_Proposed_Account_Removal__c>();
		popupData.Add(m_dataProvider.getPricingProposedAcctRemoval(selectedId));
	}

	private List<SelectOption> getAccountsAvailableToRemove() {
		List<EB_Account__c> acctsAvailableToRemove = pricingRequest.existingAccounts;
		for(Pricing_Proposed_Account_Removal__c acctToRemove : pricingRequest.proposedAccountRemovals.values()){
			removeItemFromEBAccountList(acctToRemove.EB_Account__c, acctsAvailableToRemove);
		}
		List<SelectOption> acctsAvailableToRemoveOptions = new List<SelectOption>();
		for(EB_Account__c acct : acctsAvailableToRemove){

			acctsAvailableToRemoveOptions.add(new SelectOption(acct.Id, getAccountRemovalDisplayValue(acct)));
		}
		return acctsAvailableToRemoveOptions;
	}

	private void removeItemFromEBAccountList(Id acctToRemove, List<EB_Account__c> listToRemoveFrom) {
		for(Integer index = 0; index < listToRemoveFrom.size(); index++){
			if(listToRemoveFrom[index].Id == acctToRemove){
				listToRemoveFrom.remove(index);
				break;
			}
		}
	}

	private String getAccountRemovalDisplayValue(EB_Account__c acct){
		String displayValue = acct.Account_Number__c + ' (' + acct.ApplicationDescription__c;
		if(acct.Core_Current_Balance__c == null){
			displayValue += ')';
		}else{
			displayValue += ' - Balance: ' + acct.Core_Current_Balance__c + ')';
		}
		return displayValue;
	}

}