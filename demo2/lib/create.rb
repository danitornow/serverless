require 'aws-sdk'
require 'json'

module Create
  def dynamo
    Aws::DynamoDB::Client.new(region: ENV['REGION'])
  end

  def handler(event:, context:)
    p "Create your dynamo entry here"
    { statusCode: 200, body: JSON.generate('Entry created successfully') }
  end

end
