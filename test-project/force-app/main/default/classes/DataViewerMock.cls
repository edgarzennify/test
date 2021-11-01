@IsTest
public class DataViewerMock {
    public class ofIDataProvider extends ApexMoq implements DataViewer.IDataProvider {
        public PM_DVReport getReportByName(String rptName) {
            return (PM_DVReport)handleMethodInvocation('getReportByName', new List<Object>{rptName});
        }
        public List<Object> getResults(String param) {
            return (List<Object>)handleMethodInvocation('getResults', new List<Object>{param});
        }
        public DataViewer.IReportDataProvider getReportDataProviderInstance(String param) {
            return (DataViewer.IReportDataProvider)handleMethodInvocation('getReportDataProviderInstance', new List<Object>{param});
        }
    }

    public class ofIHelper extends ApexMoq implements DataViewer.IHelper {
        public Blob getOutputTemplate(PM_DVReport report){
            return (Blob)handleMethodInvocation('getOutputTemplate', new List<Object>{report});
        }
        public List<Object> executeQuery(String query){
            return (List<OBject>)handleMethodInvocation('executeQuery', new List<OBject>{query});
        }
        public List<Object> getResultsFromReportDataProvider(String className, String contextId){
            return (List<OBject>)handleMethodInvocation('getResultsFromReportDataProvider', new List<OBject>{className, contextId});
        }
        public String prepareQuery(String queryTemplate, List<DataViewer.MergeField> fields){
            return (string)handleMethodInvocation('prepareQuery', new List<Object>{queryTemplate, fields});
        }
        public List<DataViewer.MergeField> buildMerges(string contextId, Map<string, string> parameters){
            return (List<DataViewer.MergeField>)handleMethodInvocation('buildMerges', new List<Object>{contextId, parameters});
        }
        public PM_DVReport getReportByName(string name){
            return (PM_DVReport)handleMethodInvocation('getReportByName', new List<Object>{name});
        }
    }

    public class ofIDocumentHandler extends ApexMoq implements DataViewer.IDocumentHandler {
        public string getPdfDocument(Blob templateBytes, string dataAsJson, string folderName, string documentName){
            return (string)handleMethodInvocation('getPdfDocument', new List<Object>{templateBytes, dataAsJson, folderName, documentName});
        }
        public string getDocumentName(string documentNamePrefix){
            return (string)handleMethodInvocation('getDocumentName', new List<Object>{documentNamePrefix});
        }
        public string getHtmlDocument(Blob templateBytes, string dataAsJson){
            return (string)handleMethodInvocation('getHtmlDocument', new List<Object>{templateBytes, dataAsJson});
        }
        public string getPdfDocument(string base64Pdf, string folderName,string documentName){
            return (string)handleMethodInvocation('getPdfDocument', new List<Object>{base64Pdf,folderName,documentName});
        }
    }

    public class ofIPresenter extends ApexMoq implements DataViewer.IPresenter {
        public DataViewer.FormVm buildFormVm() {
            return (DataViewer.FormVm)handleMethodInvocation('buildFormVm');
        }
    }
}