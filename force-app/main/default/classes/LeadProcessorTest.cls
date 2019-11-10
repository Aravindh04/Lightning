@isTest
public class LeadProcessorTest {
    @testSetup
    static void setUp(){
        List<Lead> leadList = new List<Lead>();
        for(integer i=0; i < 200; i++){
            Lead ld = new Lead(
                LeadSource = 'Test',
                FirstName = 'Test'+i,
                LastName = 'Test'+i,
                Company = 'Accenture'
            );
            leadList.add(ld);
        }
        insert leadList;
    }
    
    @isTest static void batchTest(){
        Test.startTest();
        LeadProcessor ldPro = new LeadProcessor();
        String batchId = Database.executeBatch(ldPro);
        Test.stopTest();
        Lead testLead = [SELECT LeadSource, Id from Lead limit 1];
        system.assertEquals('Dreamforce', String.valueOf(testLead.LeadSource));
    }

}