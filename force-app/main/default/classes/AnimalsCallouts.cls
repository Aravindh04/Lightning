public class AnimalsCallouts {
    public static HttpResponse makeGetCallout() {
        Http http = new Http();
		HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('GET');
        HttpResponse hres=http.send(request);
        if(hres.getStatusCode() == 200){
            Map<String, Object> mResults = ( Map<String, Object> )JSON.deserializeUntyped(hres.getBody());
            List<Object> animals = (List<Object>) mResults.get('animals');
            for(Object animal : animals){
                system.debug(animal);
            }
        }
        return hres;
    }
    public static HttpResponse makePostCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"name":"mighty moose"}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        return response;
    }        
}