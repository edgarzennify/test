public class ImageNowDocument {

    public interface IImageNowDocumentDataProvider{
        String GetDocumentByDocID(string docID);
    }

    private IImageNowDocumentDataProvider m_dataProvider;

    public ImageNowDocument(IImageNowDocumentDataProvider dataProvider)
    {
        m_dataProvider = dataProvider;
    }

    public String GetImageNowDocumentByID(string docID){
        return GetImageNowDocumentFromJSON(m_dataProvider.GetDocumentByDocID(docID));
    }

    private String GetImageNowDocumentFromJSON(string jsonString){
        try{
            JSONParser parser = JSON.createParser(jsonString);
            parser.nextToken();
            parser.nextValue();
            parser.nextValue();
            return parser.getText();
        } 
        catch (Exception e){
            return '';
        }

    }


}