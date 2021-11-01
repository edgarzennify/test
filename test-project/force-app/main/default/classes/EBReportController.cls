public class EBReportController {
	private List<EB_Report__c> reports;
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
    public List<EB_Report__c> getReports() {
           return reports;
    }
    public PageReference View() {
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        reports = Database.query('Select id,  URL__c, Description__c , Report_Name__c,  Viewing_Order__c, Name, Category__c  FROM EB_Report__c  order by ' + sortFullExp + ' limit 950');
        return null;
    }
    public static testMethod void verifyReportControllerPageReference(){
        EB_Report__c report = new EB_Report__c(URL__c = 'http://www.google.com',
                                                Description__c = 'google',
                                                //View__c = '<a href="http://www.google.com" target="_blank">google website</a>',
                                                 //Report_Name__c =   '<a href="http://www.google.com" target="_blank">google website</a>',                                                
                                                  Viewing_Order__c = 2 
                                                                                                  );
        insert report;
        
        EBReportController controller = new EBReportController();
        controller.View();
    }
     public static testMethod void verifyTrainingVideosMethods(){
       EB_Report__c report = new EB_Report__c(URL__c = 'http://www.google.com',
                                                Description__c = 'google',
                                                //View__c = '<a href="http://www.google.com" target="_blank">google website</a>',
                                                 //Report_Name__c =   '<a href="http://www.google.com" target="_blank">google website</a>',                                                
                                                  Viewing_Order__c = 2 
                                                                                                  );
        insert report;
         EBReportController controller = new EBReportController();
        controller.setSortDirection('Asc');
        String d = controller.getSortDirection();
        controller.sortExpression = 'sortExp';
        String s = controller.sortExpression;
        
        
     }
}