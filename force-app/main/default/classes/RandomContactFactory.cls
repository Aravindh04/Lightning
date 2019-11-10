public class RandomContactFactory {
    
    public static List<Contact> generateRandomContacts(Integer num, String lstName){
        List<Contact> conList = new List<Contact>();
        for(Integer i=0;i<num;i++){
            conList.add(new Contact(FirstName = 'Test'+i, LastName = lstName));
        }
        return conList;
    }

}