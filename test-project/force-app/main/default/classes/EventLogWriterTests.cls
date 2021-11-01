@IsTest
private class EventLogWriterTests {

    private static final EventLogWriter sut;
    private static final Mock.ofIConfigurations mockConfigs;

    static {
        mockConfigs = new Mock.ofIConfigurations();
        sut = new EventLogWriter(mockConfigs);
    }

    @IsTest
    static void it_get_config_values_once() {
        String configReturnValue = 'Debug';
        String logLevel = 'Debug';

        mockConfigs.setup('get', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        mockConfigs.Verify('get', new List<Object>{'test application Logging Level'}, Times.Once);
    }

    @IsTest
    static void it_should_create_a_log_when_configs_returns_debug_and_logLevel_is_debug() {
        String configReturnValue = 'Debug';
        String logLevel = 'Debug';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals('Debug', results.Log_Level__c);
        System.assertEquals('test application', results.Application__c);
        System.assertEquals('test message', results.Message__c);
        System.assertEquals('test details', results.Location_Details__c);
    }

    @IsTest
    static void it_should_create_a_log_when_configs_returns_debug_and_logLevel_is_info() {
        String configReturnValue = 'Debug';
        String logLevel = 'Info';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals('Info', results.Log_Level__c);
        System.assertEquals('test application', results.Application__c);
        System.assertEquals('test message', results.Message__c);
        System.assertEquals('test details', results.Location_Details__c);
    }

    @IsTest
    static void it_should_create_a_log_when_configs_returns_debug_and_logLevel_is_error() {
        String configReturnValue = 'Debug';
        String logLevel = 'Error';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals('Error', results.Log_Level__c);
        System.assertEquals('test application', results.Application__c);
        System.assertEquals('test message', results.Message__c);
        System.assertEquals('test details', results.Location_Details__c);
    }

    @IsTest
    static void it_should_not_create_a_log_when_configs_returns_info_and_logLevel_is_debug() {
        String configReturnValue = 'Info';
        String logLevel = 'Debug';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_create_a_log_when_configs_returns_info_and_logLevel_is_info() {
        String configReturnValue = 'Info';
        String logLevel = 'Info';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals('Info', results.Log_Level__c);
        System.assertEquals('test application', results.Application__c);
        System.assertEquals('test message', results.Message__c);
        System.assertEquals('test details', results.Location_Details__c);
    }

    @IsTest
    static void it_should_create_a_log_when_configs_returns_info_and_logLevel_is_error() {
        String configReturnValue = 'Info';
        String logLevel = 'Error';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals('Error', results.Log_Level__c);
        System.assertEquals('test application', results.Application__c);
        System.assertEquals('test message', results.Message__c);
        System.assertEquals('test details', results.Location_Details__c);
    }

    @IsTest
    static void it_should_not_create_a_log_when_configs_returns_error_and_logLevel_is_debug() {
        String configReturnValue = 'Error';
        String logLevel = 'Debug';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_not_create_a_log_when_configs_returns_error_and_logLevel_is_info() {
        String configReturnValue = 'Error';
        String logLevel = 'Info';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_create_a_log_when_configs_returns_error_and_logLevel_is_error() {
        String configReturnValue = 'Error';
        String logLevel = 'Error';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals('Error', results.Log_Level__c);
        System.assertEquals('test application', results.Application__c);
        System.assertEquals('test message', results.Message__c);
        System.assertEquals('test details', results.Location_Details__c);
    }

    @IsTest
    static void it_should_not_create_a_log_when_no_config_value_is_returned_and_logLevel_is_debug() {
        Configurations.ConfigurationKeyNotFoundException e = new Configurations.ConfigurationKeyNotFoundException();
        String logLevel = 'Debug';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).throws(e);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_not_create_a_log_when_no_config_value_is_returned_and_logLevel_is_info() {
        Configurations.ConfigurationKeyNotFoundException e = new Configurations.ConfigurationKeyNotFoundException();
        String logLevel = 'Info';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).throws(e);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_create_a_log_when_no_config_value_is_returned_and_logLevel_is_error() {
        Configurations.ConfigurationKeyNotFoundException e = new Configurations.ConfigurationKeyNotFoundException();
        String logLevel = 'Error';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).throws(e);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals('Error', results.Log_Level__c);
        System.assertEquals('test application', results.Application__c);
        System.assertEquals('test message', results.Message__c);
        System.assertEquals('test details', results.Location_Details__c);
    }

    @IsTest
    static void it_should_not_create_a_log_when_a_invalid_config_value_is_returned_and_logLevel_is_debug() {
        String configReturnValue = 'foo';
        String logLevel = 'Debug';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_not_create_a_log_when_a_invalid_config_value_is_returned_and_logLevel_is_info() {
        String configReturnValue = 'foo';
        String logLevel = 'Info';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        //assert
        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_create_a_log_when_a_invalid_config_value_is_returned_and_logLevel_is_error() {
        String configReturnValue = 'foo';
        String logLevel = 'Error';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals('Error', results.Log_Level__c);
        System.assertEquals('test application', results.Application__c);
        System.assertEquals('test message', results.Message__c);
        System.assertEquals('test details', results.Location_Details__c);
    }

    @IsTest
    static void it_should_create_a_log_when_configs_returns_debug_and_logLevel_is_invalid() {
        String configReturnValue = 'Debug';
        String logLevel = 'foo';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals('Debug', results.Log_Level__c);
        System.assertEquals('test application', results.Application__c);
        System.assertEquals('test message', results.Message__c);
        System.assertEquals('test details', results.Location_Details__c);
    }
    
    @IsTest
    static void it_should_not_create_a_log_when_configs_returns_info_and_logLevel_is_invalid() {
        String configReturnValue = 'Info';
        String logLevel = 'foo';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_not_create_a_log_when_configs_returns_error_and_logLevel_is_invalid() {
        String configReturnValue = 'Error';
        String logLevel = 'foo';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals(null, results);
    }

    @IsTest
    static void it_should_create_a_log_when_configs_returns_debug_and_logLevel_is_debug_CaseTest() {
        String configReturnValue = 'DeBuG';
        String logLevel = 'dEbUg';

        mockConfigs.setup('get', new List<Object>{'test application Logging Level'}).Returns(configReturnValue);
        
        EventLog__c results = sut.createLog(logLevel, 'test application', 'test message', 'test details');
        
        System.assertEquals('Debug', results.Log_Level__c);
        System.assertEquals('test application', results.Application__c);
        System.assertEquals('test message', results.Message__c);
        System.assertEquals('test details', results.Location_Details__c);
    }

    @IsTest
    static void it_should_bootstrap() {
        try {
            EventLogWriter.IEventLogWriter xsut = EventLogWriter.bootstrap();
            System.assert(true);
        } catch (Exception e) {
            System.assert(false, 'Bootstrap method failed to properly bootstrap.');
        }
    }
}