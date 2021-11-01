public with sharing class PricingWkstComponentLoans extends PricingWkstComponentBase {
	
	public List<PricingWkst.ProposedLoansDisplay> existingItems 
	{
		get
		{
			return pricingResults.proposedLoanPricingDetails;
		}
		set;
	}

	public List<Pricing_Proposed_Loan__c> popupData {get;set;}

	public Decimal amountTotal {get;set;}
	public Decimal riskExpenseTotal {get;set;}
	public Decimal adminTotal {get;set;}
	public Decimal capitalTotal {get;set;}
	public Decimal incomeTotal {get;set;}

	private static String MISSING_REQUIRED_FIELDS = 'All fields are required to save an entry.';

	public PricingWkstComponentLoans() {
		m_apexPages = new ApexPagesWrapper();
		m_dataProvider = new PricingWkstDataProv();
	}

	public PricingWkstComponentLoans(IApexPages apexPages, PricingWkst.IPricingWkstDataProv dataProvider)
	{
		m_apexPages = apexPages;
		m_dataProvider = dataProvider;
	}

	public override void createNewItem(){
		Pricing_Proposed_Loan__c newEntry = new Pricing_Proposed_Loan__c();
		newEntry.Pricing_Worksheet__c = currentWorksheet.Id;
		popupData.add(newEntry);
	}

	public override PageReference addNewItems(){
		if(validateListItems()){
			m_dataProvider.addPricingProposedLoans(popupData);
			return refreshPage();
		}else{
			m_apexPages.addMessage(ApexPages.Severity.Warning, MISSING_REQUIRED_FIELDS);
			return null;
		}
	}

	public override PageReference updateItems(){
		if(validateListItems()){
			m_dataProvider.updatePricingProposedLoans(popupData);
			return refreshPage();
		}else{
			m_apexPages.addMessage(ApexPages.Severity.Warning, MISSING_REQUIRED_FIELDS);
			return null;
		}
	}

	private Boolean validateListItems(){
		for(Pricing_Proposed_Loan__c listItem : popupData){
			if(listItem.Amount__c == null) return false;
			if(String.IsBlank(listItem.Collateral__c)) return false;
			if(String.IsBlank(listItem.Loan_Type__c)) return false;
			if(listItem.Rate__c == null) return false;
			if(String.IsBlank(listItem.Rate_Type__c)) return false;
			if(String.IsBlank(listItem.Risk__c)) return false;
			if(String.IsBlank(listItem.Term__c)) return false;
		}
		return true;
	}

	public override PageReference deleteItems(){
		m_dataProvider.deletePricingProposedLoans(popupData);
		return refreshPage();
	}

	public override void setPopupToAllItems(){
		popupData = pricingRequest.proposedLoans.values();
	}

	public override void setPopupToNewItem(){
		popupData = new List<Pricing_Proposed_Loan__c>();
		createNewItem();
	}

	public override void setPopupToSelectedItem(){
		popupData = new List<Pricing_Proposed_Loan__c>();
		popupData.Add(m_dataProvider.getPricingProposedLoan(selectedId));
	}

	public override void updateTotals()
	{
		amountTotal = 0;
		riskExpenseTotal = 0;
		adminTotal = 0;
		capitalTotal = 0;
		incomeTotal = 0;
		for(PricingWkst.ProposedLoansDisplay item : existingItems){
			if(item.proposedLoan.amount__c != null){
				amountTotal += item.proposedLoan.amount__c;	
			}
			if(item.riskExpense != null){
				riskExpenseTotal += item.riskExpense;		
			}
			if(item.adminFees != null){
				adminTotal += item.adminFees;		
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