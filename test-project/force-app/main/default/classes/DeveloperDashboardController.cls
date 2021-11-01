public class DeveloperDashboardController{
	public Boolean popupVisible {get;set;}
	
	public String objectDrilldown {get;set;}
	public List<FieldWrapper> drillDownFields {get;set;}
    
    public String EnvironmentName{
        get{
            if(URL.getSalesforceBaseUrl().toExternalForm().contains('full'))            
            return 'Sandbox Full';
            else if(URL.getSalesforceBaseUrl().toExternalForm().contains('ru'))
            return 'Sandbox ru';
            else if(URL.getSalesforceBaseUrl().toExternalForm().contains('bh'))
            return 'Sandbox bh';
            else if(URL.getSalesforceBaseUrl().toExternalForm().contains('jb'))
            return 'Sandbox jb';
            else if(URL.getSalesforceBaseUrl().toExternalForm().contains('klm2'))
            return 'Sandbox klm2';
            return URL.getSalesforceBaseUrl().toExternalForm();
        }
    }

    public List<ApexClass> ApexClasses{
        get{
            return [SELECT Id, Name, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById  FROM ApexClass ORDER BY LastModifiedDate DESC];
        }
    }
    
    public List<ApexComponent> ApexComponents{
        get{
            return [SELECT Id, Name, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById FROM ApexComponent ORDER BY LastModifiedDate DESC];
        }
    }
    
    public List<ApexPage> ApexPages{
        get{
            return [SELECT Id, Name, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById FROM ApexPage ORDER BY LastModifiedDate DESC];
        }
    }
    
    public List<ApexTrigger> ApexTriggers{
        get{
            return [SELECT Id, Name, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById FROM ApexTrigger ORDER BY LastModifiedDate DESC];
        }
    }
    
    private List<ObjectWrapper> ObjectsAndCustomSettings{
    	get{
    		if(ObjectsAndCustomSettings == null){
	    		List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();     
	            ObjectsAndCustomSettings = new List<ObjectWrapper>();
	            
	            for(Schema.SObjectType f : gd){
	                ObjectWrapper ow = new ObjectWrapper(f);
	                if(ow.isCustom()){
	                	ObjectsAndCustomSettings.add(ow);
	                }
	            }
	            
	            ObjectsAndCustomSettings.sort();
    		}
            return ObjectsAndCustomSettings;
    	}
    	set;
    }
    
    public List<ObjectWrapper> Objects{
    	get{
	        List<ObjectWrapper> objs = new List<ObjectWrapper>();
		    
		    for(ObjectWrapper ow : ObjectsAndCustomSettings){
		    	if(ow.isCustom() && ow.Type=='Object'){objs.add(ow);}
		    }
		    
		    objs.sort();
		    return objs;
    	}
    }
    
    public List<ObjectWrapper> CustomSettings{
        get{
            List<ObjectWrapper> objs = new List<ObjectWrapper>();
            
            for(ObjectWrapper ow : ObjectsAndCustomSettings){
                if(ow.isCustom() && ow.Type=='Custom Setting'){objs.add(ow);}
            }
            
            objs.sort();
            return objs;
        }
    }
    
    public List<FieldWrapper> Fields{
        get{
        	List<FieldWrapper> flds = new List<FieldWrapper>();
        	for(ObjectWrapper ow : Objects){
        		if(flds.size() < 1){
        		flds.addAll(ow.fields);
        		}
        	}
        	return flds;
        }
    }
        
    public void showObjectFields(){
    	for(ObjectWrapper ow : ObjectsAndCustomSettings){
            if(ow.Name == objectDrilldown){
            	drillDownFields = ow.fields;
            }
        }
        popupVisible = true;
    }
    
    public void closePopup(){
    	popupVisible = false;
    }
    
    public class ObjectWrapper implements Comparable{
    	private Schema.SObjectType m_sObj;
    	public ObjectWrapper(Schema.SObjectType sObj){
    		m_sObj = sObj;
    		
    	}
    	public String Name{
    		get{
    			return m_sObj.getDescribe().getName();
    		}
        }
        public String Label{
            get{
                return m_sObj.getDescribe().getLabel();
            }
        }
        public String Type{
            get{
                if(m_sObj.getDescribe().isCustomSetting()){
                	return 'Custom Setting';
                }
                return 'Object';
            }
        }
        public Boolean isCustom(){
        	return m_sObj.getDescribe().isCustom();
        }
        public List<FieldWrapper> fields{
        	get{
        		List<FieldWrapper> myFields = new List<FieldWrapper>();
        		Map <String, Schema.SObjectField> fieldMap = m_sObj.getDescribe().fields.getMap();
	            for(Schema.SObjectField sfield : fieldMap.Values()){
	                   myFields.add(new FieldWrapper(this, sfield));
	            }
	            myFields.sort();
        		return myFields;
        	}
        }
        public Integer compareTo(Object compareTo){
        	ObjectWrapper compareToObject = (ObjectWrapper)compareTo;
	        if (Name == compareToObject.Name) return 0;
	        if (Name > compareToObject.Name) return 1;
	        return -1; 
        }
    }
    
    public class FieldWrapper implements Comparable{
    	private ObjectWrapper m_obj;
    	private Schema.SObjectField m_field;
        public FieldWrapper(ObjectWrapper obj, Schema.SObjectField field){
            m_field = field;
            m_obj = obj;
        }
        public String ObjectName{
        	get{
        		return m_obj.Name;
        	}
        }
        public String Name{
            get{
                return m_field.getDescribe().getName();
            }
        }
        public String Label{
            get{
                return m_field.getDescribe().getLabel();
            }
        }
        public String Type{
            get{
                return String.valueOf(m_field.getDescribe().getType());
            }
        }
        public Integer compareTo(Object compareTo){
            FieldWrapper compareToField = (FieldWrapper)compareTo;
            if (Name == compareToField.Name) return 0;
            if (Name > compareToField.Name) return 1;
            return -1; 
        }
    }
        
}