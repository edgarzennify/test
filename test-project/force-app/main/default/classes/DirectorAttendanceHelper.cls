public with sharing class DirectorAttendanceHelper {
public void createAttendanceObjects(List<Board_Meeting__c> newList){
		System.assert(newList !=null);
		List<Board_Meeting_Attendance__c> newBMA = new List<Board_Meeting_Attendance__c>();
		List<Board_Director_Association__c> directors = [SELECT EB_Team_Member__c, Compensation_Type__c, Board__c FROM Board_Director_Association__c WHERE Role__c != 'Retired' ];
				
		for(integer i = 0; i < newList.size(); i++ ){
			Board_Meeting__c bm = newList.get(i);
			//create the attendance object for each non-retired Director on the board		
			for (Board_Director_Association__c d: directors){
				if(d.Board__c == bm.Board__c){
					//create an attendance object
					Board_Meeting_Attendance__c bma = new Board_Meeting_Attendance__c();
					bma.Associate_Director__c = d.EB_Team_Member__c;
					bma.Compensation_Type__c = d.Compensation_Type__c;
					bma.Attended_Meeting__c = 'No';
					bma.Board_Meeting__c = bm.id;
					bma.Name__c = bm.Name__c;
					newBMA.add(bma);
				}
			}
		}
		if(newBMA <> null) insert newBMA;
	}
	
	public void createBoardMeetingName(List<Board_Meeting__c> newList){
		List<Board__c> boards = new List<Board__c>();
		string boardName;
		boards = [SELECT Name from Board__c];		
		try {
			for(integer i = 0; i < newList.size(); i++ ){
				Board_Meeting__c bm = newList.get(i);				
				for (Board__c b: boards){
					if (bm.Board__c == b.id){
						boardName = b.Name;
					}
				}
				string dt = bm.Date__c.format();
				bm.Name__c = boardName + ' ' + dt;
			}		
		}catch(exception ex){
			
		}
	}
	
	public void createBoardMemberAttendanceName(List<Board_Meeting_Attendance__c> newList){
		List<Board_Meeting__c> boards = new List<Board_Meeting__c>();
		string boardName;
		boards = [SELECT Name, Name__c from Board_Meeting__c];		
		try {
			for(integer i = 0; i < newList.size(); i++ ){
				Board_Meeting_Attendance__c bm = newList.get(i);				
				for (Board_Meeting__c b: boards){
					if (bm.Board_Meeting__c == b.id){
						boardName = b.Name__c;
						bm.Name__c = boardName;								
					}
				}					
			}		
		}catch(exception ex){

		}
	}	

}