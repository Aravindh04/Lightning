public class SendEmail {
    public static PageReference sendingEmail(Payment__c pEmail){
        String uId1= pEmail.Wallet_From__c;
        String uId2= pEmail.Pay_to__c;
        User_Master__c otherUser =[SELECT Id, Name, Email__c
                                   FROM User_Master__c 
                                   WHERE ID !=: uId1 AND Name !=: uId2 LIMIT 1
                                  ];
        User_Master__c wFrom =[SELECT Id, Name, Email__c
                                   FROM User_Master__c 
                                   WHERE ID =: uId1 LIMIT 1
                                  ];
        User_Master__c pTo =[SELECT Id, Name, Email__c
                                   FROM User_Master__c 
                                   WHERE ID =: uId2 LIMIT 1
                                  ];
        Messaging.SingleEmailMessage seMail = new Messaging.SingleEmailMessage();
        Date Today = System.today();
        String toAddress=pEmail.Pay_to__r.Email__c;
        String ccAddress=otherUser.Email__c;	
        String bccAddress=pEmail.Wallet_From__r.Email__c;
        
        String[] sendingTo = new String[]{pTo.Email__c};
        
        if(pEmail.Pay_to__r.Name == 'Aravindh'){
            sendingTo.add('aravindhv04@gmail.com');    
        }
        
        if(pEmail.Pay_to__r.Name == 'Yokesh'){
            sendingTo.add('yokeshmohan1095@gmail.com');    
            sendingTo.add('aravindhv04@gmail.com'); 
        }
        
        if(pEmail.Pay_to__r.Name == 'Tejas'){
            sendingTo.add('tjtejo@gmail.com');
            sendingTo.add('aravindhv04@gmail.com'); 
        }
        
        String[] sendingTocAdd = new String[]{wFrom.Email__c};
            
        if(pEmail.Wallet_From__r.Name == 'Aravindh'){
            sendingTocAdd.add('aravindhv04@gmail.com');    
        }
        
        if(pEmail.Wallet_From__r.Name == 'Yokesh'){
            sendingTocAdd.add('yokeshmohan1095@gmail.com');    
            sendingTocAdd.add('aravindhv04@gmail.com'); 
        }
        
        if(pEmail.Wallet_From__r.Name == 'Tejas'){
            sendingTocAdd.add('tjtejo@gmail.com');
            sendingTocAdd.add('aravindhv04@gmail.com'); 
        }
        
        String[] sendingToBccAdd = new String[]{otherUser.Email__c};
		
		if(otherUser.Name == 'Aravindh'){
            sendingToBccAdd.add('aravindhv04@gmail.com');    
        }
        
        if(otherUser.Name == 'Yokesh'){
            sendingToBccAdd.add('yokeshmohan1095@gmail.com');    
            sendingToBccAdd.add('aravindhv04@gmail.com'); 
        }
        
        if(otherUser.Name == 'Tejas'){
            sendingToBccAdd.add('tjtejo@gmail.com');
            sendingToBccAdd.add('aravindhv04@gmail.com'); 
        }           
        seMail.setToAddresses(sendingTo);
        seMail.setCcAddresses(sendingTocAdd);
        seMail.emailPriority = 'High';
        
        seMail.setSubject('Monthly Expense - Cash Received ');
        seMail.setPlainTextBody('Hello '+pTo.Name+'!\n \t You have received Rs.'+pEmail.Amount__c+' from '+wFrom.Name+'. Please verify your \'ToGet\' amount feild and Approve once you have received the Amount'+'\n\n Sender Comments: '+pEmail.Comments__c+'\n\nAmount\t\t\t:\t'+pEmail.Amount__c+'\nPayment method:\t'+pEmail.Payment_Method__c+'\nSent date\t\t:\t'+Today+'\n\n\nRegards,\nSalesforce Developer\n'+wFrom.Name+'\n'+wFrom.Email__c+'To login:\t https://login.salesforce.com or https://aravindhapps-dev-ed.lightning.force.com');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {seMail});
        return null;
    }
    
    public static PageReference sendEmailOnExpenceCreation(Expense__c exp){
        //Spending User
        String uId1= exp.Member__c;
        
        List<User_Master__c> otherUser =[SELECT Id, Name, Email__c
                                   FROM User_Master__c 
                                   WHERE ID !=: uId1 LIMIT 2
                                  ];
        User_Master__c expUser =[SELECT Id, Name, Email__c
                                   FROM User_Master__c 
                                   WHERE ID =: uId1 LIMIT 1
                                  ];
        
        Messaging.SingleEmailMessage seMail = new Messaging.SingleEmailMessage();
        
        Date Today = System.today();
        decimal share = (exp.Amount__c/3).setScale(2);
        decimal toReceive = (exp.Amount__c-share).setScale(2);
        String[] sendingTo = new String[]{expUser.Email__c};
        String[] sendingTocAdd = new String[]{otherUser[0].Email__c,otherUser[1].Email__c};
        
		
		seMail.setToAddresses(sendingTo);
        seMail.setCcAddresses(sendingTocAdd);
        seMail.emailPriority = 'High';
        
        seMail.setSubject('New Expense for '+expUser.Name);
        seMail.setPlainTextBody('Hello '+expUser.Name+'!\n \t You have added an Expense \''+exp.Name+'\' of Rs.'+exp.Amount__c+'\nYou need to receive Rs.'+toReceive+' from '+otherUser[0].Name+' and '+otherUser[1].Name+'.\n\nDetails\n=======\n'+'Spent On\t\t:\t'+exp.Category__c+'\nExpence Date\t  :\t'+Today+'\nSharing type\t  :\t'+exp.Expense_on__c+'\nPayment method\t  :\t'+exp.Payment_Method__c+'\n\nSharing Details\n---------------------\n\t'+expUser.Name+'		:\t'+Share+'\n\t'+otherUser[0].Name+'		:\t'+share+'\n\t'+otherUser[1].Name+'		\t:\t'+Share+'\n\n----------------\n Sender Comments: '+exp.Comments__c+'\n--------------------\n\n\nRegards,\nSalesforce Developer\n'+expUser.Name+'\n'+expUser.Email__c+'\n\n\nTo login:\t https://login.salesforce.com or https://aravindhapps-dev-ed.lightning.force.com');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {seMail});
        return null;
    }
    public static PageReference sendEmailOnExpenceDeletion(Expense__c exp){
        String uId1= exp.Member__c;
        
        List<User_Master__c> otherUser =[SELECT Id, Name, Email__c
                                         FROM User_Master__c 
                                         WHERE ID !=: uId1 LIMIT 2];
        User_Master__c expUser =[SELECT Id, Name, Email__c
                                 FROM User_Master__c 
                                 WHERE ID =: uId1 LIMIT 1];
        
        Messaging.SingleEmailMessage seMail = new Messaging.SingleEmailMessage();
        
        Date Today = System.today();
        decimal share = (exp.Amount__c/3).setScale(2);
        decimal toReceive = (exp.Amount__c-share).setScale(2);
        String[] sendingTo = new String[]{expUser.Email__c};
        String[] sendingTocAdd = new String[]{otherUser[0].Email__c,otherUser[1].Email__c};
        
		
		seMail.setToAddresses(sendingTo);
        seMail.setCcAddresses(sendingTocAdd);
        seMail.emailPriority = 'High';
        
        seMail.setSubject('Expense Deletion for '+expUser.Name);
        seMail.setPlainTextBody('Hello '+expUser.Name+'!\n \tYour expense of \''+exp.Name+'\' on '+ exp.Category__c+' of Rs.'+exp.Amount__c+' has been deleted successfully. Cash changes will be reverted back. Please Verify.\n\nRegards,\nSalesforce'+'\n\n\nTo login:\t https://login.salesforce.com or https://aravindhapps-dev-ed.lightning.force.com');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {seMail});
        
        return null;
    }
    
    public static PageReference sendEmailOnSharesRefresh(){
        List<User_Master__c> allUsers =[SELECT Id, Name, Email__c, Office_Mail__c
                                        FROM User_Master__c LIMIT 3
                                       ];
        Date Today = System.today();
        
        Messaging.SingleEmailMessage seMail = new Messaging.SingleEmailMessage();
        
        String[] sendingTo = new String[]{};
            
        for(User_Master__c usr: allUsers){
        	sendingTo.add(usr.Email__c);
            sendingTo.add(usr.Office_Mail__c);
        }
        seMail.setToAddresses(sendingTo);
        seMail.emailPriority = 'High';
        seMail.setSubject('Monthly Shares Refresh');
        seMail.setPlainTextBody('Hello All!,\n\tYour shares for this month has been refreshed and created Today ie.'+Today+' a new share record. Please Verify!\n\nRegards,\nSalesforce\n\n\nTo login:\t https://login.salesforce.com or https://aravindhapps-dev-ed.lightning.force.com');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {seMail});

        return null;
    }
    public static PageReference sendACleaningReminder(){
        //Spending User
        List<User_Master__c> allUser =[SELECT Id, Name, Email__c
                                       FROM User_Master__c 
                                      ];
        
        
        Messaging.SingleEmailMessage seMail = new Messaging.SingleEmailMessage();
        
        
        String[] sendingTo = new String[]{allUser[0].Email__c,allUser[1].Email__c,allUser[2].Email__c};
        String[] sendingTocAdd = new String[]{'furiousflamesaravindh@gmail.com'};
        
		
		seMail.setToAddresses(sendingTo);
        seMail.setCcAddresses(sendingTocAdd);
        seMail.emailPriority = 'High';
        
        seMail.setSubject('Weekly Cleaning Reminder!!!');
        seMail.setPlainTextBody('Hello All, \n\t Gentle Reminder to clean Toilet and Mob the floor. Please Update completed If you have already done \n\nRegards, BGP Residence \nbgpresidence@home.com\n\n\nTo login:\t https://login.salesforce.com or https://aravindhapps-dev-ed.lightning.force.com');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {seMail});
        return null;
    }
    
    //Rent - Send Email reminder
    public static PageReference sendRentEmailReminder(Id userId){
        List<User_Master__c> allUser =[SELECT Id, Name, Email__c
                                       FROM User_Master__c
                                       WHERE Id !=: userId	];
        Messaging.SingleEmailMessage seMail = new Messaging.SingleEmailMessage();
        
        
        String[] sendingTo = new String[]{allUser[0].Email__c,allUser[1].Email__c};
        String[] sendingTocAdd = new String[]{'furiousflamesaravindh@gmail.com'};
        
		
		seMail.setToAddresses(sendingTo);
        seMail.setCcAddresses(sendingTocAdd);
        seMail.emailPriority = 'High';
        seMail.setSubject('Rent Reminder!!!');
        seMail.setPlainTextBody('Hello Aravindh and Tejas, \n\t Gentle Reminder to send the \'Rent\' amount or remaining Amount of User Master to Yokesh without fail. Please Ignore if it had been done already.\n\nRegards, BGP Residence \nbgpresidence@home.com\n\n\nTo login:\t https://login.salesforce.com or https://aravindhapps-dev-ed.lightning.force.com');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {seMail});
        return null;
    }
    
    //Loan and Dues Reminder Mail
    public static PageReference DueAmountReminder(Id loanId){
        User_Master__c userAravindh =[SELECT Id, Name, Email__c
                                      FROM User_Master__c
                                      WHERE Name = 'Aravindh'
                                     ];
        Loan_and_Dues__c loan = [SELECT Id, Person_Name__c, Due_type__c, Amount__c, Paid_date__c, Due_Date__c, Status__c, Comments__c, Secondary_User__c, Settled_date__c 
                                 FROM Loan_and_Dues__c
                                 WHERE Id =: loanId];
        
        
        Messaging.SingleEmailMessage seMail = new Messaging.SingleEmailMessage();
        
        
        String[] sendingTo = new String[]{userAravindh.Email__c};
        seMail.setToAddresses(sendingTo);
        String dueString;
        String paidDate = loan.Paid_date__c.format();
        if(loan.Due_type__c == 'Owe to' ){
            dueString = ' which is \'Pending\' with ';
        	seMail.setSubject('Loan and Dues! Pending Amount with your Friend '+ loan.Secondary_User__c);   
        }else if(loan.Due_type__c == 'Pending with' ){
            dueString = ' which you \'Owe\' to ';
            seMail.setSubject('Loan and Dues! Need to Pay your Friend '+loan.Secondary_User__c );  
        }
        seMail.emailPriority = 'High';
        seMail.setPlainTextBody('Hi '+userAravindh.Name+', \n\t Gentle Reminder to process the Due amount of Rs.'+loan.Amount__c+dueString+loan.Secondary_User__c+'. Transaction date '+paidDate+'.'+'\n\nRegards, \nSalesforce\n\n\nTo login:\t https://login.salesforce.com or https://aravindhapps-dev-ed.lightning.force.com\n\n Go to Record: https://aravindhapps-dev-ed.lightning.force.com/one/one.app#/sObject/'+loan.Id+'/view');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {seMail});
        return null;
    }
    
}