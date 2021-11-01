trigger TMReview on Task (after insert, after update) {

    for(Task task : trigger.new){
            TMReviewTriggerHelper tmreview = null;
            tmreview =  new TMReviewTriggerHelper();
            tmreview.updateLastTMReview(task);
     }
}