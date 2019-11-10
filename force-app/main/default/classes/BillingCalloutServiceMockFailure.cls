@isTest
global class BillingCalloutServiceMockFailure implements WebServiceMock {
    
    private final BillingServiceProxy.billProjectResponse_element responseElement;
    
    global BillingCalloutServiceMockFailure() {
        responseElement = new BillingServiceProxy.billProjectResponse_element();
        responseElement.status = 'UNAUTHORIZED';
    }
    
    global void doInvoke(
        Object stub, Object request,	
        Map<String, Object> response,
        String endPoint, String soapAction,
        String requestName, String reponseNS,
        String responseName, String responseType
    )
    {
        response.put('response_x', responseElement);
    }
    
}