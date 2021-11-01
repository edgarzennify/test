public class TeamRoleMatrix{
    public interface IDataProvider{
        List<Account_Team_Role__c> ApprovalRoles();
        List<AccountTeamMember> AccountTeamMembers(Id EntityId, Map<String,Account_Team_Role__c> approvedRoleMap);
        Map<Id,User> Users();
    }
    
    public class DataProvider implements IDataProvider{
    	private List<Account_Team_Role__c> m_approvalRoles = null;
    	private List<AccountTeamMember> m_accountTeamMembers = null;
    	private Map<Id,User> m_users = null;
    	
        public List<Account_Team_Role__c> ApprovalRoles(){
        	if (m_approvalRoles == null){
        		m_approvalRoles = [SELECT Name, Approval_Authority_Order__c FROM Account_Team_Role__c WHERE Can_Approve_Loan__c =:'Yes' order by Approval_Authority_Order__c];
        	}
            return m_approvalRoles;
        }
        
        public List<AccountTeamMember> AccountTeamMembers(Id EntityId, Map<String,Account_Team_Role__c> approvedRoleMap){
            System.debug('###approvedRoleMap.size(): ' + string.valueOf(approvedRoleMap.size()));
            if(m_accountTeamMembers == null){
            	m_accountTeamMembers = [SELECT Id, TeamMemberRole, UserId FROM AccountTeamMember WHERE  AccountId =: EntityId and TeamMemberRole IN:approvedRoleMap.keyset()];
            }
            System.debug('###m_accountTeamMembers.size(): ' + string.valueOf(m_accountTeamMembers.size()));
            return m_accountTeamMembers;
        }
        
        public Map<Id,User> Users(){
        	if(m_users == null){
        		m_users = new Map<Id,User>([SELECT Id, name, UserRoleId /*,Signer_One_Authority__c*/ FROM User]);
        	}
            return m_users;
        }
    }
    
	public interface ITeamRoleMatrix{
		 List<SelectOption> GetSigners(Id EntityId);
	}
    
	public class Signer implements Comparable{
        public User User{get;set;}
        public String TeamMemberRole{get;set;}
        public Integer Approval_Authority_Order{get;set;}
        public Integer compareTo(Object compareTo){
            Signer otherSigner = (Signer) compareTo;
            if (this.Approval_Authority_Order == otherSigner.Approval_Authority_Order) return secondarySort(compareTo);
            if (this.Approval_Authority_Order > otherSigner.Approval_Authority_Order) return 1;
            return -1;        
        }
        public Integer secondarySort(Object compareTo){
            Signer otherSigner = (Signer) compareTo;
            if (this.User.Name == otherSigner.User.Name) return 0;
            if (this.User.Name > otherSigner.User.Name) return 1;
            return -1; 
        }
    }
	public class TeamRoleMatrixImplementation implements ITeamRoleMatrix{
        private IDataProvider m_dataProvider;
	
		public TeamRoleMatrixImplementation(){
			SetDataProvider(new DataProvider());
		}	
        
        public void SetDataProvider(IDataProvider provider){
        	m_dataProvider = provider;
        }
        
		public List<SelectOption> GetSigners(Id EntityId){
			system.debug('### Getting Signers');
			List<Signer> signers = GetSignersFromAccountTeam(EntityId);
			List<Signer> approvedSigners = GetValidSigners(signers);
			return CreateSelectOptionsFromSigners(approvedSigners);
		}
			
		private List<Signer> GetSignersFromAccountTeam(Id EntityId){		
			Map<String,Account_Team_Role__c> approvedRoleMap = new Map<String,Account_Team_Role__c>();
			for(Account_Team_Role__c atr : m_dataProvider.ApprovalRoles()){
				approvedRoleMap.put(atr.Name,atr);
                system.debug('### Approved Role Add: ' + atr.Name);
			}
			
			List<Signer> Signers = new List<Signer>();
			Map<id,User> userMap = m_dataProvider.Users();
			for(AccountTeamMember atm : m_dataProvider.AccountTeamMembers(EntityId, approvedRoleMap)){
				Signer s = new Signer();
				s.User = userMap.get(atm.UserId);
				s.TeamMemberRole = atm.TeamMemberRole;
				s.Approval_Authority_Order = integer.valueof(approvedRoleMap.get(atm.TeamMemberRole).Approval_Authority_Order__c);
				Signers.add(s);
				system.debug('###CalculateSigners ' + s.TeamMemberRole);
			}
			return Signers;
		}
        
		private List<Signer> GetValidSigners(List<Signer> Signers){
			List<Signer> validSigners = new List<Signer>();
			for(signer s : signers){
                //if(s.User.Signer_One_Authority__c == true){
                    validSigners.add(s);
                //}
			}			
			return validSigners;
		}
        
		private List<SelectOption> CreateSelectOptionsFromSigners(List<Signer> signers){
			 signers.sort();
			 List<SelectOption> options = new List<SelectOption>();
			 options.add(new SelectOption('', '--None--'));
			 for(signer s: Signers){
			 	String description = s.User.Name;// + ' (' + s.TeamMemberRole + ')';
			 	options.add(new SelectOption(s.User.Id,description));			 	
			 }
			 return options;
		}		
	}
}