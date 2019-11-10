global class cAuthURIForAPIReq {
    global String AuthenticationURI= '';
    public cAuthURIForAPIReq(String ClientKey, String RedirectURI){
        String key_ClientId = EncodingUtil.urlEncode(ClientKey, 'UTF-8');
        String redirect_uri = EncodingUtil.urlEncode(RedirectURI, 'UTF-8');
        String response_type = 'code';
        String scope = 'https://www.googleapis.com/auth/drive';
        
        String authuri = 'https://accounts.google.com/o/oauth2/v2/auth?';
        authuri += 'client_id='			+key_ClientId;
        authuri += '&response_type='	+response_type;
        authuri += '&scope='			+scope;
        authuri += '&redirect_uri='		+redirect_uri;
        authuri += '&login_hint=jsmith@example.com';
        authuri += '&access_type=offline';
        //https://accounts.google.com/o/oauth2/v2/authclient_id=841907095075-onjv9mkld4mq534g3meg16c91908f4ki.apps.googleusercontent.com&response_type=code&scope=https://www.googleapis.com/auth/drive&redirect_uri=https%3A%2F%2Faravindhapps-dev-ed--c.visualforce.com%2Fapex%2FGoogleDriveIntegeration&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oauth2-login-demo.example.com/myHome&login_hint=jsmith@example.com&access_type=offline
        AuthenticationURI = authuri;
    }
            
}