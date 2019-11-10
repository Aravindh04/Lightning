public class ContactController {
    
    Public static void createDropboxFolder(String Name){
        HttpRequest req1 = new HttpRequest();
        req1.setEndpoint('https://api.dropbox.com/1/fileops/create_folder?root=sandbox&path=%2Ftest123');
        req1.setHeader('Authorization', 'Bearer ' + 'JWTBQh8CCaAAAAAAAAAAFkEKf0S4_HL6FgEaCooyPs7tWbk1re_LQAa6CgDzUPJW');
        req1.setMethod('POST');
        req1.setTimeout(60000);
        Http h = new Http();
        HttpResponse res1 = h.send(req1);
        string resp1 = res1.getBody();
        System.debug(' createdFolder :: ' + resp1);
        
    }
}