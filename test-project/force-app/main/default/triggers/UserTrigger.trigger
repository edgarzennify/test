/************************************************************************
** CLIENT
**   Enterprise Bank & Trust
**
** PROJECT
**   Enterprise Bank and Trust Phase 1 (a0bE0000001L85f)
**
** PURPOSE
**   This trigger determines if another User has already been set to the
**   same Distribution_Channel__c and Referral_Routing_Team__c
**   combination, and identifies the first such conflict via an appropriate
**   error message.
**
** NOTES   
**   Both Distribution_Channel__c and Referral_Routing_Team__c are
**   multi-select picklists, therefore the possible combinations are
**   actually the matrix of permutations.  
**
** POTENTIAL ENHANCEMENTS
**
************************************************************************/

trigger UserTrigger on User (before insert, before update) {
    
    // constants
    private final String SCHAR = ';';


    //______________________________________________________________
    // identify the Users potentially involved in Internal Referrals
    List<User> significantUsers;
    try {
        significantUsers = [ SELECT Id, Name, Username, Distribution_Channel__c, 
                                    Referral_Routing_Team__c
                               FROM User 
                         WHERE (Distribution_Channel__c  != ''
                            OR  Referral_Routing_Team__c != '')
                           AND IsActive = true ];
    }
    catch (Exception curse) {
        system.debug('User select failed: ' + curse);
        Trigger.new[0].addError('The attempt to determine User referral assignments failed.  \n' +
            'Please notify a System Administrator, and report: ' + curse);
    }
    system.debug('significantUsers: ' + significantUsers.size() + ', ' + significantUsers); 
    
    
    //______________________________________________
    // build a map of existing, covered combinations
    String[] eChannels;
    String[] eTeams;
    Map<String, User> combos = new Map<String, User>();
    
    for (User existingUser : significantUsers) {
    	system.debug('existingUser: ' + existingUser);
    	
        // unburst the multi-select picklist options
        if (String.isEmpty(existingUser.Distribution_Channel__c)) {
            eChannels = new List<String>();
            eChannels.add('');
        }
        else
            eChannels = existingUser.Distribution_Channel__c.split(SCHAR);
        //system.debug('eChannels: ' + eChannels);
            
        if (String.isEmpty(existingUser.Referral_Routing_Team__c)) {
            eTeams = new List<String>();
            eTeams.add('');
        }           
        else
            eTeams = existingUser.Referral_Routing_Team__c.split(SCHAR);  
        //system.debug('eTeams: ' + eTeams);          
            
        // build a map of all possible channel vs. team combinations
        for (String channel : eChannels) {
            for (String team : eTeams) {
                combos.put(channel + SCHAR + team, existingUser);
            }
        }
    }
    system.debug('combos: ' + combos.size() + ', ' + combos.keySet());
    //system.debug('full combos: ' + combos);
        
        
    //_______________________________
    // process each new/modified User
    User newUser, incumbent;
    String matching;    
    List<String> nChannels = new List<String>();
    List<String> nTeams    = new List<String>();   
    
    for (Integer lpcnt = 0; lpcnt < Trigger.new.size(); lpcnt++) {
        newUser = Trigger.new[lpcnt];
        system.debug('newUser: ' + newUSer);
        
        // unburst the multi-select picklist options
        if (String.isEmpty(newUser.Distribution_Channel__c)) {
            nChannels.clear();
            nChannels.add('');
        }
        else
            nChannels = newUser.Distribution_Channel__c.split(SCHAR);
        //system.debug('nChannels: ' + nChannels);
            
        if (String.isEmpty(newUser.Referral_Routing_Team__c)) {
            nTeams.clear();
            nTeams.add('');
        }           
        else
            nTeams = newUser.Referral_Routing_Team__c.split(SCHAR); 
        //system.debug('nTeams: ' + nTeams); 
            
        // try all possible channel vs. team combinations
        for (String channel : nChannels) {
            for (String team : nTeams) {
                // is this conbination already assigned?
                matching = channel + SCHAR + team;
                system.debug('matching: ' + matching);               
                if (combos.containsKey(matching)) {
                    // not the same user?
                    incumbent = combos.get(matching);
                    system.debug('incumbent: ' + incumbent);
                    if (incumbent.Id != newUser.Id) {
                    	// report this conflict to user
	                    system.debug('conflict ' + matching + ', ' + newUser + ', ' + incumbent);                    	
	                    newUser.addError('User \'' + incumbent.Name + '\' (' + incumbent.Username +
	                        ') is already assigned to Distribution Channel \'' + incumbent.Distribution_Channel__c +
	                        '\' and Referral Routing Team \'' + incumbent.Referral_Routing_Team__c + 
	                        '\'.  Please select another referral assignment combination.');
	                        
	                    // can only display one error pernew/modifiedUser
	                    break;
                    }
                }   
            }
        }     
    }        
    
} // UserTrigger