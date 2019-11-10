public class conTriggerController {
    
    public static void updateAccList(Set<Id> acc_Id_Set){
        //List of Accounts to update the Count
        List<Account> accList_To_Update = new List<Account>();
        
        //Check Set<Account Id > is not Empty
        if (!acc_Id_Set.isempty())
        {
            //iterating through the account records obtained from the set
            for (Account each_account : [select id, count__c, (select id from contacts) from account where id in: acc_Id_Set])
            {
                //Creating a new Account instance to add to the list of Account to update
                Account new_Acc_Instance = new Account(Id =each_account.id, count__c = each_account.contacts.size());
                accList_To_Update.add(new_Acc_Instance);   
            }
        }
        
        //Checking whether the list of accounts to update is not empty
        if (!accList_To_Update.isempty())
        {
            SavePoint sp = Database.setSavepoint();
            try{
                //DML update on Account
                update accList_To_Update;
            }catch(Exception e){
                Database.rollback(sp);
            }
        }
        
    }
    
    Public static Set<Id> accountIds(List<Contact> conList){
        //Set Of Account Id's to be Populated to return
        Set<Id> acc_Id_to_Update = new Set<Id>();
        
        System.debug('accountIds() conList :\t'+conList );
        
        if(!conList.isEmpty()){
            for(Contact conItem : conList)
            {
                System.debug('conItem on conList '+conItem.AccountId+'\tItems'+conItem);
                if (conItem.AccountId !=Null)
                {
                    acc_Id_to_Update.add(conItem.AccountId);
                }
            }
            
            for(integer i=0; i< conList.size(); i++){
                System.debug('In '+i+'th Position the contact value is - '+conList[i]);
            }
        }
        system.debug('set<Id> acc_Id_to_Update '+acc_Id_to_Update);
        return acc_Id_to_Update;
        
    }

}