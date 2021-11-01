public with sharing class TriggerFactory {
	
    private static final Configurations.IConfigurations m_configs = Configurations.bootstrap();
    
    public static void createHandler(Schema.sObjectType soType) {
        if (triggerIsEnabled(soType)) {
            ITrigger handler = TriggerRegistry.getHandlerByType(soType);
            
            handler.initialize();
            execute(handler);
            handler.finalize();
        }
    }
    
    private static Boolean triggerIsEnabled(Schema.sObjectType soType) {
        String key = String.valueOf(soType);
        return (Boolean)m_configs.get(TriggerBreaker__mdt.SObjectType, key);
    }
    
    private static void execute(ITrigger handler) {
        if (Trigger.isBefore) {
            executeBeforeTrigger(handler);
        } else {
            executeAfterTrigger(handler);
        }
    }

    private static void executeBeforeTrigger(ITrigger handler) {
        if (Trigger.isDelete) {
            handler.bulkBeforeDelete(Trigger.old);
        }
        else if (Trigger.isInsert) {
            handler.bulkBeforeInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {
            handler.bulkBeforeUpdate(Trigger.old, Trigger.newMap);
        }
    }

    private static void executeAfterTrigger(ITrigger handler) {
        if (Trigger.isDelete) {
            handler.bulkAfterDelete(Trigger.old);
        }
        else if (Trigger.isInsert) {
            handler.bulkAfterInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {
            handler.bulkAfterUpdate(Trigger.old, Trigger.newMap);
        }
    }
}