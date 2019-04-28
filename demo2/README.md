#Demo Part 2

We're going to add some API endpoints and change the handler! GO TEAM

You'll want to install the dependancies. For ruby, I used bundle. 

`bundle install`

Try a message, maybe with postman. Get the endpoint from the SLS deploy and send some JSON. i.e.

`{"id":"12345"}`

Try watching your logs live by running:

`sls logs --stage <stagename> --function create --aws-profile <profilename> -t`
