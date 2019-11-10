trigger AccountUpdateTrigger on Account (before insert,after insert, after update) {
    //Before
    //After
    //
    //Update
    //Insert
    //Delete
    //Undelete
    
    
    //Before Insert
    //Before Update
    //Before Delete
    //
    
    
    //Context variables
    //Boolean
    //Trigger.isBefore()
    //Trigger.isAfter()
    //Trigger.isInsert()
    //Trigger.isUpdate()
    //Trigger.isDelete()
    //Trigger.isUndelete()
    //Trigger.isExecuting()
    //
    //Collection
    //Trigger.New
    //Trigger.Old
    //Trigger.NewMapC
    //Trigger.oldMap
    
    //Trigger.size
    /*<Id, Account>
                get()
                Put()
                keySet()
                values()
                containsKey()*/
    //
    //
    //
    
    system.debug('Trigger.New '+Trigger.New[0].Name);
    if(Trigger.isAfter && Trigger.isInsert){
        for(Account ac : Trigger.New){
            /*Contact cc= new Contact();
            cc.lastName = 'Aravind';
            cc.firstName = 'Rahul';
            cc.AccountId = ac.Id;
            insert cc;*/
        }
        
    }
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            for(Account ac : Trigger.new){
                if(ac.Type == 'Prospect')
                    ac.Industry = 'Apparel';
            }
        }
        if(Trigger.isUpdate){
            for(Account ac : Trigger.new){
                if(ac.Type == 'Other')
                    ac.Industry = 'Banking';
            }
        }
    }
    
    
    if(Trigger.isUpdate && Trigger.isAfter){
        /*Map<Id,Account> mAccout = new Map<Id,account>();
        mAccout = Trigger.oldMap;
        Account acc = mAccout.get('0017F00001WODdS');*/
        List<Contact> lstCon = new List<Contact>();
        //To get keyset of Accout Id's for whose descrition is changed and for which the contacts needs update
        Set<Id> AccId = new Set<Id>();
        //Iterate to identify the change
        for(Account ac : Trigger.New){
            Account oldAcc = Trigger.oldMap.get(ac.Id);
            //Compare the old description and new Description
            if(oldAcc.Description != ac.Description){
                //Adding to the set to uniquely take the Account Id set
                AccId.add(ac.Id);
            }
        }
        
        //new instance of map to store the List of Account with related contacts
        Map<Id, Account> newMapAcc = new Map<Id,Account>();
        
        //The Trigger.NewMap is not used since it does not contain any related contacts
        
        //Fetching the list of account using Keyset and Populatin the Map values
        for(Account ac : [select Id,Description, (select Id, Description from contacts) from Account where Id IN: AccId]){
            //Adding to the new map with related contacts
            newMapAcc.put(ac.Id,ac);
        }
        
        //instance for adding the contact list to update
        List<Contact> conListToUpdate = new List<Contact>();
        
        //iterating the map keyset
        for(Id aId : newMapAcc.keySet() ){
            Account newAccIns = newMapAcc.get(aId);
            
            //Iterating the related contacts for each account in Map and Updating with the description field of the Account
            for(Contact conAcc : newAccIns.contacts){
                conAcc.Description = newAccIns.Description;
                conListToUpdate.add(conAcc);
            }
        }
        
        //DML Update on the populated contact list
        update conListToUpdate;
    }
 
}