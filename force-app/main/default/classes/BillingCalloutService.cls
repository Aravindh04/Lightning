public class BillingCalloutService {
    private static final String PROJECTSERVICECALLOUT = 'callout:ProjectService';
    private static final String POSTMETHOD = 'POST';
    private static final String CONTENTTYPE = 'Content-Type';
    private static final String JSONTYPE = 'application/json';
    private static final String TOKEN = 'token';
    private static final String BILLINGSERVICEENDPOINT ='http://sb-integration-bs.herokuapp.com';
    
    public static void callBillingService(Map<Id, Project__c> projectOldMap, Map<Id, Project__c> projectNewMap) {
        List<Project__c> projectsUpdated = new List<Project__c>();
        Project__c oldProject;
        for(Project__c newProject : projectNewMap.values()) {
            oldProject = projectOldMap.get(newProject.Id);
            if ( newProject.Status__c.equals('Billable') && newProject.Status__c != oldProject.Status__c ) {
                projectsUpdated.add(newProject);
            }
        }
        
        if(!projectsUpdated.isEmpty()) {
            doCallout(JSON.serialize(projectsUpdated));
        }
        
    }
    
    
    
    @future(callout = true)
    public static void doCallout(String projectsToShareJSON) {
        List<Project__c> projectsToShare = (List<Project__c>)JSON.deserialize(projectsToShareJSON, List<Project__c>.class);
        ServiceCredentials__c serviceCreds = ServiceCredentials__c.getInstance('BillingServiceCredential');
        
        Project__c[] projectsBilled = new List<Project__c> ();
        
        HttpRequest request = new HttpRequest();
        
        BillingServiceProxy.project project;
        for(Project__c thisProject : projectsToShare) {
            project = new BillingServiceProxy.project();
            project.username = serviceCreds.Username__c;
            project.password = serviceCreds.Password__c;
            project.projectid = thisProject.ProjectRef__c;
            project.billAmount =  thisProject.Billable_Amount__c;
            
            String response =  new BillingServiceProxy.InvoicesPortSoap11().billProject(project);
            
            if(response.equals('OK')) {
                thisProject.Status__c = 'Billed';
                projectsBilled.add(thisProject);
                
            } else {
                System.debug('Unable to update the Flow');
            }
        }
        
        if(!projectsBilled.isEmpty()) {
            Update projectsBilled;
        }
    }
}