require 'aws-sdk-dynamodb'

module Get
  module_function

  @uuid

  def dynamo
    Aws::DynamoDB::Client.new(region: ENV['REGION'])
  end

  def params
    {
      table_name: ENV['DYNAMODB_TABLE'],
      key: {
        id: uuid
      }
    }
  end

  def uuid
    @uuid
  end

  def extract_data(event)
    @uuid = event['pathParameters']['id']
  end

  def handler(event:, context:)
    #when you have to see the whole message:
    #puts event.inspect
    begin
      p extract_data(event)
      data = dynamo.get_item(params)
      p data
      { statusCode: 200, body: JSON.generate(data['item']) }
    rescue StandardError => e
      puts "Could not handle message, error #{e}"
      { statusCode: 500, body: JSON.generate('Your request is bad. Maybe a bad uuid?') }
    rescue  Aws::DynamoDB::Errors::ServiceError => e
      puts "Dynamo error:  #{e}"
      { statusCode: 500, body: JSON.generate('Could not find data. Oopsie.') }
    end
  end
end
