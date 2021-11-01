public virtual with sharing class PricingWkstComponentBase {

	public final IApexPages m_apexPages;
	public final PricingWkst.IPricingWkstDataProv m_dataProvider;

	public Pricing_Worksheet__c currentWorksheet {get;set;}
	public PricingWkstRequest pricingRequest {get;set;}
	public PricingWkstResults pricingResults 
	{
		get;
		set
		{
			pricingResults = value;
			updateTotals();
		}
	}

	public String popupType {get;set;}
	public Boolean popupDisplayed {get;set;}
	public Id selectedId {get;set;}

	public PricingWkstComponentBase() {
	}


	public virtual void createNewItem(){}
	public virtual PageReference addNewItems(){return null;}
	public virtual PageReference updateItems(){return null;}
	public virtual PageReference deleteItems(){return null;}
	public virtual void setPopupToAllItems(){}
	public virtual void setPopupToNewItem(){}
	public virtual void setPopupToSelectedItem(){}
	public virtual void updateTotals(){}

	public void showAddPopup() {
		setPopupToNewItem();
		displayPopup('add');
	}


	public void showUpdatePopupForSingleItem()
	{
		setPopupToSelectedItem();
		displayPopup('update');		
	}

	public void showUpdatePopupForAllItems()
	{
		setPopupToAllItems();
		displayPopup('update');		
	}


	public void showDeletePopupForSingleItem()
	{
		setPopupToSelectedItem();
		displayPopup('deletesingle');		
	}

	public void showDeletePopupForAllItems()
	{
		setPopupToAllItems();
		displayPopup('deleteall');		
	}


	private void displayPopup(String forType)
	{
		popupDisplayed = true;
		popupType = forType;		
	}

	public void hidePopup()
	{
		popupDisplayed = false;
	}

	public PageReference refreshPage()
	{
		PageReference pageRef = new PageReference('/apex/pricingwkst?id='+currentWorksheet.Id);
		pageRef.setRedirect(true);
		return pageRef;
	}



}