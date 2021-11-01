/************************************************************************
** CLIENT
**   Enterprise Bank & Trust
**
** PROJECT
**   Enterprise Bank and Trust Phase 1 (a0bE0000001L85f)
**
** PURPOSE
**   This trigger serves the following purposes:
**     1. If separate Contacts have been related to the Lead being converted,
**        then they associated with the newly created Entity (Account).
**     2. The value of Lead.Referring_User__c is duped into 
**        Opportunity.Referring_User__c, in order to preserve the referrer's
**        relationship so he/she can be compensated.
**
** NOTES   
**
** POTENTIAL ENHANCEMENTS
**
************************************************************************/

trigger LeadConversionTrigger on Lead (after update) {
    LeadConversionServices services = new LeadConversionServices();
    services.fired(Trigger.new, Trigger.old);
    
} // LeadConversionTrigger