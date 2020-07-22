import requests 
import sys
def getAccessToken(URL,clientid,clientsecret,scope):
    # header is given here 
    request_header = {'content-type': 'application/x-www-form-urlencoded'}
    request_data = {'grant_type':'client_credentials','client_id':clientid,'client_secret':clientsecret,'scope':scope } 
    # sending post request and saving the response as response object 
    r = requests.post(url = URL,data=request_data,headers = request_header) 
    # extracting data in json format 
    data = r.json() 
    access_token= data['access_token']
    return access_token
  
  
def main():
    url= sys.argv[1]
    clientid= sys.argv[2]
    clientsecret=sys.argv[3]
    scope=sys.argv[4]
    request_header = {'content-type': 'application/x-www-form-urlencoded'}
    print(getAccessToken(url,clientid,clientsecret,scope))
main()
  
