trigger transactionCreationLog on Expense__c (before Insert, before delete, after delete, before Update){
    Date dat = Date.today();
    Integer month = dat.month();
    Share__c sha = new Share__c();
    sha = [SELECT Id, Name, Total_Expense__c, Monthly_Expence__c
           FROM Share__c
           WHERE CALENDAR_MONTH(createdDate) =: month LIMIT 1
          ];
    if(Trigger.isInsert){
        if(Trigger.IsBefore){
            List<User_Master__c> allUser  = new List<User_Master__c>();
            allUser =   [SELECT Id, Name, Total_Expence__c, Total_Amount_Shared__c, Total_Amount_Spent__c, To_Get__c, To_Pay__c, Email__c
                         FROM User_Master__c];
            
            //Expense creation Starts here
            for(Expense__c ex: Trigger.New){
                if(ex.Amount__c > 0 && ex.Expense_on__c == 'Pair'){
                    Personal_User_Profile__c payUsr = [SELECT Id, Name, Pair_Shared_Expense__c, Master__c, To_pay_Aravindh__c, To_pay_Tejas__c, To_pay_Yokesh__c
                                                       FROM Personal_User_Profile__c
                                                       WHERE Master__c =:ex.Member__c];
                    Personal_User_Profile__c shareUsr = [SELECT Id, Name, Pair_Shared_Expense__c, Master__c, To_pay_Aravindh__c, To_pay_Tejas__c, To_pay_Yokesh__c
                                                         FROM Personal_User_Profile__c
                                                         WHERE Name=:ex.Shared_with__c];
                    User_Master__c expUser = [SELECT Id, Name 
                                              FROM User_Master__c
                                              WHERE Id =: ex.Member__c];
                    decimal share = (ex.Amount__c/2).setScale(2);
                    payUsr.Pair_Shared_Expense__c = payUsr.Pair_Shared_Expense__c + share; 
                    
                    if(expUser.Name != ex.Shared_with__c){
                        if(expUser.Name == 'Aravindh'){
                            shareUsr.To_pay_Aravindh__c = shareUsr.To_pay_Aravindh__c + share;
                        }
                        else if(expUser.Name == 'Tejas'){
                            shareUsr.To_pay_Tejas__c = shareUsr.To_pay_Tejas__c + share;
                        }
                        else if(expUser.Name == 'Yokesh'){
                            shareUsr.To_pay_Yokesh__c = shareUsr.To_pay_Yokesh__c + share;
                        }
                        else{
                            ex.addError('Something went wrong, Please contact ADMINISTRATOR or Aravindh');
                        }
                    }
                    else{
                        ex.addError('Both Users Cannot be same. Here, \''+expUser.Name+'\' and \''+ex.Shared_with__c+'\' are Same. Please select a valid user');
                    }
                    
                    UPDATE payUsr;
                    UPDATE shareUsr;
                    /*ex.addError('Please Select the \'Expense on\' as \"Common\" or \"Individual\", You have choosen \"'+ex.Expense_on__c+'\"');*/
                }
                else if(ex.Amount__c > 0 && ex.Expense_on__c == 'Individual'){
                    Personal_User_Profile__c pers = [SELECT Id, Name, Personal_Expense__c, Master__c
                                                  FROM Personal_User_Profile__c
                                                    WHERE Master__c =:ex.Member__c];
                    
                    pers.Personal_Expense__c = pers.Personal_Expense__c + ex.Amount__c;
                    update pers;
                    
                }
                else if(ex.Amount__c > 0 && ex.Expense_on__c == 'Common'){
                    List<Payment__c> paymnt =[SELECT Id, Name, Wallet_from__c, Pay_to__c, Amount__c 
                                              FROM Payment__c
                                              WHERE Status__c = 'Pending' AND (Wallet_from__c =: ex.Member__c OR Pay_to__c =: ex.Member__c)];
                    if(sha != null){
                        if(paymnt.size()==0){
                            //SendEmail.sendEmailOnExpenceCreation(ex);
                            sha.Total_Expense__c = sha.Total_Expense__c + ex.Amount__c;
                            sha.Monthly_Expence__c = sha.Monthly_Expence__c + ex.Amount__c;
                            Update_UserDetails_on_Transaction.updateUserAdd(ex);
                            update sha;
                        }
                        else{
                            ex.addError('Hello There! You have '+paymnt.size()+' \'Pending\' payment(s) Either To Pay or To Get. You cannot create any expense until they payment is \'Successful\'.\nPlease check Payments and User Master or Contact administrator for Approval');
                        }
                    }
                    else{
                        ex.addError('Shares Not availale'+ sha.Id);
                    }
                }
                else{
                    ex.addError('please enter an Amount More than \'0\'');
                }
            }
        }
        
    }
    if(Trigger.isDelete){
        if(Trigger.isBefore){
            for(Expense__c ex: Trigger.old){
                if(ex.Expense_on__c == 'Common'){
                    if(sha != null){
                        /*try{
                        SendEmail.sendEmailOnExpenceDeletion(ex);
                        }Catch(Exception e){}*/
                        sha.Total_Expense__c = sha.Total_Expense__c - ex.Amount__c;
                        sha.Monthly_Expence__c = sha.Monthly_Expence__c - ex.Amount__c;
                        Update_UserDetails_on_Transaction.updateUserDelete(ex);
                        update sha;
                    }
                    else{
                        ex.addError('Shares Not availale'+ sha.Id);
                    }
                }
                if(ex.Expense_on__c == 'Pair'){
                    Personal_User_Profile__c payUsr = [SELECT Id, Name, Pair_Shared_Expense__c, Master__c, To_pay_Aravindh__c, To_pay_Tejas__c, To_pay_Yokesh__c
                                                       FROM Personal_User_Profile__c
                                                       WHERE Master__c =:ex.Member__c];
                    Personal_User_Profile__c shareUsr = [SELECT Id, Name, Pair_Shared_Expense__c, Master__c, To_pay_Aravindh__c, To_pay_Tejas__c, To_pay_Yokesh__c
                                                         FROM Personal_User_Profile__c
                                                         WHERE Name=:ex.Shared_with__c];
                    User_Master__c expUser = [SELECT Id, Name 
                                              FROM User_Master__c
                                              WHERE Id =: ex.Member__c];
                    decimal share = (ex.Amount__c/2).setScale(2);
                    payUsr.Pair_Shared_Expense__c = payUsr.Pair_Shared_Expense__c - share;
                    
                    
                    if(expUser.Name != ex.Shared_with__c){
                        if(expUser.Name == 'Aravindh'){
                            shareUsr.To_pay_Aravindh__c = shareUsr.To_pay_Aravindh__c - share;
                        }
                        else if(expUser.Name == 'Tejas'){
                            shareUsr.To_pay_Tejas__c = shareUsr.To_pay_Tejas__c - share;
                        }
                        else if(expUser.Name == 'Yokesh'){
                            shareUsr.To_pay_Yokesh__c = shareUsr.To_pay_Yokesh__c - share;
                        }
                        else{
                            ex.addError('Something went wrong, Please contact ADMINISTRATOR or Aravindh');
                        }
                    }
                    else if(ex.Amount__c > 0 && ex.Expense_on__c == 'Individual'){
                        Personal_User_Profile__c pers = [SELECT Id, Name, Personal_Expense__c, Master__c
                                                         FROM Personal_User_Profile__c
                                                         WHERE Master__c =:ex.Member__c];
                        
                        pers.Personal_Expense__c = pers.Personal_Expense__c - ex.Amount__c;
                        update pers;
                        
                    }
                    else{
                        ex.addError('Both Users Cannot be Same \nHere,'+expUser.Name+' and '+ex.Shared_with__c+' are Same. Please select a valid user');
                    }
                    
                    UPDATE payUsr;
                    UPDATE shareUsr;
                    /*ex.addError('Please Select the \'Expense on\' as \"Common\" or \"Individual\", You have choosen \"'+ex.Expense_on__c+'\"');*/
                    
                    
                } 
                else if(ex.Expense_on__c == 'Individual'){
                    Personal_User_Profile__c expUser = [SELECT Id, Name, Personal_Expense__c, Master__c
                                                       FROM Personal_User_Profile__c
                                                       WHERE Master__c =:ex.Member__c];
                    expUser.Personal_Expense__c = expUser.Personal_Expense__c - ex.Amount__c;
                }
            }
        }
    }
    if(Trigger.isUpdate){
        String pro =UserInfo.getProfileId();
        if(pro == '00e7F000001gIkQQAU'){
            for(Expense__c ex: Trigger.New){
                Expense__c oldEx = Trigger.oldMap.get(ex.Id);
                if(ex.Amount__c != oldEx.Amount__c || ex.Member__c != oldEx.Member__c || ex.Expense_on__c != oldEx.Member__c || ex.CreatedDate != oldEx.CreatedDate || ex.OwnerId != oldEx.OwnerId){
                    ex.addError('You are allowed to edit \'Payment Method, Bank name, Wallet Name, Expense Name, Comments and Expense Date\'You cannot edit Certain fields in order to maintain Consistency, Thayavu Seidhu \'Cancel\' Seiyavum. Please contact Admin');
                }
                else if(ex.Expense_Date__c.month() != oldEx.Expense_Date__c.month()){
                    ex.addError('You Cannot Change the Month of any Expense, Please Contact Admin');
                }
            }    
        }
    }
    
 }