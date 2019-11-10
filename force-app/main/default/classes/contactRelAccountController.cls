public class contactRelAccountController {
    
    public static List<Account> accountUpdateOnContactChange(List<Contact> conList){
        
        Set<Id> accId = new Set<Id>();
        List<Account> accLst2Update = new List<Account>();
        if(!conList.isEmpty() && conList.size() > 0){
            for(Contact c : conList){
                if(c.AccountId != null){
                    accId.add(c.AccountId);
                }
            }
            if(!accId.isEmpty()){
                for(Account ac : [Select Id, Name, Count__c, (select Id from Contacts) from Account where Id IN: accId]){
                    Account acIn = new Account(Id = ac.Id, count__c = ac.contacts.size());
                    //acIn.Id = ac.Id;
                    //acIn.count = ac.contacts.size();
                    accLst2Update.add(acIn);
                    
                }
            }
        }
        Return accLst2Update;
    }
    
    public static void getAccList(List<Contact> conList){
        list<Account> accList = accountUpdateOnContactChange(conList);
        if(!accList.isEmpty() && accList.size()>0){
            try{
                update accList;
            }catch(Exception ex){
                system.debug('Failed with Exception - type : '+ex.getTypeName()+'\tMessage : '+ex.getMessage());
            }
        }
        
    }
    

}