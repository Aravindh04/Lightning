@isTest
public class TestVerifyDate {
    @isTest static void dateTest(){
        Date retDat = VerifyDate.CheckDates(System.today(), System.today() + 20);
        system.assertEquals(System.today() + 20, retDat, 'Doesnt return the actual date');
    }
    
    
    @isTest static void dateTest2(){
        Date retDat = VerifyDate.CheckDates(System.today(), System.today() - 20);
        system.assertEquals(System.today() + 25, retDat, 'Doesnt return the actual date');
    }
}