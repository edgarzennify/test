public class EBEventConfirmation {
	public Id recId;
	public EB_Event_Attendees__c att{get;set;}
	public EB_Event_Session__c s{get;set;}
 
    public EBEventConfirmation(ApexPages.StandardController controller) {
		recId = apexpages.currentpage().getparameters().get('Id');
		initialize();
    }
    
    public void initialize(){
		if(recId <> null){
			try{
				att = [SELECT Id,  Attendee__c, Company__c, EB_Event_Course__r.Capacity__c, EB_Event_Course__r.EB_Event__r.Name, EB_Event_Course__r.Date_Time_of_Event__c, EB_Event_Course__r.Event_Location__c, EB_Event_Course__r.Address__c  FROM EB_Event_Attendees__c WHERE Id =: recId limit 1];
				s = att.EB_Event_Course__r;
			}catch(exception ex){
				att = null;
				s = null;
			}
		}
	}
    
    public String getName(){
    	if(att <> null){
    		if(att.Company__c <> ''){
    			return att.Attendee__c + ' (' + att.Company__c + ')';
    		}else{
    			return att.Attendee__c;
    		}    		
    	}
    	return '';
    }   
        
    public String getTime(){
    	if (att <> null){
    		String d = att.EB_Event_Course__r.Date_Time_of_Event__c.format('MM/dd/yyyy');
    		String t = att.EB_Event_Course__r.Date_Time_of_Event__c.format('hh:mm a');
    		return d + ' at ' + t;    		
    	}
    	return '';
    }
    
    ///////////////////test methods////////////////////////////////
    public static testMethod void testThisClass(){
    	test.startTest();
    	EBEventConfirmationTester.testWithValues();
    	EBEventConfirmationTester.testWithNulls();
    	test.stopTest();
    }
}