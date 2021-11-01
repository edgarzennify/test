public class RESTutility {
    
    private final GatewayApiMetadataProvider.IGatewayApiMetadataProvider m_gatewayMetadataProvider;
    private Configurations.IConfigurations m_configurations;

    public RESTutility(GatewayApiMetadataProvider.IGatewayApiMetadataProvider gatewayMetadataProvider, Configurations.IConfigurations configurations){
        m_gatewayMetadataProvider = gatewayMetadataProvider;
        m_configurations = configurations;
    }

    public string GetApiResource(string apiName){
        return m_configurations.restServiceBaseUrl() + m_gatewayMetadataProvider.GetResourceBy(apiName);
    }

    private string ClientCertificateName() {
        return m_configurations.CertificateName();
    }

    private static RESTUtility NewObj{
        get{
            return new RESTutility(new GatewayApiMetadataProvider(), Configurations.bootstrap());
        }
    }
    
    public static string ArchiveReportUrl{
        get{
            return NewObj.GetApiResource('ArchiveReportUrl');
        }
    }
    public static string AvailableUrl{
        get{
            return NewObj.GetApiResource('AvailableUrl');
        }
    }
    public static string CreditRelationshipUrl{
        get{
            return NewObj.GetApiResource('CreditRelationshipUrl');            
           }
    }
    public static string CreditRelationshipUrlOREO{
        get{
            return NewObj.GetApiResource('CreditRelationshipUrlOREO');
           }
    }
    public static string ImageNowDocumentUrl{
        get{
            return NewObj.GetApiResource('ImageNowDocumentUrl');
        }
    }
    public static String PricingWorksheetUrl{
        get{
            return NewObj.GetApiResource('PricingWorksheetUrl');
        }
    }
    public static String NumberGeneratorUrl{
        get{
            return NewObj.GetApiResource('NumberGeneratorUrl');
        }
    }
    public static string SnapshotUrl{
        get{
            return NewObj.GetApiResource('SnapshotUrl');
        }
    }
    
    public class result{
            public string response{get;set;}
            public string status{get;set;}    
            public string responseTime{get;set;}  
    }

    public class EbtRestGetRequest{
        public string Url{get;set;}
        public Map<string,string> Headers{get;set;}
    }

    public class EbtRestPostRequest{
        public string Url{get;set;}
        public string Body{get;set;}
        public Map<string,string> Headers{get;set;}
    }
    
    public static string Available(){
            result res = EbRESTGet(AvailableUrl);
            if(res != null) return res.response;
            return '';
    }
    
    public static void WakeupService(){
        try{
            Available(); //will possibly break if the service is sleeping.
        }catch(exception ex){}
    }
    
    public static result TestEntityDocuments(string key){
        Result result = new Result();
        result.status = '200 OK';
        
        if(key=='616-4902'){
            result.response = '{"imageNowEntityTreeResult":[{"Application":"","Comment":"Comment","DocTypeName":"Tax Returns","DocumentDate":"2011-08-16 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N8B","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Resolutions","DocumentDate":"2011-08-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026NC7","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2011-09-07 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026NCY","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2011-11-03 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026NDH","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2012-02-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026NDX","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2012-05-01 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026NEB","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2009-07-23 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026MYV","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2009-07-28 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026MZ8","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2009-10-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026MZZ","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2009-10-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N1M","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Loan Write-up","DocumentDate":"2010-04-30 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N29","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2010-06-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N2J","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2010-07-26 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N2Y","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2010-07-26 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N4F","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2010-09-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N4V","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2010-10-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N58","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2010-10-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N5T","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2011-05-02 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N6D","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2011-05-03 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N6S","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Tax Returns","DocumentDate":"2011-07-20 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N82","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements","DocumentDate":"2009-03-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026MWW","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Resolutions","DocumentDate":"2009-11-24 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N21","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Tax Returns","DocumentDate":"2011-05-25 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026N7T","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026MNB","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026MP1","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026MRM","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026MVD","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Miscellaneous - Credit","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026M9B","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Loan Write-up","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026MGT","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Operating Agreement","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Z_0RWYKCV81026MHP","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2011-11-03 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001MFE","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements","DocumentDate":"2012-02-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001MGL","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2012-05-01 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001MHS","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2010-06-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001M8T","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2010-09-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001MBG","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2010-10-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001MBW","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2010-10-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001MC9","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements","DocumentDate":"2011-05-02 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001MCP","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2011-05-03 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001MDQ","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2011-08-16 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001ME4","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2011-09-07 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001MF0","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2010-01-07 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001M4Y","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements","DocumentDate":"2010-06-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001M6X","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2010-06-29 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001M8E","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2009-07-28 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001M1M","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2009-10-27 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001M2Z","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001LYG","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements - Interim","DocumentDate":"2009-07-23 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001M17","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Corporate Good Standing Cert","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001LTH","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Rent Roll","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001LVD","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001LVS","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Financial Statements","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001LWN","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Loan Write-up","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001LR4","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Corporate Good Standing Cert","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001LQW","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"","Comment":"Comment","DocTypeName":"Articles of Organization","DocumentDate":"2008-09-12 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW83_0RWYP6GLM001LS0","DrawerName":"Credit","Key":"616-4902","Name":"BLOCK ONE COMPANY LLC","Objecttype":"Entity","RecordRelationship":"0","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Agreements-Loan","DocumentDate":"2009-03-24 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003W0N","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Loan Documentation Report","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VW5","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Modification or Renewal Agreement","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003W0E","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Promissory Note","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VZP","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Agreements-Loan","DocumentDate":"2009-03-24 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003W0N","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Loan Documentation Report","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VW5","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Modification or Renewal Agreement","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003W0E","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Promissory Note","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VZP","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Settlement Statement","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VVF","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Title Company Adv. Requests","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VPH","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Settlement Statement","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VVF","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Title Company Adv. Requests","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VPH","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Loan Commitment Letter","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VMX","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Paid Receipts and Checks","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VNB","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Loan Commitment Letter","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VMX","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Paid Receipts and Checks","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VNB","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"}]}';
        }else if(key=='1700008219-15'){
            result.response = '{"imageNowEntityTreeResult":[{"Application":"15","Comment":"Comment","DocTypeName":"Agreements-Loan","DocumentDate":"2009-03-24 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003W0N","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Loan Documentation Report","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VW5","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Modification or Renewal Agreement","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003W0E","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Promissory Note","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VZP","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Agreements-Loan","DocumentDate":"2009-03-24 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003W0N","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Loan Documentation Report","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VW5","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Modification or Renewal Agreement","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003W0E","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Promissory Note","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VZP","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Settlement Statement","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VVF","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Title Company Adv. Requests","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VPH","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Settlement Statement","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VVF","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Title Company Adv. Requests","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VPH","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Loan Commitment Letter","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VMX","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Paid Receipts and Checks","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VNB","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Loan Commitment Letter","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VMX","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Paid Receipts and Checks","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VNB","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"}]}';
        }else if(key=='30475-20'){
            result.response = '{"imageNowEntityTreeResult":[{"Application":"15","Comment":"Comment","DocTypeName":"Agreements-Loan","DocumentDate":"2009-03-24 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003W0N","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Loan Documentation Report","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VW5","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Modification or Renewal Agreement","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003W0E","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Promissory Note","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VZP","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Agreements-Loan","DocumentDate":"2009-03-24 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003W0N","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Loan Documentation Report","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VW5","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Modification or Renewal Agreement","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003W0E","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Promissory Note","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VZP","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Settlement Statement","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VVF","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Title Company Adv. Requests","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VPH","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Settlement Statement","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VVF","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Title Company Adv. Requests","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VPH","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Loan Commitment Letter","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VMX","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Paid Receipts and Checks","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VNB","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"15","Comment":"Comment","DocTypeName":"Loan Commitment Letter","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VMX","DrawerName":"Lending","Key":"1700008219-15","Name":"(1700008219-15) - BLOCK ONE COMPANY LLC","Objecttype":"Loan","RecordRelationship":"1","RelationshipName":"Primary"},{"Application":"20","Comment":"Comment","DocTypeName":"Paid Receipts and Checks","DocumentDate":"2008-08-06 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=301YW7Q_0RWYH868N003VNB","DrawerName":"Lending","Key":"30475-20","Name":"(30475-20) - D/T & ASSIGN OF RENTS LOT 2 TOWN CENTER PLAZA,LEAWOOD KS","Objecttype":"Collateral","RecordRelationship":"1","RelationshipName":"Primary"}]}';
        }

        return result;
    }
    public static void CreditRelationship(String archiveReportId){            
        WakeupService();
        archiveReportId = convertid15ToId18(archiveReportId);
        result res = EbRESTPost(CreditRelationshipUrl + archiveReportId ,'reportid='+ EncodingUtil.urlEncode(archiveReportId,'UTF-8'));                                  
    }
     public static void CreditRelationshipOREO(String archiveReportId){            
        WakeupService();
        archiveReportId = convertid15ToId18(archiveReportId);
        result res = EbRESTPost(CreditRelationshipUrlOREO + archiveReportId ,'reportid='+ EncodingUtil.urlEncode(archiveReportId,'UTF-8'));                                  
    }
        
    public static void GenerateLoanApplicationSnapshot(String  minuteid){
        WakeupService();
        minuteid = convertid15ToId18(minuteid);
        result res = EbRESTPost(SnapshotUrl + 'minute&minuteid=' + minuteid ,'type=minute&minuteid='+ EncodingUtil.urlEncode(minuteid,'UTF-8'));
    }
    
    public static void GenerateArchivedLoanApplicationSnapshot(String  minuteid , String LoanAppId){
        WakeupService();                  
        minuteid = convertid15ToId18(minuteid);
        LoanAppId = convertid15ToId18(LoanAppId);
        result res = EbRESTPost(SnapshotUrl +'archive&minuteid=' + minuteid + '&LoanAppId=' + loanappid ,'type=archive&minuteid='+ EncodingUtil.urlEncode(minuteid,'UTF-8') + '&loanappid=' +EncodingUtil.urlEncode(loanappid,'UTF-8'));
    }    
    public static void ArchiveReport(String  idlong1){    
        WakeupService();                 
        idlong1 = convertid15ToId18(idlong1);
        result res = EbRESTGet(ArchiveReportUrl + idlong1 );                                           
    }
    
    private static void TrySetClientCertificate(HttpRequest req){
        String cert = NewObj.ClientCertificateName();
        if(cert <> ''){
            req.setClientCertificateName(cert);
        }
    }
    
    public static result EbRESTGet(String url){   
        EbtRestGetRequest ebtRequest = new EbtRestGetRequest();
        ebtRequest.url = url;
        ebtRequest.headers = new Map<string,string>();
        return EbRestGet(ebtRequest);
    }

    public static result EbRestGet(EbtRestGetRequest ebtRequest){
        Datetime tStart = Datetime.now();     
        result resultobj = new result();
        try{
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setEndpoint(ebtRequest.url);
            req.setMethod('GET');
            System.debug('---------------------EbRESTGet-url: ' + ebtRequest.url);
            TrySetClientCertificate(req);
            req.setTimeout(59000);
            String login = 'sdfc';
            String pwd = '!wed$3WMQ';
            Blob headerValue = Blob.valueOf(login + ':' + pwd);
            String authorizationHeader = EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            for(String key : ebtRequest.Headers.keyset()){
                req.setHeader(key, ebtRequest.Headers.get(key));
            }

            req.setCompressed(true);
            System.debug('*** req-Compressed: ' + req);
            
            Http http = new Http();
            HttpResponse res = http.send(req);            
            resultobj.response = res.getBody();
            resultobj.status = res.getStatus();               
        }catch(exception ex){
            resultobj.status = ex.getmessage();
            return resultobj; 
        }
        Datetime tEnd = Datetime.now();
        Double tDiff = (tEnd.getTime() - tStart.getTime());
        resultobj.responseTime = String.valueOf(tDiff) + ' ms';
        
        system.debug('######Web Service Callout Response Time: ' + resultObj.responseTime);
        
        return resultobj;
    }
    
    public static result EbRESTPost(String url,  String body){
        EbtRestPostRequest ebtRequest = new EbtRestPostRequest();
        ebtRequest.url = url;
        ebtRequest.body = body;
        ebtRequest.headers = new Map<string,string>();
        return EbRESTPost(ebtRequest);
    }

    public static result EbRESTPost(EbtRestPostRequest ebtRequest){
        Datetime tStart = Datetime.now();         
        result resultobj = new result();
        try{
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setEndpoint(ebtRequest.url);
            req.setMethod('POST');
            req.setBody(ebtRequest.body);
            System.debug('---------------------EbRESTPost-url: ' + ebtRequest.url);
            TrySetClientCertificate(req);
            req.setTimeout(59000);
            String login = 'sdfc';
            String pwd = '!wed$3WMQ';
            Blob headerValue = Blob.valueOf(login + ':' + pwd);
            String authorizationHeader = EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader); 
            for(String key : ebtRequest.Headers.keyset()){
                req.setHeader(key, ebtRequest.Headers.get(key));
            }           
            System.debug('---------------------EbRESTPost-req: ' + req);
            Http http = new Http();
            HttpResponse res = http.send(req);            
            System.debug('---------------------EbRESTPost-res: ' + res);
            resultobj.response = res.getBody();
            resultobj.status = res.getStatus();
           
        }catch(exception ex){
            resultobj.status = 'Error' + ex.getmessage();
            return resultobj; 
        }
        
        Datetime tEnd = Datetime.now();
        Double tDiff = (tEnd.getTime() - tStart.getTime());
        resultobj.responseTime = String.valueOf(tDiff) + ' ms';
        
        return resultobj;
    }
    
    public static String convertid15ToId18(String id15) {
        if (id15.length() != 15) return id15;
        Id currentId = id15;
        String id18 = currentId;
        return id18;
    }

    public static String GenerateSingleTokenFromJSON(string jsonString){
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