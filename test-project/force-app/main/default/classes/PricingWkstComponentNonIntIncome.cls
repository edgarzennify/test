public with sharing class PricingWkstComponentNonIntIncome extends PricingWkstComponentBase {
	
	public List<PricingWkst.ProposedNonIntIncomeDisplay> existingItems {
		get{
			return pricingResults.proposedNonInterestIncomePricingDetails;
		}
		set;
	}	
	public List<Pricing_Proposed_Non_Interest_Income__c> popupData {get;set;}

	public Decimal annualGrossFeesTotal {get;set;}
	public Decimal incomeTotal {get;set;}

	public PricingWkstComponentNonIntIncome() {
		m_apexPages = new ApexPagesWrapper();
		m_dataProvider = new PricingWkstDataProv();
	}

	public PricingWkstComponentNonIntIncome(IApexPages apexPages, PricingWkst.IPricingWkstDataProv dataProvider)
	{
		m_apexPages = apexPages;
		m_dataProvider = dataProvider;
	}


	public override void createNewItem(){
		Pricing_Proposed_Non_Interest_Income__c newEntry = new Pricing_Proposed_Non_Interest_Income__c();
		newEntry.Pricing_Worksheet__c = currentWorksheet.Id;
		popupData.add(newEntry);
	}

	public override PageReference addNewItems(){
		m_dataProvider.addPricingProposedNonIntIncomes(popupData);
		return refreshPage();
	}

	public override PageReference updateItems(){
		m_dataProvider.updatePricingProposedNonIntIncomes(popupData);
		return refreshPage();
	}

	public override PageReference deleteItems(){
		m_dataProvider.deletePricingProposedNonIntIncomes(popupData);
		return refreshPage();
	}

	public override void setPopupToAllItems(){
		popupData = pricingRequest.proposedNonInterestIncome.values();
	}

	public override void setPopupToNewItem(){
		popupData = new List<Pricing_Proposed_Non_Interest_Income__c>();
		createNewItem();
	}

	public override void setPopupToSelectedItem(){
		popupData = new List<Pricing_Proposed_Non_Interest_Income__c>();
		popupData.Add(m_dataProvider.getPricingProposedNonIntIncome(selectedId));
	}

	public override void updateTotals()
	{
		annualGrossFeesTotal = 0;
		incomeTotal = 0;
		for(PricingWkst.ProposedNonIntIncomeDisplay item : existingItems){
			if(item.proposedNonIntIncome.Annual_Gross_Fees__c != null){
				annualGrossFeesTotal += item.proposedNonIntIncome.Annual_Gross_Fees__c;	
			}
			if(item.income != null){
				incomeTotal += item.income;		
			}
		}
	}



}