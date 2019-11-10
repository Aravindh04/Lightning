global class Month_Refresh_On_Shares implements Schedulable {
    global void execute(SchedulableContext SC){
        ScheduledTask.dailyRun();
        ScheduledTask.openTasks();
    }
}