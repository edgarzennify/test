@IsTest
private class DirectorAttendanceHelperTests {
    private static testMethod void verifyCreateAttendanceObjectsCode(){  

        EB_Team_Member__c teamMember = ObjectFactory.getTeamMember('testTeamMember');
        RecordType recordType = utility.recordTypeObject('EB_Team_Member__c', 'Director');
        teamMember.RecordTypeID = recordType.Id;
        update teamMember;
        Board__c board = new Board__c(Name='test board');
        insert board;
        Board_Director_Association__c boardDirectorAssociation = new Board_Director_Association__c(Board__c = board.Id,Eb_Team_Member__c = teamMember.Id);
        insert boardDirectorAssociation;

        //create a board meeting object
        Board_Meeting__c bm = new Board_Meeting__c();
        bm.Board__c = board.id;
        bm.Date__c = date.newinstance(1960, 2, 17);
        insert bm;
    }
    
    private static testMethod void verifycreateBoardMemberAttendanceNameCode(){
        Board__c board = new Board__c(Name='test board');
        insert board;

        //create a board meeting object
        Board_Meeting__c bm = new Board_Meeting__c();
        bm.Board__c = board.id;
        bm.Date__c = date.newinstance(1960, 2, 17);
        insert bm;
        
        //create a board meeting attendance object
        Board_Meeting_Attendance__c bma = new Board_Meeting_Attendance__c();
        bma.Board_Meeting__c = bm.id;
        insert bma;
    }
    
    private static testMethod void verifyCreateBoardMeetingNameCode(){
        Board__c board = new Board__c(Name='test board');
        insert board;

        //create a board meeting object
        Board_Meeting__c bm = new Board_Meeting__c();
        bm.Board__c = board.id;
        bm.Date__c = date.newinstance(1960, 2, 17);
        insert bm;
    }

}