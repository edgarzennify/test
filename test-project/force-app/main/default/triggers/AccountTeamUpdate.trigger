trigger AccountTeamUpdate on Account (before update, after insert, after update) {
    Configurations.IConfigurations m_configs = Configurations.bootstrap();
    
    if (triggerIsEnabled(Account.SObjectType)
        && trigger.isAfter
        && trigger.isUpdate
        && trigger.new.size() == 1) {

        AccountTeamHelper ath = new AccountTeamHelper();
        ath.updateValidationForRelatedEntities(trigger.new);
        ath.updateRelatedLoanPacketUnitSinceLoanAppsHaveHitformulaLimit(trigger.new);       
    }

    private Boolean triggerIsEnabled(Schema.sObjectType soType) {
        String key = String.valueOf(soType);
        return (Boolean)m_configs.get(TriggerBreaker__mdt.SObjectType, key);
    }
}