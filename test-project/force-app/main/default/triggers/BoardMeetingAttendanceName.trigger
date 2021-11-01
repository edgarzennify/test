trigger BoardMeetingAttendanceName on Board_Meeting_Attendance__c (before insert) {
  	    DirectorAttendanceHelper defaults = null;
        defaults =  new DirectorAttendanceHelper();
        defaults.createBoardMemberAttendanceName(trigger.new);
}