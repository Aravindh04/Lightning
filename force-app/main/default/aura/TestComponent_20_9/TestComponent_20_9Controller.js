({
	handleClick : function(component,event,helper) {
        helper.testThebutton(component,event);
        /*try{
            var source = event.getSource().get('v.variant');
            alert('Source : '+source); 
            helper.testThebutton(component);
        }catch(e){
            
        }
        if(source= 'success'){
            console.log('Perform an action of \'success\'');
        }else if(source= 'destructive'){
            console.log('Perform an action of \'destructive\'');
        }
        
        /*Integer x = 1;
        float y=2.2;
        string z= 'xxx';*/
        /*var
        let*/
        
    },

    handleClick2 : function(component,event,helper) {
        helper.testThebutton(component,event);
    }
})