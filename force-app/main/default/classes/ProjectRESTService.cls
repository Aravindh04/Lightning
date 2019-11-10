@RestResource (urlMapping = '/project/*')
global class ProjectRESTService {
    private static string OK = 'OK';
    
    @HttpPost
    global static String  postProjectData(String projectRef, String	projectName, String	opportunityId, Date	startDate, Date	endDate, Double	amount, String	status) {
        
        string response;
        
        System.SavePoint sp = Database.setSavepoint();
        
        try {
            Upsert new Project__c (
                ProjectRef__c 		= projectRef,
                Name 				= projectName,
                Opportunity__c 		= Id.valueOf(opportunityId),
                Start_Date__c 		= startDate,
                End_Date__c  		= endDate,
                Billable_Amount__c  = amount,
                Status__c 			= status
            );
            
            Update new Opportunity(
                Id = Id.valueOf(opportunityId),
                DeliveryInstallationStatus__c = 'In Progress'
            );
            
            response = OK;
            
        } Catch(Exception ex) {
            Database.rollback(sp);
            response = ex.getMessage();
        }
        
        return response;
    }
}