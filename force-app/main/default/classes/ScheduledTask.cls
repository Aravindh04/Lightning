public class ScheduledTask {
    public static void dailyRun(){
        
        //Todays date
        Date tday = Date.today();
        
        Integer thisMonth = System.Today().Month();
        
        //Getting Previous Month
        Integer previousMonth = System.Today().Month() - 1; //To get The previous month as Number
        
        
        
        
        //For January
        if(previousMonth == 0){
            previousMonth = 12;
        }
        
        //Current day of month
        Integer dayOfMnth = System.Today().day(); 	//returns day of the Month ie. 1 for 1st of month
        
        //Listing all users
        List<User_Master__c> users = [SELECT Id, Name, Total_Expence__c, Total_Amount_Shared__c, Total_Amount_Spent__c, To_Get__c, To_Pay__c, Email__c
                                      FROM User_Master__c
                                     ];
        //if(dayOfMnth == 1){
            List<Share__c> createdShare = new List<Share__c>();
            try{
                createdShare = [SELECT Id, Monthly_Expence__c, Total_Expense__c 
                                FROM share__c
                                WHERE CALENDAR_MONTH(createdDate) =: thisMonth AND CALENDAR_YEAR(createdDate) = 2019 LIMIT 1];
            }catch(Exception ex){
                system.debug('Null Pointer'+ex.getMessage());
            }
            if(createdShare.isEmpty()){
                TaskAndProgress.monthlyTask('Monthly');
                Share__c share= new Share__c();
                Share__c oldShare= [SELECT Id, Monthly_Expence__c, Total_Expense__c 
                                    FROM share__c
                                    WHERE CALENDAR_MONTH(createdDate) =: previousMonth ORDER BY createdDate desc LIMIT 1];
                
                for(User_Master__c usr: users){
                    usr.Total_Amount_Shared__c = 0;
                    usr.Total_Amount_Spent__c = 0;
                    System.debug(usr);
                    update usr;
                }
                Datetime myDatetime = Datetime.now();
                String ShareName = 'Shares - '+myDatetime.format('MMMM d,  yyyy');
                System.debug(ShareName);
                share.Name =ShareName;
                share.Monthly_Expence__c = 0;
                share.Total_Expense__c = oldShare.Total_Expense__c;
                system.debug(share);
                insert share;
                try{
                    SendEmail.sendEmailOnSharesRefresh();
                }catch(Exception ex){
                    system.debug(ex.getMessage());
                }
            }
        /*else*/ if(dayOfMnth == 15){
            TaskAndProgress.billPaymentTask(tday);
        }
        
        if('sun'=='moon'){
            Datetime dt = (DateTime)tday;
            String dayOfWeek = dt.format('EEEE');
            if(dayOfWeek == 'Thursday'){
                TaskAndProgress.createNewTask('Weekly');
                SendEmail.sendACleaningReminder();
            }
            else if(dayOfWeek == 'Friday'){
                SendEmail.sendACleaningReminder();
            }else if(dayOfWeek == 'Saturday'){
                SendEmail.sendACleaningReminder();
            }
            //For Scheduled Reminders about paying and Getting Dues
            String formatedToday = tday.format();
            List<Loan_and_Dues__c> loan = [SELECT Id, Person_Name__c, Due_type__c, Amount__c, Paid_date__c, Due_Date__c, Status__c, Comments__c, Secondary_User__c, Settled_date__c FROM Loan_and_Dues__c];
            for(Loan_and_Dues__c singleLoan : loan){
                String DueDate = singleLoan.Due_Date__c.format();
                if(formatedToday == DueDate){
                    system.debug('Today '+formatedToday+' Due Date '+DueDate);
                    //send email calling Method
                    try{
                        SendEmail.DueAmountReminder(singleLoan.Id);
                    }
                    catch(Exception ex){
                        system.debug(ex.getMessage());
                    }
                }
            }
        }
        
        /*List<Task__c> tsks = [SELECT Id, Name, Additional_Comments__c, Assigned_User__r.Name, Assigned_User__c, Category__c, Deadline__c,
                                 Re_assign_to__c, Re_assign_to__r.Name, Status__c, Type__c
                                 FROM Task__c
                                 WHERE Status__c!='Completed'];
            Map<String,List<Task__c>> userTask = new Map<String,List<Task__c>>();
            for(Task__c eachTask: tsks){
                String taskMember;
                if(eachTask.Assigned_User__c != null){
                    taskMember = eachTask.Assigned_User__r.Name;
                }else{
                    taskMember = eachTask.Re_assign_to__r.Name;        
                }
                if(userTask.containsKey(taskMember)){
                    userTask.get(taskMember).add(eachTask);
                }else{
                    userTask.put(taskMember,new List<Task__c>());
                    userTask.get(taskMember).add(eachTask);
                }
                system.debug('UserTask MAP '+userTask);
            }
            
            for(String eachUser : userTask.keySet()){
                List<Task__c> temp = userTask.get(eachUser);
                if(temp != null){
                    Calculations.sendEmail(eachUser);
                }
                system.debug('User and Task'+' User '+eachUser+' Tasks '+temp);
                //sendEmail
            }
           
        }*/
    }
    
    public static void openTasks(){
        List<Task__c> tasks = [SELECT Id, Name, Deadline__c, Status__c, Category__c, Additional_Comments__c, Assigned_User__c, 
                               Re_assign_to__c, Type__c
                               FROM Task__c
                               WHERE Status__c !=  'Completed'];
        List<User_Master__c> users = [SELECT Id, Name, Total_Expence__c, Total_Amount_Shared__c, Total_Amount_Spent__c, 
                                      To_Get__c, To_Pay__c, Email__c
                                      FROM User_Master__c
                                     ];
        Map<Id,List<Task__c>> userTasks = new Map<Id,List<Task__c>>();
        for(Task__c tsk : tasks){
            Id user;
            if(tsk.Assigned_User__c != null){
                user = tsk.Assigned_User__c;
            }else{
                user = tsk.Re_assign_to__c;
            }
            system.debug('User '+ users.get(2));
            
            if(!userTasks.containsKey(user)){
                userTasks.put(user, new List<Task__c>());
                userTasks.get(user).add(tsk);
            }else{
                userTasks.get(user).add(tsk);
            }
        }
        System.debug(' Map of Tasks : '+userTasks);
        
        
        for(Id eachUser : userTasks.keySet()){
            List<Task__c> temp = userTasks.get(eachUser);
            if(temp != null){
                Calculations.sendEmail(eachUser);
            }
            system.debug('User and Task'+' User '+eachUser+' Tasks '+temp);
            //sendEmail
        }
        
        //User Specific List of Tasks
        /*for(User_Master__c usr : users){
            if(userTasks.containsKey(usr.Id)){
                system.debug('Count of tasks for '+usr.Name+' : '+userTasks.get(usr.Id).size());   
                List<Task__c> tsks = userTasks.get(usr.Id); 
                for(Integer i =0 ;i<tsks.size();i++){
                    system.debug('Task Name  : '+tsks[i].Name);
                }
            }
            
        }*/
                     
        
    }
    
}