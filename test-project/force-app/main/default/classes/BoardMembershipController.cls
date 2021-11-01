public with sharing class BoardMembershipController {
	Board_Director_Association__c bm;
	Board__c board;
	Board_Director_Association__c membership;	
	Id boardId;
    Id MembershipId;
    String retURL;
    String url = ''; 
    String PageTitle = '';
	CurrentMode Mode;
	PageReference thisPage = null;
	enum CurrentMode {saveNew, saveEdit, None}
	 
	public BoardMembershipController(ApexPages.StandardController stdController) {
		if(url == '') url = Utility.getServerUrl();
		if(thisPage==null) thisPage = apexpages.currentpage();
		getQueryParameters();
		setMode();
		initialize();
    }

	private void setMode(){
    	this.Mode = CurrentMode.None;
    	if(membershipId==null) {
      		this.Mode = CurrentMode.saveNew;
      		this.PageTitle = 'New Director';
    	}
  
    	if(boardId==null){
      		this.Mode = CurrentMode.saveEdit;
      		this.PageTitle = 'Edit Director';
    	}
    }
    
    public String getPageTitle() {
    	return PageTitle;
    }

	private void initialize() {
		if (membershipId==null) {
			bm = new Board_Director_Association__c();
			bm.Board__c = boardId;
			
		} else {
			bm = [
			Select b.Name, 				   
				   b.Id, 
				   b.EB_Team_Member__c, 
				   b.Date_Resigned__c, 
				   b.Date_Elected__c, 
				   b.Compensation_Type__c, 
				   b.Role__c,
				   b.Board__c 
			From Board_Director_Association__c b
			WHERE b.Id =: membershipId			
			];			
			boardId = bm.Board__c;
			
		}			
	}

	public Board_Director_Association__c getBm() {
        return bm;
     }
        
 	public pageReference membershipSave() {
		try{
        	String newPageUrl;
			if (this.Mode == CurrentMode.saveNew) {	
          		if(CheckDuplicate()) {
          			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Director already exists for this board.');
        			ApexPages.addMessage(myMsg);
        			return null;      		
          		} else {
          			insert bm;
          			newPageUrl = this.url + '/' +  this.boardId;  
              		PageReference newPage = new PageReference(newPageUrl);
              		newPage.setRedirect(true);
              		return newPage;
          		}
			} else {
					update bm;
          			newPageUrl = this.url + '/' +  this.boardId;  
              		PageReference newPage = new PageReference(newPageUrl);
              		newPage.setRedirect(true);
              		return newPage;
			}
    	}catch(exception ex){
        	return null;     
    	}
    }

 	private Boolean CheckDuplicate(){
        try{
         	Board_Director_Association__c chk = [SELECT Id FROM Board_Director_Association__c WHERE Board__c =: bm.Board__c AND EB_Team_Member__c =: bm.EB_Team_Member__c];
        	id i = chk.Id;
        }catch(exception ex){
       		return false;
        }         
        return true;
  	}
        
	public pageReference membershipCancel() {
    	try{
        	String newPageUrl;
            if(this.boardId != null){
            	newPageUrl = this.url + '/' +  this.boardId;
                PageReference newPage = new PageReference(newPageUrl);
                newPage.setRedirect(true);
                return newPage;
             } else {
             	return null;
             }
    	}catch(exception ex){
        	return null;
    	}
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
            this.membershipId = thisPage.getparameters().get('id');                 
        }catch(exception ex){
            this.membershipId = null;
        }
	}

	//test methods	
	public static testMethod void verifyInitialize(){
		
		
     	Board__c board = ObjectFactory.getBoard('My Super Test Board');
     	EB_Team_Member__c director = ObjectFactory.getTeamMember('Sally Smith');
		director.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');
		update director;
		Board_Director_Association__c bda = ObjectFactory.getBoardMembership(director.Id, board.Id, 'Cash', 'Advisory');
     	    	
        String url = utility.getServerUrl() + '/apex/boardmembershipedit?id=';
        PageReference pr = new PageReference(url + bda.Id);
	    pr.setRedirect(true);        
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new ApexPages.standardController(bda);
       	BoardMembershipController controller = new BoardMembershipController(sc);
        controller.getQueryParameters();
     	controller.initialize();
     	string pt = controller.getPageTitle();
     	controller.setMode();
     	controller.getBm();   
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
     	
     	String url = utility.getServerUrl() + '/apex/boardmembershipedit?bid=';
        PageReference pr = new PageReference(url + board.Id);
        pr.setRedirect(true);        
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new ApexPages.standardController(bda);
       	BoardMembershipController controller = new BoardMembershipController(sc);
     	controller.bm.EB_Team_Member__c = director.id;
     	controller.bm.Compensation_Type__c = 'Cash';
		controller.bm.Date_Elected__c = ObjectFactory.getDate();
		controller.bm.Role__c = 'Member';
     	
 		PageReference membershipSave = controller.membershipSave();
 		controller.bm.EB_Team_Member__c = director2.id;
		membershipSave = controller.membershipSave();
		controller.MembershipId = controller.bm.id;
		controller.setMode();
		controller.bm.Role__c = 'Advisory';
		membershipSave = controller.membershipSave();
		PageReference canc = controller.membershipCancel();
		controller.boardId=null;
		canc = controller.membershipCancel();
	}
	
	public static testMethod void verifyExceptions() {
		Board__c board = ObjectFactory.getBoard('My Super Test Board');
     	EB_Team_Member__c director = ObjectFactory.getTeamMember('Sally Smith');
		director.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');
		update director;
		Board_Director_Association__c bda = ObjectFactory.getBoardMembership(director.Id, board.Id, 'Cash', 'Advisory');
		ApexPages.StandardController sc = new ApexPages.standardController(bda);
       	BoardMembershipController controller = new BoardMembershipController(sc);
     	controller.thisPage = null;
		controller.getQueryParameters();
	}
}