public class operartionOnExpenseTrigger {
    public static void ExpenseCreation(User_Master__c user){
        User_Master__c usr = [SELECT Id, Name, Email__c
                              FROM User_Master__c
                              WHERE Name = 'Yokesh'];
        
        Expense__c monthlyRent = new Expense__c();
        
        DateTime thisDay = System.Now();
        
        monthlyRent.Amount__c = 12000.00;
        monthlyRent.Bank_Name__c = 'HDFC Bank';
        monthlyRent.Category__c = 'Rent';
        monthlyRent.Comments__c = 'Auto - triggered Mail, Record creation - Confirmed';
        monthlyRent.Expense_Date__c = System.Today();
        monthlyRent.Expense_on__c = 'Common';
        monthlyRent.Member__c =usr.Id;
        monthlyRent.Payment_Method__c = 'Card';
        monthlyRent.Name = 'Monthly Rent'+thisDay.format('MMMM d,  yyyy');
        Insert monthlyRent;
        system.debug('Monthly rent record '+monthlyRent);
        SendEmail.sendRentEmailReminder(usr.Id);
    }
}