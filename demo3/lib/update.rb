require 'aws-sdk-dynamodb'
require 'json'

module Update
  module_function

  @uuid
  @body

  def dynamo
    Aws::DynamoDB::Client.new(region: ENV['REGION'])
  end

  def uuid
    @uuid
  end

  def body
    @body
  end

  def extract_data(event)
    @uuid = event['pathParameters']['uuid']
    @body = JSON.parse(event['body'])
  end

  def params
    {
      table_name: ENV['DYNAMODB_TABLE'],
      key: {
        id: uuid
      },
      update_expression: 'set info.status_update = :s',
      expression_attribute_values: {':s' => body['status'].to_s},
      return_values: 'UPDATED_NEW'
    }
  end

  def handler(event:, context:)
    #when you have to see the whole message:
    #puts event.inspect
    begin
      p extract_data(event)
      p params
      p dynamo.update_item(params)
      puts 'Updated entry: ' + uuid.to_s
      { statusCode: 200, body: JSON.generate("Entry updated successfully. ID: #{uuid}") }
    rescue StandardError => e
      puts "Could not handle message, error #{e}"
      { statusCode: 500, body: JSON.generate('Your message is bad. Did you include a JSON with status?') }
    rescue  Aws::DynamoDB::Errors::ServiceError => error
      puts 'Unable to add item: ' + uuid.to_s
      puts error.message
      { statusCode: 500, body: JSON.generate('Could not insert entry. Oopsie.') }
    end
  end
end
