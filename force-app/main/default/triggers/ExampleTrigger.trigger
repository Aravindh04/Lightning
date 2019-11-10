trigger ExampleTrigger on Contact (before insert) {
    if(Trigger.isInsert){
        Integer recordCount = Trigger.New.size();
        EmailManager.sendMail(new string[]{'aravindh.vijayakumar@accenture.com'},  new string[]{'Trailhead Trigger Tutorial'}, new string[]{recordCount + ' contact(s) were inserted.'});
    }

}