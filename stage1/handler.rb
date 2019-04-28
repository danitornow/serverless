require 'json'

def hello(event:, context:)
  p "Log message goes here!"
  { statusCode: 200, body: JSON.generate('Go Serverless v1.0! Your function executed successfully!') }
end
