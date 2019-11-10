public class AccountProcessor {
    @future
    Public static void countContacts(List<Id> accIds){
        List<Account> accList = [Select Id, Name, (Select Id from Contacts)  from Account WHERE Id in: accIds ];
        List<Account> accsToUpdate = new List<Account>();
        system.debug('accList '+accList.size()+' \nlist '+accList);
        for(Account ac: accList){
            if(!ac.Contacts.isEmpty() && accList.size()>0){
                Decimal conSize = ac.Contacts.size();
                Id acId = ac.Id;
                ac = new Account();
                ac.Id = acId;
                ac.Number_of_Contacts__c = conSize;
                accsToUpdate.add(ac);
            }
        }
        if(!accsToUpdate.isEmpty())
        Database.Update(accList);
    }

}