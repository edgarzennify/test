trigger BoardMeetingName on Board_Meeting__c (before insert, before update) {
        DirectorAttendanceHelper defaults = null;
        defaults =  new DirectorAttendanceHelper();
        defaults.createBoardMeetingName(trigger.new);

}