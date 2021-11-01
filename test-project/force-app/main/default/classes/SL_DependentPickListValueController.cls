public with sharing class SL_DependentPickListValueController
{
    public SL_DependentPickListValueController(){}
    public static Map<String,Map<String,List<Schema.PicklistEntry>>> mapObjFldPkVals = new Map<String,Map<String,List<Schema.PicklistEntry>>>();
    
    public static void loadObjFldPkVals(String pObjName, set<String> setFldNames){
    	
    	if(pObjName==null || setFldNames==null || setFldNames.size()==0) return;
    	
    	boolean isNeedLoad = false;
    	if(!mapObjFldPkVals.containsKey(pObjName)){
    		isNeedLoad = true;
    		mapObjFldPkVals.put(pObjName, new Map<String,List<Schema.PicklistEntry>>());
    	}
    	for(String item:setFldNames)
    	{
    		if(!mapObjFldPkVals.get(pObjName).containsKey(item)){
    			isNeedLoad = true;
    			mapObjFldPkVals.get(pObjName).put(item, new List<Schema.PicklistEntry>());
    		}
    	}
    	
    	if(isNeedLoad)
    	{
    		Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
    		Schema.SObjectType pType = Schema.getGlobalDescribe().get(pObjName);
    		for(String item:setFldNames)
    		{
    			if(mapObjFldPkVals.get(pObjName).get(item).size()==0)
    			{
    				List<Schema.PicklistEntry> ctrl_ple = pType.getDescribe().fields.getMap().get(item).getDescribe().getPicklistValues();
    				mapObjFldPkVals.get(pObjName).put(item, ctrl_ple);
    			}
    		}
    	}
    }

    public static Map<String,List<String>> GetDependentOptions(String pObjName, String pControllingFieldName, String pDependentFieldName)
    {
		SL_DependentPickListValueController.loadObjFldPkVals(pObjName, new set<String>{pControllingFieldName,pDependentFieldName});

		Map<String,List<String>> objResults = new Map<String,List<String>>();
        //get the string to sobject global map
        ////Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        //get the type being dealt with
        ////Schema.SObjectType pType = objGlobalMap.get(pObjName);
        ////Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
        //get the control values   
        ////List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> ctrl_ple = SL_DependentPickListValueController.mapObjFldPkVals.get(pObjName).get(pControllingFieldName);
        //get the dependent values
        ////List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> dep_ple = SL_DependentPickListValueController.mapObjFldPkVals.get(pObjName).get(pDependentFieldName);
        //iterate through the values and get the ones valid for the controlling field name
        SL_PickListUtils.Bitset objBitSet = new SL_PickListUtils.Bitset();
        //set up the results
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){            
            //get the pointer to the entry
            Schema.PicklistEntry ctrl_entry = ctrl_ple[pControllingIndex];
            //get the label
            String pControllingLabel = ctrl_entry.getLabel();
            //create the entry with the label
            objResults.put(pControllingLabel,new List<String>());
        }
        //check the dependent values
        for(Integer pDependentIndex=0; pDependentIndex<dep_ple.size(); pDependentIndex++){            
            //get the pointer to the dependent index
            Schema.PicklistEntry dep_entry = dep_ple[pDependentIndex];
            //get the valid for
            String pEntryStructure = JSON.serialize(dep_entry);                
            SL_PickListUtils.PicklistDetails objDepPLE = (SL_PickListUtils.PicklistDetails)JSON.deserialize(pEntryStructure, SL_PickListUtils.PicklistDetails.class);
            //iterate through the controlling values
            for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){    
                if (objBitSet.fitBit(objDepPLE.validFor,pControllingIndex)){                    
                    //get the label
                    String pControllingLabel = ctrl_ple[pControllingIndex].getLabel();
                    objResults.get(pControllingLabel).add(objDepPLE.label);
                }
            }
        } 
        return objResults;
    }
    
    public static List<String> getPickListValuesIntoList(String pObjName, String pControllingFieldName)
    {
		SL_DependentPickListValueController.loadObjFldPkVals(pObjName, new set<String>{pControllingFieldName});
		
		List<String> pickListValuesList= new List<String>();
		
		////Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
		////Schema.SObjectType pType = objGlobalMap.get(pObjName);
        ////Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
		
		////List<Schema.PicklistEntry> ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
		List<Schema.PicklistEntry> ple = SL_DependentPickListValueController.mapObjFldPkVals.get(pObjName).get(pControllingFieldName);
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }    
        return pickListValuesList;
    }
}