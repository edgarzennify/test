@IsTest
public class LMS_ConfigurationRepositoryTests {

    private static final LMS_ConfigurationRepository sut;
    private static final LMS_Mock.OfILMS_DataProvider mockDataProvider;
    private static final Mock.ofICachedMap mockCache;

    static{
        mockDataProvider = new LMS_Mock.OfILMS_DataProvider();
        mockCache = new Mock.ofICachedMap();
        sut = new LMS_ConfigurationRepository(mockDataProvider, mockCache);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_once_within_the_same_trigger_execution(){
        mockCache.setup('containsKey', new List<Object>{'LMS_KEYWITHDETAILS'}).returns(false);
        mockCache.setup('containsKey', new List<Object>{'LMS_KEYWITHOUTDETAILS'}).returns(true);
        mockDataProvider.setup('getDefinitions').returns(new List<LMS_LoanMetricSubstage.LMS_Definition>());
        mockCache.setup('get', new List<Object>{'LMS_KEYWITHDETAILS'}).returns(new List<LMS_LoanMetricSubstage.LMS_Definition>());
        
        sut.getDefinitionsWithDetails();
        sut.getDefinitionsWithoutDetails();
        
        mockCache.verify('put', new List<Object>{'LMS_KEYWITHDETAILS', new List<LMS_LoanMetricSubstage.LMS_Definition>()}, Times.Once);
        mockCache.verify('put', new List<Object>{'LMS_KEYWITHOUTDETAILS', new List<LMS_LoanMetricSubstage.LMS_Definition>()}, Times.Once);
        mockCache.verify('containsKey', new List<Object>{'LMS_KEYWITHDETAILS'}, Times.Once);
        mockCache.verify('containsKey', new List<Object>{'LMS_KEYWITHOUTDETAILS'}, Times.Once);
        mockDataProvider.verify('getDefinitions', Times.Once);
    }

    @IsTest
    static void it_should_call_the_data_provider_once_within_the_same_execution_context(){
        mockCache.setupSequence('containsKey', new List<Object>{'LMS_KEYWITHDETAILS'}).returns(false).returns(true);
        mockDataProvider.setup('getDefinitions').returns(new List<LMS_LoanMetricSubstage.LMS_Definition>());
        mockCache.setup('get', new List<Object>{'LMS_KEYWITHDETAILS'}).returns(new List<LMS_LoanMetricSubstage.LMS_Definition>());
        
        sut.getDefinitionsWithDetails();
        sut.getDefinitionsWithDetails();
        
        mockCache.verify('put', new List<Object>{'LMS_KEYWITHDETAILS', new List<LMS_LoanMetricSubstage.LMS_Definition>()}, Times.Once);
        mockCache.verify('put', new List<Object>{'LMS_KEYWITHOUTDETAILS', new List<LMS_LoanMetricSubstage.LMS_Definition>()}, Times.Once);
        mockDataProvider.verify('getDefinitions', Times.Once);
        mockCache.verify('get', new List<Object>{'LMS_KEYWITHDETAILS'}, Times.Twice);
    }

    @IsTest
    static void it_should_return_a_list_of_definitions_when_the_map_contains_LMS_KEYWITHDETAILS(){
        mockCache.setup('containsKey', new List<Object>{'LMS_KEYWITHDETAILS'}).returns(true);
        
        sut.getDefinitionsWithDetails();
        
        mockCache.verify('get', new List<Object>{'LMS_KEYWITHDETAILS'}, Times.Once);
    }

    @IsTest
    static void it_should_return_a_list_of_definitions_when_the_map_contains_LMS_KEYWITHOUTDETAILS(){
        mockCache.setup('containsKey', new List<Object>{'LMS_KEYWITHOUTDETAILS'}).returns(true);
        
        sut.getDefinitionsWithoutDetails();
        
        mockCache.verify('get', new List<Object>{'LMS_KEYWITHOUTDETAILS'}, Times.Once);
    }

    @IsTest
    static void it_should_add_each_definition_to_the_map_based_detailsRequired_field(){
        LMS_LoanMetricSubstage.LMS_Definition definition01 = new LMS_LoanMetricSubstage.LMS_Definition();
        definition01.detailsRequired = true;
        LMS_LoanMetricSubstage.LMS_Definition definition02 = new LMS_LoanMetricSubstage.LMS_Definition();
        definition02.detailsRequired = false;
        List<LMS_LoanMetricSubstage.LMS_Definition> definitions = new list<LMS_LoanMetricSubstage.LMS_Definition>{definition01,definition02};
        List<LMS_LoanMetricSubstage.LMS_Definition> definitionsWithDetails = new list<LMS_LoanMetricSubstage.LMS_Definition>();
        List<LMS_LoanMetricSubstage.LMS_Definition> definitionsWithoutDetails = new list<LMS_LoanMetricSubstage.LMS_Definition>();
        
        mockCache.setup('containsKey', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(false);
        mockDataProvider.setup('getDefinitions').returns(definitions);
        mockCache.setup('get', new List<Object>{'LMS_KEYWITHDETAILS'}).returns(definitionsWithDetails);
        mockCache.setup('get', new List<Object>{'LMS_KEYWITHOUTDETAILS'}).returns(definitionsWithoutDetails);
        
        sut.getDefinitionsWithDetails();
        
        mockCache.verify('get', new List<Object>{'LMS_KEYWITHDETAILS'}, Times.Twice);  
        mockCache.verify('get', new List<Object>{'LMS_KEYWITHOUTDETAILS'}, Times.Once);
        System.assertEquals(1, definitionsWithDetails.size());
        System.assertEquals(true, definitionsWithDetails.contains(definition01));
        System.assertEquals(1, definitionsWithoutDetails.size());
        System.assertEquals(true, definitionsWithoutDetails.contains(definition02));
    }
}