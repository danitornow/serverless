require 'aws-sdk-dynamodb'
require 'json'
require 'securerandom'
require 'date'

module Delete
  module_function

  @uuid
  @body

  def dynamo
    Aws::DynamoDB::Client.new(region: ENV['REGION'])
  end

  def uuid
    @uuid
  end

  def extract_data(event)
    @uuid = event['pathParameters']['uuid']
  end

  def params
    {
      table_name: ENV['DYNAMODB_TABLE'],
      key: {
        id: uuid
      }
    }
  end

  def handler(event:, context:)
    #when you have to see the whole message:
    #puts event.inspect
    begin
      extract_data(event)
      p params
      dynamo.delete_item(params)
      puts 'Deleted entry: ' + uuid.to_s
      { statusCode: 200, body: JSON.generate("Entry deleted successfully. ID: #{uuid}") }
    rescue StandardError => e
      puts "Could not handle message, error #{e}"
      { statusCode: 500, body: JSON.generate('Your message is bad. Is your uuid correct?') }
    rescue  Aws::DynamoDB::Errors::ServiceError => error
      puts 'Unable to delete item: ' + uuid.to_s
      puts error.message
      { statusCode: 500, body: JSON.generate('Could not delete entry. Oopsie.') }
    end
  end
end
