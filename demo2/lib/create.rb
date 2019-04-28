require 'aws-sdk-dynamodb'
require 'json'
require 'securerandom'
require 'date'

module Create
  module_function

  @uuid
  @body

  def dynamo
    Aws::DynamoDB::Client.new(region: ENV['REGION'])
  end

  def now
    DateTime.now.strftime('%Y%m%dT%H%M%S%LZ')
  end

  def item
    {
      id: uuid,
      data: body,
        info: {
          timestamp: now
        }
    }
  end

  def uuid
    @uuid
  end

  def set_uuid
    @uuid = SecureRandom.uuid
  end

  def body
    @body
  end

  def extract_data(event)
    begin
      @body = JSON.parse(event['body'])
    rescue StandardError => e
      puts "Could not parse JSON, error #{e}"
      raise StandardError
    end
  end

  def params
    {
        table_name: ENV['DYNAMO'],
        item: item
    }
  end

  def handler(event:, context:)
    #when you have to see the whole message:
    #puts event.inspect
    begin
      set_uuid
      extract_data(event)
      dynamo.put_item(params)
      puts 'Added entry: ' + uuid.to_s
      { statusCode: 200, body: JSON.generate("Entry created successfully. ID: #{uuid}") }
    rescue  Aws::DynamoDB::Errors::ServiceError => error
      puts 'Unable to add item: ' + uuid.to_s
      puts error.message
      { statusCode: 500, body: JSON.generate(':( It failed! ') }
    end
  end
end
