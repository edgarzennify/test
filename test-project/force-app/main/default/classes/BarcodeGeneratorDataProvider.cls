public class BarcodeGeneratorDataProvider implements BarcodeGenerator.IDataProvider {
    
    public List<BarcodeGeneratorCfgJunction__c> getJunctions() {
        return [
            SELECT
                Category__r.Id,
                Category__r.Name,
                Category__r.Required_Perrmission_Set_Name__c,
                Context__r.Id,
                Context__r.ObjectName__c,
                Query_Description_Field__c,
                Query_Template__c,
                Query_Value_Field__c,
                JunctionType__c,
				Id
            FROM
                BarcodeGeneratorCfgJunction__c
            ORDER BY
                Category__r.Name
        ];
    }

    public List<BarcodeGeneratorCfgDocType__c> getDocTypes() {
        return  [
            SELECT
                Id,
                Name,
                Category__r.Id,
                Category__r.Name,
                Category__r.Required_Perrmission_Set_Name__c
            FROM
                BarcodeGeneratorCfgDocType__c
            ORDER BY
                Name
        ];
    }

    public void save(List<SObject> sObjects) {
        List<SObject> insertList = new List<SObject>();
        List<SObject> updateList = new List<SObject>();
        for(SObject s : sObjects) {
            if(s != null) {
                if(s.Id == null) {
                    insertList.add(s);
                }else{
                    updateList.add(s);
                }
            }
        }
        if(insertList.size() > 0) insert insertList;
        if(updateList.size() > 0) update updateList;
    }
}