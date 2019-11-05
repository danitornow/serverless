require 'aws-sdk-dynamodb'
require 'json'

module List
  module_function

  def dynamo
    Aws::DynamoDB::Client.new(region: ENV['REGION'])
  end

  def params
    {
      table_name: ENV['DYNAMODB_TABLE']
    }
  end

  def handler(event:, context:)
    #when you have to see the whole message:
    #puts event.inspect
    begin
      data = dynamo.scan(params)
      p data
      { statusCode: 200, body: JSON.generate(data['items']) }
    rescue StandardError => e
      puts "Could not handle message, error #{e}"
      { statusCode: 500, body: JSON.generate('Your request is bad.') }
    rescue  Aws::DynamoDB::Errors::ServiceError => e
      puts "Dynamo error:  #{e}"
      { statusCode: 500, body: JSON.generate('Could not find data. Oopsie.') }
    end
  end
end
