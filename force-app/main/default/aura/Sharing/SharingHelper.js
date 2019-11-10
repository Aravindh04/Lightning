({
    callServer : function(component,method,callback,params) {
        
        //1.Get reference to server side controller Method
        var action = component.get(method);
         
        //2.set parametrs if there are any such
        if(params){
            action.setParams(params);
        }
        
        //3.Register call back function and handle response
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state=="SUCCESS"){
                var result = response.getReturnValue();
                callback.call(this,result);
            }else{
                alert('Error');
            }
            
        });
        
        //4. use Enqueue action and place server call in queue
        $A.enqueueAction(action);
        
    }
})