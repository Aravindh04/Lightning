public class duesUpdates {
    public static void updatePersonalProfile(Loan_and_Dues__c dues){
        Personal_User_Profile__c usr = [Select Id, Name, To_Pay__c, To_Get__c
                                        FROM Personal_User_Profile__c
                                        WHERE Master__c =: dues.Person_Name__c];
        if(dues.Status__c == 'Pending'){
            if(dues.Due_type__c=='Owe to'){
                usr.To_Pay__c = usr.To_Pay__c + dues.Amount__c;
            }
            else if(dues.Due_type__c =='Pending with'){
                usr.To_Get__c = usr.To_Get__c + dues.Amount__c;
            }
        }
        else if(dues.Status__c == 'Paid'){
            if(dues.Due_type__c=='Owe to'){
                usr.To_Pay__c = usr.To_Pay__c - dues.Amount__c;
            }
            else if(dues.Due_type__c =='Pending with'){
                usr.To_Get__c = usr.To_Get__c - dues.Amount__c;
            }
            
            dues.Settled_date__c = DateTime.now();
        }
        update usr;
    }
}