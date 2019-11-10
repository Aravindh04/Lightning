@isTest
public class DoingFizzBuzz_Test {
    
    static testMethod void FizzBuzzTest(){
        for(Integer i=0; i<100; i++){
            String retVal = DoingFizzBuzz.FizzBuzz(i);
            
            if(Math.mod(i, 3) == 0 && Math.mod(i, 5) != 0){
                System.assertEquals('fizz', retVal);
            }
            
            if(Math.mod(i, 5) == 0 && Math.mod(i, 3) != 0){
                System.assertEquals('buzz', retVal);
            }
            
            if(Math.mod(i, 3) == 0 && Math.mod(i, 5) == 0){
                System.assertEquals('fizzbuzz', retVal);
            }
            
            if(Math.mod(i, 3) != 0 && Math.mod(i, 5) != 0){
                System.assertEquals(String.valueOf(i), retVal);
            }
        }
    }
}