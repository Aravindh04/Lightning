trigger NumberofRelatedContacts on Contact (before insert, after insert, after update, after delete, after undelete) {
    
    
    if(trigger.isafter && trigger.isupdate)
    {
        set<id> updtaccid = new set<id>();
        for (Contact con: trigger.new)
        {
            id oldaccid = trigger.oldmap.get(con.id).accountid;
            id newaccid = con.accountid;
            if(newaccid!= oldaccid)
            {
                if ( newaccid!= null)
                {
                    updtaccid.add(newaccid);   
                }
                if (oldaccid != null) 
                {
                    updtaccid.add(oldaccid);
                }
            }
        }
        conTriggerController.updateAccList(updtaccid);
        
    }
    
    if (trigger.isafter && (trigger.isundelete || Trigger.isinsert || Trigger.isDelete))
    {
        List<Contact> con_items = new List<Contact>();
        if(Trigger.isDelete){
            con_items = Trigger.old;
        }else{
            con_items = Trigger.New;
        }
        Set<Id> acc_Id_to_Update = conTriggerController.accountIds(con_items);
        //conTriggerController classConTri = new conTriggerController();
        //Set<Id> acc_Id_to_Update = classConTri.accountIds(con_items);
        conTriggerController.updateAccList(acc_Id_to_Update);
    }
    
    //Whenever insert a contact with same name for the Account, Throw error
    //
    //
    //
    
    if(Trigger.isInsert && Trigger.isBefore){
        
        Set<Id> acc_Id_to_Update = conTriggerController.accountIds(Trigger.new);
        Map<Id, List<Contact>> mAccCon = new Map<Id, List<Contact>>();
        if(acc_Id_to_Update != null && !acc_Id_to_Update.isEmpty()){
            for(Contact eachCon : [SELECT Id, FirstName, LastName, Name, AccountId FROM Contact WHERE AccountId IN: acc_Id_to_Update LIMIT 50000]){
                if(eachCon.AccountId != null){
                    if(!mAccCon.containsKey(eachCon.AccountId)){
                        mAccCon.put(eachCon.AccountId,new List<Contact>());
                    }
                    mAccCon.get(eachCon.AccountId).add(eachCon);
                }
            }
        }
        
        for(Contact eachCon : Trigger.New){
            if(mAccCon.containsKey(eachCon.AccountId)){
                for(Contact con : mAccCon.get(eachCon.AccountId)){
                    if(eachCon.FirstName == con.FirstName){
                        eachCon.addError('Contact already exists with the same name for this account');
                    }
                }
            }
        }
    }
    
   
    
    
}