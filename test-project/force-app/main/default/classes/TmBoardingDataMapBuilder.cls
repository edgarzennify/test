public class TmBoardingDataMapBuilder  implements TmBoarding.IDataMapBuilder {

	public TmBoarding.LayoutComponent2 buildPacket(TmBoarding.RequestPm pm) {
        TmBoarding.LayoutComponent2 packet = new TmBoarding.LayoutComponent2();
        packet.PacketDetail = new TmBoarding.LayoutComponentRelated();
        packet.PacketDetail.Id = pm.packetPm == null? '' : pm.packetPm.Id;
        packet.PacketDetail.Name = pm.packetPm == null? '' : pm.packetPm.Name;
        packet.Entity = new TmBoarding.LayoutComponentRelated();
        packet.Entity.Id = pm.entityPm == null ? '': pm.entityPm.Id;
        packet.Entity.Name = pm.entityPm == null ? '': pm.entityPm.Name;
        packet.Request = new TmBoarding.LayoutComponentRelated();
        packet.Request.Id = pm.requestPm == null? '' : pm.requestPm.Id;
        packet.Request.Name = pm.requestPm == null? '' : pm.requestPm.Name;
        packet.Type =  pm.requestPm.RecordType == null ? '' : pm.requestPm.RecordType.Name;
        packet.Requests = new List<TmBoarding.LayoutComponentRelated>();

        if(pm.packetRequestsPm != null) {
            for(TM_Service_Request__c req :   pm.packetRequestsPm) {
                TmBoarding.LayoutComponentRelated rel = new TmBoarding.LayoutComponentRelated();
                rel.Id = req.Id;
                rel.Name = req.RecordType.Name;
                packet.Requests.add(rel);
            }
        }
        return packet;
    }

	public TmBoarding.DataComponent buildDetails(TmBoarding.RequestPm pm, List<DmField> requestfields, List<DmField> scheduleFields) {
        
		Map<String, Object> details = new Map<String, Object>();
		TmBoarding.DataComponent component = new TmBoarding.DataComponent();
		String requestObjectId = String.Format('{0}.Id', new List<string>{TmConfiguration.TM_REQUEST});
        String packetObjectId = String.Format('{0}.Id', new List<string>{TmConfiguration.TM_REQUEST_PACKET});
        Boolean packetFieldExists = findPacketDmField(requestFields, scheduleFields);

        details.put(requestObjectId, pm.requestPm.get('Id'));
        if(packetFieldExists){
            details.put(packetObjectId, pm.packetPm.get('Id'));
        }
        
		for(DmField fld : requestfields) {
            if(IsValid(fld)) {
                setFieldValues(fld, pm, details);
            }
		}
 
       
		for(DmField fld : scheduleFields) {
            if(IsValid(fld)) {
                setFieldValues(fld, pm, details);
            }
		}
        
		component.Data = new List<Map<String, Object>>{details};

		return component;
	}

    private void setFieldValues(DmField fld, TmBoarding.RequestPm pm, Map<String, Object> details){
        String objectWithFieldName1 = buildKey(fld);
        details.put(objectWithFieldName1,getDetailValue(fld, pm));             
        String altName = getAlternateField(fld);
        if(String.isNotBlank(altName)){
            String objectWithFieldName2 = buildAltKey(fld);
            details.put(objectWithFieldName2,getAltDetailValue(fld, pm)); 
        }
    }

	public TmBoarding.DataComponent buildContacts(TmBoarding.RequestPm pm, List<DmField> contactOptions) {

		TmBoarding.DataComponent component = new TmBoarding.DataComponent();
		List<Map<String, Object>> dataContacts = new List<Map<String, Object>>();
        Map<Id, TM_Service_Request_Contact__c> serviceContactMap = new  Map<Id, TM_Service_Request_Contact__c>();
        for(TM_Service_Request_Contact__c rc : pm.serviceContactPms) {
            serviceContactMap.put(rc.Contact__c , rc);
        }

        for(Contact c : pm.contactPms) {
            Map<String, Object> data = buildContact(c, contactOptions, serviceContactMap);
            dataContacts.add(data);
        }

        component.Data = dataContacts;

		return component;
	}

    public Map<String, Object> buildContact(Contact c, List<DmField> contactOptions, Map<Id, TM_Service_Request_Contact__c> serviceContactMap) {
        Map<String, Object> data = new Map<String, Object>();
        for(DmField fld : contactOptions) {
            try{
                if(IsValid(fld)) {
                    String objectWithFieldName = buildKey(fld);
                    TM_Service_Request_Contact__c rc = serviceContactMap.get(c.Id);
                    if(fld.objectName.tolowerCase() == TmConfiguration.CORE_CONTACT.tolowerCase()) {
                        String objectId = buildId(fld);
                        data.put('ParentId', c.Id);
                        data.put('ParentName', c.Name);
                        data.put(objectId, c.get('Id') );
                        boolean selected = rc == null ? false : true;
                        data.put('Included', buildSelected(selected, c.get('Id')) );                     
                        data.put(objectWithFieldName, c.get(fld.Name) );
                    }
                    
                    if(fld.objectName.tolowerCase() == TmConfiguration.TM_REQUEST_CONTACT.tolowerCase()) {
                        if(rc!= null) {
                            String objectId = buildId(fld);
                            data.put(objectId, rc.get('Id') );
                            data.put('Included', buildSelected(true, c.get('Id')) ); 
                            data.put(objectWithFieldName, rc.get(fld.Name) );
                        }
                    }
                }
            }catch(exception ex) {

            }
        }
        return data;
    }

	public TmBoarding.DataComponent buildAccounts(TmBoarding.RequestPm pm, List<DmField> accountOptions) {
		TmBoarding.DataComponent component = new TmBoarding.DataComponent();
		List<Map<String, Object>> dataAccounts = new List<Map<String, Object>>();
        Map<String, TM_Service_Request_Account__c> serviceAccountMap = new  Map<String, TM_Service_Request_Account__c>();
        Map<String, Eb_Account__c> accounts = new Map<String,Eb_Account__c>();

        if(pm.accountPms != null) {
            for(Eb_Account__c a : pm.accountPms){
                if(!accounts.containsKey(a.Id)){
                    accounts.put(a.Id, a);
                }
            }
        }
        if(pm.serviceAccountPms != null){
            for(TM_Service_Request_Account__c r : pm.serviceAccountPms){
                if(!accounts.containsKey(r.Eb_Account__c)){
                    accounts.put(r.Eb_Account__c, r.Eb_Account__r);
                }
            }
        }

        if(pm.serviceAccountPms != null) {
            for(TM_Service_Request_Account__c ac : pm.serviceAccountPms) {
                if(String.IsBlank(ac.Eb_Account__c)){
                    String prospective = ac.Prospective_Account__c;
                    serviceAccountMap.put(prospective, ac);
                }else{
                    serviceAccountMap.put(ac.Eb_Account__c , ac);
                }
            }
        }

        for(String acctId : serviceAccountMap.keySet()){
            if(accounts.get(acctId) == null) {
                TM_Service_Request_Account__c ac = serviceAccountMap.get(acctId);
                String accountNumber = ac.Eb_Account__c == null ? ac.Prospective_Account__c : ac.Eb_Account__r.Account_Number__c;
                
                Eb_Account__c currentAccount = ac.EB_Account__r;
                currentAccount.Account_Number__c = accountNumber;
                accounts.put(acctId, currentAccount);
            }
        }

        for(Eb_Account__c a : accounts.values()) {
            Map<String, Object> data = buildAccount(a, accountOptions, serviceAccountMap);
            if(data.keyset().size() > 0) {dataAccounts.add(data);}
        }

        component.Data = dataAccounts;

        return component;
	}

    public Map<string, Object> buildAccount(Eb_Account__c a ,List<DmField> accountOptions ,Map<String, TM_Service_Request_Account__c> serviceAccountMap) {

        Map<String, Object> data = new Map<String, Object>();
        for(DmField fld : accountOptions) {
            try {
                if(IsValid(fld)) {
                    String objectWithFieldName = buildKey(fld);
                    TM_Service_Request_Account__c ac = null;
                    if(String.isBlank(a.Id)){
                        ac = serviceAccountMap.get(a.Account_Number__c);
                    }else {
                        ac = serviceAccountMap.get(a.Id);
                    }
                    String ParentId = String.isBlank(a.Id)  ? ac.Prospective_Account__c : a.Id;
                    String ParentName = String.isBlank(a.Id) ? ac.Prospective_Account__c : a.Name;
                    if(fld.objectName.tolowerCase() == TmConfiguration.CORE_ACCOUNT.tolowerCase()) {
                        String objectId = buildId(fld);
                        data.put('ParentId', ParentId);
                        data.put('ParentName', ParentName);
                        data.put(objectId, a.get('Id') );
                        boolean selected = ac == null ? false : true;
                        data.put('Included', buildSelected(selected, (Object)ParentId) );                     
                        data.put(objectWithFieldName, a.get(fld.Name) );
                       
                    }
                    if(fld.objectName.tolowerCase() == TmConfiguration.TM_REQUEST_ACCOUNT.tolowerCase()) {
                        
                        if(ac!= null) {
                            String objectId = buildId(fld);
                            data.put(objectId, ac.get('Id') );
                            data.put('Included', buildSelected(true, (Object)ParentId) );
                            data.put(objectWithFieldName, ac.get(fld.name) );
                        }
                    }
                }
            }catch(exception ex) {

            }
        }
        return data;
    }

	public TmBoarding.DataComponent buildContactAccounts(TmBoarding.RequestPm pm, List<DmField> contactAccounts) {
		//needs implementation
        TmBoarding.DataComponent dc = new TmBoarding.DataComponent();
		return null;
	}

    private Object getDetailValue(DmField fld, TmBoarding.RequestPm pm){
         if(fld.ObjectName.tolowercase() == 'tm_service_request_packet__c'){
    		return pm.packetPm.get(fld.Name);
        }
        return pm.requestPm.get(fld.name);
    }

    private Object getAltDetailValue(DmField fld, TmBoarding.RequestPm pm){
         if(fld.ObjectName.tolowercase() == 'tm_service_request_packet__c'){
    		return pm.packetPm.get(fld.AlternateName);
        }
        return pm.requestPm.get(fld.AlternateName);
    }

	private String buildKey(DmField fld) {
        return String.format('{0}.{1}', new LIST<String>{fld.ObjectName, fld.Name});
    }

    private String buildAltKey(DmField fld) {
        return String.format('{0}.{1}', new LIST<String>{fld.ObjectName, fld.AlternateName});
    }

    private String buildId(DmField fld) {
        return String.format('{0}.Id', new LIST<String>{fld.ObjectName});
    }

    private Boolean findPacketDmField(List<DmField> requestFields, List<DmField> scheduleFields){

        for(DmField dm : requestFields){
            if(dm.ObjectName.tolowercase() == TmConfiguration.TM_REQUEST_PACKET.tolowercase()){
                return true;
            }
        }

        for(DmField dm : scheduleFields){
            if(dm.ObjectName.tolowercase() == TmConfiguration.TM_REQUEST_PACKET.tolowercase()){
                return true;
            }
        }

        return false;
    }

    private Map<String, Object> buildSelected(boolean selected, Object objectId) {
         Map<String, Object> selectedParams = new Map<String, Object>();
         selectedParams.put('Selected', selected );
         selectedParams.put('Id', objectId);
         return selectedParams;
    }

    private boolean IsValid(DmField fld) {
        return (fld.IsAccessible == null ||fld.IsAccessible == true ) 
               && String.IsNotBlank(fld.Name) ;
    }

    private String getAlternateField(DmField fld){
        return String.isBlank(fld.AlternateName )?'':fld.AlternateName;
    }
}