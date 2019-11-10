public class Calculations {
    @AuraEnabled
    Public static void Tally(){
        List<Expense__c> Exps = [SELECT Id, Member__c, Category__c, Amount__c, Payment_Method__c, Expense_on__c, Comments__c, Shared_with__c, Bank_Name__c, Wallet_Name__c, Name, Expense_Date__c FROM Expense__c where Expense_on__c = 'Common'];
        List<User_Master__c> users = [SELECT Id, Name, Total_Expence__c, Total_Amount_Shared__c, Total_Amount_Spent__c, 
                                      To_Get__c, To_Pay__c, Paid__c, Received__c, Email__c
                                      FROM User_Master__c
                                     ];
        Map<Id,List<Expense__c>> userExp = new Map<Id,List<Expense__c>>();
        for(Expense__c exp : Exps){
            Id user = exp.Member__c;
            
            if(!userExp.containsKey(user)){
                userExp.put(user, new List<Expense__c>());
                userExp.get(user).add(exp);
            }else{
                userExp.get(user).add(exp);
            }
        }
        System.debug(' Map of Tasks : '+userExp);
        
        Map<Id,Decimal> individualExpense = new Map<Id,Decimal>();
        
        Decimal wholeExpTotal =0;
        
        for(User_Master__c usr : users){
            if(userExp.containsKey(usr.Id)){
                system.debug('Count of Expenses for '+usr.Name+' : '+userExp.get(usr.Id).size());   
                List<Expense__c> expenses = userExp.get(usr.Id); 
                Decimal  Total = 0;
                for(Integer i =0 ;i<expenses.size();i++){
                    Total = Total + expenses[i].Amount__c; 
                }
                individualExpense.put(usr.Id,Total);
                system.debug('Total Expense Amount: '+Total);
                wholeExpTotal = wholeExpTotal+ Total;
            }
            
        }
        
        for(User_Master__c talUser : users){
            System.debug(' wholeExpTotal '+ wholeExpTotal +' Average '+ (wholeExpTotal/3) +' - '+ individualExpense.get(talUser.Id)+ ' - ' + talUser.Paid__c +' + '+ talUser.Received__c+ ' - '+ talUser.To_Pay__c + ' + '+talUser.To_Get__c);
            Decimal talSum = (((wholeExpTotal/users.size()) - individualExpense.get(talUser.Id) - talUser.Paid__c) + talUser.Received__c )+ talUser.To_Get__c -talUser.To_Pay__c;
			System.debug('Loss Calculation for '+talUser.Name +' - talSum : Rs.'+talSum);
            if(talSum <= 1 && talSum >= -1){
            	System.debug(talUser.Name+' account has been \"Tallied\"');    
            }else{
                System.debug(talUser.Name+' account has been been \"Failed\" !!!');    
            }       
        }
    }
    Public static void sendEmail(Id user){
        User_Master__c taskUser = [SELECT Name, Email__c, Office_Mail__c, createdById
                                  FROM User_Master__c
                                  WHERE Id =: user];
        
        try{
            List<Messaging.SingleEmailMessage> mails =new List<Messaging.SingleEmailMessage>(); 
            
            EmailTemplate guardRailApproved = [SELECT Id, Name, Body, HtmlValue 
                                               FROM EmailTemplate where developerName = 'Open_Tasks'];
            //system.debug('templateId'+templateId);
            //system.debug('Body of Email'+guardRailApproved.Body);
            //system.debug('HTML Value of Email'+guardRailApproved.HtmlValue);
            Messaging.SingleEmailMessage sendPreApprMail = new Messaging.SingleEmailMessage();
            String[] sendingTo = new String[]{};
            String[] sendingCc = new String[]{};    
            sendingTo.add(taskUser.Email__c);
            sendingTo.add(taskUser.Office_Mail__c);
            system.debug('sender email id'+sendingTo);
            sendPreApprMail.setToAddresses(sendingTo);
            sendPreApprMail.setTemplateId(guardRailApproved.Id);
            //sendPreApprMail.setOrgWideEmailAddressId(taskUser.Office_Mail__c); 
            sendPreApprMail.setSaveAsActivity(false);
            sendPreApprMail.setTargetObjectId(taskUser.createdById);
            sendPreApprMail.setWhatId(taskUser.Id);
            mails.add(sendPreApprMail);
            Messaging.sendEmail(mails);
        
        }catch(exception ex){
            system.debug('Mail Failed with Message : '+ex.getMessage()); 
        }
    }

}