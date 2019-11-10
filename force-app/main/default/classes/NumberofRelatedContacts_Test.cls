@isTest
public class NumberofRelatedContacts_Test {
    
    @isTest
    static void insertContact(){
        //Insert an Account record
        List<Account> acList = new List<Account>();
        
        acList.add(new Account(Name = 'Test Account'));
        acList.add(new Account(Name = 'Test account 2'));
        
        Insert acList;
        
        
        //Insert contact
        Contact con = new Contact();
        con.FirstName = 'Aravindh';
        con.LastName = 'SecondName';
        con.AccountId = acList[0].Id;
        
        
        
        Contact con2 = new Contact();
        con2.FirstName = 'Aravindh';
        con2.LastName = 'SecondName';
        con2.AccountId = acList[0].Id;
       
        Test.startTest();
        //Insert one contact
        System.assert(con.Id == null);
        Database.SaveResult results = Database.insert(con, true);
        System.assertEquals(true, results.isSuccess());
        System.debug('results :'+results);
        
        System.assert(con.Id != null);
        try{
            Database.SaveResult results2 = Database.insert(con2, true);
            system.assertEquals(results2.isSuccess(),false);
        }Catch(Exception ex){
            System.assert(con2.Id == null);
        }
        
        con.LastName = 'Rahul';
        con.AccountId = acList[1].Id;
        Update con;
        
        Delete con;
        
        Test.stopTest();
    }
    
    static testMethod void insertContact2(){
        
    }
    
}