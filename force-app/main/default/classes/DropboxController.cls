public class DropboxController
{
    //Fetched from URL
    String code ;
    
    public DropboxController()
    {
        code = ApexPages.currentPage().getParameters().get('code') ;
        //Get the access token once we have code
        if(code != '' && code != null)
        {
            AccessToken() ;
        }
    }
    
    public PageReference DropAuth()
    {
        //Authenticating
        PageReference pg = new PageReference('https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=vaabb5qz4jv28t5&redirect_uri=https://c.ap1.visual.force.com/apex/DropboxPage&state=Mytesting') ;
        return pg ;
    }
    
    public void AccessToken()
    {
        //Getting access token from dropbox
        String tokenuri = 'https://api.dropbox.com/1/fileops/create_folder?root=production&path=%2Ftest123'; 
        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenuri);
        req.setMethod('POST');
        req.setTimeout(60*1000);
          
        Blob headerValue = Blob.valueOf('vaabb5qz4jv28t5' + ':' + 'dpmmll522bep6pt');
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', 'Bearer ' + 'bXpIHGQ1zQAAAghjghjghjghjjghjdfgAAFGo46RiqyVChuyOEd_K_');
        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        
        System.debug(' You can parse the response to get the access token ::: ' + resp);
   }
}