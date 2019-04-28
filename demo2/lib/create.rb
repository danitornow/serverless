require 'aws-sdk-dynamodb'
require 'json'
require 'securerandom'
require 'date'

module Create
  module_function

  @uuid = SecureRandom.uuid

  def dynamo
    Aws::DynamoDB::Client.new(region: ENV['REGION'])
  end

  def uuid
    @uuid
  end

  def now
    DateTime.now.strftime('%Y%m%dT%H%M%S%LZ')
  end

  def item
    {
      id: uuid,
      data: ' Big New Movie',
        info: {
          plot: 'Nothing happens at all.',
          timestamp: date
        }
    }
  end

  def data
    begin
      msg = message(JSON.parse(event['body']))
    rescue StandardError => e
      puts 'Could not parse JSON'
    end
  end

  def params
    {
        table_name: ENV['DYNAMO'],
        item: item
    }
  end

  def handler(event:, context:)
    puts event.inspect
    begin
      dynamo.put_item(params)
      puts 'Added entry: ' + uuid.to_s
      { statusCode: 200, body: JSON.generate('Entry created successfully') }
    rescue  Aws::DynamoDB::Errors::ServiceError => error
      puts 'Unable to add item: ' + uuid.to_s
      puts error.message
      { statusCode: 500, body: JSON.generate('It failed! :(') }
    end
  end
end
