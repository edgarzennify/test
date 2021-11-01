public class BarcodeGeneratorDmBuilder implements BarcodeGenerator.IDmBuilder {
  
    public DmBgBatch buildBatch(Id batchId) {
        DmBgBatch batch = new DmBgBatch();
        batch.batchId = batchId;
        return batch;
    }

    public DmBgContext buildDmContext(Id contextId, List<BarcodeGeneratorCfgJunction__c> contextJxs, Map<Id, List<BarcodeGeneratorCfgDocType__c>> doctypes) {
        DmBgContext dm = new DmBgContext();
        dm.objectName = contextJxs[0].Context__r.ObjectName__c;
        dm.categories = new List<DmBgCategory>();
        Map<String, List<BarcodeGeneratorCfgJunction__c>> jxByCat = groupByCategory(contextJxs);
        for(String catName : jxByCat.keySet()){
            List<BarcodeGeneratorCfgJunction__c> jxs = jxByCat.get(catName);
            BarcodeGeneratorCfgJunction__c first = jxs[0];
            dm.categories.add(buildDmCategory(jxs, doctypes.get(first.Category__r.Id)));
        }
        return dm;
    }
    
    private DmBgCategory buildDmCategory(List<BarcodeGeneratorCfgJunction__c> jxs, List<BarcodeGeneratorCfgDocType__c> doctypes){
        DmBgCategory dm = new DmBgCategory();
        BarcodeGeneratorCfgJunction__c first = jxs[0];
        dm.name = first.Category__r.Name;
        dm.permissionSet = first.Category__r.Required_Perrmission_Set_Name__c;
        dm.docTypes = doctypes == null ? new List<DmBgDocType>() : buildDmDocTypes(doctypes);
        dm.junctionId = first.Id;
        dm.junctionType = first.JunctionType__c;
        dm.queries = new List<DmBgQuery>();
        for(BarcodeGeneratorCfgJunction__c jx : jxs){
            DmBgQuery qdm = new DmBgQuery();
            qdm.queryTemplate = jx.Query_Template__c;
            qdm.queryDescription = jx.Query_Description_Field__c;
            qdm.queryValue = jx.Query_Value_Field__c;
            dm.queries.add(qdm);
        }        
        return dm;
    }

    private List<DmBgDocType> buildDmDocTypes(List<BarcodeGeneratorCfgDocType__c> pms) {
        List<DmBgDocType> dms = new List<DmBgDocType>();
        for(BarcodeGeneratorCfgDocType__c pm : pms) {
            dms.add(buildDmDocType(pm));
        }
        return dms;
    }

    private DmBgDocType buildDmDocType(BarcodeGeneratorCfgDocType__c pm) {
        DmBgDocType dm = new DmBgDocType();
        dm.name = pm.Name;
        return dm;
    }


    private Map<String, List<BarcodeGeneratorCfgJunction__c>> groupByCategory(List<BarcodeGeneratorCfgJunction__c> jxs){
        Map<String, List<BarcodeGeneratorCfgJunction__c>> grouped = new Map<String, List<BarcodeGeneratorCfgJunction__c>>();
        for(BarcodeGeneratorCfgJunction__c jx : jxs){
            String key = jx.Category__r.Name;
            if(!grouped.containsKey(key)){
                grouped.put(key, new List<BarcodeGeneratorCfgJunction__c>());
            }
            grouped.get(key).add(jx);
        }
        return grouped;
    }
}