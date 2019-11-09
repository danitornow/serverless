# frozen_string_literal: true

require 'json'
require 'base64'

module Authorizer
  module_function

  @@username = ''
  @@password = ''

  def authorizer_function(event:, context:)
    #when you have to see the whole message:
    #puts event.inspect
    authorization_header = event['authorizationToken']

    if authorization_header
      encoded_creds = authorization_header.split(' ')[1]
      plain_creds = Base64.decode64(encoded_creds).to_s.partition(':')
      username = plain_creds[0]
      pwd = plain_creds[-1]

      if username == 'demo' && pwd == 'demo12345'
        puts 'Authorization Success'
        build_policy(event, username, 'Allow')
      else
        build_policy(event, username, 'Unauthorized')
      end
    else
      build_policy(event, username, 'Unauthorized')
    end
  end

  def build_policy(event, username, effect)
    if effect == 'Unauthorized'
      raise('Unauthorized')
    end

    tmp = event['methodArn'].split(':')
    api_gateway_arn_tmp = tmp[5].split('/')
    aws_account_id = tmp[4]
    aws_region = tmp[3]
    rest_api_id = api_gateway_arn_tmp[0]
    stage = api_gateway_arn_tmp[1]

    api_arn = 'arn:aws:execute-api:' + aws_region + ':' + aws_account_id + ':' + rest_api_id + '/' + stage + '/*/*'
    policy = {
      principalId: username,
      policyDocument: {
        Version: '2012-10-17',
        Statement: [
          {
            Action: 'execute-api:Invoke',
            Effect: effect,
            Resource: [api_arn]
          }
        ]
      },
      context: {
        'effect': effect
      }
    }

    policy
  end

end
