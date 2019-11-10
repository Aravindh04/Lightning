public without sharing class TestClass_Sample {
    Public static List<Opportunity> oppList;
    public void TestClass_Sample(/*Parameters*/){
        oppList= [select id from Opportunity limit 200];
    }
    
    public static void getOppDetails(){
        for(Opportunity op : oppList){
            
        }
    }
    public void method2(){
        system.debug('Inside method 2');
        oppList.size();
    }
    public void method3(){
        
    }
    public void method4(){
        
    }
    
    public static void sample4(){
        
    }
}