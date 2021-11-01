public class FileDeconstructor implements IFileDeconstructor{
    public interface IFileDeconstructor{
        List<String> getCsvLineItems(Blob fileBody);
    }
    public List<String> getCsvLineItems(Blob fileBody){
        String fileAsString = fileBody.toString();
        List<String>fileItems = fileAsString.split('\n');
        return fileItems;
    }
}