public with sharing class BoardMeetingController {

	Board__c board;
	Board_Meeting__c bm;
	Id meetingId;
	Id boardId;
	Id bmaId;
 	String retURL;
    String url = ''; 
    PageReference thisPage = null;
    public List<Board_Meeting_Attendance__c> bma {get; set;}
	CurrentMode Mode;
	enum CurrentMode {saveNew, saveEdit, None}

	private void setMode(){
    	this.Mode = CurrentMode.None;
   		if(meetingId==null) {
     		this.Mode = CurrentMode.saveNew;
   		}
      	if(boardId==null){
      		this.Mode = CurrentMode.saveEdit;
    	}
	}
    
	public Board_Meeting__c getBm(){
		return bm;
	}
	
	public String getMeetingId(){
		return meetingId;
	}
	
	public String getBoardId(){
		return boardId;
	}
	
	public String getDefaultTab(){
  		Profile p = [select name from Profile where id =: UserInfo.getProfileId()];
		if ('System Administrator'.equals(p.Name)){
			return 'All';		
		} else {
			try{
				PermissionSet ps = [select id from PermissionSet where Label='Function - Director Attendance Log Read/Write'];
				PermissionSetAssignment psa =[SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() and PermissionSetId = :ps.Id];
				return 'All';
			}catch(System.QueryException e){
				return 'Yes';
			}
		}
	}
	
	private void initialize() {
		if (meetingId==null) {
			bm = new Board_Meeting__c();
			bm.Board__c = boardId;
		} else {
			bm = [
			
			Select b.Name, 				   
				   b.Id, 
				   b.Board__c,
				   (Select Id,Attended_Meeting__c, Compensation_Type__c, How_Attended__c, Associate_Director__r.Id, Associate_Director__r.name from Board_Meeting_Attendance__r)
			 From Board_Meeting__c b
			WHERE b.Id =: meetingId			
			];			
			boardId = bm.Board__c;
			bma = [Select Id,Attended_Meeting__c, Compensation_Type__c, How_Attended__c, Associate_Director__r.Id, Associate_Director__r.name from Board_Meeting_Attendance__c where Board_Meeting__r.Id = :bm.Id];
		}
	}
	
	public BoardMeetingController(ApexPages.StandardController stdController) {		
		if(thisPage==null) thisPage = apexpages.currentpage();
		if(url == '') url = Utility.getServerUrl();
		getQueryParameters();
		setMode();
		initialize();
	}

	public pageReference save(){
		update bma;
		return null;
	}
	
	public pageReference cancelInlineEdit(){
		String newPageUrl;
		newPageUrl = this.url + '/' +  this.meetingId;  
		PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
	}
	
	public PageReference cancel() {
		String newPageUrl;
		newPageUrl = this.url + '/' +  this.boardId;  
		PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
	}
	
	public PageReference BoardMeetingSave() {
		String newPageUrl;
		if (this.Mode == CurrentMode.saveNew) {	
			insert bm;
			newPageUrl = this.url + '/' +  this.boardId;  
			PageReference newPage = new PageReference(newPageUrl);
			newPage.setRedirect(true);
			return newPage;
		} else {
			update bm;
			newPageUrl = this.url + '/' +  this.boardId;  
			PageReference newPage = new PageReference(newPageUrl);
			newPage.setRedirect(true);
			return newPage;
		}
	}
	
	public PageReference BoardMeetingCancel() {
		String newPageUrl;
		newPageUrl = this.url + '/' +  this.boardId;  
		PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
	}
	
	public PageReference newBoardMeetingAttendance() {
		String newPageUrl = this.url + '/apex/boardmeetingattendanceedit?bmid=' + meetingId;
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
	}
	
	public PageReference editAttendance() {
		String newPageUrl = this.url + '/apex/boardmembershipedit?id=' + bmaId + '&bmid=' + meetingId;
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
	}
	

	private void getQueryParameters(){
		try{
			this.boardId = thisPage.getparameters().get('bid');
		}catch(exception ex){
			this.boardId = null;
		}

		try{
			this.retURL = thisPage.getparameters().get('retURL');
		}catch(exception ex){
			this.retURL = '';
		}

		try{
			this.meetingId = thisPage.getparameters().get('id');
		}catch(exception ex){
			this.meetingId = null;
		}
	}	
	
	public static testMethod void verifyInitialize(){
		Board__c board = ObjectFactory.getBoard('My Super Test Board');
     	Board_Meeting__c boardMeeting = ObjectFactory.getBoardMeeting(board.Id); 
     	EB_Team_Member__c director = ObjectFactory.getTeamMember('Sally Smith');
		director.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');
		update director;
     	Board_Director_Association__c bda = ObjectFactory.getBoardMembership(director.Id, board.Id, 'Cash', 'Advisory');
        String url = utility.getServerUrl() + '/apex/boardmeetingedit?bid=';
        PageReference pr = new PageReference(url + board.Id);
	    pr.setRedirect(true);        
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new ApexPages.standardController(boardMeeting);
       	BoardMeetingController controller = new BoardMeetingController(sc);
        controller.getQueryParameters();
     	controller.initialize();     	
     	controller.setMode();
     	controller.getBm();
     	controller.getBoardId();
     	controller.getMeetingId();
     	controller.newBoardMeetingAttendance() ;
     	controller.editAttendance();
     	controller.getDefaultTab();
	}
	
	public static testMethod void verifyPageReferences(){
		
		Board__c board = ObjectFactory.getBoard('My Super Test Board');
     	Board_Meeting__c boardMeeting = ObjectFactory.getBoardMeeting(board.Id); 
		EB_Team_Member__c director = ObjectFactory.getTeamMember('Sally Smith');
		director.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');
		update director;
	    
	    EB_Team_Member__c director2 = ObjectFactory.getTeamMember('Sally Smith');
		director2.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');
		update director2;
     	Board_Director_Association__c bda = ObjectFactory.getBoardMembership(director.Id, board.Id, 'Cash', 'Advisory');
     	    
     	String url = utility.getServerUrl() + '/apex/boardmeetingedit?id=';
        PageReference pr = new PageReference(url + boardMeeting.Id);
        pr.setRedirect(true);        
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new ApexPages.standardController(boardMeeting);
     	BoardMeetingController controller = new BoardMeetingController(sc);
     	PageReference bmc = controller.BoardMeetingCancel();
     	controller.save();
     	controller.cancel();
     	controller.cancelInlineEdit();
     	controller.BoardMeetingSave();
     	controller.BoardMeetingCancel();
     	controller.meetingId = null;
     	controller.initialize();
     	controller.setMode();
     	controller.bm.Date__c = ObjectFactory.getDate();
     	controller.BoardMeetingSave();
     	controller.getDefaultTab();
     	User usr = ObjectFactory.getUser('board', 'director', 'bdirector@enterprisebank.stl.com', true);
     	System.runAs(usr){
     		controller.getDefaultTab();
     	}
	}
	
	public static testMethod void verifyExceptions() {
		Board__c board = ObjectFactory.getBoard('My Super Test Board');
     	Board_Meeting__c boardMeeting = ObjectFactory.getBoardMeeting(board.Id); 
		ApexPages.StandardController sc = new ApexPages.standardController(boardMeeting);
		BoardMeetingController controller = new BoardMeetingController(sc);
		controller.thisPage = null;
		controller.getQueryParameters();
	}
}