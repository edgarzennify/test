@IsTest
public class TeamRoleMatrixTest{
    
	static testMethod void testRoles(){
		TeamRoleMatrix.TeamRoleMatrixImplementation m_sut = new TeamRoleMatrix.TeamRoleMatrixImplementation();
		TeamRoleMatrix.IDataProvider m_provider = new MockDataProvider();		
		m_sut.setDataProvider(m_provider);
		
		List<SelectOption> options = m_sut.GetSigners(leadentity.id);
		
		System.assert(options.size() == 4);
	}
    
	static Id ClientRecordTypeId{
		get{
			if(ClientRecordTypeID == null){
				ClientRecordTypeID = utility.RecordTypeObject('Account','Client').Id;
				system.debug('### ClientRecordTypeId loaded');
			}
			return ClientRecordTypeID;
		}
		set;
	}
	
    static EB_Team_Member__c teamRM{
    	get{
    		if(teamRM == null){
    			teamRM = ObjectFactory.getTeamMember('Team1');
    		}
    		return teamRM;
    	}
    	set;
    }
    static Account leadEntity{
    	get{
    		if(leadEntity == null){
    			leadEntity = ObjectFactory.getEntity('Test Entity', ClientRecordTypeId, teamRM);
    		}
    		return leadEntity;
    	}
    	set;
    }
    
    public class MockDataProvider implements TeamRoleMatrix.IDataProvider{
        private user u1 = objectfactory.getUser('kmark');
        private user u2 = objectfactory.getUser('bholland');
        private user u3 = objectfactory.getUser('rupadhya');
        
    	public List<Account_Team_Role__c> ApprovalRoles(){
            
            List<Account_Team_Role__c> roles = new List<Account_Team_Role__c>();
            Account_Team_Role__c role1 = new Account_Team_Role__c();
            role1.Name = 'Test Role 1';
            role1.Approval_Authority_Order__c = '1';
            roles.add(role1);
            Account_Team_Role__c role2 = new Account_Team_Role__c();
            role2.Name = 'Test Role 2';
            role2.Approval_Authority_Order__c = '2';
            roles.add(role2);
            return roles;
        }
        
        public List<AccountTeamMember> AccountTeamMembers(Id EntityId, Map<String,Account_Team_Role__c> approvedRoleMap){
        	List<AccountTeamMember> members = new List<AccountTeamMember>();
        	AccountTeamMember m1 = new AccountTeamMember();
        	m1.TeamMemberRole = 'Test Role 1';
        	m1.UserId = u1.id;
        	members.add(m1);
        	AccountTeamMember m2 = new AccountTeamMember();
        	m2.TeamMemberRole = 'Test Role 1';
        	m2.UserId = u2.id;
        	members.add(m2);
        	AccountTeamMember m3 = new AccountTeamMember();
        	m3.TeamMemberRole = 'Test Role 2';
        	m3.UserId = u3.id;
        	members.add(m3);
        	
            return members;
        }
        
        public Map<Id,User> Users(){
           
           Map<Id,User> userMap = new Map<Id,User>();           
           userMap.put(u1.id, u1);
           userMap.put(u2.id,u2);
           userMap.put(u3.id,u3); 
           return userMap;
            
        }
    }

}