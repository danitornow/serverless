# Demo Part 3

Adding more of the CRUD, so we can see a few more handlers and a few more serverless entries.

Endpoints in this demo:
```
endpoints:
  POST - https://<randomstringhere>.execute-api.us-east-2.amazonaws.com/demo3/create
  PUT - https://<randomstringhere>.execute-api.us-east-2.amazonaws.com/demo3/update/{uuid}
  DELETE - https://<randomstringhere>.execute-api.us-east-2.amazonaws.com/demo3/delete/{uuid}
  GET - https://<randomstringhere>.execute-api.us-east-2.amazonaws.com/demo3/list
  GET - https://<randomstringhere>.execute-api.us-east-2.amazonaws.com/demo3/list/{id}
```

Payload sample for /create:
`{"fruit":"orange"}`

Payload sample for /update:
`{"status":"done"}`


