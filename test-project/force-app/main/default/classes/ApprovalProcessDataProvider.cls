public class ApprovalProcessDataProvider implements ApprovalProcess.IDataProvider {

    public ApprovalProcess.ProcessPm getProcessPm(String approvalName, String sObjectApiName, String sObjectRecordId){

        List<ProcessInstance> ins = [
            SELECT
                Id
                ,Status
                ,CompletedDate
                ,LastActorId
                ,LastActor.Id
                ,LastActor.Name
                ,LastActor.Email
                ,CreatedDate
                ,ProcessDefinition.Id
                ,ProcessDefinition.Name
                ,ProcessDefinition.TableEnumOrId
                ,ProcessDefinition.LockType
                ,ProcessDefinition.Type
                ,ProcessDefinition.CreatedDate
                ,(
                    SELECT 
                        Id
                        ,ProcessInstanceId
                        ,StepStatus
                        ,Comments
                    FROM 
                        Steps
                    ORDER BY
                        CreatedDate DESC
                )
                ,(
                    SELECT 
                        Id
                        ,ProcessInstanceId
                        ,ElapsedTimeInDays
                        ,ElapsedTimeInHours
                        ,ElapsedTimeInMinutes
                    FROM 
                        WorkItems
                )
                ,(
                    SELECT 
                        ID
                        ,ProcessNodeId
                        ,ProcessNode.Name
                        ,StepStatus
                        ,Comments
                        ,TargetObjectId
                        ,CreatedById
                        ,IsDeleted
                        ,IsPending
                        ,OriginalActorId
                        ,OriginalActor.Id
                        ,OriginalActor.Name
                        ,OriginalActor.Email
                        ,ActorId
                        ,Actor.Id
                        ,Actor.Name
                        ,Actor.Email
                        ,ProcessInstanceId
                        ,RemindersSent
                        ,CreatedDate
                    FROM 
                        StepsAndWorkitems
                    ORDER BY
                        CreatedDate DESC, StepStatus
                )
            FROM 
                ProcessInstance
            WHERE 
                ProcessDefinition.TableEnumOrId =: sObjectApiName
                AND ProcessDefinition.Name =: approvalName
                AND TargetObjectId =: sObjectRecordId
            ORDER BY
                CreatedDate DESC
        ];

        ApprovalProcess.ProcessPm processPm = new ApprovalProcess.ProcessPm();
        processPm.steps = new List<ProcessInstanceStep>();
        processPm.workItems = new List<ProcessInstanceWorkItem>();
        List<ProcessInstanceHistory> swkt = new List<ProcessInstanceHistory>();

        return ins != null && ins.size() == 0? new ApprovalProcess.ProcessPm(): buildPm(ins);
    }

    public ProcessDefinition getProcessDefinition(String approvalName, String sObjectApiName){
        List<ProcessDefinition> pds = [
            SELECT
                Id
                ,Name
                ,TableEnumOrId
                ,Type
                ,State
            FROM
                ProcessDefinition
            WHERE
                TableEnumOrId =: sObjectApiName
                AND Type =: 'Approval'
                AND State =: 'Active'
                AND Name =: approvalName
            LIMIT 1
        ];
        return pds == null || pds.size() == 0? new ProcessDefinition():pds[0];
    }

    private ApprovalProcess.ProcessPm buildPm(List<ProcessInstance> instancePms){
        ApprovalProcess.ProcessPm processPm = new ApprovalProcess.ProcessPm();
        processPm.steps = new List<ProcessInstanceStep>();
        processPm.workItems = new List<ProcessInstanceWorkItem>();
        processPm.history = new List<ProcessInstanceHistory>();
        processPm.instances = instancePms;
        processPm.definition = instancePms[0].ProcessDefinition;
        for(ProcessInstance p : instancePms){
            processPm.steps.addAll(p.Steps);
            processPm.workItems.addAll(p.WorkItems);
            processPm.history.addAll(p.StepsAndWorkitems);
        }

        return processPm;
    }
}