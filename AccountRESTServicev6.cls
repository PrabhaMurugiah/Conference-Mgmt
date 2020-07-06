@RESTResource(urlmapping='/v6/accounts/*')
global with sharing class AccountRESTServicev6 {

    @httpPost
    global static PostResponseWrapper doPost(RequestWrapper reqw){
        
        RESTRequest req = RestContext.request;
        RESTResponse res = RESTContext.response;
        PostResponseWrapper postRespw = new PostResponseWrapper();
 
        insert reqw.acc;
        
        for (Contact c:reqw.con)
            c.AccountId = reqw.acc.Id;
        
        insert reqw.con;
        
        postRespw.rw = reqw;
        postRespw.status = 0;
        postRespw.Message = 'Success';
        
        return postRespw;
    }
    
    
    @httpGet
    global static AccountWrapper doGett(){
        RESTRequest req = RESTContext.request;
        RESTResponse res = RESTContext.response;
        AccountWrapper aw=new AccountWrapper();        
        String accId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		System.debug(accId);        
        If (!accId.startsWith('accounts')){
            System.debug('Here');
            List<Account> acc= [select Id,Name from Account where Id=:accId];     
            If (acc.size()<>0){
                aw.wAcc.add(acc[0]);
                aw.status = 0;
                aw.message = 'Success';
            }
            else {
                aw.wAcc=NULL;
                aw.status = 1;
                aw.message = 'Row not found';
            }      
            }
        If (accId.startsWith('accounts')){
        	String accName = '%'+req.params.get('Name')+'%';
            
            List<Account> acc= [select Id,Name from Account where Name like :accName];     
            If (acc.size()<>0){
                aw.wAcc.addAll(acc);
                aw.status = 0;
                aw.message = 'Success';
            }
            else {
                aw.wAcc=NULL;
                aw.status = 1;
                aw.message = 'Rows not found';
            }      
       }
    return aw;
    }
    
    global class AccountWrapper{
        List<Account> wAcc;
        Integer status;
        String message;
        AccountWrapper(){
            wAcc=new List<Account>();
        }
    }
    
        global class RequestWrapper{
        Account acc;
        List<Contact> con;
        }
    
        global class PostResponseWrapper{
        RequestWrapper rw;
        Integer status;
        String message;
        PostResponseWrapper(){
            rw=new RequestWrapper();
        }
    }
    
}