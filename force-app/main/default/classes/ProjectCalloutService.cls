public class ProjectCalloutService {
    private static final String PROJECTSERVICECALLOUT = 'callout:ProjectService';
    private static final String POSTMETHOD = 'POST';
    private static final String CONTENTTYPE = 'Content-Type';
    private static final String JSONTYPE = 'application/json';
    private static final String TOKEN = 'token';
    
    //Complete the implementation for business and callout logic
    @InvocableMethod
	public static void postOpportunityToPMS(List<Id> oppIdsToProcess) {
        List<Opportunity> oppsToSync = [SELECT ID, NAME, ACCOUNT.NAME, CLOSEDATE, AMOUNT
                                        FROM Opportunity
                                        WHERE Id IN :oppIdsToProcess];
        System.enqueueJob(new QueueablePMSCall(oppsToSync));
    }
	
    @future(callout=true)
    public static void doCallout(String unstrucOpportunities) {
        List<Opportunity> oppsToSync = new List<Opportunity>();
        oppsToSync = (List<Opportunity>)JSON.deserialize(unstrucOpportunities, List<Opportunity>.class);
        
        ServiceTokens__c serviceToken = ServiceTokens__c.getvalues('ProjectServiceToken');
        
        Opportunity[] oppsToUpdate = new List<Opportunity>();
        
        Http http = new Http();
        HttpRequest request;
        HttpResponse response;
        
        for(Opportunity opp : oppsToSync) {
            request = new HttpRequest();
            
            request.setEndpoint(PROJECTSERVICECALLOUT);
            
            request.setMethod(POSTMETHOD);
            request.setHeader(CONTENTTYPE, JSONTYPE);
            request.setHeader(TOKEN, serviceToken.Token__c);
            
            request.setBody(JSON.serialize(new POSTJsonWrapper(opp.Id, opp.Name, opp.Account.Name, String.valueOf(opp.CloseDate), opp.Amount)));
            
            response = new HttpResponse();
            try {
                response = http.send(request);
                if (201 == response.getStatusCode()) {
                    oppsToUpdate.add(
                        new Opportunity(Id = opp.Id, StageName = 'Submitted Project')
                    );
                    
                } else {
                    oppsToUpdate.add(
                        new Opportunity(Id = opp.Id, StageName = 'Resubmit Project')
                    );
                }
                
            } Catch(System.CalloutException cEx) {
                System.debug(cEx.getMessage());
            }
        }
        
        if(!oppsToUpdate.isEmpty()) {
            try {
                Update oppsToUpdate;
                
            } Catch(DmlException ex) {
                System.debug(ex);
            }
        }
        
        
    }
   
    
    public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        List<Opportunity> oppsToSync;
        public QueueablePMSCall(List<Opportunity> oppsToSync) {
            this.oppsToSync = oppsToSync;
        }
        
        public void execute(QueueableContext qc) {
            doCallout(JSON.serialize(oppsToSync));
        }
        
    }
    
    
    public class POSTJsonWrapper {
        public String opportunityId;
        public String opportunityName;
        public String accountName;
        public String closeDate;
        public Decimal amount;
        
        public POSTJsonWrapper( String opportunityId, String opportunityName, 
                                  String accountName, String closeDate, Decimal amount) 
        {
            this.opportunityId = opportunityId;
            this.opportunityName = opportunityName;
            this.accountName = accountName;
            this.closeDate = closeDate;
            this.amount = amount;
        }
    }
}