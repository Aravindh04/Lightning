({
	mapData : function(component, event, helper) {
        
        var sObj = component.get('v.sObjRec');
        var flds = component.get('v.fieldNames');
        console.log(JSON.stringify(sObj));
        var datalist =[];
        flds.forEach(function(fld){
            var fldValue;
            if(fld.includes('.')){
                var tempFld = fld.split('.');
                fld = tempFld[1];
                var tempItem = sObj[tempFld[0]];
                fldValue = tempItem[fld];
            }else{
                fldValue = sObj[fld];
            }
            
            datalist.push(fldValue);
        });
        console.log('datalist '+datalist);
        component.set('v.fieldData',datalist);
    }
})