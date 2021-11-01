public class DataViewer {
    
    public interface IPresenter{
        FormVm buildFormVm();
    }
    
    public interface IDataProvider {
        PM_DvReport getReportByName(String name);
        List<Object> getResults(String queryString);
        IReportDataProvider getReportDataProviderInstance(String className);
    }
    
    public interface IReportDataProvider {    	
        List<Object> getResults(String contextId);
    }

    public interface IDocumentHandler{
        string getDocumentName(string documentNamePrefix);
        string getPdfDocument(Blob templateBytes, string dataAsJson, string folderName, string documentName);
        string getHtmlDocument(Blob templateBytes, string dataAsJson);
        string getPdfDocument(string base64Pdf, string folderName,string documentName);
    }

    public interface IHelper{
        Blob getOutputTemplate(PM_DVReport report);
        List<Object> executeQuery(String query);
        List<Object> getResultsFromReportDataProvider(String className, String contextId);
        PM_DVReport getReportByName(string name);
        String prepareQuery(String queryTemplate, List<MergeField> fields);
        List<MergeField> buildMerges(string contextId, Map<string, string> parameters);
    }

    public class FormVm {
        public string reportName{get;set;} 
        public String results {get;set;}
        public Boolean showDebugInfo {get;set;}
        public List<String> debugErrors {get;set;}
    	public String debugReportObj {get;set;}
        public String debugQuery {get;set;}
        public String debugData {get;set;}   
        public Boolean isPdf {get;set;}
        public string documentId{get;set;}      
    }
    
    public class ResultsWrapper {
        public List<Object> results {get;set;}
    }

    public class MergeField{
        public string Token{get;set;}
        public string Value{get;set;}
    }

    public class ProcessingData{
        public string Json{get;set;}
        public string Query{get;set;}
        public Blob TemplateBytes{get;set;}
        public DataViewer.ResultsWrapper ResultData{get;set;}
    }
}