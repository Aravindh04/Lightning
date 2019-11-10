({
    onLoad : function(component, event, helper) {
        helper.loadValues(component,'Category__c','v.Category');
        helper.loadValues(component,'Payment_Method__c','v.Payment');
        helper.loadValues(component,'Expense_on__c','v.ExpenceType');
        helper.loadValues(component,'Shared_with__c','v.User');
        helper.loadValues(component,'Wallet_Name__c','v.Wallet');
        helper.loadValues(component,'Bank_Name__c','v.Bank');
    },
    
    setExpenseType : function(component, event, helper) {
        var selectedType = event.getSource();
        var catogery = selectedType.get("v.label");
        console.log('Catogery '+catogery);
        component.set("v.selectedExpenseType",catogery);
        component.set("v.valuesOnExpense.Expense_on__c",catogery);
        
        var temp = component.find("typeId");
        $A.util.addClass(temp,"slds-hide");
        
        var temp2 = component.find("userId");
        $A.util.removeClass(temp2,"slds-hide");
    },
    
    setUser : function(component, event, helper) {
        var selectedUser = event.getSource();
        var User = selectedUser.get("v.label");
        console.log('User '+User);
        component.set("v.selectedUser",User);
        
        var temp = component.find("userId");
        $A.util.addClass(temp,"slds-hide");
        
        var catogery = component.get("v.valuesOnExpense.Expense_on__c");
        var temp2;
        if(catogery == 'Pair'){
            temp2 = component.find("shareUserId");
        }else{
        	temp2 = component.find("amountId");
        }
        $A.util.removeClass(temp2,"slds-hide");
    },
    
    setSecondUser : function(component, event, helper) {
        var selectedSecUser = event.getSource();
        var shareUser = selectedSecUser.get("v.label");
        console.log('selectedSecondUser '+shareUser);
        component.set("v.selectedSecondUser",shareUser);
        component.set("v.valuesOnExpense.Shared_with__c",shareUser);
        
        var temp = component.find("shareUserId");
        $A.util.addClass(temp,"slds-hide");
        
        var temp2 = component.find("amountId");
        $A.util.removeClass(temp2,"slds-hide");
    },
    
    setAmount : function(component, event, helper) {
        var amount = component.get("v.valuesOnExpense.Amount__c");
        var fldValue = component.find('amountField').get('v.value');
        if(amount != null && fldValue != null){
            var temp = component.find("amountId");
            $A.util.addClass(temp,"slds-hide");
            
            var temp2 = component.find("payId");
            $A.util.removeClass(temp2,"slds-hide");    
        }else if(amount == null || fldValue == null){
            helper.displayToast(component,event, helper, 'Error', 'Please Enter a Valid Amount', 'warning');
        }
        
        
    },
    
    setPayment : function(component, event, helper) {
        var selectedPayMethod = event.getSource();
        var payMethod = selectedPayMethod.get("v.label");
        console.log('Catogery '+payMethod);
        component.set("v.selectedPayment",payMethod);
        component.set("v.valuesOnExpense.Payment_Method__c",payMethod);
        
        var temp = component.find("payId");
        $A.util.addClass(temp,"slds-hide");
        
        var type = temp.get("v.label");
        
        var temp2;
        if(payMethod == 'Card'){
            temp2 = component.find("bankId");
        }else if(payMethod == 'Wallet'){
            temp2 = component.find("walletId");
        }else if(payMethod == 'Cash'){
            temp2 = component.find("catogeryId");
        }
        $A.util.removeClass(temp2,"slds-hide");
    },
    
    setWallet : function(component, event, helper) {
        var walletName = component.find('wallet').get("v.value");
        console.log('walletName '+walletName);
        component.set("v.valuesOnExpense.Wallet_Name__c",walletName);
        
        var temp = component.find("walletId");
        $A.util.addClass(temp,"slds-hide");
        
        var temp2 = component.find("catogeryId");
        $A.util.removeClass(temp2,"slds-hide");
    },
    
    setBank : function(component, event, helper) {
        var bankName = component.find('bank').get("v.value");
        console.log('bankName '+bankName);
        component.set("v.valuesOnExpense.Bank_Name__c",bankName);
        
        var temp = component.find("bankId");
        $A.util.addClass(temp,"slds-hide");
        
        var temp2 = component.find("catogeryId");
        $A.util.removeClass(temp2,"slds-hide");
    },
    
    doSomething : function(component, event, helper) {
        var getOptionValue = component.find('select').get('v.value');
        component.set("v.selectionOption",getOptionValue);
        component.set("v.valuesOnExpense.Category__c",getOptionValue);
        
        var temp1 = component.find("catogeryId");
        $A.util.addClass(temp1,"slds-hide");
        
        var temp5 = component.find("comments");
        //var temp3 = component.find("dateField");
        //var temp4 = component.find("expName");
        $A.util.removeClass(temp5,"slds-hide");
        //$A.util.removeClass(temp3,"slds-hide");
        //$A.util.removeClass(temp4,"slds-hide");
    },
    
    setDefault : function(component, event, helper) {
        var getOptionValue = component.find('select').get('v.value');
        component.set("v.selectionOption",getOptionValue);
        component.set("v.valuesOnExpense.Category__c",getOptionValue);
        
        var temp1 = component.find("catogeryId");
        $A.util.addClass(temp1,"slds-hide");
        
        var temp5 = component.find("comments");
        $A.util.removeClass(temp5,"slds-hide");
    },
    
    setCustom : function(component, event, helper) {
        var temp = component.find("customEdit");
        $A.util.addClass(temp,"slds-hide");
        
        var label = event.getSource().get("v.label");
        console.log('Checking Label '+label);
        
        var temp2;
        if(label == 'Change Date'){
            temp2 = component.find("dateField");
            $A.util.removeClass(temp2,"slds-hide");
        }else if(label == 'Change Expense Name'){
            temp2 = component.find("expName");
            $A.util.removeClass(temp2,"slds-hide");
        }else if(label == 'Quick Save'){
            helper.saveExpense(component,event,helper);
        }
    },
    
    actionSet : function(component, event, helper) {
        var label = event.getSource().get("v.label");
        console.log('Checking Label '+label);
        
        var today = new Date();
        var thisMonth = today.getMonth() +1;
        console.log('thisMonth : '+thisMonth+' today: '+today);
        
        if(label == 'Set Expense Name'){
            var temp = component.find("expName");
            $A.util.addClass(temp,"slds-hide");
        }else if(label == 'Set Date'){
            
            var selectedDate = component.find("selectedDate").get("v.value");
            console.log('selectedDate : '+selectedDate);
            
            if(selectedDate != null){
                var selectedMonth = selectedDate.split('-');
                console.log('selectedMonth :'+selectedMonth[1]);
                
                console.log('selectedDate :'+selectedDate+' selectedMonth : '+selectedMonth+' thisMonth : '+thisMonth);
                if(selectedMonth[1] == thisMonth){
                    //Setting Date
                    console.log(component.get("v.valuesOnExpense.Expense_Date__c"));
                    var temp = component.find("dateField");
                    $A.util.addClass(temp,"slds-hide");
                    //Hiding Values
                    
                }else{
                    helper.displayToast(component,event, helper, 'Error', 'Please pick a Day from Month', 'warning');
                }
            }else{
                var temp = component.find("dateField");
                $A.util.addClass(temp,"slds-hide");
            }
        }
         
        var temp2 = component.find("customEdit");
        $A.util.removeClass(temp2,"slds-hide"); 
    },
    
    
    setComments : function(component, event, helper) {
        var addComments = component.get("v.valuesOnExpense.Comments__c");
        if(addComments != null){
            var temp = component.find("comments");
            $A.util.addClass(temp,"slds-hide");
            
            var temp2 = component.find("customEdit");
            $A.util.removeClass(temp2,"slds-hide");
        }else{
            helper.displayToast(component,event, helper, 'Error', 'Please Enter Valid Comments', 'warning');
        }
    },
    
    save : function(component, event, helper) {
        var temp2 = component.find("customEdit");
        $A.util.addClass(temp2,"slds-hide");
        helper.saveExpense(component,event,helper);
        
    },
    
    resetAll : function(component, event, helper) {
        try{
            $A.get('e.force:refreshView').fire();
        }catch(ex){
            document.location.reload();            
        }
    },
})