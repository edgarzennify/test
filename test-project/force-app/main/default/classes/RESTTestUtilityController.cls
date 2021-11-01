public class RESTTestUtilityController {
    private WebServices.IRESTService m_restSvc;
    
    public String Url{get;set;}
    public String Body{get;set;}
    public String Method{get;set;}
    public String Results{get;set;}
    public String Status{get;set;}
    
    public RESTTestUtilityController(){
        m_restSvc =new RestService(new GatewayApiMetadataProvider(), Configurations.bootstrap()); 
    }
    
    public RESTTestUtilityController(WebServices.IRESTService restSvc){
        m_restSvc = restSvc;
    }
    
    public PageReference Available(){
        Url = RESTutility.AvailableUrl;
        Method = 'GET';
        return SendRequest();
    }
    
    public PageReference ClearForm(){
        ClearInput();
        ClearOutput();
        return null;
    }
    
    private void ClearInput(){
        Url = '';
        Method = '';
    }
    
    private void ClearOutput(){
        Results = '';
        Status = '';
    }
        
    public PageReference SendRequest(){
        ClearOutput();
        Datetime tStart = Datetime.now(); 
        try{                                       
            if(Method=='GET'){
                Results = m_restSvc.GET(Url).response;
            }else if(Method=='POST'){
                Results = m_restSvc.POST(Url, Body).response;
            }else{
                throw new applicationException('Sorry, the ' + Method + ' method is currently not suppported by this utility.');
            }
        }catch(exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(myMsg);
            Results = 'Errors encountered...';
        }
        
        Datetime tEnd = Datetime.now();
        Double tDiff = (tEnd.getTime() - tStart.getTime());
        Status = String.valueOf(tDiff) + ' ms';
        
        return null;
    }
    
    public static testMethod void TestSendRequest(){
        RESTTestUtilityController testcontroller = new RESTTestUtilityController();
        testcontroller.Url = 'test';
        
        testcontroller.Method = 'GET';
        testcontroller.SendRequest();
        
        testcontroller.Method = 'POST';
        testcontroller.SendRequest();  
         
        testcontroller.Available();
        testcontroller.ClearForm();      
    }
   
}