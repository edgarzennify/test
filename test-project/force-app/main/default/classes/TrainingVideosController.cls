public class TrainingVideosController {
    private List<Training_Video__c> videos;
    private String sortDirection = 'ASC';
    private String sortExp = 'Viewing_Order__c';
    public String sortExpression{
         get{
                 return sortExp;
            }
         set{   
                 if (value == sortExp) 
                     sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
                else
                     sortDirection = 'ASC';
                     sortExp = value;
            }
    }
    public String getSortDirection() {
         if (sortExpression == null || sortExpression == '')
               return 'ASC';
         else     return sortDirection;
    }
    public void setSortDirection(String value) {
         sortDirection = value;
    }
    public List<Training_video__c> getVideos() {
           return videos;
    }
    public PageReference View() {
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        videos = Database.query('Select id,  URL__c, Description__c , View__c, Duration__c, Viewing_Order__c , Library__c FROM Training_Video__c  order by ' + sortFullExp + ' limit 950');
        return null;
    }
    public static testMethod void verifyTrainingVideosPageReference(){
        Training_Video__c tivo = new Training_Video__c(URL__c = 'http://www.google.com',
                                                                                                   Description__c = 'google',
                                                                                                   //View__c = '<a href="http://www.google.com" target="_blank">google website</a>',
                                                                                                   Duration__c = '2 Minutes',
                                                                                                   Viewing_Order__c = 2 ,
                                                                                                   Library__c ='SalesForce.com Foundations' );
        insert tivo;
        
        TrainingVideosController controller = new TrainingVideosController();
        controller.View();
    }
     public static testMethod void verifyTrainingVideosMethods(){
        Training_Video__c tivo = new Training_Video__c(URL__c = 'http://www.google.com',
                                                                                                   Description__c = 'google',
                                                                                                   //View__c = '<a href="http://www.google.com" target="_blank">google website</a>',
                                                                                                   Duration__c = '2 Minutes',
                                                                                                   Viewing_Order__c = 2 ,
                                                                                                   Library__c ='SalesForce.com Foundations' );
                insert tivo;
                TrainingVideosController controller = new TrainingVideosController();
        controller.setSortDirection('Asc');
        String d = controller.getSortDirection();
        controller.sortExpression = 'sortExp';
        String s = controller.sortExpression;
        
        
     }
  }