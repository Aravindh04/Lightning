public class Sharing_Details {
   @auraEnabled
    public static List<Expense__c> getExp(){
        List<Expense__c> exp =  [SELECT Name, Member__c, Expense_on__c, Expense_Date__c, Category__c, Amount__c
                                FROM Expense__c
                                ];
        return exp;
    }
    
    @auraEnabled
    public static List<Expense__c> getExp1(){
        Date dat= Date.today();
        Integer mon = dat.month();
        List<Expense__c> exp =  [SELECT Name, Member__c, Expense_on__c, Expense_Date__c, Category__c, Amount__c
                                FROM Expense__c
                                WHERE CALENDAR_MONTH(Expense_Date__c) =: mon
                                ];
        return exp;
    }
     @auraEnabled
    public static Share__c getShare(){
        Date dat= Date.today();
        Integer mon = dat.month();
        Share__c Shar =     [SELECT Id,Name, Total_Expense__c, Monthly_Expence__c
                                FROM Share__c
                                WHERE CALENDAR_MONTH(createdDate) =: mon LIMIT 1
                                ];
        return Shar;
    }
    
    @auraEnabled
    public static List<User_Master__c> getUserMaster(){
        List<User_Master__c> usr =  [SELECT Id, Name, Total_Expence__c, Total_Amount_Shared__c, Total_Amount_Spent__c, To_Get__c, To_Pay__c, Email__c
                                    FROM User_Master__c
                                    ];
        return usr;
    }
    
    @AuraEnabled
    public static List<String> CatogeryValues(String fieldName, sObject objectName){
        system.debug('FildName :'+fieldName+ '\nobjectName :'+objectName);
        Schema.sObjectType objectType = objectName.getSObjectType();
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        System.debug('sObject Type :'+objectType+'\nDescribe : '+objectDescribe);
        Map<String,Schema.SObjectField> fieldMap = objectDescribe.fields.getMap();
        
        List<String> options = new List<String>();
        List<Schema.PicklistEntry> values = fieldMap.get(fieldName).getDescribe().getPickListValues();
        System.debug('Picklist values SChema.entry :'+values+'\nFieldmap of Object Describe : '+fieldMap);
        for(Schema.PicklistEntry opts: values){
            options.add(opts.getValue());
        }
        system.debug('Options : '+options);
        return options;
    }
    
    @AuraEnabled
    public static String SaveExpense(Expense__c Exp, String usr){
        String responses;
        
        DateTime dat = System.now();
        
        User_Master__c expUsr = [SELECT Id from User_Master__c WHERE Name =: usr];
        Exp.Member__c = expUsr.Id;
            
        if(Exp.Name == null){
        	Exp.Name = Exp.Category__c + ' Expense - '+dat.format('MMMM d, YYYY HH:mm');    
        }
        Date  ExpDate = Date.valueOf(Exp.Expense_Date__c);
        if(ExpDate != null){
            Exp.Expense_Date__c = ExpDate;
        }else{
            Exp.Expense_Date__c = System.today();
        }
        try{
            insert Exp;
            system.debug('Successfull : Expense - '+Exp);    
            responses = 'Success';
        }catch(Exception ex){
            responses = ex.getMessage();
        }
        return responses;
    }
}