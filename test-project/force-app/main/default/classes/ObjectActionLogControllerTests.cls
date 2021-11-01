@IsTest
public class ObjectActionLogControllerTests {
    
    private static final ObjectActionLogController sut;
	private static Mock.ofIObjectActionLogService mockObjectActionLogSvc;

    static {
        mockObjectActionLogSvc = new Mock.ofIObjectActionLogService();
        sut = new ObjectActionLogController(mockObjectActionLogSvc);
    }

    @IsTest
    static void it_should_call_the_logging_service_and_get_logs(){
        String objectIdAttribute = 'test id';
        String actionTypeAttribute = 'test type';

        ObjectActionLogService.ObjectAndTypeRequest request = new ObjectActionLogService.ObjectAndTypeRequest();
        request.ObjectRecordId = objectIdAttribute;
        request.ActionType = actionTypeAttribute;
        //act
        sut.objectIdAttribute = objectIdAttribute;
        sut.actionTypeAttribute = actionTypeAttribute;
        //assert
        mockObjectActionLogSvc.verify('get', new List<Object>{request}, Times.Once);
    }

    @IsTest
    static void it_should_not_call_the_logging_service_when_idAttribute_is_null(){
        String objectIdAttribute = null;
        String actionTypeAttribute = 'test type';

        ObjectActionLogService.ObjectAndTypeRequest request = new ObjectActionLogService.ObjectAndTypeRequest();
        request.ObjectRecordId = objectIdAttribute;
        request.ActionType = actionTypeAttribute;
        //act
        sut.objectIdAttribute = objectIdAttribute;
        sut.actionTypeAttribute = actionTypeAttribute;
        //assert
        mockObjectActionLogSvc.verify('get', Times.Never);
    }

    @IsTest
    static void it_should_not_call_the_logging_service_when_typeAttribute_is_null(){
        String objectIdAttribute = 'test id';
        String actionTypeAttribute = null;

        ObjectActionLogService.ObjectAndTypeRequest request = new ObjectActionLogService.ObjectAndTypeRequest();
        request.ObjectRecordId = objectIdAttribute;
        request.ActionType = actionTypeAttribute;
        //act
        sut.objectIdAttribute = objectIdAttribute;
        sut.actionTypeAttribute = actionTypeAttribute;
        //assert
        mockObjectActionLogSvc.verify('get', Times.Never);
    }

    @IsTest
    static void code_coverage(){
        ObjectActionLogController controller = new ObjectActionLogController();
        controller.titleAttribute = 'foo';
        controller.heightAttribute = 5;
    }
}