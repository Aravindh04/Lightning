public with sharing class DropboxUploadController2 {
    
    private String apiKey;
    private String apiSecret;
    private String redirectURI;
    private String Dropbox_Account_endpoint;
    private String Dropbox_files_endpoint;
    private String Dropbox_OAuth_authorize;
    private String Dropbox_OAuth_token;
    private String authorizationCode;
    private String refreshToken;
    
    public String code { get; set; }
    public String username { get; set; }
    public String fileName { get; set; }
    public Blob fileBody { get; set; }
    public Boolean success { get; set; }
    public Boolean connected { get; set; }
    
    public DropboxUploadController2() {
        connected = false;
        success = false;
        apiKey = 'fvvoiqkn5bszwmo'; // this is your dropbox apikey
        apiSecret = '68pq73f8quud9ym'; // this is your dropbox api secret
        redirectURI = 'https://aravindhapps-dev-ed--c.visualforce.com/apex/DropboxUpload'; // url of the vf page in which the dropbox login is done
        Dropbox_Account_endpoint = 'https://api.dropboxapi.com/2/users/get_current_account';
        Dropbox_files_endpoint = 'https://content.dropboxapi.com/2/files/upload';
        Dropbox_OAuth_authorize = 'https://www.dropbox.com/1/oauth2/authorize';
        Dropbox_OAuth_token = 'https://api.dropboxapi.com/1/oauth2/token';
        
        code = ApexPages.currentPage().getParameters().get('code');
        system.debug('code '+code);
        if(code != null) {
            connected = true;
            authorizationCode = code;
            getRefreshToken();
            retrieveUserInfo();
        }
    }
    
    
    public PageReference getAuthorizationCode() {
        String uri = Dropbox_OAuth_authorize +
                     '?client_id=' + apiKey +
                     '&response_type=code' +
                     '&redirect_uri=' + redirectURI;
        PageReference pr = new PageReference(uri);
        pr.setRedirect(true);
        return pr;
    }
    
    private void getRefreshToken() {
        if(authorizationCode != null) {
            try {
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                 
                req.setEndpoint(Dropbox_OAuth_token);  
                string bodyRequest = '';
                bodyRequest = 'code=' + EncodingUtil.urlEncode(authorizationCode, 'UTF-8');
                bodyRequest+= '&grant_type=authorization_code';
                bodyRequest+= '&client_id=' + EncodingUtil.urlEncode(apiKey, 'UTF-8');
                bodyRequest+= '&client_secret=' + EncodingUtil.urlEncode(apiSecret, 'UTF-8');
                bodyRequest+= '&redirect_uri=' + EncodingUtil.urlEncode(redirectURI, 'UTF-8');
                
                
                system.debug('getAccessToken URL '+bodyRequest);
                
                req.setBody(bodyRequest);    
                req.setHeader('Content-length', string.ValueOf(bodyRequest.length()));
                req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                req.setMethod('POST');
                req.setTimeout(60*1000);
                
                HttpResponse res = h.send(req);
                system.debug('response '+res.getBody());
                map<string, string> jsonValues = new map<string, string>();
                jsonValues = parseJSONToMap(res.getBody());
                if(jsonValues.containsKey('error')) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Couldn\'t connect to Dropbox.'));
                }
                else {
                    refreshToken = jsonValues.get('access_token');
                }
            }
            catch(Exception e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Couldn\'t connect to Dropbox.'));
            }
        }
        else 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Couldn\'t connect to Dropbox.'));
    }
    
    
    // method that returns the username of the connected dropbox account
    private void retrieveUserInfo() {
        if(refreshToken != null) {
            try {
                Http h = new Http();
                HttpRequest req = new HttpRequest(); 
                req.setEndpoint(Dropbox_Account_endpoint);
                
                req.setHeader('Authorization', 'Bearer '+refreshToken);	
                //req.setHeader('Content-Type', 'application/json; charset=UTF-8');
                //req.setHeader('Accept','application/json');
                req.setMethod('POST');
                req.setTimeout(60*1000);
                
                HttpResponse res = h.send(req);
                System.debug('userInfo '+res.getBody()+'\n'+res);
                map<string, string> jsonValues = new map<string, string>();
                jsonValues = parseJSONToMap(res.getBody());
                if(jsonValues.containsKey('error')){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Couldn\'t connect to Dropbox.'));
                }
                else {
                     username = jsonValues.get('email');
                }
            }
            catch(Exception e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Couldn\'t connect to Dropbox.'));
            }
        }
        else
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Couldn\'t connect to Dropbox.'));
    }
    
    
    // method that uploads files to dropbox
    public Boolean uploadToDropBox(Blob file, String filename) {
        try {
            /*
            JSONGenerator jsonGenerate = JSON.createGenerator(true);  //Creating JSON with the given Input Details
            jsonGenerate.writeStartObject();
            jsonGenerate.writeStringField('path','/'+'TestFolder');
            jsonGenerate.writeStringField('mode','add');
            jsonGenerate.writeBooleanField('autorename',true);
            jsonGenerate.writeBooleanField('mute',false);
            jsonGenerate.writeBooleanField('strict_conflict',false);
            jsonGenerate.writeEndObject();*/
            String boundary = '----------9889464542212';
            String bodyEncoded = EncodingUtil.base64Encode(file);
            Blob bodyEncoded2 = EncodingUtil.base64Decode(bodyEncoded);
            
            Http http = new Http();
            String x = '{"path": "/TestFolder/'+filename+'","mode": "add","autorename": true,"mute": false,"strict_conflict": false}';
            HttpRequest req = new HttpRequest();
            String endpoint = Dropbox_files_endpoint;
            req.setEndpoint(endpoint);
            req.setHeader('Authorization', 'Bearer '+refreshToken);
            req.setHeader('Content-Type', 'application/octet-stream');
            req.setHeader('Dropbox-API-Arg', x);
            req.setBodyAsBlob(bodyEncoded2);
            req.setMethod('POST');
            req.setTimeout(60*1000);
            HttpResponse resp = http.send(req);
            System.debug('Updload Info '+resp.getBody());
            map<string, string> jsonValues = new map<string, string>();
            jsonValues = parseJSONToMap(resp.getBody());
            if(jsonValues.containsKey('error')){
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:'+jsonValues.get('error'));
               ApexPages.addMessage(myMsg);
               return false;
            }
            else
              return true;
        }
        catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Files couldn\'t be uploaded to Dropbox.'));
            return false;
        }
    }
    
    private map<string, string> parseJSONToMap(string JSONValue){
        JSONParser parser = JSON.createParser(JSONValue);
        map<string, string> jsonMap = new map<string, string>();
        string keyValue = '';
        string tempValue = '';
        while (parser.nextToken() != null) {
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                keyValue = parser.getText();
                parser.nextToken();
                tempValue = parser.getText();
                jsonMap.put(keyValue, tempValue);            
            }
        }
        return jsonMap;
    }
    
    public void uploadFiles() {
        success = uploadToDropBox(fileBody, fileName);
    }

}