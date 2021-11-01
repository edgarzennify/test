public class ExternalDocumentViewer {

    public interface IRequestHandler{
        string Handle();
        DmDocument buildDocument(Map<string, string> parameters);
    }

    public interface IPresenter{
        DmDocument getDocument(Map<string, string> parameters);
    }
}