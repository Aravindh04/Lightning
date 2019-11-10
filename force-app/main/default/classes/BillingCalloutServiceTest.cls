@isTest
private class BillingCalloutServiceTest {
    
    @testSetup
    static void setUpData() {
        
        insert new ServiceCredentials__c(
            Name = 'BillingServiceCredential',
            Username__c = 'TestUser',
            Password__c = 'qwerty123&*('
        );
        
        List<Account> accountsToInsert = new List<Account>();
        for ( Integer i = 0; 100 > i; i++ ) {
            accountsToInsert.add( 
                new Account(
                    Name = 'Test data ' + i
                )
            );
        }
        
        insert accountsToInsert;
        
        List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
        
        // Iterating over accounts, to prepare the opportunities that will be inserted
        for(Account thisAcc : accountsToInsert) {
            opportunitiesToInsert.add(  
                new Opportunity(
                    CloseDate = Date.today().addDays(15),
                    Name = 'Test Opportunity ' + thisAcc.Name,
                    AccountId = thisAcc.Id,
                    Amount = 100000,
                    StageName = 'Prospecting'
                ) 
            );
        }
        
        insert opportunitiesToInsert;  
        
        List<Project__c> projectsToInsert = new List<Project__c>();
        
        for(Opportunity thisAcc : opportunitiesToInsert ) {
            projectsToInsert.add( 
                new Project__c(
                    Name = 'Test Project' + thisAcc.Name,
                    Billable_Amount__c = 1000,        
                    ProjectRef__c = 'TestRef ' + thisAcc.Name,
                    Status__c = 'Running',
                    Opportunity__c = thisAcc.Id 
                )
            );
        }
        
        insert projectsToInsert;
    }
    
    testMethod static void callBillingServiceSuccessTest() {
        Test.setMock( WebServiceMock.class, new BillingCalloutServiceMock() ); 
        
        Test.startTest();
        List<Project__c> existingProjects = [SELECT Name, Billable_Amount__c, ProjectRef__c, Status__c, Opportunity__c
                                             FROM Project__c];
        
        List<Project__c> projectsToUpdate = new List<Project__c>();
        for(Project__c thisProj : existingProjects) {
            projectsToUpdate.add(
                new Project__c(
                    Id = thisProj.Id,
                    Status__c = 'Billable'
                )
            );
        }
        
        Update projectsToUpdate;
        
        
        
        Test.stopTest();
        
        // Confirming that records were updated
        for ( Project__c updatedProjects: [SELECT Status__c FROM Project__c ] ) {
            System.assertEquals( 'Billed', updatedProjects.Status__c );
        }
    }
    
    
    testMethod static void callBillingServiceFailureTest() {
        
        Test.setMock( WebServiceMock.class, new BillingCalloutServiceMockFailure() ); 
        
        Test.startTest();
        List<Project__c> existingProjects = [SELECT Name, Billable_Amount__c, ProjectRef__c, Status__c, Opportunity__c
                                             FROM Project__c];
        
        List<Project__c> projectsToUpdate = new List<Project__c>();
        for(Project__c thisProj : existingProjects) {	
            projectsToUpdate.add(
                new Project__c(
                    Id = thisProj.Id,
                    Status__c = 'Billable'
                )
            );
        }
        
        Update projectsToUpdate;
        
        
        
        Test.stopTest();
        
        // Confirming that records were updated
        for ( Project__c updatedProjects: [SELECT Status__c FROM Project__c ] ) {
            System.assertnOTEquals( 'Billed', updatedProjects.Status__c );
        }
    }
}