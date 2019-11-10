@isTest
private class ProjectRESTServiceTest {
    @testSetup
    public static void setupData() {
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
    
    testMethod static void postProjectDataSuccessTest() {
        Opportunity oppInserted = [SELECT CloseDate, Name, Amount, StageName FROM Opportunity LIMIT 1]; 
        
        
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/project/';
        request.httpMethod = 'POST';
        
        RestContext.request = request;
        
        String response = ProjectRESTService.postProjectData(
            'Reference', 
            'Sample', 
            String.valueOf(oppInserted.Id), 
            Date.today().addDays(10),
            Date.today().addDays(20),
            10000,
            'Billable'
        );
        
        System.assertEquals('OK', response, 'Unexpected reponse');
    
    }
    
    
    testMethod static void postProjectDataFailureTest() {
        Opportunity oppInserted = [SELECT CloseDate, Name, Amount, StageName FROM Opportunity LIMIT 1]; 
        
        
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/project/';
        request.httpMethod = 'POST';
        
        RestContext.request = request;
        
        String response = ProjectRESTService.postProjectData(
            'Non - Reference', 
            'Invalid Sample', 
            'InvalidId', 
            Date.today().addDays(10),
            Date.today().addDays(20),
            10000,
            'Billable'
        );
        
        System.assertEquals('Invalid id: Using a opp Id that does not exist', response, 'The response should be Invalid id: Using a opp Id that does not exist' );
    
    }
    
}