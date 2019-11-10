({
	userSelect : function(component, event, helper) {
        var fromUser = component.find('select').get('v.value');
        if(fromUser != null && fromUser != '' ){
        	component.set('v.mailFrom', fromUser);    
        }else{
            helper.showToast(component, event, helper, 'Invalid','Select a valid user','warning');
        }
      	
    },
    
    sendMail : function(component, event, helper) {
        var subject = 'Message from  '+component.get('v.mailFrom')+' - '+ component.get('v.mailBody');
		helper.callServer(component,'c.sendEmailWithBody',function(result){
            console.log(result);
            var msgType, toastMessage, toastType;
            if(result=='SUCCESS'){
                msgType = 'Success';
                toastMessage = 'Email sent successfully';
                toastType = 'success';
            }else{
                msgType = 'Failed';
                toastMessage = result;
                toastType = 'Error';
            }
            helper.showToast(component, event, helper, msgType,toastMessage,toastType);
            component.set('v.sendTo',[]);
            component.set('v.mailFrom',		''); 
            component.set('v.mailBody',		undefined);
            component.set('v.mailSubject',	undefined);
			           
        },{
            toAddress 		: component.get('v.sendTo'),
            mailBody 		: component.get('v.mailBody'),
            mailSubject 	: subject
        });
    },
    
    addTOAddress : function(component, event, helper) {
        var selUsers = component.get('v.selectedLookUpRecords');
        var toAdd = component.get('v.sendTo');
        console.log('toAdd '+toAdd);
        selUsers.forEach(function(usr){
            if(toAdd.length > 0){
                if(!(toAdd.indexOf(usr.Email__c)>=0)){
                    toAdd.push(usr.Email__c);
                    console.log('IN If condition');
                }
                if(!(toAdd.indexOf(usr.Office_Mail__c))>=0){
                    toAdd.push(usr.Office_Mail__c);
                    console.log('IN else condition');
                }
            }else{
                console.log('Failed If');
                toAdd.push(usr.Email__c);
                toAdd.push(usr.Office_Mail__c);
            }
            
        });
        component.set('v.sendTo',toAdd);
        var lookUp = component.find('lookUpContainer');
        //$A.util.addClass(lookUp,'slds-hide');
    },
    
    handleRemove : function(component, event, helper) {
        var mail = event.getSource().get('v.label');
        console.log('mail '+mail);
        var selUsers = component.get('v.sendTo');
        selUsers.splice(selUsers.indexOf(mail),1);
        component.set('v.sendTo',selUsers);
    },
    
    
})