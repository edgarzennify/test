global class PrimaryRelationshipBatchScheduler implements Schedulable {
	global void execute(SchedulableContext sc) {
		PrimaryRelationshipBatchUpdate primRelBatch = new PrimaryRelationshipBatchUpdate();
		database.executebatch(primRelBatch, 50);
	}
}