global class DailyLeadProcessor implements Schedulable {
    global void execute(SchedulableContext sc){
        List<Lead> ldMem = new List<Lead>([select Id, leadSource from Lead where leadSource != null limit 10000]);
        for(Lead ld : ldMem){
            ld.leadSource = 'Dreamforce' ;
        }
        update ldMem;
    }
}