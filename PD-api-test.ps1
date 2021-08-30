$headers=@{}
$headers.Add("accept", "application/vnd.pagerduty+json;version=2")
$headers.Add("content-type", "application/json")
$headers.Add("from", "")
$headers.Add("authorization", "Token token=u+sTpxjNm9emq1yoa-CA")
$response = Invoke-RestMethod -Uri 'https://api.pagerduty.com/users' `
-Method POST -Headers $headers `
-ContentType 'application/json' `
-Body '{"user":{"id":"string","summary":null,"type":"user","self":null,"html_url":null,"name":"kt theapideveloper","email":"kt.theapideveloper@kt.name","time_zone":"Australia/Sydney","color":"yellow","role":"admin","job_title":"Developer","avatar_url":"https://secure.gravatar.com/avatar/1d1a39d4635208d5664082a6c654a73f.png?d=mm&r=PG","description":"Im the API Dev"}}'