trigger contactRelAccountOps on Contact (after insert, after delete, after update) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        contactRelAccountController.getAccList(Trigger.new);
    }
    If(Trigger.isAfter && Trigger.isDelete){
        contactRelAccountController.getAccList(Trigger.old);
    }
    
    If(Trigger.isUpdate && Trigger.isAfter){
        set<Id> accId = new Set<Id> ();
        //Trigger.new - > 1 contact
        for(Contact newCon : Trigger.new){
            
            /*Map<Id,Contact> mOldCon = new Map<Id,Contact>();
            mOldCon = Trigger.oldMap;
            
            Contact oldCon = new Contact();
            oldCon = mOldCon.get(newCon.Id);*/
            
            if(newCon.AccountId != Trigger.oldMap.get(newCon.Id).AccountId){
                If(newCon.AccountId != null){
                    accId.add(newCon.AccountId);
                }
            }
        }
        
        List<Account> newAccToUpdate = new List<Account>();
        
        if(!accId.isEmpty()){
            for(Account newAc : [select Id, Count__c,(select Id from Contacts) from Account where Id IN: accId]){
                //Account ac = new Account(Id =newAc.Id, Count__c = newAc.Contacts.size());
                /*ac.Id = newAc.Id;
                ac.Count__c = newAc.Contacts.size();*/
                newAccToUpdate.add(new Account(Id =newAc.Id, Count__c = newAc.Contacts.size()));
            }
        }
        
        If(!newAccToUpdate.isEmpty()){
        	Update newAccToUpdate;    
        }
    }
    
    if(Trigger.isInsert && Trigger.isBefore){
        for(Contact con : Trigger.new){
            User u = [SELECT Id, Name from User where Name = 'Aravindh' LIMIT 1];
            CON.OwnerId = u.Id;
        }
    }
    
    if(Trigger.isInsert && Trigger.isBefore){
        
    }
    
    if(Trigger.isInsert && Trigger.isBefore){
        
    }
    
    
    
}