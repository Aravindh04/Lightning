public class Update_UserDetails_on_Transaction {
    public static void updateUserAdd(Expense__c exp){
        User_Master__c paidUser  = 	[SELECT Id, Name, Total_Expence__c, Total_Amount_Shared__c, Total_Amount_Spent__c, To_Get__c, To_Pay__c, Email__c
                                     FROM User_Master__c
                                     WHERE Id =: exp.Member__c
                                    ];
        List<User_Master__c> allUsers  = 	[SELECT Id, Name, Total_Expence__c, Total_Amount_Shared__c, Total_Amount_Spent__c, To_Get__c, To_Pay__c, Email__c
                                             FROM User_Master__c
                                            ];
        
        //Sharing Money
        if(exp.Expense_on__c == 'Common'){
            //To get the current month
            Date dat = Date.today();
            Integer MonthOfToday = dat.month();
            
            decimal shareAmount = (exp.Amount__c/3).setScale(2);
            decimal toGet = (exp.Amount__c - shareAmount).setScale(2);
            
            //Update my account
            paidUser.Total_Expence__c = paidUser.Total_Expence__c + exp.Amount__c;
            if(toGet <= paidUser.To_Pay__c ){
                System.debug('to get <= to pay '+toGet+' <= '+paidUser.To_Pay__c );
                paidUser.To_Pay__c = paidUser.To_Pay__c - toGet;
                
            }
            else if(toGet > paidUser.To_Pay__c ){
                System.debug('to get > to pay :'+toGet+' > '+paidUser.To_Pay__c);
                paidUser.To_Get__c = paidUser.To_Get__c + toGet;
                paidUser.To_Get__c = paidUser.To_Get__c - paidUser.To_Pay__c;
                paidUser.To_Pay__c = paidUser.To_Pay__c - paidUser.To_Pay__c;
            }
            paidUser.Total_Amount_Spent__c = paidUser.Total_Amount_Spent__c + exp.Amount__c; 
            paidUser.Total_Amount_Shared__c = paidUser.Total_Amount_Shared__c + shareAmount;
            
            //Share To others
            for(Integer i=0; i<allUsers.size(); i++){
                if(allUsers[i].Name != paidUser.Name){
                    System.debug(allUsers[i].Name+' != '+paidUser.Name);
                    allUsers[i].To_Pay__c = allUsers[i].To_Pay__c + shareAmount;
                    if(allUsers[i].To_Pay__c.setScale(2) >= allUsers[i].To_Get__c.setScale(2) && allUsers[i].To_Get__c.setScale(2) >= 0){
                        	System.debug(allUsers[i].To_Pay__c+' >= '+allUsers[i].To_Get__c+' && '+allUsers[i].To_Get__c+' >= 0');
                            allUsers[i].To_Pay__c = allUsers[i].To_Pay__c.setScale(2) - allUsers[i].To_Get__c.setScale(2);
                            allUsers[i].To_Get__c = allUsers[i].To_Get__c.setScale(2) - allUsers[i].To_Get__c.setScale(2);
                    }
                    else if(allUsers[i].To_Pay__c.setScale(2) < allUsers[i].To_Get__c.setScale(2)){
                        System.debug(allUsers[i].To_Pay__c.setScale(2)+' < '+allUsers[i].To_Get__c.setScale(2));
                        allUsers[i].To_Get__c = allUsers[i].To_Get__c.setScale(2) - allUsers[i].To_Pay__c.setScale(2);
                        allUsers[i].To_Pay__c = allUsers[i].To_Pay__c.setScale(2) - allUsers[i].To_Pay__c.setScale(2);
                    }
                    update allUsers[i];
                }
            }
            update paidUser;
        }
    }
    public static void updateUserDelete(Expense__c exp){
        User_Master__c paidUser  = 	[SELECT Id, Name, Total_Expence__c, Total_Amount_Shared__c, Total_Amount_Spent__c, To_Get__c, To_Pay__c, Email__c
                                     FROM User_Master__c
                                     WHERE Id =: exp.Member__c
                                    ];
        List<User_Master__c> allUsers  = 	[SELECT Id, Name, Total_Expence__c, Total_Amount_Shared__c, Total_Amount_Spent__c, To_Get__c, To_Pay__c, Email__c
                                             FROM User_Master__c
                                            ];
        
        //Sharing Money(
        if(exp.Expense_on__c == 'Common'){
            //To get the current month
            Date dat = Date.today();
            Integer MonthOfToday = dat.month();
            
            decimal shareAmount = (exp.Amount__c/3).setScale(2);
            decimal toGet = (exp.Amount__c - shareAmount).setScale(2);
            
            //Update my account
            paidUser.Total_Expence__c = paidUser.Total_Expence__c.setScale(2) - exp.Amount__c;
            IF(paidUser.To_Get__c.setScale(2)> paidUser.To_Pay__c.setScale(2)){
                if(paidUser.To_Get__c.setScale(2) <= toGet){
                    decimal toEqualize = toGet;
                    toEqualize = toEqualize - paidUser.To_Get__c;
                    paidUser.To_Get__c = paidUser.To_Get__c.setScale(2) - paidUser.To_Get__c.setScale(2);
                    paidUser.To_Pay__c = paidUser.To_Pay__c.setScale(2) + toEqualize;
                }
                else{
                    paidUser.To_Get__c = paidUser.To_Get__c.setScale(2) - toGet;
                }
            }
            else{
                paidUser.To_Pay__c = paidUser.To_Pay__c.setScale(2)  + toGet;
            }
            paidUser.Total_Amount_Spent__c = paidUser.Total_Amount_Spent__c.setScale(2) - exp.Amount__c; 
            paidUser.Total_Amount_Shared__c = paidUser.Total_Amount_Shared__c.setScale(2) - shareAmount;
            
            //Share To others
            for(Integer i=0; i<allUsers.size(); i++){
                if(allUsers[i].Name != paidUser.Name){
                    System.debug(allUsers[i].To_Pay__c+'>'+allUsers[i].To_Get__c+' && '+allUsers[i].To_Pay__c+'-'+shareAmount+'>0');
                    System.debug(allUsers[i].To_Pay__c+'>'+allUsers[i].To_Get__c);
                    System.debug(allUsers[i].To_Pay__c+'>='+allUsers[i].To_Get__c +' && '+allUsers[i].To_Pay__c +'-'+shareAmount+'<0');
                    if(allUsers[i].To_Pay__c.setScale(2) > allUsers[i].To_Get__c.setScale(2) && (allUsers[i].To_Pay__c.setScale(2) - shareAmount)>=0){
                        allUsers[i].To_Pay__c = allUsers[i].To_Pay__c.setScale(2) - shareAmount;
                        update allUsers[i];
                    }
                    else if(allUsers[i].To_Pay__c.setScale(2) < allUsers[i].To_Get__c.setScale(2)){
                        allUsers[i].To_Get__c = allUsers[i].To_Get__c.setScale(2) + shareAmount;
                        update allUsers[i];
                    }
                    else if(allUsers[i].To_Pay__c >= allUsers[i].To_Get__c.setScale(2) && (allUsers[i].To_Pay__c.setScale(2) - shareAmount)<0){
                        decimal toEqualize = shareAmount;
                        toEqualize = toEqualize - allUsers[i].To_Pay__c ;
                        allUsers[i].To_Pay__c = allUsers[i].To_Pay__c.setScale(2) - allUsers[i].To_Pay__c.setScale(2);
                        allUsers[i].To_Get__c = allUsers[i].To_Get__c.setScale(2) + toEqualize;
                        update allUsers[i];
                    }
                    else{
                        exp.addError('Review the error - To Pay amount : '+ allUsers[i].To_Pay__c + ' To Get Amount : '+ allUsers[i].To_Get__c +' Share reduction : '+shareAmount);
                    }
                    
                }
            }
            update paidUser;
        }
    }
    
}