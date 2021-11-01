public with sharing class BoardController {
	Board__c board;
	Board_Director_Association__c membership;	
	Board_Meeting__c meeting;
	Id BoardId;
    Id MembershipId;
    Id BoardMeetingId;
    String retURL;
    String url = '';
    PageReference thisPage = null;
    
    public String boardMemberChosen {get; set;}	
	public String boardMeetingChosen {get; set;} 
	      
    public String getReadonlyStatus(){
    	return 'true';  	}
  	
  	public Board__c getBoard() {
     	return board;    }
        
    public Board_Director_Association__c getMembership() {
        return membership;    }
    
  	public String getCanDelete(){
  		string res = 'false';
  		Profile p = [select name from Profile where id =: UserInfo.getProfileId()];
		if ('System Administrator'.equals(p.Name)){
			res ='true';		
		}
		return res;  	}
	
	public String getCanEdit() {
		if (this.getCanDelete()=='true'){
			return 'true';
		} else {
				List<PermissionSet> ps = [select id from PermissionSet where Label='Function - Director Attendance Log Read/Write'];
				if(ps.size()>0){
					id psid = ps[0].id;
					List<PermissionSetAssignment> psa  = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() and PermissionSetId = :psid];
					if (psa.size()>0){
						return 'true';
					} else {
						return 'false';
					}
				} else {
					return 'false';
				}
		}
		
	}

   public BoardController(ApexPages.StandardController stdController) {
   		if(thisPage==null) thisPage = apexpages.currentpage();
		if(url == '') url = Utility.getServerUrl() + '/';
		getQueryParameters();
		initialize();}
   
		
	public PageReference newBoardMembership() {
		String newPageUrl = this.url + 'apex/boardmembershipedit?bid=' + boardId;
		PageReference newPage = new PageReference(newPageUrl);
		newPage.setRedirect(true);
		return newPage;
	}        
        
	public pageReference newBoardMeeting() {
		String newPageUrl = this.url + 'apex/boardmeetingedit?bid=' + boardId;
		PageReference newPage = new PageReference(newPageUrl);
	    newPage.setRedirect(true);
	    return newPage;
	}
		    
	public pageReference deleteMembership(){		
		Board_Director_Association__c toDel=new Board_Director_Association__c(id=boardMemberChosen);
		delete toDel;
		String newPageUrl = this.url + 'apex/boardview?id=' + boardId;
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
    }
	
	public pageReference deleteMeeting(){		
		Board_Meeting__c toDel=new Board_Meeting__c(id=boardMeetingChosen);
		delete toDel;
		String newPageUrl = this.url + 'apex/boardview?id=' + boardId;
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
    }
	
	public pageReference editMembership(){		
		String newPageUrl = this.url + 'apex/boardmembershipedit?id=' + boardMemberChosen;
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
    }
    
	private void initialize() {
		board = (boardId == null) ? new Board__c() : 
			[			
			Select b.Name,  b.Id, b.CreatedDate, b.CreatedById, (Select Id, Date_Resigned__c, Compensation_Type__c, Role__c , Date_Elected__c, EB_Team_Member__r.name, EB_Team_Member__r.Id From Board_Director_Associations__r) 
            ,(Select Id, Name, Name__c, Location__c, Date__c, Attendance__c from Board_Meetings__r order by Date__c DESC) 
            From Board__c b WHERE b.Id =: boardId            
            ];       
	}
	
	private void getQueryParameters(){		
		try{
			this.boardId = thisPage.getparameters().get('id');
		}catch(exception ex){
		    this.boardId = null;
		}		                
		try{
			this.retURL = thisPage.getparameters().get('retURL');
		}catch(exception ex){
		    this.retURL = '';
		}		                
		try{
		    this.membershipId = thisPage.getparameters().get('mid');
		}catch(exception ex){
		    this.membershipId = null;
		}		               
		try{
		    this.boardMeetingId = thisPage.getparameters().get('bid');
		 }catch(exception ex){
		    this.boardMeetingId = null;
		 }        
	}
	
	//test methods
	
	public static testMethod void verifyInitialize(){

     	Board__c board = ObjectFactory.getBoard('My Super Test Board');
        Id boardId = board.Id;
        String url = utility.getserverurl() + '/apex/BoardView?id=';
        PageReference pr = new PageReference(url + boardId);
	    pr.setRedirect(true);        
        test.setCurrentPage(pr);
        ApexPages.StandardController sc =new ApexPages.StandardController(board);
        BoardController controller = new BoardController(sc);
        controller.getQueryParameters();
     	controller.initialize();
     	string ros = controller.getReadonlyStatus();
     	
     	Board__c nb = controller.getBoard();
     	Board_Director_Association__c bdac = controller.getMembership();
     	string edit = controller.getCanEdit();
     	string del = controller.getCanDelete();
     	User usr = ObjectFactory.getUser('board', 'director', 'bdirector@enterprisebank.stl.com', true);
     	System.runAs(usr){
     		edit = controller.getCanEdit();
     		del = controller.getCanDelete();
     	}
     	boardid = null;
     	controller.initialize();
	}
	
	public static testMethod void verifyPageReferences(){
     	
     	Board__c board = ObjectFactory.getBoard('My Super Test Board');
     	Board_Meeting__c boardMeeting = ObjectFactory.getBoardMeeting(board.Id);    	
		EB_Team_Member__c director = ObjectFactory.getTeamMember('Sally Smith');
		director.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');
		update director;
     	Board_Director_Association__c bda = ObjectFactory.getBoardMembership(director.Id, board.Id, 'Cash', 'Advisory');
         
		ApexPages.StandardController sc =new ApexPages.StandardController(board);
        BoardController controller = new BoardController(sc);		
        PageReference pnbms  = controller.newBoardMembership();
		System.assert( pnbms.getUrl()!=null );
 		PageReference pbm  = controller.newBoardMeeting();
 		
 		controller.boardMemberChosen = bda.id;
 		PageReference pdms = controller.deleteMembership();
 		
 		controller.boardMeetingChosen = boardMeeting.id; 		
 		PageReference pdm = controller.deleteMeeting();
 		
 		PageReference pem = controller.editMembership();
	}
	
	public static testMethod void verifyExceptions() {
		Board__c board = ObjectFactory.getBoard('My Super Test Board');
		ApexPages.StandardController sc =new ApexPages.StandardController(board);
        BoardController controller = new BoardController(sc);
		controller.thisPage = null;
		controller.getQueryParameters();
	}
}