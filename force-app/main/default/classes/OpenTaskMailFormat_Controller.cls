public class OpenTaskMailFormat_Controller {
    
    public Id uID {get;set;}
    public List<Task__c> tasks {
        get{
            tasks = [SELECT  Id, Name, Category__c, Deadline__c, Re_assign_to__c, Assigned_User__c, Status__c, Type__c, Additional_Comments__c
                     FROM Task__c
                     WHERE (Assigned_User__c =: uID OR Re_assign_to__c =: uID ) AND Status__c != 'Completed'];
            return tasks;
        }set;
    }
    Public User_Master__c usr {
        get{
            usr = [SELECT Id, Name, Email__c, Office_Mail__c
                   FROM User_Master__c
                   WHERE Id =:  uID];
            return usr;
        }set;
    }
}