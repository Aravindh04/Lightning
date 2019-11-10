public class Generic_ServerSide_Controller {
    @AuraEnabled
    public static String sendEmailWithBody(List<String> toAddress, String mailSubject, String mailBody){
        string response;
        try{
            Messaging.SingleEmailMessage seMail = new Messaging.SingleEmailMessage();
            
            seMail.setToAddresses(toAddress);
            seMail.emailPriority = 'High';
            
            seMail.setSubject(mailSubject);
            seMail.setPlainTextBody(mailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {seMail});
            response = 'SUCCESS';
        }catch(Exception ex){
            response = ex.getMessage();
            system.debug('Exception Message : '+response);
            
        }
        return response;
    }

}