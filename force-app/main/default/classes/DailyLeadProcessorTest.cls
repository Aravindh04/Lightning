@isTest
public class DailyLeadProcessorTest {
    @isTest static void schedulingTest(){
        List<Lead> leadList = new List<Lead>();
        for(integer i=0;i<=200;i++){
            Lead ld= new Lead();
            ld.LeadSource = 'Dreamforce';
            ld.LastName = 'Test'+i;
            ld.Company = 'Company '+i;
            leadList.add(ld);
        }
        insert leadList;
        Test.startTest();
        DailyLeadProcessor dailyPro = new DailyLeadProcessor();
        String jobId = System.Schedule('dailyleadprocessing','0 10 12 12 10 ? 2019',dailyPro);
        Test.stopTest();
        
        List<Lead> leadSrc = new List<Lead>([select Id from Lead where LeadSource = 'Dreamforce']);
        system.assertEquals(201, leadSrc.size());
    }
}