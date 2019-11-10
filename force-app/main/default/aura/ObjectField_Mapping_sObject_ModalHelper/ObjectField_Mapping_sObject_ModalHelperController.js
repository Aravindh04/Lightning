({
    doInit : function(component, event, helper) {
        var data = component.get('v.sObjectsList');
        helper.splitObject(component,event,helper,data);
    },
    
    cusCmpView : function(component, event, helper) {
        console.log('params '+JSON.stringify(event.getParams()));
        //component.set(v., event.getParam('checked'));
    },
    
    stdCmpView : function(component, event, helper) {
        console.log('params '+JSON.stringify(event.getParams()));
        //component.set(v., event.getParam('checked'));
    },
    
    showSpinner : function(component, event, helper) {
        
    },
    
    hideSpinner : function(component, event, helper) {
        
    },
    
    searchString : function(component, event, helper){
        var search = component.find('searchIp');
        var str = event.getParam('value').toLowerCase();
        console.log('str '+str);
        var data = component.get('v.sObjectsList');
        var searchData =[];
        data.forEach(function(object){
            var contentValue = object.value.toLowerCase();
            var contentLabel = object.label.toLowerCase();
            if(contentValue.match(str) || contentLabel.match(str)){
                searchData.push(object);
            }
        });
        helper.splitObject(component,event,helper,searchData);        
    },
    
    changeToAPI : function(component, event, helper) {
        var unBrand = component.find('labelBtn');
        unBrand.set('v.variant','neutral');
        var brand = event.getSource();
        brand.set('v.variant','brand');
        component.set('v.viewAPI',true);
    },
    
    changeToLabel : function(component, event, helper) {
        var unBrand = component.find('apiBtn');
        unBrand.set('v.variant','neutral');
        var brand = event.getSource();
        brand.set('v.variant','brand');
        component.set('v.viewAPI',false);
    },
    
    saveSObject : function(component, event, helper) {
        component.getEvent("objectSelected").setParams({
            data: component.get('v.selSObject')
        }).fire();
        component.destroy();
    },
    
    getValue : function(component, event, helper) {
        var val = event.currentTarget.dataset.val;
        var label = event.currentTarget.dataset.label;
        var obj = { 
            value : val,
            label : label
        };
        component.set('v.selSObject',obj);
    },
    
    closeModal : function(component, event, helper) {
        component.destroy();
    },
    
})