public class sampleDemoClass {
    public static void sampleMethod(){
        List<sObject> samIns = new List<sObject>();
        
        Account acc = new Account(name='Test');
        Insert acc;
        
        List<sObject> staIns = [SELECT Id, Name from Account];
        String dynQuery = 'SELECT Id, Name from Account ';
        samIns = Database.query(dynQuery);
        Expense__c ex = [Select Name, Amount__c from Expense__c limit 1];
        ex.Amount__c = 10000;
        Update ex;
        system.debug('Test');
        
    }
}