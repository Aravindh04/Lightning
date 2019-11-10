public class TaskAndProgress {
    Public static final String weekly ='Weeky';
    Public static final String monthly ='Monthly';
    public static void createNewTask(String taskType){
        Integer Aravindh, Yokesh, Tejas;
        List<Task__c> weeklyTask = new List<Task__c>();
        List<User_Master__c> users = [SELECT Id, Email__c, Name 
                                     FROM User_Master__c];
        List<Task__c> oldTasks = [SELECT Id, Name, Category__c, Assigned_User__c, Re_assign_to__c, Status__c
                                 FROM Task__c];
        
        if(taskType == weekly){
            if(oldTasks == null ){
                //Task - 1
                weeklyTask[0].Name = 'Clean the Floor';
                weeklyTask[0].Category__c = 'Cleaning';
                weeklyTask[0].Assigned_User__c = users[0].Id;
                weeklyTask[0].Status__c = 'Assigned';
                weeklyTask[0].Type__c = 'Floor';
                weeklyTask[0].Additional_Comments__c = '1.Sweep and Mob the floor \n2.Dust the Floor Mats \n3.Empty the Dustbin and place the New cover ';
                weeklyTask[0].Deadline__c = System.today()+3;
                //Task - 2
                weeklyTask[1].Name = 'Clean the Washroom';
                weeklyTask[1].Category__c = 'Cleaning';
                weeklyTask[1].Assigned_User__c = users[1].Id;
                weeklyTask[1].Additional_Comments__c = '1.Trash all the waste inside \n2.Clean the Toilet \n.3Clean the washbasin \nAdded: If Month end clean the floor, door, Bucket Mug and Taps';
                weeklyTask[1].Status__c = 'Assigned';
                weeklyTask[1].Type__c = 'Washrroom';
                weeklyTask[1].Deadline__c = System.today()+3;
                //Task - 3
                weeklyTask[2].Name = 'Clean Kitchen';
                weeklyTask[2].Category__c = 'Cleaning';
                weeklyTask[2].Assigned_User__c = users[2].Id;
                weeklyTask[2].Additional_Comments__c = '1.Clean the Slabs  \n2.Remove Oil stains from boxes and Vessels \n3.Thorow the Rotten Fruits and Vegetables \n4.Clean the Stove \n5. \nAdded: If monthend wash with Soap water or Floor Cleaner';
                weeklyTask[2].Status__c = 'Assigned';
                weeklyTask[2].Type__c = 'Kitchen';
                weeklyTask[2].Deadline__c = System.today()+3;
                //Inserting into DB
                Insert weeklyTask;
                system.debug('Inserting a New task '+weeklyTask[0]);
            }
            else{
                //Cleaning Floor
                User_Master__c lstAssUserFloor = new User_Master__c();
				Task__c weeklyTask1 = new Task__c();
				Task__c weeklyTask2 = new Task__c();
				Task__c weeklyTask3 = new Task__c();
                Integer floorCountAravindh = [select count() from Task__c where (Assigned_User__r.Name ='Aravindh' OR Re_assign_to__r.Name = 'Aravindh') AND Status__c ='Completed' AND Type__c = 'Floor'];
                Integer floorCountTejas = [select count() from Task__c where (Assigned_User__r.Name ='Tejas' OR Re_assign_to__r.Name = 'Tejas') AND Status__c ='Completed'  AND Type__c = 'Floor'];
                Integer floorCountYokesh = [select count() from Task__c where (Assigned_User__r.Name ='Yokesh' OR Re_assign_to__r.Name = 'Yokesh') AND Status__c ='Completed' AND Type__c = 'Floor' ];
                Integer smallestCount = floorCountAravindh < floorCountTejas ? (floorCountAravindh < floorCountYokesh ? floorCountAravindh : floorCountYokesh) : (floorCountTejas < floorCountYokesh ? floorCountTejas : floorCountYokesh);
                    if(smallestCount == floorCountAravindh){
                        lstAssUserFloor = [select Id, Email__c, Name from User_Master__c where Name = 'Aravindh'];
                    }else if(smallestCount == floorCountTejas){
                        lstAssUserFloor = [select Id, Email__c, Name from User_Master__c where Name = 'Tejas'];
                    }else{
                        lstAssUserFloor = [select Id, Email__c, Name from User_Master__c where Name = 'Yokesh'];
                    }
                
                system.debug('Task assiggned User '+lstAssUserFloor);
                
                weeklyTask1.Name = 'Clean the Floor';
                weeklyTask1.Category__c = 'Cleaning';
                weeklyTask1.Assigned_User__c = lstAssUserFloor.Id;
                weeklyTask1.Additional_Comments__c = '1.Sweep and Mob the floor \n2.Dust the Floor Mats \n3.Empty the Dustbin and place New cover \n4. Wash Trashpad and Dustbin ';
                weeklyTask1.Status__c = 'Assigned';
                weeklyTask1.Type__c = 'Floor';
                weeklyTask1.Deadline__c = System.today()+3;
                Insert weeklyTask1;
                system.debug('Inserting a New task '+weeklyTask);
                
                //Cleaning Washroom
                User_Master__c lstAssUserWash = new User_Master__c();
                Integer wRoomCountAravindh = [select count() from Task__c where (Assigned_User__r.Name ='Aravindh' OR Re_assign_to__r.Name = 'Aravindh') AND Status__c ='Completed' AND Type__c = 'Washrroom'];
                Integer wRoomCountTejas = [select count() from Task__c where (Assigned_User__r.Name ='Tejas' OR Re_assign_to__r.Name = 'Tejas') AND Status__c ='Completed' AND Type__c = 'Washrroom' ];
                Integer wRoomCountYokesh = [select count() from Task__c where (Assigned_User__r.Name ='Yokesh' OR Re_assign_to__r.Name = 'Yokesh') AND Status__c ='Completed' AND Type__c = 'Washrroom' ];
                Integer smallestCountW = wRoomCountAravindh < wRoomCountTejas ? (wRoomCountAravindh < wRoomCountYokesh ? wRoomCountAravindh : wRoomCountYokesh) : (wRoomCountTejas < wRoomCountYokesh ? wRoomCountTejas : wRoomCountYokesh);
                    if(smallestCountW == wRoomCountAravindh){
                        lstAssUserWash = [select Id, Email__c, Name from User_Master__c where Name = 'Aravindh'];
                    }else if(smallestCountW == wRoomCountTejas){
                        lstAssUserWash = [select Id, Email__c, Name from User_Master__c where Name = 'Tejas'];
                    }else{
                        lstAssUserWash = [select Id, Email__c, Name from User_Master__c where Name = 'Yokesh'];
                    }
                weeklyTask2.Name = 'Clean the Washroom';
                weeklyTask2.Category__c = 'Cleaning';
                weeklyTask2.Assigned_User__c = lstAssUserWash.Id;
                weeklyTask2.Additional_Comments__c = '1.Trash all the waste inside \n2.Clean the Toilet \n.3Clean the washbasin \nAdded: If Month end clean the floor, door, Bucket Mug and Taps';
                weeklyTask2.Status__c = 'Assigned';
                weeklyTask2.Type__c = 'Washrroom';
                weeklyTask2.Deadline__c = System.today()+3;
                Insert weeklyTask2;
                system.debug('Inserting a New task '+weeklyTask2);
                
                //Cleaning Kitchen
                User_Master__c lstAssUserKitchen = new User_Master__c();
                Integer kitchenCountAravindh = [select count() from Task__c where (Assigned_User__r.Name ='Aravindh' OR Re_assign_to__r.Name = 'Aravindh') AND Status__c ='Completed' AND Type__c = 'Washrroom'];
                Integer kitchenCountTejas = [select count() from Task__c where (Assigned_User__r.Name ='Tejas' OR Re_assign_to__r.Name = 'Tejas') AND Status__c ='Completed' AND Type__c = 'Washrroom' ];
                Integer kitchenCountYokesh = [select count() from Task__c where (Assigned_User__r.Name ='Yokesh' OR Re_assign_to__r.Name = 'Yokesh') AND Status__c ='Completed' AND Type__c = 'Washrroom' ];
                Integer smallestCountK = kitchenCountAravindh < kitchenCountTejas ? (kitchenCountAravindh < kitchenCountYokesh ? kitchenCountAravindh : kitchenCountYokesh) : (kitchenCountTejas < kitchenCountYokesh ? kitchenCountTejas : kitchenCountYokesh);
                    if(smallestCountK == kitchenCountAravindh){
                        lstAssUserKitchen = [select Id, Email__c, Name from User_Master__c where Name = 'Aravindh'];
                    }else if(smallestCountK == kitchenCountTejas){
                        lstAssUserKitchen = [select Id, Email__c, Name from User_Master__c where Name = 'Tejas'];
                    }else{
                        lstAssUserKitchen = [select Id, Email__c, Name from User_Master__c where Name = 'Yokesh'];
                    }
                weeklyTask3.Name = 'Clean Kitchen';
                weeklyTask3.Category__c = 'Cleaning';
                weeklyTask3.Assigned_User__c = lstAssUserKitchen.Id;
                weeklyTask3.Additional_Comments__c = '1.Clean the Slabs  \n2.Remove Oil stains from boxes and Vessels \n3.Thorow the Rotten Fruits and Vegetables \n4.Clean the Stove \n5.Empty the Dustbin, Wash and replace Cover \nAdded: If monthend wash with Soap water or Floor Cleaner';
                weeklyTask3.Status__c = 'Assigned';
                weeklyTask3.Type__c = 'Kitchen';
                weeklyTask3.Deadline__c = System.today()+3;
                Insert weeklyTask3;
                
                system.debug('Inserting a New task '+weeklyTask2);
            }
        }
    }
    
    public static void monthlyTask(String taskType){
        if(taskType == monthly){
            User_Master__c usr = [SELECT Id, Name, Email__c
                                  FROM User_Master__c
                                  WHERE Name = 'Yokesh'];
            DateTime currentDay = System.Now();
            Task__c newTask = new Task__c();
            newTask.Assigned_User__c = usr.Id;
            newTask.Category__c = 'Sending Money';
            newTask.Deadline__c = System.today()+4;
            newTask.Name	= 'Monthly Rent - '+currentDay.format('MMMM d, yyyy');
            newTask.Additional_Comments__c = 'Please pay the rent now';
            newTask.Status__c = 'Assigned';
            newTask.Type__c = 'Rent Payment';
            Insert newTask;
        }else{
            system.debug('Non - monthly task, Received task type '+taskType);
        }
    }
    
    public static void billPaymentTask(Date billingDate){
		Date tdy = System.today();        	
        if(billingDate == tdy){
            User_Master__c usr = [SELECT Id, Name, Email__c
                                  FROM User_Master__c
                                  WHERE Name = 'Aravindh'];
            DateTime currentDay = System.Now();
            Task__c newTask = new Task__c();
            newTask.Assigned_User__c = usr.Id;
            newTask.Category__c = 'Bill Payments';
            newTask.Deadline__c = System.today()+4;
            newTask.Name	= 'EB Bill - '+currentDay.format('MMMM d, yyyy');
            newTask.Additional_Comments__c = 'Please pay the EB bill';
            newTask.Status__c = 'Assigned';
            newTask.Type__c = 'Electric Bill';
            Insert newTask;
        }else{
            system.debug('Failed EB Bill payment \n Dates dont match');
        }
    }

}