public with sharing class SL_ChatterLightning_Controller {
    private static Map<String, String> aRequestNames = null;
    
    private static Map<String, Map<String, String>> aOneArray = new Map<String, Map<String, String>>(); 
    private static  Map<String, Map<String, Map<String, String>>> aTwoArray = new Map<String, Map<String, Map<String, String>>>();


    public Map<String, String> aParam{get;set;}
    public Map<String, String> aReadonly {get;set;}
    
    public SL_ChatterLightning_Controller(){
        this.aParam = new Map<String, String>{
            'color' => '',
            'font' => '',
            'button' => '',
            'bg' => '',
            'parent' => '',
            'id' => ''
        };
        this.parseRequestArray();
        this.prepare();
    }
    
    private void prepare(){
    	for(String sKey : this.aParam.keySet()){
    		if (SL_ChatterLightning_Controller.aRequestNames.containsKey(sKey)) {
	            this.aParam.put(sKey, SL_ChatterLightning_Controller.aRequestNames.get(sKey));
	        }
    	}
    }
    
    private void parseRequestArray() {
        List<String> aTmp;
        Integer nLevel, nTemp = 0;
        String sTmpName;
        SL_ChatterLightning_Controller.aRequestNames = new Map<String, String>();
        for (String sName : ApexPages.currentPage().getParameters().keySet()) {
            aTmp = sName.split('\\[');
            nLevel = aTmp.size();
            if (nLevel == 1) {
                SL_ChatterLightning_Controller.aRequestNames.put(sName, ApexPages.currentPage().getParameters().get(sName));
                continue;
            } 
            else if (nLevel == 2) {
                if (!SL_ChatterLightning_Controller.aOneArray.containsKey(aTmp[0])) {
                    SL_ChatterLightning_Controller.aOneArray.put(aTmp[0], new Map<String, String>());
                }
                
                sTmpName = aTmp[1].replace(']', '');
                if (sTmpName == '') {
                    sTmpName = '' + nTemp;
                    nTemp = nTemp + 1;
                }
                SL_ChatterLightning_Controller.aOneArray.get(aTmp[0]).put(sTmpName, ApexPages.currentPage().getParameters().get(sName));
            } else if (nLevel == 3) {
                if (!SL_ChatterLightning_Controller.aTwoArray.containsKey(aTmp[0])) {
                    SL_ChatterLightning_Controller.aTwoArray.put(aTmp[0], new Map<String, Map<String, String>>());
                }
                sTmpName = aTmp[1].replace(']', '');
                if (!SL_ChatterLightning_Controller.aTwoArray.get(aTmp[0]).containsKey(sTmpName)) {
                    SL_ChatterLightning_Controller.aTwoArray.get(aTmp[0]).put(sTmpName, new Map<String, String>());
                }
                SL_ChatterLightning_Controller.aTwoArray.get(aTmp[0]).get(sTmpName).put(aTmp[2].replace(']', ''), ApexPages.currentPage().getParameters().get(sName));
            }
        }
        
    }
}