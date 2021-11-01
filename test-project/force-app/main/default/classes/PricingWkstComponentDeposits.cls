public with sharing class PricingWkstComponentDeposits extends PricingWkstComponentBase{
	
	public List<PricingWkst.ProposedDepositsDisplay> existingItems 
	{
		get
		{
			return pricingResults.proposedDepositPricingDetails;
		}
		set;
	}

	public List<Pricing_Proposed_Deposit__c> popupData {get;set;}

	public Decimal avgBalTotal {get;set;}
	public Decimal capitalTotal {get;set;}
	public Decimal incomeTotal {get;set;}

	public PricingWkstComponentDeposits() {
		m_apexPages = new ApexPagesWrapper();
		m_dataProvider = new PricingWkstDataProv();

	}

	public PricingWkstComponentDeposits(IApexPages apexPages, PricingWkst.IPricingWkstDataProv dataProvider)
	{
		m_apexPages = apexPages;
		m_dataProvider = dataProvider;
	}

	public override void createNewItem(){
		Pricing_Proposed_Deposit__c newEntry = new Pricing_Proposed_Deposit__c();
		newEntry.Pricing_Worksheet__c = currentWorksheet.Id;
		popupData.add(newEntry);
	}

	public override PageReference addNewItems(){
		m_dataProvider.addPricingProposedDeposits(popupData);
		return refreshPage();
	}

	public override PageReference updateItems(){
		m_dataProvider.updatePricingProposedDeposits(popupData);
		return refreshPage();
	}

	public override PageReference deleteItems(){
		m_dataProvider.deletePricingProposedDeposits(popupData);
		return refreshPage();
	}

	public override void setPopupToAllItems(){
		popupData = pricingRequest.proposedDeposits.values();
	}

	public override void setPopupToNewItem(){
		popupData = new List<Pricing_Proposed_Deposit__c>();
		createNewItem();
	}

	public override void setPopupToSelectedItem(){
		popupData = new List<Pricing_Proposed_Deposit__c>();
		popupData.Add(m_dataProvider.getPricingProposedDeposit(selectedId));
	}

	public override void updateTotals()
	{
		avgBalTotal = 0;
		capitalTotal = 0;
		incomeTotal = 0;
		for(PricingWkst.ProposedDepositsDisplay item : existingItems){
			if(item.proposedDeposit.Average_Balance__c != null){
				avgBalTotal += item.proposedDeposit.Average_Balance__c;	
			}
			if(item.capital != null){
				capitalTotal += item.capital;		
			}
			if(item.income != null){
				incomeTotal += item.income;		
			}
		}
	}

}