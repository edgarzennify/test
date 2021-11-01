public class StaticResourceDataProvider implements StaticResourceDataProvider.IStaticResource {
    public interface IStaticResource {
        Blob getData(String staticResourceName);
        Blob getData(String staticResourceName, String fileNameInZippedFolder);
    }
    
    public Blob getData(String staticResourceName) {
         PageReference resource = PageReference.forResource(staticResourceName);
         return Blob.valueOf(resource.getContent().toString());
    }
    
    public Blob getData(String staticResourceName, String fileName) {

        StaticResource resource = getResource(staticResourceName);
        String timeStamp = String.valueOf(((DateTime)resource.get('SystemModStamp')).getTime());              
        String url = String.format('/resource/{0}/{1}/{2}', new LIST<String>{timeStamp, 
                                        String.valueOf(resource.get('Name')), fileName});
		PageReference pg = new PageReference(url);
		return Blob.valueOf(pg.getContent().toString());       
    }

    private StaticResource getResource(String staticResourceName) {
      
        return [
            SELECT
                Id
                ,Name
                ,SystemModStamp
            FROM
                StaticResource
            WHERE
                Name =: staticResourceName
            LIMIT 1
        ];
    }
}