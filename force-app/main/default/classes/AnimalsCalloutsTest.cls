@isTest
public class AnimalsCalloutsTest {
    
    @isTest static void testCallouts(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetAnimalResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class,mock);
        HttpResponse testResponse = AnimalsCallouts.makeGetCallout();
        system.assertNotEquals(null,testResponse,'This returned a null response');
        system.assertEquals('application/json;charset=UTF-8', testResponse.getHeader('Content-type'),'The content type is not matching');
        Map<String,object> mResult = (Map<String,Object>) JSON.deserializeUntyped(testResponse.getBody());
        List<Object> animals = (List<Object>) mResult.get('animals');
        system.assertEquals(3, animals.size());
        
    }
    
    @isTest static void testPostCallout() {
        Test.setMock(HttpCalloutMock.class, new AnimalsHttpCalloutMock()); 
        HttpResponse response = AnimalsCallouts.makePostCallout();
        String contentType = response.getHeader('Content-type');
        system.assert(contentType == 'application/json');
        String value = '{"animals" : ["Majestic bear","fluffy rabbit","jumbo elephant"]}';
        system.assertEquals(response.getBody() , value);
        system.assertEquals(200, response.getStatusCode());
        
    }
}