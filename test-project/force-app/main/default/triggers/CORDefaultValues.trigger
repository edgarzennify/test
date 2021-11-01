trigger CORDefaultValues on Charge_Off_Recovery__c (before insert, after insert, before update) {
         if(trigger.new.size() ==1){
        	 CORTriggerHelper defaults = new CORTriggerHelper();
        	defaults.createCORDefaultValues(trigger.new);
         }
}