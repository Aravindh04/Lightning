@isTest(seeAllData = true) public class AccountProcessorTest {
    @isTest static void countContactsTest(){
        List<Id> accIds = new List<Id>(new Map<Id, Account>([select Id from Account limit 1000]).keySet());
        system.debug('accIds '+accIds);
        Test.startTest();
        AccountProcessor.countContacts(accIds);
        Test.stopTest();
        Account acc = [select Id, Name, Number_of_Contacts__c from Account where Number_of_Contacts__c != null];
        system.assert(acc.Number_of_Contacts__c>0);
    }

}