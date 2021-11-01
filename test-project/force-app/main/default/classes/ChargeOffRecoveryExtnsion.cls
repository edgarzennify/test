public with sharing class ChargeOffRecoveryExtnsion {
	
	private String selectedRecordType;
	List<RecordType> corRecordTypeList = [SELECT Name, Id FROM RecordType WHERE SobjectType =: 'Charge_Off_Recovery__c'];
	Map<String,String> corRecordTypes = new Map<String,String>{};
								  
    String retURL;
    String url = ''; 
    PageReference thisPage = null;
    Id crid;
    Charge_Off_Recovery__c cor;
    public String corChosen {get; set;} 
    
	public ChargeOffRecoveryExtnsion(ApexPages.StandardController controller) {			
		if(thisPage==null) thisPage = apexpages.currentpage();
		if(url == '') url = Utility.getServerUrl();
		getQueryParameters();

	}

	private void getQueryParameters(){
    	try{
    		this.crid = thisPage.getparameters().get('crid');
        	this.selectedRecordType = thisPage.getparameters().get('RecordType');
        	this.retURL = thisPage.getparameters().get('retURL');
		}catch(exception ex){
		   
    	}
	}
	
	public String getRecordTypeName(){
		String ret;
		for(RecordType r: corRecordTypeList){
			if(r.Id == selectedRecordType){
				ret =  r.Name;
			}
		}
		return ret;
	}
	
	public String getRecordTypeId(String recTypeName){
		String ret;
		for(RecordType r: corRecordTypeList){
			if(r.Name == recTypeName){
				ret =  r.Id;
			}
		}
		return ret;
	}

    public static testMethod void verifyChargeOffRecoveryExtnsionMethods(){
     	  
		Id RecTypeRecoveryId = ObjectFactory.getRecordTypeIdByNameAndObject('Recovery', 'Charge_Off_Recovery__c');
		system.debug('##RecoveryId' + RecTypeRecoveryId );
		EB_Team_Member__c member =  ObjectFactory.getTeamMember('phoban');
		Id recEntityId = ObjectFactory.getRecordTypeIdByNameAndObject('Prospect', 'Account');
		Account entity = ObjectFactory.getEntity('test', recEntityId, member);
		system.debug('##EntityId' + entity.Id );
		Eb_Account__c acct = ObjectFactory.getEBAccount('Test', '12121', entity);
		system.debug('##AccountId' + acct.Id );

		Charge_Off_Recovery__c CrRecoveryObj = objectfactory.getChargeOffRecoveryObj(RecTypeRecoveryId, acct.Id);
		system.assertNotEquals(CrRecoveryObj, null);
		String url = Utility.getServerUrl() + '/apex/ChargeOffRecoveryNew?RecordType='+ CrRecoveryObj.RecordTypeId;

		PageReference pr = ChargeOffRecoveryExtnsion.testhelper(url );
		test.setCurrentPage(pr);
		ApexPages.StandardController sc = new Apexpages.Standardcontroller(CrRecoveryObj);
		ChargeOffRecoveryExtnsion testcontroller = new ChargeOffRecoveryExtnsion(sc);
		Id recoveryid = testcontroller.getRecordTypeId('Recovery');
		PageReference urlhelper =  ChargeOffRecoveryExtnsion.testhelper('http://www.google.com');
		String recTypeName = testcontroller.getRecordTypeName();     
     }
     
     public static PageReference testhelper(String url){
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(true);
        return newPage;
     }
    
}