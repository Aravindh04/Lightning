trigger updateUserAccountDetails on Payment__c (after update, before Insert, before delete) {
    If(Trigger.isInsert && Trigger.isBefore){
        
        for(Payment__c insPay: Trigger.new){
            
            //Paying for User master, Transaction Creation
            if(insPay.Pay_for__c == 'User Master'){
                User_Master__c payToUser =[SELECT Id, Name, To_Get__c, To_Pay__c
                                           FROM User_Master__c
                                           WHERE Id =: insPay.Pay_to__c];
                User_Master__c payingUser =[SELECT Id, Name, To_Get__c, To_Pay__c
                                            FROM User_Master__c
                                            WHERE Id =: insPay.Wallet_from__c];
                if(insPay.Amount__c>0){
                    if(insPay.Amount__c<=payToUser.To_Get__c && insPay.Amount__c <= payingUser.To_Pay__c.setScale(2)){
                        System.debug('Success !!'+insPay.Id+insPay.Amount__c+' is less than '+payToUser.To_Get__c);
                        
                    }
                    else if(insPay.Amount__c > payingUser.To_Pay__c.setScale(2)){
                        insPay.addError('Sorry ! You are crossing you Max \'To pay\' amount. Your payment should be Less than Rs.'+payingUser.To_Pay__c.setScale(2)+'. Please enter a lesser Sum.');
                    }
                    else if(insPay.Amount__c>payToUser.To_Get__c.setScale(2) && insPay.Amount__c <= payingUser.To_Pay__c.setScale(2)){
                        insPay.addError(payToUser.Name+' is yet to receive only Rs.'+payToUser.To_Get__c.setScale(2)+' Plese Enter a lesser amount');
                    }else{
                        insPay.addError(payToUser.Name+' has no Pending or unsettled amount in his Wallet, Please select a different user');
                    }
                    
                    insPay.Status__c = 'Pending';
                    insPay.Transaction_Status__c = 'Pending';
                    //SendEmail 
                    /*try{
                            SendEmail.sendingEmail(insPay);   
                    }
                    catch(exception ex){}*/
                    
                }
                else{
                    insPay.addError('Please Enter a valid Data. \'Amount cannot be 0 or Negative value\'\nEntered amoount : '+insPay.Amount__c );
                }
            }
            
            //payment Between  pair of users
            else if(insPay.Pay_for__c == 'Pair Sharing'){
                //Sharing User
                Personal_User_Profile__c getUsr = [SELECT Id, Name, Pair_Shared_Expense__c, Master__c, To_pay_Aravindh__c, To_pay_Tejas__c, To_pay_Yokesh__c
                                                   FROM Personal_User_Profile__c
                                                   WHERE Master__c =:insPay.Pay_to__c];
                //Paying User
                Personal_User_Profile__c payUsr = [SELECT Id, Name, Pair_Shared_Expense__c, Master__c, To_pay_Aravindh__c, To_pay_Tejas__c, To_pay_Yokesh__c
                                                   FROM Personal_User_Profile__c
                                                   WHERE Master__c =:insPay.Wallet_From__c];
                if(getUsr.Name == payUsr.Name){
                    insPay.addError('Both users cannot be same, \nYou have selected \"'+getUsr.Name+'\" for Both the users. Please select a different User');
                }
                else{
                    if(payUsr.To_pay_Aravindh__c >0 || payUsr.To_pay_Tejas__c >0|| payUsr.To_pay_Yokesh__c>0){
                        if(payUsr.Name == 'Aravindh'){
                            if(getUsr.Name == 'Yokesh'){
                                if(insPay.Amount__c<=payUsr.To_pay_Yokesh__c){
                                    payUsr.To_pay_Yokesh__c = payUsr.To_pay_Yokesh__c - insPay.Amount__c;
                                    payUsr.Pair_Shared_Expense__c = payUsr.Pair_Shared_Expense__c + insPay.Amount__c;
                                    insPay.Status__c = 'Successful';
                                    insPay.Transaction_Status__c = 'Completed';
                                    update payUsr;
                                }
                                else if(insPay.Amount__c > payUsr.To_pay_Yokesh__c){
                                    insPay.addError('You need to pay only Rs.'+payUsr.To_pay_Yokesh__c+' to Yokesh. Please select a lesser sum');
                                }
                                else{
                                    insPay.Status__c = 'Failed';
                                    insPay.Transaction_Status__c = 'Failed';
                                    
                                }
                            }
                            if(getUsr.Name == 'Tejas'){
                                if(insPay.Amount__c<=payUsr.To_pay_Tejas__c){
                                    payUsr.To_pay_Tejas__c = payUsr.To_pay_Tejas__c - insPay.Amount__c;
                                    payUsr.Pair_Shared_Expense__c = payUsr.Pair_Shared_Expense__c + insPay.Amount__c;
                                    insPay.Status__c = 'Successful';
                                    insPay.Transaction_Status__c = 'Completed';
                                    system.debug('payment Successfully Updated '+payUsr);
                                    update payUsr;
                                }
                                else if(insPay.Amount__c > payUsr.To_pay_Tejas__c){
                                    insPay.addError('You need to pay only Rs.'+payUsr.To_pay_Tejas__c+' to Tejas. Please select a lesser sum');
                                }
                                else{
                                    insPay.Status__c = 'Failed';
                                    insPay.Transaction_Status__c = 'Failed';
                                    
                                }
                             }
                        }
                        if(payUsr.Name == 'Yokesh'){
                            if(getUsr.Name == 'Aravindh'){
                                if(insPay.Amount__c<=payUsr.To_pay_Aravindh__c){
                                    payUsr.To_pay_Aravindh__c = payUsr.To_pay_Aravindh__c - insPay.Amount__c;
                                    payUsr.Pair_Shared_Expense__c = payUsr.Pair_Shared_Expense__c + insPay.Amount__c;
                                    insPay.Status__c = 'Successful';
                                    insPay.Transaction_Status__c = 'Completed';
                                    update payUsr;
                                }
                                else if(insPay.Amount__c > payUsr.To_pay_Aravindh__c){
                                    insPay.addError('You need to pay only Rs.'+payUsr.To_pay_Aravindh__c+' to Aravindh. Please select a lesser sum');
                                }
                                else{
                                    insPay.Status__c = 'Failed';
                                    insPay.Transaction_Status__c = 'Failed';
                                    
                                }
                            }
                            if(getUsr.Name == 'Tejas'){
                                if(insPay.Amount__c<=payUsr.To_pay_Tejas__c){
                                    payUsr.To_pay_Tejas__c = payUsr.To_pay_Tejas__c - insPay.Amount__c;
                                    payUsr.Pair_Shared_Expense__c = payUsr.Pair_Shared_Expense__c + insPay.Amount__c;
                                    insPay.Status__c = 'Successful';
                                    insPay.Transaction_Status__c = 'Completed';
                                    update payUsr;
                                }
                                else if(insPay.Amount__c > payUsr.To_pay_Tejas__c){
                                    insPay.addError('You need to pay only Rs.'+payUsr.To_pay_Tejas__c+' to Tejas. Please select a lesser sum');
                                }
                                else{
                                    insPay.Status__c = 'Failed';
                                    insPay.Transaction_Status__c = 'Failed';
                                    
                                }
                            }
                        }
                        if(payUsr.Name == 'Tejas'){
                            if(getUsr.Name == 'Aravindh'){
                                if(insPay.Amount__c<=payUsr.To_pay_Aravindh__c){
                                    payUsr.To_pay_Aravindh__c = payUsr.To_pay_Aravindh__c - insPay.Amount__c;
                                    payUsr.Pair_Shared_Expense__c = payUsr.Pair_Shared_Expense__c + insPay.Amount__c;
                                    insPay.Status__c = 'Successful';
                                    insPay.Transaction_Status__c = 'Completed';
                                    update payUsr;
                                }
                                else if(insPay.Amount__c > payUsr.To_pay_Aravindh__c){
                                    insPay.addError('You need to pay only Rs.'+payUsr.To_pay_Aravindh__c+' to Aravindh. Please select a lesser sum');
                                }
                                else{
                                    insPay.Status__c = 'Failed';
                                    insPay.Transaction_Status__c = 'Failed';
                                    
                                }
                            }
                            if(getUsr.Name == 'Yokesh'){
                                if(insPay.Amount__c<=payUsr.To_pay_Yokesh__c){
                                    payUsr.To_pay_Yokesh__c = payUsr.To_pay_Yokesh__c - insPay.Amount__c;
                                    payUsr.Pair_Shared_Expense__c = payUsr.Pair_Shared_Expense__c + insPay.Amount__c;
                                    insPay.Status__c = 'Successful';
                                    insPay.Transaction_Status__c = 'Completed';
                                    update payUsr;
                                }
                                else if(insPay.Amount__c > payUsr.To_pay_Yokesh__c){
                                    insPay.addError('You need to pay only Rs.'+payUsr.To_pay_Yokesh__c+' to Yokesh. Please select a lesser sum');
                                }
                                else{
                                    insPay.Status__c = 'Failed';
                                    insPay.Transaction_Status__c = 'Failed';
                                    
                                }
                            }
                        }
                    }
                    else{
                        insPay.addError('You don\'t have any Pending dues in Pair shared Expense, Please try User Master');
                    }
                }
            }
            
        }
    }
    
    If(Trigger.isUpdate && Trigger.isAfter){
        for(Payment__c pay:Trigger.New){
            if(pay.Pay_for__c == 'User Master'){
                User_Master__c payToUser =[SELECT Id, Name, To_Get__c, To_Pay__c, Received__c, Total_Expence__c, Paid__c
                                           FROM User_Master__c
                                           WHERE Id =: pay.Pay_to__c];
                User_Master__c payingUser =[SELECT Id, Name, To_Get__c, To_Pay__c, Total_Expence__c, Paid__c, Received__c
                                            FROM User_Master__c
                                            WHERE Id =: pay.Wallet_from__c];
                
                //For Updating =||User Mastert||= Object
                if(pay.Amount__c<=payToUser.To_Get__c.setScale(2) && pay.Status__c == 'Successful'&& pay.Transaction_Status__c == 'Pending'){
                    System.debug('Status '+pay.Status__c+'; To Pay Amount : '+pay.Amount__c+'; User Getting Amount : '+ payToUser.To_Get__c.setScale(2));
                    System.debug(payToUser.To_Get__c.setScale(2)+'>='+pay.Amount__c.setScale(2)+'&&'+payToUser.To_Get__c.setScale(2)+'>0;'+payToUser.To_Pay__c.setScale(0)+'==0;'+payingUser.To_Pay__c.setScale(2)+ '<='+ pay.Amount__c+';'+pay.Amount__c+'>0 Thats All');
                    if((payToUser.To_Get__c.setScale(2) >= pay.Amount__c.setScale(2)) && (payToUser.To_Get__c.setScale(2) >0)  &&  (payToUser.To_Pay__c.setScale(0)==0) && (pay.Amount__c <= payingUser.To_Pay__c.setScale(2)) && (pay.Amount__c>0)){
                        payToUser.To_Get__c = payToUser.To_Get__c - pay.Amount__c;    
                        payingUser.To_Pay__c = payingUser.To_Pay__c - pay.Amount__c;
                        payingUser.Total_Expence__c = payingUser.Total_Expence__c + pay.Amount__c;
                        payToUser.Total_Expence__c = payToUser.Total_Expence__c - pay.Amount__c;
                        payingUser.Paid__c = payingUser.Paid__c + pay.Amount__c;
                        payToUser.Received__c = payToUser.Received__c + pay.Amount__c;
                        update payToUser;
                        update payingUser;
                    }
                    else{
                        pay.Status__c = 'Failed';
                        update pay;
                        System.debug('Failed due to '+pay.Amount__c+' > ' +payToUser.To_Get__c.setScale(2));
                        System.debug(payToUser.To_Get__c.setScale(2)+'>='+pay.Amount__c.setScale(2)+'&&'+payToUser.To_Get__c.setScale(2)+'>0;'+payToUser.To_Pay__c.setScale(0)+'==0;'+payingUser.To_Pay__c.setScale(2)+ '<='+ pay.Amount__c+';'+pay.Amount__c+'>0 Thats All');
                    }
                    
                    
                }
                else if(pay.Transaction_Status__c == 'Completed'){
                        
                }
                else{
                    pay.addError('Request cannot be Processed');
                }
                
            }
        }
    }
    
    if(Trigger.isDelete){
        if(Trigger.isBefore){
            for(Payment__c payDel: Trigger.old){
                if(payDel.Pay_for__c == 'User Master'){
                    User_Master__c payToUser =[SELECT Id, Name, To_Get__c, To_Pay__c, Total_Expence__c, Received__c, Paid__c
                                               FROM User_Master__c
                                               WHERE Id =: payDel.Pay_to__c];
                    User_Master__c payingUser =[SELECT Id, Name, To_Get__c, To_Pay__c, Total_Expence__c, Received__c, Paid__c
                                                FROM User_Master__c
                                                WHERE Id =: payDel.Wallet_from__c];
                    if( payDel.Transaction_Status__c == 'Pending' && payDel.Status__c == 'Successful'){
                        payDel.addError('You Cannot Delete When a Transaction is Successful and Incomlete, Please Update Transaction Status To Completed');
                    }
                    else if(payDel.Status__c == 'Successful'  && payDel.Transaction_Status__c == 'Completed'){
                        if(payToUser.To_Get__c >= payToUser.To_Pay__c){
                            payToUser.To_Get__c = payToUser.To_Get__c + payDel.Amount__c;
                        }else if(payToUser.To_Get__c < payToUser.To_Pay__c){
                            decimal tempAmount = payDel.Amount__c - payToUser.To_Pay__c;
                            if(tempAmount > 0){
                                payToUser.To_Get__c = payToUser.To_Get__c + tempAmount;
                            }else{
                                payToUser.To_Pay__c = payToUser.To_Pay__c - payDel.Amount__c;
                            }
                        }
                        
                        if(payingUser.To_Pay__c >= payingUser.To_Get__c ){
                            payingUser.To_Pay__c = payingUser.To_Pay__c + payDel.Amount__c;    
                        }else if(payingUser.To_Pay__c < payingUser.To_Get__c){
                            decimal tempAmount = payDel.Amount__c - payingUser.To_Get__c;
                            if(tempAmount>0){
                                payingUser.To_Pay__c = payingUser.To_Pay__c + tempAmount;
                            }else{
                                payingUser.To_Get__c = payingUser.To_Get__c - payDel.Amount__c;
                            }
                        }
                        
                        payingUser.Total_Expence__c = payingUser.Total_Expence__c - payDel.Amount__c;
                        payToUser.Total_Expence__c = payToUser.Total_Expence__c + payDel.Amount__c;
                        payingUser.Paid__c = payingUser.Paid__c - payDel.Amount__c;
                        payToUser.Received__c = payToUser.Received__c - payDel.Amount__c;
                        update payToUser;
                        update payingUser;
                    }
                }
                else if(payDel.Pay_for__c == 'Pair Sharing'){
                    Personal_User_Profile__c getUsr = [SELECT Id, Name, Pair_Shared_Expense__c, Master__c, To_pay_Aravindh__c, To_pay_Tejas__c, To_pay_Yokesh__c
                                                   FROM Personal_User_Profile__c
                                                   WHERE Master__c =:payDel.Pay_to__c];
                    Personal_User_Profile__c payUsr = [SELECT Id, Name, Pair_Shared_Expense__c, Master__c, To_pay_Aravindh__c, To_pay_Tejas__c, To_pay_Yokesh__c
                                                   FROM Personal_User_Profile__c
                                                   WHERE Master__c =:payDel.Wallet_From__c];
                    
                    payUsr.Pair_Shared_Expense__c = payUsr.Pair_Shared_Expense__c - payDel.Amount__c;
                    if(getUsr.Name == 'Aravindh'){
                        payUsr.To_pay_Aravindh__c =payUsr.To_pay_Aravindh__c + payDel.Amount__c;
                    }
                    if(getUsr.Name == 'Yokesh'){
                        payUsr.To_pay_Yokesh__c = payUsr.To_pay_Yokesh__c + payDel.Amount__c;
                    }
                    if(getUsr.Name == 'Tejas'){
                        payUsr.To_pay_Tejas__c = payUsr.To_pay_Tejas__c + payDel.Amount__c;
                    }
                    update payUsr;
                }
            }
        }
    }
}