@isTest(seeAllData = true)
public class TestRestrictContactByName {
    @isTest static void restricInvalidTest(){
        Contact con = new Contact();
        con.FirstName = 'Sample';
        con.LastName = 'INVALIDNAME';
        contact conUp = [SELECT Id, FirstName, LastName from Contact limit 1];
		conUp.LastName = 'INVALIDNAME';
		TEST.startTest();
        Database.SaveResult result = database.insert(con,false);
        Database.SaveResult result1 = database.update(conUp,false);
        TEST.stopTest();
        system.assert(!result.isSuccess());
        system.assert(result.getErrors().size() > 0);
        system.assertEquals('The Last Name "'+con.LastName+'" is not allowed for DML', result.getErrors()[0].getMessage());
        system.assert(!result1.isSuccess());
        system.assert(result1.getErrors().size() > 0);
        system.assertEquals('The Last Name "'+conUp.LastName+'" is not allowed for DML', result1.getErrors()[0].getMessage());
    }
}