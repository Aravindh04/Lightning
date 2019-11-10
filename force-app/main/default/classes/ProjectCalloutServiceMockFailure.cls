global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type','application/json');
        response.setStatusCode(204);
        return response;
    }
}