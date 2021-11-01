public with sharing class WebsiteCMSAssociateController {
	
	EB_Team_Member__c associate;
	EB_Team_Member__c displayAssociate;
	PageReference thisPage = null;
	String retURL;
	String url = '';
    
    String displayName;
    String displayTitle;
    String displayDivision;
    String displayEmail;
    String displayPhone;
    String displayMobile;
    
    String view;    
	String viewBranch;   
	String assoc_currentPos;
	String unit_currentPos;
	
	String displayFirstName;
	String displayLastName;
	
	String detailPage;
	
	public string getDisplayFirstName(){
		return displayFirstName;
	}
	
	public string getDisplayLastName(){
		return displayLastName;
	}
    
    public string getDisplayName(){
    	return displayName;
    }
    
    public string getDisplayTitle(){
    	return displayTitle;
    }
    
    public string getDisplayDivision(){
    	return displayDivision;
    }
    
    public string getDisplayEmail(){
    	return displayEmail;
    }
    
    public string getDisplayPhone(){
    	return displayPhone;
    }
    
    public string getDisplayMobile(){
    	return displayMobile;
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
    
    public String MyAsciiCode {get; set;}
    
        
	public WebsiteCMSAssociateController(ApexPages.StandardController stdController) {
   		if(thisPage==null) thisPage = apexpages.currentpage();
		if(url == '') url = Utility.getServerUrl();
		associate=(EB_Team_Member__c)stdController.getrecord();
		getQueryParameters();
		initialize();
	}
	
	public void initialize(){
		displayName = associate.Website_Name__c;
		displayTitle = associate.Website_Title__c;
		displayDivision = associate.Website_Division__c;
		displayEmail = associate.Website_Email__c;
		displayPhone = associate.Website_Office_Phone__c;
		displayMobile = associate.Website_Mobile_Phone__c;
		displayFirstName = associate.Website_First_Name_Published__c;
		displayLastName = associate.Website_Last_Name_Published__c;
	}

	public void stageName() {		
		if(associate.Website_First_Name_Override__c==null && associate.Website_Last_Name_Override__c==null){			
			displayName = associate.Name;
			integer split = displayName.indexOf(' ');
			displayFirstName = displayname.substring(0, split);
			displayLastName = displayName.substring(split+1,displayName.length());
		} else if (associate.Website_First_Name_Override__c==null &&  associate.Website_Last_Name_Override__c<>null){
			displayName = associate.Website_Last_Name_Override__c;		
			displayFirstName = null;
			displayLastName = associate.Website_Last_Name_Override__c;		
		} else if (associate.Website_First_Name_Override__c<>null &&  associate.Website_Last_Name_Override__c==null){
			displayName = associate.Website_First_Name_Override__c;
			displayFirstName = associate.Website_First_Name_Override__c;
			displayLastName = null;
		} else {
			displayName = associate.Website_First_Name_Override__c + ' ' + associate.Website_Last_Name_Override__c;
			displayFirstName = associate.Website_First_Name_Override__c;
			displayLastName = associate.Website_Last_Name_Override__c;
		}
	}
	
	public void publishName() {		
		associate.Website_Name_Published__c =displayName;
		associate.Website_First_Name_Published__c = displayFirstName;
		associate.Website_Last_name_Published__c = displayLastName;
	}
	
	public void stageTitle() {		
		if(associate.Website_Title_Override__c==null){
			displayTitle = associate.User__r.Title;
		} else {
			displayTitle = associate.Website_Title_Override__c;
		}
	}
	public void publishTitle() {		
		associate.Website_Title_Published__c = displayTitle;
	}
	
	public void stageDivision() {		
		if(associate.Website_Division_Override__c==null){
			displayDivision = associate.User__r.Division;
		} else {
			displayDivision = associate.Website_Division_Override__c;
		}
	}

	public void publishDivision() {		
		associate.Website_Division_Published__c =displayDivision;
	}
	
	public void stageEmail() {		
		if(associate.Website_Email_Override__c==null){
			displayEmail = associate.user__r.Email;
		} else {
			displayEmail = associate.Website_Email_Override__c;
		}
	}

	public void publishEmail() {		
		associate.Website_Email_Published__c =displayEmail;
		associate.Website_Email_Obfuscated__c = obfuscateEmail(displayEmail);
	}
	
	public void stagePhone() {		
		if(associate.Website_Office_Phone_Override__c==null){
			displayPhone = associate.User__r.Phone;
		} else {
			displayPhone = associate.Website_Office_Phone_Override__c;
		}
	}

	public void publishPhone() {		
		associate.Website_Office_Phone_Published__c =displayPhone;
	}
	
	public void stageMobile() {		
		if(associate.Website_Mobile_Phone_Override__c==null){
			displayMobile = associate.User__r.MobilePhone;
		} else {
			displayMobile = associate.Website_Mobile_Phone_Override__c;
		}
	}

	public void publishMobile() {		
		associate.Website_Mobile_Phone_Published__c =displayMobile;
	}
	
	public pageReference Save() {
	 	String newPageUrl;
       	update associate;
        newPageUrl = this.url + '/apex/websiteCMSLists?ap=' + assoc_currentPos + '&up=' + unit_currentPos + '&av=' + view + '&uv=' + viewBranch;  
        PageReference listPage = new PageReference(newPageUrl);                
        PageReference associatePage = new ApexPages.StandardController(associate).view();
        //send the user back to either the standard detail page or to the custom list view
        if(this.detailPage=='detail'){
	        associatePage.setRedirect(true);
     	   return associatePage;
        }else{
	        listPage.setRedirect(true);
    	    return listPage;
        }
	}
	
	public pageReference Cancel() {
	 	String newPageUrl;
        newPageUrl = this.url + '/apex/websiteCMSLists?ap=' + assoc_currentPos + '&up=' + unit_currentPos + '&av=' + view + '&uv=' + viewBranch; 
        PageReference listPage = new PageReference(newPageUrl);
        PageReference associatePage = new ApexPages.StandardController(associate).view();
        //send the user back to either the standard detail page or to the custom list view
        if(this.detailPage=='detail'){
	        associatePage.setRedirect(true);
     	   return associatePage;
        }else{
	        listPage.setRedirect(true);
    	    return listPage;
        }


	}
	
	public String obfuscateEmail(string email){
		String hash;
		hash='';
		integer j;
		for (j=0;j<email.length();j++){
			if(hash != '') hash += ',';
			hash = hash + asciiMap.get(email.substring(j, j+1));
		}		
		return hash;
	}
	
	private static Map<String,String> asciiMap = new Map<String,String>();
		static {				
			asciiMap.put('', '32');
			asciiMap.put('!', '33');
			asciiMap.put('"', '34');
			asciiMap.put('#', '35');
			asciiMap.put('$', '36');
			asciiMap.put('%', '37');
			asciiMap.put('&', '38');
			asciiMap.put('\'', '39');
			asciiMap.put('(', '40');
			asciiMap.put(')', '41');
			asciiMap.put('*', '42');
			asciiMap.put('+', '43');
			asciiMap.put(',', '44');
			asciiMap.put('-', '45');
			asciiMap.put('.', '46');
			asciiMap.put('/', '47');
			asciiMap.put('0', '48');
			asciiMap.put('1', '49');
			asciiMap.put('2', '50');
			asciiMap.put('3', '51');
			asciiMap.put('4', '52');
			asciiMap.put('5', '53');
			asciiMap.put('6', '54');
			asciiMap.put('7', '55');
			asciiMap.put('8', '56');
			asciiMap.put('9', '57');
			asciiMap.put(':', '58');
			asciiMap.put(';', '59');
			asciiMap.put('<', '60');
			asciiMap.put('=', '61');
			asciiMap.put('>', '62');
			asciiMap.put('?', '63');
			asciiMap.put('@', '64');
			asciiMap.put('A', '65');
			asciiMap.put('B', '66');
			asciiMap.put('C', '67');
			asciiMap.put('D', '68');
			asciiMap.put('E', '69');
			asciiMap.put('F', '70');
			asciiMap.put('G', '71');
			asciiMap.put('H', '72');
			asciiMap.put('I', '73');
			asciiMap.put('J', '74');
			asciiMap.put('K', '75');
			asciiMap.put('L', '76');
			asciiMap.put('M', '77');
			asciiMap.put('N', '78');
			asciiMap.put('O', '79');
			asciiMap.put('P', '80');
			asciiMap.put('Q', '81');
			asciiMap.put('R', '82');
			asciiMap.put('S', '83');
			asciiMap.put('T', '84');
			asciiMap.put('U', '85');
			asciiMap.put('V', '86');
			asciiMap.put('W', '87');
			asciiMap.put('X', '88');
			asciiMap.put('Y', '89');
			asciiMap.put('Z', '90');
			asciiMap.put('[', '91');
			asciiMap.put('\\', '92');
			asciiMap.put(']', '93');
			asciiMap.put('^', '94');
			asciiMap.put('_', '95');
			asciiMap.put('`', '96');
			asciiMap.put('a', '97');
			asciiMap.put('b', '98');
			asciiMap.put('c', '99');
			asciiMap.put('d', '100');
			asciiMap.put('e', '101');
			asciiMap.put('f', '102');
			asciiMap.put('g', '103');
			asciiMap.put('h', '104');
			asciiMap.put('i', '105');
			asciiMap.put('j', '106');
			asciiMap.put('k', '107');
			asciiMap.put('l', '108');
			asciiMap.put('m', '109');
			asciiMap.put('n', '110');
			asciiMap.put('o', '111');
			asciiMap.put('p', '112');
			asciiMap.put('q', '113');
			asciiMap.put('r', '114');
			asciiMap.put('s', '115');
			asciiMap.put('t', '116');
			asciiMap.put('u', '117');
			asciiMap.put('v', '118');
			asciiMap.put('w', '119');
			asciiMap.put('x', '120');
			asciiMap.put('y', '121');
			asciiMap.put('z', '122');
			asciiMap.put('{', '123');
			asciiMap.put('|', '124');
			asciiMap.put('}', '125');
			asciiMap.put('~', '126');
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
     	EB_Team_Member__c assoc = new EB_Team_Member__c(Name='Sally Smith');
     	insert assoc;

        String url = utility.getServerUrl() + '/apex/cmswebsiteassociate?id=';
        PageReference pr = new PageReference(url + assoc.Id + '&ap=0&up=3&av=ALL&uv=ALL');
	    pr.setRedirect(true);        
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new ApexPages.standardController(assoc);
       	WebsiteCMSAssociateController controller = new WebsiteCMSAssociateController(sc);

     	controller.initialize();
     	controller.getDisplayName();
     	controller.getDisplayFirstName();
     	controller.getDisplayLastName();
  		controller.getDisplayTitle();
		controller.getDisplayDivision();
		controller.getDisplayEmail();
		controller.getDisplayPhone();
		controller.getDisplayMobile();
		
		controller.getView();
		controller.getViewBranch();
		controller.getunit_currentpos();
		controller.getassoc_currentpos();
		controller.stageName();
		assoc.Website_Name_Override__c = 'Override Name';
		controller.stageName();
		controller.publishName();		
		
		assoc.Website_Name_Override__c = null;
		
		
		assoc.Website_First_Name_Override__c = null;
		assoc.Website_Last_Name_Override__c = null;
		controller.stageName();
		controller.publishName();	
		
		assoc.Website_First_Name_Override__c = 'Test First';
		assoc.Website_Last_Name_Override__c = null;
		controller.stageName();
		controller.publishName();	
		
		assoc.Website_First_Name_Override__c = null;
		assoc.Website_Last_Name_Override__c = 'Test Last';
		controller.stageName();
		controller.publishName();	
		
		assoc.Website_First_Name_Override__c = 'Test First';
		assoc.Website_Last_Name_Override__c = 'Test Last';
		controller.stageName();
		controller.publishName();	
		
		controller.stageTitle();
		assoc.Website_Title_Override__c = 'Title Override';
		controller.stageTitle();
		controller.publishTitle();
		
		controller.stageDivision();
		assoc.Website_Division_Override__c = 'Division Override';
		controller.stageDivision();
		controller.publishDivision();
		
		controller.stageEmail();
		assoc.Website_Email_Override__c = 'Email Override';
		controller.stageEmail();
		controller.publishEmail();
		
		controller.stagePhone();
		assoc.Website_Office_Phone_Override__c = 'Office Phone Override';
		controller.stagePhone();
		controller.publishPhone();
		
		controller.stageMobile();
		assoc.Website_Mobile_Phone_Override__c = 'Mobile Phone Override';
		controller.stageMobile();
		controller.publishMobile();
		controller.Save();
		controller.Cancel();
		controller.detailPage='detail';
		controller.Save();
		controller.Cancel();
	}
}