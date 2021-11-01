public class BarcodeGeneratorPmBuilder implements BarcodeGenerator.IPmBuilder {

	private String BATCH_DESCRIPTION = 'Create Barcode Batch ID';
	private final Utility.IUtility m_util;

	public BarcodeGeneratorPmBuilder(Utility.IUtility util) {
		m_util = util;
	}

    public BarcodeGeneratorBatch__c buildBatch(String contextId) {
        BarcodeGeneratorBatch__c batch = new BarcodeGeneratorBatch__c();
        batch.description__c = BATCH_DESCRIPTION;       
        if(!String.isBlank(contextId)){    
	        batch.Object_URL__c = m_util.getServerUrl() + '/' + m_util.convertid15ToId18(contextId);
	    }
		return batch;
    }

    public BarcodeGenerator.BarcodeConfig buildChildrenAndSiblings(BarcodeGeneratorBatch__c batch, BarcodeGenerator.FormSm formSm) {
		BarcodeGenerator.BarcodeConfig config = new BarcodeGenerator.BarcodeConfig();
		config.children = new List<BarcodeGeneratorChildKey__c>();
		config.siblings = new List<BarcodeGeneratorSibling__c>();
		for(BarcodeGenerator.RowSm sm: formSm.rows) {
		    if(!String.isBlank(sm.documentType)) {    
			    BarcodeGeneratorChildKey__c child = buildChild(batch, sm, formSm.batchTitle);          
	            config.children.add(child);
	            config.siblings.addAll(buildSiblings(child, sm.Objects));  
            }           
        }
        return config;
	}

	public BarcodeGenerator.BarcodeConfig updateSiblingsWithChildKeys(BarcodeGenerator.BarcodeConfig config) {
		if (config.siblings.size()>0){
            for(BarcodeGeneratorChildKey__c childkey :config.children){                
                for (BarcodeGeneratorSibling__c sibling :config.siblings){
                    if (childkey.SequenceNumber__c == sibling.ChildKeySequenceNumber__c) {                      
                        sibling.BarcodeGeneratorChildKey__c = childkey.id;
                    }
                }
            }        
        }
		return config;
	}

	private BarcodeGeneratorChildKey__c buildChild(BarcodeGeneratorBatch__c batch, BarcodeGenerator.RowSm sm, String batchTitle) {
		BarcodeGeneratorChildKey__c child = new BarcodeGeneratorChildKey__c();
        child.BarcodeGeneratorLookup__c = batch.Id;               
        child.Category__c = sm.category;
        child.DocumentType__c = sm.documentType;
        child.DocumentDate__c = sm.documentDate;
        child.Comment__c = sm.comment;
        child.BatchTitle__c = batchTitle;
        child.SequenceNumber__c = sm.rowIndex + 1;
        return child;  
	}

	private List<BarcodeGeneratorSibling__c> buildSiblings(BarcodeGeneratorChildKey__c child, List<String> objectIds) {
		List<BarcodeGeneratorSibling__c> siblings = new List<BarcodeGeneratorSibling__c>();
		Integer counter = 1;
        for(string objId: objectIds) {
            siblings.add(buildSibling(child, objId, counter++));               
        }
        return siblings;
	}

	private BarcodeGeneratorSibling__c buildSibling(BarcodeGeneratorChildKey__c child, String objId, Integer counter) {
		BarcodeGeneratorSibling__c sibling = new BarcodeGeneratorSibling__c();
    	sibling.ChildKeySequenceNumber__c = child.SequenceNumber__c;
    	sibling.SequenceNumber__c = counter;
        sibling.SalesforceKey__c = objId;
        return sibling;
	}
}