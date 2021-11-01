@IsTest
private class ApprovalProcessDataProviderTests {

    private static ApprovalProcessDataProvider sut;

    static{
        sut = new ApprovalProcessDataProvider();
    }

    @IsTest
    private static void it_should_get_process_pm_when_approval_process_name_sobject_name_and_record_id_are_provided(){
        Grenzsoldat__c app = new Grenzsoldat__c();
        app.Reisepass__c = 'test';
        insert app;

        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Approve');
        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req.setObjectId(app.Id);
        Approval.ProcessResult res = Approval.process(req);
        
        ProcessInstance ins = [
            SELECT
                ProcessDefinition.Id
                ,ProcessDefinition.name
                ,ProcessDefinition.TableEnumOrId
                ,Id
            FROM
                ProcessInstance
            LIMIT 1
        ];   

        ApprovalProcess.ProcessPm result = sut.getProcessPm(ins.ProcessDefinition.name, ins.ProcessDefinition.TableEnumOrId, app.Id);

        System.assertEquals(1, result.workItems.size());
        Object fieldObject = result.workItems[0].Id;
        fieldObject = result.workItems[0].ProcessInstanceId;
        fieldObject = result.workItems[0].ElapsedTimeInDays;
        fieldObject = result.workItems[0].ElapsedTimeInHours;
        fieldObject = result.workItems[0].ElapsedTimeInMinutes;
        System.assertEquals(1, result.steps.size());
        fieldObject = result.steps[0].Id;
        fieldObject = result.steps[0].ProcessInstanceId;
        fieldObject = result.steps[0].StepStatus;
        fieldObject = result.steps[0].Comments;
        fieldObject = result.definition;
        fieldObject = result.history;
        fieldObject = result.steps;
        fieldObject = result.instances;
        fieldObject = result.definition.Id;
        fieldObject = result.definition.name;
        fieldObject = result.definition.TableEnumOrId;
    }

    @IsTest
    private static void it_should_get_process_definition_when_sobject_and_approval_process_name_is_provided(){
        String approvalName = 'Test Approval';
        String sObjectApiName = 'Grenzsoldat__c';

        ProcessDefinition result = sut.getProcessDefinition(approvalName, sObjectApiName);

        Object fieldObject = result.Id;
        fieldObject = result.Name;
        fieldObject = result.TableEnumOrId;
        fieldObject = result.type;
        fieldObject = result.state;
        System.assertEquals(approvalName, result.Name);
        System.assertEquals(sObjectApiName, result.TableEnumOrId);
    }
}