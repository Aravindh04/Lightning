@isTest
private class ProjectCalloutServiceTest {
    @testSetup
    public static void setupData() {
        ServiceTokens__c newServiceToken = new ServiceTokens__c();
        newServiceToken.Name = 'ProjectServiceToken';
        newServiceToken.Token__c = 'TestingPurpose';
        insert newServiceToken;
        
        List<Account> accountsToInsert = new List<Account>();
        
        for (Integer i = 0;  50 > i; i++) {
            accountsToInsert.add( 
                new Account(
                    Name = 'Test Account ' + i
                ) 
            );
        }
        
        Insert accountsToInsert;
        
        List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
        
        // Iterating over accounts, to prepare the opportunities that will be inserted
        for ( Account acc: accountsToInsert ) {
            opportunitiesToInsert.add( 
                new Opportunity(
                    CloseDate = Date.today().addDays(15),
                    Name = 'Test Opportunity ' + acc.Name,
                    AccountId = acc.Id,
                    Amount = 100000,
                    StageName = 'Prospecting'
                ) 
            );
        }
        
        Insert opportunitiesToInsert;
    }
    
    @isTest
    public static void testProjectCalloutSuccess() {
        
        List<Opportunity> opportunitiesCreated = [SELECT CloseDate, Name, AccountId, Amount, StageName FROM Opportunity];
        
        List<Id> oppIds = new List<Id>();
        for ( Opportunity opp : opportunitiesCreated ) {
            oppIds.add(opp.Id);
        }
        
        //Calling the invocable method
        ProjectCalloutService.postOpportunityToPMS(oppIds);
        
        // Testing the Queuable Job
        Test.startTest();        
        
        Test.setMock( HttpCalloutMock.class, new ProjectCalloutServiceMock() );
        System.enqueueJob(new ProjectCalloutService.QueueablePMSCall(opportunitiesCreated));
        ProjectCalloutService.doCallout(JSON.serialize(opportunitiesCreated));        
        
        Test.stopTest();
        
        //Verifying
        for ( Opportunity updatedOpp : [ SELECT StageName FROM Opportunity ] ) {
            System.assertEquals( 'Submitted Project', updatedOpp.StageName , 'something went wrong' ); 
        }
    }
    
    @isTest
    public static void testProjectCalloutFailure() {
        
        List<Opportunity> opportunitiesCreated = [SELECT CloseDate, Name, AccountId, Amount, StageName FROM Opportunity];
        
        List<Id> oppIds = new List<Id>();
        for ( Opportunity opp : opportunitiesCreated ) {
            oppIds.add(opp.Id);
        }
        
        //Calling the invocable method
        ProjectCalloutService.postOpportunityToPMS(oppIds);
        
        
        Test.startTest();        
        
        Test.setMock( HttpCalloutMock.class, new ProjectCalloutServiceMockFailure() );
        
        //Queue processing
        System.enqueueJob(new ProjectCalloutService.QueueablePMSCall(opportunitiesCreated) );
        
        //Calling the future method, out of the test context | Asynchronous
        ProjectCalloutService.doCallout(JSON.serialize(opportunitiesCreated));
        Test.stopTest();
        
        //Verifying
        for ( Opportunity updatedOpp : [SELECT StageName FROM Opportunity] ) {
            System.assertEquals('Resubmit Project', updatedOpp.StageName, 'something went wrong'); 
        }
    }    
}