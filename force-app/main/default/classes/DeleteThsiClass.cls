public class DeleteThsiClass {
    
    public static void updateAcc(){
        List<contact> conList = new List<Contact>();
        //conList = [select Id, AccountId from Contact where AccountId != null limit 5];
        contactRelAccountController.getAccList(conList);
    }

}