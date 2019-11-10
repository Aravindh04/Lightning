public class CalloutClass {
    @future(callout=true)
    public static void makeCallout() {
        
        JSONGenerator jsonGenerate = JSON.createGenerator(true);  //Creating JSON with the given Input Details
        jsonGenerate.writeStartObject();
        jsonGenerate.writeStringField('path','/'+'TestFolder');
        jsonGenerate.writeBooleanField('autorename',False);
        jsonGenerate.writeEndObject();
        
        String jsonReqString = jsonGenerate.getAsString();  //Keeping constructed JSON in a variable 
        system.debug('jsonReqString'+jsonReqString);
        	
        //create Folder 
        HttpRequest request = new HttpRequest();
        
        String endpoint = 'https://api.dropboxapi.com/2/files/create_folder_v2'; 
        request.setEndpoint(endpoint);
        request.setHeader('Authorization', 'Bearer ' +'JWTBQh8CCaAAAAAAAAAASB7umCyZd8nk-E-_uOuafwrVG4nVmpCrVUweCCaQSQc8'); // access token stored in label
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
        request.setbody(jsonReqString );
        request.setTimeout(60000);
        Http h = new Http();
        HttpResponse response = new HTTP().send(request);
        
    }
}