@isTest
global class AnimalsHttpCalloutMock implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-type','application/json');
        response.setBody('{"animals" : ["Majestic bear","fluffy rabbit","jumbo elephant"]}');
		response.setStatusCode(200);
        return response;
    }
    
}