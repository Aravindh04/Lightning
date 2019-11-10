({
	doInit : function(component, event, helper) {
       	helper.callServer(component,"c.getExp",function(result){
            component.set("v.expence",result);
        });
        helper.callServer(component,"c.getExp1",function(result){
            component.set("v.expenceMonth",result);
        });
        helper.callServer(component,"c.getUserMaster",function(result){
            component.set("v.userMas",result);
        });
        helper.callServer(component,"c.getShare",function(result){
            component.set("v.Shares",result);
        });
        
    },
    
    showTran : function(component, event, helper) {
        var totalAmt = 0;
        var temp = component.get("v.expenceMonth[0].Amount__c");  
        alert('temp'+ temp);
        var length = component.get("v.expenceMonth.length");
		for(var i=0;i<length;i++){
            temp = component.get("v.expenceMonth[i].Amount__c");  
            totalAmt = temp + totalAmt;
        }
        component.set("v.monthlyAmount",totalAmt);
        component.set("v.showMonthlytran",true);
        alert('length'+ length);
        
        alert('totalAmt'+ totalAmt);
                
    }
})