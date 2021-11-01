public class DataViewerHelper implements DataViewer.IHelper{

    private final DataViewer.IDataProvider m_dataProvider;
    private final AttachmentHandler.IAttachmentHandler m_attachmentHandler;

    public DataViewerHelper(DataViewer.IDataProvider dataProvider, AttachmentHandler.IAttachmentHandler attachmentHandler){
        m_dataProvider = dataProvider;
        m_attachmentHandler = attachmentHandler;
    }

    public Blob getOutputTemplate(PM_DVReport report){
        Blob templateBytes = null;
        
        if(report.Use_Attachment_As_Template == true){
            for(Attachment a : m_attachmentHandler.getAllAttachmentsForParent(report.Id)) {
				if(a.name == report.Attatchment_Template_Name) {
					templateBytes = a.Body;
				}
            }
        }else{
            String templateString = report.Output_Template;
        	templateBytes = Blob.valueOf(templateString);
        }
        
        return templateBytes;
    }

    public List<Object> executeQuery(String query){ 
        try{
            return m_dataProvider.getResults(query);       	
        }catch(Exception ex){ 
            return new List<Object>{'execute query failed'};
        }        
    }

    public List<Object> getResultsFromReportDataProvider(String className, String contextId){
        try{            
            DataViewer.IReportDataProvider handler = m_dataProvider.getReportDataProviderInstance(className);
        	return handler.getResults(contextId);        	
        }catch(Exception ex){ 
            return new List<Object>{'Get Result Failed'};
        }
    }

    public String prepareQuery(String queryTemplate, List<DataViewer.MergeField> fields){
        String query = queryTemplate;
        for(DataViewer.MergeField x : fields){
            if(String.isNotBlank(x.Value)){
                query = query.replace(x.Token, x.Value);
            }
        }
        return query;
    }

    public List<DataViewer.MergeField> buildMerges(string contextId, Map<string, string> parameters){
        List<DataViewer.MergeField> merges = new List<DataViewer.MergeField>();
        DataViewer.MergeField ctxMerge = new DataViewer.MergeField();
        ctxMerge.Token = '{!contextId}';
        ctxMerge.Value = contextId;
        merges.add(ctxMerge);
        
        Map<String,String> pageParams = parameters;
        if(pageParams != null){
        	for(String key : pageParams.keySet()){
                DataViewer.MergeField m = new DataViewer.MergeField();
                m.Token = '{!' + key + '}';
                m.Value = pageParams.get(key);
                merges.add(m);      
        	}            
        }
        
        return merges;
    }

    public PM_DVReport getReportByName(string name){
        return m_dataProvider.getReportByName(name);
    }

}