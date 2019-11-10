global class scheduledMerge implements Schedulable {
   global void execute(SchedulableContext SC) {
      ScheduledTask.dailyRun();
   }
}