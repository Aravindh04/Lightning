trigger CreatingNewTask on Task__c (before insert, before update) {
    if(Trigger.isInsert){
        for(Task__c tsk: Trigger.new){
            tsk.Status__c = 'Assigned';
            if(tsk.Category__c == 'Cleaning' && tsk.Type__c == null){
                tsk.addError('Please select the Cleaning type!');
            }
        }
    }
    
    if(Trigger.isUpdate){
        for(Task__c tsk: Trigger.new){
            if(tsk.Re_assign_to__c != null){
                if(tsk.Assigned_User__c == tsk.Re_assign_to__c){
                    tsk.addError('Assigned user and Reassigned user cannot be Same, Please change');
                }else{
                    tsk.Assigned_User__c = null;
                }
            }
            
            if(tsk.Category__c == 'Sending Money' && tsk.Type__c == 'Rent Payment' && tsk.Status__c == 'Completed' ){
                system.debug('inide creation');
                DateTime thisDay = System.now();
                //Creating new expense on yokesh for monthly rent after task completion
                Expense__c ex = new Expense__c();
                ex.Name = 'Monthly rent - '+thisDay.format('MMMM d, yyyy');
                ex.Amount__c = 12960.00;
                ex.Category__c = 'Rent';
                ex.Expense_on__c = 'Common';
                ex.Member__c = tsk.Assigned_User__c;
                ex.Payment_Method__c = 'Card';
                ex.Expense_Date__c = System.today();
                ex.Bank_Name__c = 'HDFC Bank';
                ex.Comments__c = thisDay.Month()+' rent paid by Task completion';
                
                List<User_Master__c> usrs = [SELECT Id, Name, Email__c
                                            FROM User_Master__c];
                List<Task__c> userTasks = new List<Task__c>();
                for(User_Master__c usr : usrs){
                    if(usr.Name != tsk.Assigned_User__r.Name || usr.Name != tsk.Re_assign_to__r.Name){
                        Task__c usrTask = new Task__c();
                        
                        usrTask.Name 			= 'Rent Sharing';
                        usrTask.Assigned_User__c= usr.Id;
                        usrTask.Type__c 		= 'Pending Dues';
                        usrTask.Status__c 		= 'Assigned';
                        usrTask.Deadline__c		= System.today().addDays(7);
                        usrTask.Category__c 	= 'Sending Money';
                        usrTask.Additional_Comments__c = 'Please share the rent (or) remaining User Master \'To Pay\' amount with the other users';
                        userTasks.add(usrTask);
                    }
                }
                
                try{
                    if(!userTasks.isEmpty())
                        insert userTasks;
                    
                    if(ex != null)
                        Insert ex;
                    
                    SendEmail.sendRentEmailReminder(tsk.Assigned_User__c);  
                    
                }catch(Exception ee){
                    System.debug('Exception Message '+ ee.getMessage());
                }
            }
        }
    }
}