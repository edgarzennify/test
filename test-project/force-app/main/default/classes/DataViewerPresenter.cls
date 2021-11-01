public class DataViewerPresenter implements DataViewer.IPresenter{

    private final string FOLDER_NAME = 'DataViewer';
    private final string REPORT_PREFIX = 'DvReport';
    private final IApexPages m_apexPages;
    private final IJson m_json;
    private final DataViewer.IDocumentHandler m_docHandler;
    private final IEncodingUtil m_encodingUtil;
    private final DataViewer.IHelper m_helper;
    
    public DataViewerPresenter(IApexPages apexPages, IJson json, 
    DataViewer.IDocumentHandler docHandler, 
    IEncodingUtil encodingUtil,
    DataViewer.IHelper helper){
        m_apexPages = apexPages;
        m_json = json;
        m_docHandler = docHandler;
        m_encodingUtil = encodingUtil;
        m_helper = helper;
    }
    
    public DataViewer.FormVm buildFormVm(){
        DataViewer.FormVm vm = new DataViewer.FormVm();
        String reportName = m_apexPages.getParameter('rpt');
        Boolean debugMode = m_apexPages.getParameter('debug') == '1';
        String contextId = m_apexPages.getParameter('cid');
        vm.isPdf = m_apexPages.getParameter('pdf') == 'true';
        PM_DvReport rpt = m_helper.getReportByName(reportName);
        vm.reportName = reportName;
        
        DataViewer.ProcessingData d = getReportData(rpt, contextId);
        setupPdf(vm, d);
        setupVmDebugData( rpt, debugMode, vm, d);

        return vm;   
    }

    private void setupVmDebugData(PM_DVReport rpt, Boolean debugMode, DataViewer.FormVm vm, DataViewer.ProcessingData d){
        if(errorList.size() > 0){vm.results = 'Error: Unable to display data';}
        if(debugMode) {
            vm.showDebugInfo = true;
            vm.debugErrors = errorList;
            vm.debugReportObj = m_json.serializePretty(rpt);
            vm.debugQuery = d.query;          
            vm.debugData = m_json.serializePretty(d.ResultData);   
        }  
    }

    private DataViewer.ProcessingData getReportData(PM_DVReport rpt, string contextId){
        DataViewer.ProcessingData d = new DataViewer.ProcessingData();
        
        d.ResultData = new DataViewer.ResultsWrapper();
        if(rpt.Use_Apex_Class_As_Query){
            d.query = '< Query text unavailable, see Apex Class "' + rpt.Apex_Class_Name + '" for details. >';
        	d.ResultData.results = m_helper.getResultsFromReportDataProvider(rpt.Apex_Class_Name, contextId);
        }
        else{
            List<DataViewer.MergeField> merges = m_helper.buildMerges(contextId, m_apexPages.getparameters()); 
            d.query = m_helper.prepareQuery(rpt.Query_Template, merges);
        	d.ResultData.results = m_helper.executeQuery(d.query);    
        }
        d.Json = m_json.Serialize(d.ResultData); 
        d.TemplateBytes = m_helper.getOutputTemplate(rpt);

        return d;
    }

    private void setupPdf(DataViewer.FormVm vm, DataViewer.ProcessingData d){
        if(vm.isPdf){
            String docName = m_docHandler.getDocumentName(REPORT_PREFIX);
            vm.documentId = m_docHandler.getPdfDocument(d.templateBytes, d.json, FOLDER_NAME, docName);
        } else{
            vm.results = m_docHandler.getHtmlDocument(d.TemplateBytes, d.json);
        }
    }

    private List<String> errorList {
        get{
            if(errorList == null){
                errorList = new List<String>();
            }
            return errorList;
        }
        set;
    }
}