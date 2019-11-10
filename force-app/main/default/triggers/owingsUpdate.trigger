trigger owingsUpdate on Loan_and_Dues__c (before insert, before update, before delete) {
    if(Trigger.isInsert && Trigger.isBefore){
        for(Loan_and_Dues__c due: Trigger.New){
            due.Status__c = 'Pending';
            duesUpdates.updatePersonalProfile(due);
        }
        
    }
    if(Trigger.isUpdate && Trigger.isBefore){
        for(Loan_and_Dues__c due: Trigger.New){
            duesUpdates.updatePersonalProfile(due);
        }
        
    }
    if(Trigger.isDelete && Trigger.isBefore){
        for(Loan_and_Dues__c dues: Trigger.old){
            Personal_User_Profile__c usr = [Select Id, Name, To_Pay__c, To_Get__c
                                            FROM Personal_User_Profile__c
                                            WHERE Master__c =: dues.Person_Name__c];
            if(dues.Status__c == 'Pending'){
                if(dues.Due_type__c=='Owe to'){
                    usr.To_Pay__c = usr.To_Pay__c - dues.Amount__c;
                }
                else if(dues.Due_type__c =='Pending with'){
                    usr.To_Get__c = usr.To_Get__c - dues.Amount__c;
                }
            }
            else if(dues.Status__c == 'Paid'){
                if(dues.Due_type__c=='Owe to'){
                    usr.To_Pay__c = usr.To_Pay__c + dues.Amount__c;
                }
                else if(dues.Due_type__c =='Pending with'){
                    usr.To_Get__c = usr.To_Get__c + dues.Amount__c;
                }
            }
            update usr;
        }
    }
    
}