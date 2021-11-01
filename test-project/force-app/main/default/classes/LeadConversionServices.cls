/************************************************************************
** CLIENT
**   Enterprise Bank & Trust
**
** PROJECT
**   Enterprise Bank and Trust Phase 1 (a0bE0000001L85f)
**
** PURPOSE
**   This is invoked by the LeadConversionTrigger, and serves the following 
**   purposes:
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

public class LeadConversionServices {
    // globals
    Map<Id, Lead>     leadsWithAccounts       = new Map<Id, Lead>();
    List<Id>          leadContactIds          = new List<Id>();
    List<Contact>     contactsWithLeads       = new List<Contact>();
        
    Map<Id, Lead>     leadsWithOpportunities  = new Map<Id, Lead>();
    List<Id>          leadOpportunityIds      = new List<Id>();
    List<Opportunity> opportunitiesWithLeads  = new List<Opportunity>();
    
    
    //____________
    // constructor
    public void fired (Lead[] newLeads, Lead[] oldLeads) {        
        //_______________________
        // scan each updated Lead
        for (Integer lpcnt = 0; lpcnt < newLeads.size(); lpcnt++) {     
            // has this Lead just been converted?
            if (oldLeads[lpcnt].isConverted == false  &&  newLeads[lpcnt].isConverted == true) {
                Lead targetLead = newLeads[lpcnt];
                system.debug('targetLead: ' + targetLead);
                
                // has a new Entity/Account been created during this conversion?
                if (targetLead.ConvertedAccountId != null) {
                    leadsWithAccounts.put(targetLead.Id, targetLead);   
                    leadContactIds.add(targetLead.Id);
                }
                
                // has a new Opportunity been created during this conversion?
                if (targetLead.ConvertedOpportunityId != null) {
                    leadsWithOpportunities.put(targetLead.ConvertedOpportunityId, targetLead);
                    leadOpportunityIds.add(targetLead.ConvertedOpportunityId);
                }
            }
        }
        system.debug('leadsWithAccounts: '      + leadsWithAccounts);
        system.debug('leadContactIds: '         + leadContactIds);
        system.debug('leadsWithOpportunities: ' + leadsWithOpportunities);
        system.debug('leadOpportunityIds: '     + leadOpportunityIds);
        
        //_____________________________________________________
        // assign the associated Contacts to their new Accounts
        if (leadContactIds.size() > 0) {
            // pull all the Contacts owned by any of these Leads
            try {
                contactsWithLeads = [ SELECT Id, AccountId, Associated_With_Lead__c
                                        FROM Contact
                                       WHERE Associated_With_Lead__c IN :leadContactIds ];
            }
            catch (Exception curse) {
                system.debug('Contact select failed: ' + curse);
            }
            system.debug('contactsWithLeads before: ' + contactsWithLeads);
            
            if (contactsWithLeads.size() > 0) {
                // point each Contact to the new Entity/Account
                for (Contact eachCon : contactsWithLeads) {
                    Lead thisLead = leadsWithAccounts.get(eachCon.Associated_With_Lead__c);
                    if (thisLead != null)
                        eachCon.AccountId = thisLead.ConvertedAccountId;
                    else
                        system.debug('No Lead for ' + eachCon.Associated_With_Lead__c);
                }
                    
                // update these Contacts
                try {
                    system.debug('contactsWithLeads after:' + contactsWithLeads);
                    update contactsWithLeads;
                }
                catch (Exception curse) {
                    system.debug('Contact updates failed: ' + curse);
                }
            }
        }       
        
        //_____________________________________________________
        // preserve the referring User relationship
        if (leadOpportunityIds.size() > 0) {
            // pull all the Opportunities related to any of these Leads
            try {
                opportunitiesWithLeads = [ SELECT Id, Referring_User__c
                                             FROM Opportunity
                                            WHERE Id IN :leadOpportunityIds ];
            }
            catch (Exception curse) {
                system.debug('Opportunity select failed: ' + curse);
            }
            system.debug('opportunitiesWithLeads before: ' + opportunitiesWithLeads);    
            
            if (opportunitiesWithLeads.size() > 0) {
                // set the referrer on each new Opportunity
                for (Opportunity eachOpp : opportunitiesWithLeads) {
                    Lead thisLead = leadsWithOpportunities.get(eachOpp.Id);
                    if (thisLead != null)
                        eachOpp.Referring_User__c = thisLead.Referring_User__c;
                    else
                        system.debug('No Lead for ' + eachOpp.Id);          
                }
                    
                // update these Opportunities
                try {
                    system.debug('opportunitiesWithLeads after:' + opportunitiesWithLeads);
                    update opportunitiesWithLeads;
                }
                catch (Exception curse) {
                    system.debug('Opportunity updates failed: ' + curse);
                }
            }
        }   
    }
        
} // LeadConversionServices