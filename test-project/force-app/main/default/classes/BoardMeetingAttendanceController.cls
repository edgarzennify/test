public with sharing class BoardMeetingAttendanceController {
	Board_Meeting_Attendance__c bma;
	Board__c board;
	Board_Meeting__c bm;
	Id bmaId;
	Id boardMeetingId;
    String retURL;
    String url = ''; 
    String title = '';
    String BoardMeetingName;
	CurrentMode Mode;
	PageReference thisPage = null;
	enum CurrentMode {saveNew, saveEdit, None}
	 
	public BoardMeetingAttendanceController(ApexPages.StandardController stdController) {
		if(thisPage==null) thisPage = apexpages.currentpage();
		if(url == '') url = getServerUrl();
		getQueryParameters();
		setMode();
		initialize();
	}
			
	public String getBoardMeetingName(){
		return BoardMeetingName;
	}
	
	public String getTitle() {
		return this.title;
	}
	
	private void setMode(){
    	this.Mode = CurrentMode.None;
    	if(bmaId==null) {
      		this.Mode = CurrentMode.saveNew;
      		this.title = 'New Attendee';
    	} else {
    		this.Mode = CurrentMode.saveEdit;
    		this.title = 'Edit Attendance';
    	}

  }
  
  
	private void initialize() {
        
		if (bmaId==null) {
			bma = new Board_Meeting_Attendance__c();
			bma.Board_Meeting__c = boardMeetingId;
			bm = [Select b.Name__c 	From Board_Meeting__c b WHERE b.Id =: boardMeetingId];			
			this.BoardMeetingName = bm.Name__c;
			
		} else {
			bma = [
			Select b.Associate_Director__c,
				   b.Attended_Meeting__c,
				   b.Board_Meeting__c,
				   b.Compensation_Type__c,
				   b.How_Attended__c,
				   b.Name,
				   b.Name__c 				   
			From Board_Meeting_Attendance__c b
			WHERE b.Id =: bmaId			
			];			
			this.BoardMeetingName = bma.Name__c;
		}			
	}

public Board_Meeting_Attendance__c getBma() {
        	return bma;
        }
        
 public pageReference Save() {
	 try{
          String newPageUrl;
			if (this.Mode == CurrentMode.saveNew) {	
          			insert bma;
          			newPageUrl = this.url + '/' +  this.boardMeetingId;  
              		PageReference newPage = new PageReference(newPageUrl);
              		newPage.setRedirect(true);
              		return newPage;
			} else {
					update bma;
          			newPageUrl = this.url + '/' +  this.boardMeetingId;  
              		PageReference newPage = new PageReference(newPageUrl);
              		newPage.setRedirect(true);
              		return newPage;
			}
    }catch(exception ex){
        			//ApexPages.addMessage(ex);     
    }
    return null;
}
    
public pageReference Cancel() {
        	 try{
              String newPageUrl;
              if(this.boardMeetingId != null){
                    newPageUrl = this.url + '/' +  this.boardMeetingId;
                    PageReference newPage = new PageReference(newPageUrl);
                    newPage.setRedirect(true);
                    return newPage;
              }
    }catch(exception ex){
        
    }
    return null;
 }
        
private void getQueryParameters(){
                        try{
                                this.boardMeetingId = thisPage.getparameters().get('bmid');
                               
                        }catch(exception ex){
                                this.boardMeetingId = null;
                        }
                        
                        try{
                                this.retURL = thisPage.getparameters().get('retURL');
                        }catch(exception ex){
                                this.retURL = '';
                        }
                        
                        
                        try{
                                
                                 this.bmaId = thisPage.getparameters().get('id');
                                 
                        }catch(exception ex){
                                this.bmaId = null;
                        }
                       
                       
                        

		}
		
		 private static String  getServerUrl(){
                
                       
                return Utility.getServerUrl() + '/';
        }

		public static testMethod void verifyInitialize(){
			Board__c board = ObjectFactory.getBoard('My Super Test Board');
     		Board_Meeting__c boardMeeting = ObjectFactory.getBoardMeeting(board.Id);       		
     		EB_Team_Member__c director = ObjectFactory.getTeamMember('Sally Smith');
			director.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');
			update director;
		
		
			String url = utility.getServerUrl() + '/apex/boardmeetingattendanceedit?bmid=';
        	PageReference pr = new PageReference(url + boardMeeting.Id);
       		pr.setRedirect(true);        
        	test.setCurrentPage(pr);
        	ApexPages.StandardController sc = new ApexPages.standardController(boardMeeting);
			BoardMeetingAttendanceController controller = new BoardMeetingAttendanceController(sc);
			String bmn = controller.getBoardMeetingName();
			String title = controller.getTitle();
			controller.setMode();
			controller.getBma();
			controller.Save();
			Board_Meeting_Attendance__c bma = ObjectFactory.getBoardMeetingAttendance(director.Id, boardMeeting.id, 'Yes', 'Person', 'Cash');
			//insert bma;
			
			url = utility.getServerUrl() + '/apex/boardmeetingattendanceedit?id=';
        	pr = new PageReference(url + bma.Id);
       		pr.setRedirect(true);        
        	test.setCurrentPage(pr);
        	controller.bmaId = bma.Id;
        	controller.initialize();
			controller.setMode();
			controller.getBma();
			controller.Save();
			controller.Cancel();
			
		}
		
		public static testMethod void verifyExceptions() {
			Board__c board = ObjectFactory.getBoard('My Super Test Board');
     		Board_Meeting__c boardMeeting = ObjectFactory.getBoardMeeting(board.Id);   
			String url = utility.getServerUrl() + '/apex/boardmeetingattendanceedit?bmid=';
        	PageReference pr = new PageReference(url + boardMeeting.Id);
       		pr.setRedirect(true);        
        	test.setCurrentPage(pr);
        	ApexPages.StandardController sc = new ApexPages.standardController(boardMeeting);
			BoardMeetingAttendanceController controller = new BoardMeetingAttendanceController(sc);
			controller.thisPage = null;
			controller.getQueryParameters();
			
		
	}
}