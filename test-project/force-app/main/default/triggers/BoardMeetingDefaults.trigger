trigger BoardMeetingDefaults on Board_Meeting__c (after insert) {
        DirectorAttendanceHelper defaults = null;
        defaults =  new DirectorAttendanceHelper();
        defaults.createAttendanceObjects(trigger.new);
     
}