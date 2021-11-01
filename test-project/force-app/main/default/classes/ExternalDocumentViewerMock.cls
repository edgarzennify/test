@IsTest
public class ExternalDocumentViewerMock {

    public class ofIRequestHandler extends ApexMoq implements ExternalDocumentViewer.IRequestHandler{
        public string Handle(){
            return (string)handleMethodInvocation('Handle');
        }
        public DmDocument buildDocument(Map<string, string> parameters){
            return (DmDocument)handleMethodInvocation('buildDocument', new List<Object>{parameters});
        }
    }

    public class ofIPresenter extends ApexMoq implements ExternalDocumentViewer.IPresenter{
        public DmDocument getDocument(Map<string, string> parameters){
            return (DmDocument)handleMethodInvocation('getDocument', new List<Object>{parameters});
        }
    }
}