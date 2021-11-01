public with sharing class WebsiteCMSUnitController {

	EB_Unit__c unit;
	PageReference thisPage = null;
	String retURL;
    String url = '';
    
    String displayName;
    String displayPhone;
    String displayAddress;
    
    String view;    
	String viewBranch;   
	String assoc_currentPos;
	String unit_currentPos;
    
   	String detailPage;
   	
    public string getDisplayName(){
    	return displayName;
    }
    
    public string getDisplayPhone(){
    	return displayPhone;
    }
    
    public string getDisplayAddress(){
    	return displayAddress;
    }      

    public String getViewBranch() {
        return viewBranch;
    }
     
    public String getView() {
    	return view;
    }
    
	public String getunit_currentpos(){
		return unit_currentpos;
	}
	
	public String getassoc_currentpos(){
		return assoc_currentpos;
	}
	
 	public WebsiteCMSUnitController(ApexPages.StandardController stdController) {
   		if(thisPage==null) thisPage = apexpages.currentpage();
		if(url == '') url = Utility.getServerUrl();
		unit=(EB_Unit__c)stdController.getrecord();
		getQueryParameters();
		initialize();
	}
	
	public void initialize(){
		displayName = unit.Website_Name__c;
		displayAddress = unit.Address__c;
		displayPhone = unit.Phone_Number__c;
	}

	public void stageName() {		
		if(unit.Website_Name_Override__c==null){
			displayName = unit.Name;
		} else {
			displayName = unit.Website_Name_Override__c;
		}
	}
	public void publishName() {		
		unit.Website_Name_Published__c =displayName;
	}
	
	public void stageAddress() {		
		if(unit.Website_Address_Override__c==null){
			displayAddress = unit.Address__c;
		} else {
			displayAddress = unit.Website_Address_Override__c;
		}
	}	
	public void publishAddress() {		
		unit.Website_Address_Published__c =displayAddress;
	}	
	
	public void stagePhone() {		
		if(unit.Website_Phone_Override__c==null){
			displayPhone = unit.Phone_Number__c;
		} else {
			displayPhone = unit.Website_Phone_Override__c;
		}
	}

	public void publishPhone() {		
		unit.Website_Phone_Published__c =displayPhone;
	}	
	
	public pageReference Save() {
	 	String newPageUrl;
        update unit;
        newPageUrl = this.url + '/apex/websiteCMSLists?ap=' + assoc_currentPos + '&up=' + unit_currentPos + '&av=' + view + '&uv=' + viewBranch;  
        PageReference listPage = new PageReference(newPageUrl);
        PageReference unitPage = new ApexPages.StandardController(unit).view();
        //send the user back to either the standard detail page or to the custom list view
        if(this.detailPage=='detail'){
	        unitPage.setRedirect(true);
     	   return unitPage;
        }else{
	        listPage.setRedirect(true);
    	    return listPage;
        }
	}
	
	public pageReference Cancel() {
	 	String newPageUrl;
        newPageUrl = this.url + '/apex/websiteCMSLists?ap=' + assoc_currentPos + '&up=' + unit_currentPos + '&av=' + view + '&uv=' + viewBranch;  
        PageReference listPage = new PageReference(newPageUrl);
        PageReference unitPage = new ApexPages.StandardController(unit).view();
        //send the user back to either the standard detail page or to the custom list view
        if(this.detailPage=='detail'){
	        unitPage.setRedirect(true);
     	   return unitPage;
        }else{
	        listPage.setRedirect(true);
    	    return listPage;
        }

	}
	
	private void getQueryParameters(){
		try{	
			this.assoc_currentPos = thisPage.getParameters().get('ap');
		}catch(exception ex){
			this.assoc_currentPos = null;
		}
		try{
			this.unit_currentPos = thisPage.getParameters().get('up');
      	}catch(exception ex){
      		this.unit_currentPos = null;
      	}
      	try{
      		this.view = thisPage.getParameters().get('av');
      	}catch(exception ex){
      		this.view = null;
      	}
      	try{
      		this.viewBranch = thisPage.getParameters().get('uv');
       	}catch(exception ex){
       		this.viewBranch = null;
       	}
       	try{
       		this.detailPage = thisPage.getParameters().get('detail');
       	}catch(exception ex){
       		this.detailPage = null;
       	}
	}
	
	public static testmethod void verifyme(){		
     	EB_Unit__c unit = objectfactory.getUnit('Test Branch 1', 1);
     	unit.Phone_Number__c = '999-999-9999';

        String url = utility.getServerUrl() + '/apex/cmswebsiteunit?id=';
        PageReference pr = new PageReference(url + unit.Id + '&ap=0&up=3&av=ALL&uv=ALL');
	    pr.setRedirect(true);        
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new ApexPages.standardController(unit);
       	WebsiteCMSUnitController controller = new WebsiteCMSUnitController(sc);
       
     	controller.initialize();
     	controller.getDisplayName();
		controller.getDisplayPhone();
		controller.getDisplayAddress();
		controller.getView();
		controller.getViewBranch();
		controller.getunit_currentpos();
		controller.getassoc_currentpos();
		controller.stageName();
		unit.Website_Name_Override__c = 'Override Name';		
		controller.stageName();
		controller.publishName();		
		
		controller.stagePhone();
		unit.Website_Phone_Override__c = 'Phone Override';
		controller.stagePhone();
		controller.publishPhone();
		
		controller.stageAddress();
		unit.Website_Address_Override__c = 'Address Override';
		controller.stageAddress();
		controller.publishAddress();
		
		controller.Save();
		controller.Cancel();
		controller.detailPage='detail';
		controller.Save();
		controller.Cancel();
	}
	
}