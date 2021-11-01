public with sharing class DirectorExtension {

	private List<Board_Director_Association__c> bdas;
	private List<Board_Director_Association__c> allbdas;
	private List<Board_Meeting_Attendance__c> bmas;
	private List<Board_Meeting_Attendance__c> allbmas;

	private EB_Team_Member__c director;
	private EB_Team_Member__c dir;
	public String boardMemberChosen {get; set;}	
	public String boardMeetingChosen {get; set;} 
	String bma_previous;
	String bma_next;
	String bma_showPrev;
	String bma_showNext;
	String bma_clicked;
	Integer bma_currentPos;
	Integer bma_page = 5;
	
	String bda_previous;
	String bda_next;
	String bda_showPrev;
	String bda_showNext;
	String bda_clicked;
	Integer bda_currentPos;
	Integer bda_page = 5;
	
	public String getbma_showNext(){
		return this.bma_showNext;
	}
	public String getbma_showPrev(){
		return this.bma_showPrev;
	}
	public String getbda_showNext(){
		return this.bda_showNext;
	}
	public String getbda_showPrev(){
		return this.bda_showPrev;
	}

	String directorName;
	String url = '';
	
	
	Public String getbma_previous(){
		return '<Previous Page';
	}
	Public String getbma_next(){
		return 'Next Page>';
	}
	Public String getbda_previous(){
		return '<Previous Page';
	}
	Public String getbda_next(){
		return 'Next Page>';
	}
	
	public String getCanDelete(){
  		string res = 'false';
  		Profile p = [select name from Profile where id =: UserInfo.getProfileId()];
		if ('System Administrator'.equals(p.Name)){
			res ='true';		
		}
		return res;  	}
	
	//static boolean 
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
	
	public String getHasAccess(){
		String res = 'false';
	if (this.getCanDelete()=='true'){
			return 'true';
		} else {
			if(this.getCanEdit()=='true'){
				return 'true';
			} else {
				List<PermissionSet> ps = [select id from PermissionSet where Label='Function - Director Attendance Log Read Only'];
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
		return res;
	}

	public DirectorExtension(ApexPages.StandardController controller) {	
        this.director = (EB_Team_Member__c)controller.getRecord();
        if(dir==null) 	{
			dir = [Select id FROM EB_Team_Member__c where id = :director.id];
		}
		initialize();
	}
	
	private void initialize() {
		this.bma_currentPos = 0;
		this.bda_currentPos = 0;
		getBmas();
		getBdas();
		
	}
	public  void bma_getNext(){
		this.bma_currentPos +=this.bma_page;
	}
	
	public  void bma_getPrev(){
		this.bma_currentPos -= this.bma_page;
	}
	
	public  void bda_getNext(){
		this.bda_currentPos += this.bda_page;
	}
	
	public  void bda_getPrev(){
		this.bda_currentPos -= this.bda_page;
	}
	
	public List<Board_Director_Association__c> makeBdaList(){

				
		List<Board_Director_Association__c> ret_bdas = new List<Board_Director_Association__c>() ;
         if(allbdas == null){ 
       		 allbdas = [
				   Select b.Name, 				   
				   b.Id, 
				   b.EB_Team_Member__c, 
				   b.Date_Resigned__c, 
				   b.Date_Elected__c, 
				   b.Compensation_Type__c, 
				   b.Role__c,
				   b.Board__c,
				   b.Board__r.Name
				   From Board_Director_Association__c b   
				   WHERE b.EB_Team_Member__r.id =: dir.id AND b.Role__c <> 'Retired'	
				   ORDER BY  b.Board__r.Name    
        	];
         }
		if (allbdas.size()<=this.bda_page){ 
			ret_bdas = allbdas;
			this.bda_showNext='false';
			this.bda_showPrev='false';
		} else {
			for(integer i = this.bda_currentPos; i < this.bda_currentPos + this.bda_page; i++ ){
				System.debug('currentPos: ' + this.bda_currentPos.format() + '//AllBdas.Size: ' + allbdas.size().format()) ;
				
			
				if(i>=allbdas.size()-1){
					this.bda_showNext='false';
				} else {
					this.bda_showNext='true';
				}		

				if(i>=this.bda_page){
					this.bda_showPrev='true';
				}else {
					this.bda_showPrev='false';
				}
				if (i<=allbdas.size()-1){
					ret_bdas.add(allbdas.get(i))  ;
				}
				
  			}
			
		}
       	return ret_bdas;		
	}

	public List<Board_Meeting_Attendance__c> makeBmaList() {
		List<Board_Meeting_Attendance__c> ret_bmas = new List<Board_Meeting_Attendance__c>() ;
         if (allbmas == null){
        	allbmas = [
         		Select b.Name,
         		b.Id,
         		b.Associate_Director__c,
         		b.Name__c,
         		b.Attended_Meeting__c,
         		b.How_Attended__c,
         		b.Compensation_Type__c,
         		b.Board_Meeting__c,
         		b.Board_Meeting__r.Id,
         		b.Board_Meeting__r.Date__c
         		From Board_Meeting_Attendance__c b
         		WHERE b.Associate_Director__r.id =: dir.id and b.Attended_Meeting__c = 'Yes'
         		ORDER BY b.Board_Meeting__r.Name , b.Board_Meeting__r.Date__c desc       	
         ];
         }
		if (allbmas.size()<=this.bma_page){
			ret_bmas = allbmas;
			this.bma_showNext='false';
			this.bma_showPrev='false';
		} else {
			for(integer i = this.bma_currentPos; i < this.bma_currentPos + this.bma_page; i++ ){
				if(i>=allbmas.size()-1){
					this.bma_showNext='false';
				} else {
					this.bma_showNext='true';
				}		
				if(i>=this.bma_page){
					this.bma_showPrev='true';
				}		else {
					this.bma_showPrev='false';
				}
				if (i<=allbmas.size()-1){
					ret_bmas.add(allbmas.get(i))  ;
				}
				

  			}
			
		}
       	return ret_bmas;
	}
	
	public List<Board_Meeting_Attendance__c> getBmas() {
		bmas = makeBmaList();
        return bmas;		
	}

	public List<Board_Director_Association__c> getBdas() {
		bdas = makeBdaList();
        return bdas;			
	}	
	
	public static testMethod void verifyInitialize(){
		Board__c board1 = ObjectFactory.getBoard('My Board 1'); 
		Board__c board2 = ObjectFactory.getBoard('My Board 2');
		Board__c board3 = ObjectFactory.getBoard('My Board 3'); 
		Board__c board4 = ObjectFactory.getBoard('My Board 4');
		Board__c board5 = ObjectFactory.getBoard('My Board 5'); 
		Board__c board6 = ObjectFactory.getBoard('My Board 6');
		
     	EB_Team_Member__c director = ObjectFactory.getTeamMember('Sally Smith');
		director.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');
		update director;
     	Board_Director_Association__c bda1 = ObjectFactory.getBoardMembership(director.Id, board1.Id, 'Cash', 'Advisory');
     	Board_Director_Association__c bda2 = ObjectFactory.getBoardMembership(director.Id, board2.Id, 'Cash', 'Advisory');
     	Board_Director_Association__c bda3 = ObjectFactory.getBoardMembership(director.Id, board3.Id, 'Cash', 'Advisory');
     	Board_Director_Association__c bda4 = ObjectFactory.getBoardMembership(director.Id, board4.Id, 'Cash', 'Advisory');
     	Board_Director_Association__c bda5 = ObjectFactory.getBoardMembership(director.Id, board5.Id, 'Cash', 'Advisory');
     	Board_Director_Association__c bda6 = ObjectFactory.getBoardMembership(director.Id, board6.Id, 'Cash', 'Advisory');
     	     	
     	Board_Meeting__c boardMeeting1 = ObjectFactory.getBoardMeeting(board1.Id); 
     	Board_Meeting__c boardMeeting2 = ObjectFactory.getBoardMeeting(board1.Id); 
     	Board_Meeting__c boardMeeting3 = ObjectFactory.getBoardMeeting(board1.Id); 
     	Board_Meeting__c boardMeeting4 = ObjectFactory.getBoardMeeting(board1.Id); 
     	Board_Meeting__c boardMeeting5 = ObjectFactory.getBoardMeeting(board1.Id); 
     	Board_Meeting__c boardMeeting6 = ObjectFactory.getBoardMeeting(board2.Id); 
     	Board_Meeting__c boardMeeting10 = ObjectFactory.getBoardMeeting(board2.Id); 
     	Board_Meeting__c boardMeeting11 = ObjectFactory.getBoardMeeting(board2.Id); 
     	Board_Meeting_Attendance__c bma1 = ObjectFactory.getBoardMeetingAttendance(director.Id, boardMeeting1.Id, 'Yes', 'Phone', 'SARS');
		Board_Meeting_Attendance__c bma2 = ObjectFactory.getBoardMeetingAttendance(director.Id, boardMeeting2.Id, 'Yes', 'Person', 'Cash');
		Board_Meeting_Attendance__c bma3 = ObjectFactory.getBoardMeetingAttendance(director.Id, boardMeeting3.Id, 'Yes', 'Phone', 'SARS');
		Board_Meeting_Attendance__c bma4 = ObjectFactory.getBoardMeetingAttendance(director.Id, boardMeeting4.Id, 'Yes', 'Phone', 'SARS');
		Board_Meeting_Attendance__c bma5 = ObjectFactory.getBoardMeetingAttendance(director.Id, boardMeeting5.Id, 'Yes', 'Person', 'None');
		Board_Meeting_Attendance__c bma6 = ObjectFactory.getBoardMeetingAttendance(director.Id, boardMeeting6.Id, 'Yes', 'Phone', 'SARS');

     	String serverurl =  Utility.getServerUrl();   	
        String url = serverurl + '/';
        PageReference pr = new PageReference(url + director.Id);
	    pr.setRedirect(true);        
        test.setCurrentPage(pr);
        ApexPages.StandardController sc = new ApexPages.standardController(director);
       	DirectorExtension controller = new DirectorExtension(sc);
		controller.bma_page = 16;
    	controller.bda_page = 11;
     	controller.initialize();     	
   		controller.bma_page = 5;
    	controller.bda_page = 5;
		List<Board_Director_Association__c> bdas;
		List<Board_Meeting_Attendance__c> bmas;
		bmas = controller.makeBmaList();
		bdas = controller.makeBdaLIst();
		controller.getbma_Next();
		controller.getbma_Previous();
		controller.getbda_Next();
		controller.getbda_Previous();		
		controller.getbma_showPrev();
		controller.getbma_showNext();
		controller.getbda_showPrev();
		controller.getbda_showNext();
		controller.bma_getNext();
		controller.bda_getNext();
		bmas = controller.makeBmaList();
		bdas = controller.makeBdaLIst();
		controller.bma_getNext();controller.bda_getNext();
		bmas = controller.makeBmaList();
		bdas = controller.makeBdaLIst();
		controller.bma_getNext();controller.bda_getNext();
		bmas = controller.makeBmaList();
		bdas = controller.makeBdaLIst();
		controller.bma_getNext();controller.bda_getNext();
		bmas = controller.makeBmaList();
		bdas = controller.makeBdaLIst();
		controller.bma_getNext();controller.bda_getNext();
		bmas = controller.makeBmaList();
		bdas = controller.makeBdaLIst();		
		controller.bma_getPrev();controller.bda_getPrev();
		bmas = controller.makeBmaList();
		bdas = controller.makeBdaLIst();
		controller.bma_getPrev();controller.bda_getPrev();
		bmas = controller.makeBmaList();
		bdas = controller.makeBdaLIst();
		controller.bma_getPrev();controller.bda_getPrev();
		bmas = controller.makeBmaList();
		bdas = controller.makeBdaLIst();
		controller.bma_getPrev();controller.bda_getPrev();
		bmas = controller.makeBmaList();
		bdas = controller.makeBdaLIst();
		controller.bma_getPrev();controller.bda_getPrev();	
     	string edit = controller.getCanEdit();
     	string del = controller.getCanDelete();
     	string acc = controller.getHasAccess();
		User usr = ObjectFactory.getUser('board', 'director', 'bdirector@enterprisebank.stl.com', true);
     	System.runAs(usr){
     		edit = controller.getCanEdit();
     		del = controller.getCanDelete();
     		acc = controller.getHasAccess();
     	}
	}

}