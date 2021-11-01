public class EventLogWriter implements IEventLogWriter {
    
    public interface IEventLogWriter{
        EventLog__c createLog(String loglevel, String application, String message, String locationDetails);
    }

    private static Configurations.IConfigurations m_configs;
    private static final List<String> DEBUGLOGOPTIONS = new List<String>{'debug', 'info', 'error'};
    private static final List<String> INFOLOGOPTIONS = new List<String>{'info', 'error'};
    private static final List<String> ERRORLOGOPTIONS = new List<String>{'error'};
    private static final List<String> VALIDLOGLEVELS = new List<String>{'debug', 'info', 'error'};

    public EventLogWriter(Configurations.IConfigurations configs){
        m_configs = configs;
    }

    public EventLog__c createLog(String logLevel, String application, String message, String locationDetails){        
        if (isOkayToLog(logLevel, application)){
            return buildLog(cleanupTargetLogLevel(logLevel), application, message, locationDetails);
        } else return doNotCreateLog();
    }

    private Boolean isOkayToLog(String logLevel, String application){
        String targetLogLevel = cleanupTargetLogLevel(logLevel);
        List<String> validLogLevels = getValidLogLevels(application);
        return validLogLevels.contains(targetLogLevel);
    }

    private String cleanupTargetLogLevel(String logLevel){
        if (VALIDLOGLEVELS.contains(logLevel.toLowerCase())) {
            return logLevel.toLowerCase();
        } else return logLevel = 'debug';
    }

    private List<String> getValidLogLevels(String application){
        try{
            String configLogLevel = m_configs.get(createKey(application)).toLowerCase();

            switch on configLogLevel {
                when 'debug' { return DEBUGLOGOPTIONS;}
                when 'info' { return INFOLOGOPTIONS;}
                when 'error' { return ERRORLOGOPTIONS;}
                when else { return ERRORLOGOPTIONS;}
            }
        }catch(Configurations.ConfigurationKeyNotFoundException e){
            return ERRORLOGOPTIONS;
        }     
    }

    private String createKey(String application){
        return application + ' Logging Level';
    }

    private EventLog__c buildLog(String logLevel, String application, String message, String locationDetails){
        EventLog__c log = new EventLog__c();
        log.Log_Level__c = logLevel.capitalize();
        log.Application__c = application;
        log.Message__c = message;
        log.Location_Details__c = locationDetails;
        return log;
    }

    private EventLog__c doNotCreateLog(){
        return null;
    }

    public static IEventLogWriter bootstrap() {
		Configurations.IConfigurations configs = Configurations.bootstrap();
		return new EventLogWriter(configs);
	}
}