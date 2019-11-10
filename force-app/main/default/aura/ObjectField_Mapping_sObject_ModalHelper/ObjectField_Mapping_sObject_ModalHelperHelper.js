({
    splitObject :  function(component,event,helper,data) {
        var cusObj = [];
        var stdObj = [];
        data.forEach(function(object){
            if(helper.isNotBlank(object.value)){
                if(object.value.indexOf('__c') >= 0){
                    cusObj.push(object);
                    console.log('custom '+object.value);
                }else{
                    stdObj.push(object);
                }
            }
        });
        component.set('v.cusObj',cusObj);
        component.set('v.stdObj',stdObj);
    },
    
    isNotBlank : function(checkString) {
        return (checkString != '' && checkString != null &&
                !$A.util.isEmpty(checkString) && !$A.util.isUndefined(checkString));
    },
})