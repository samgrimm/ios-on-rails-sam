require 'spec_helper'
require 'rails_helper'

describe 'POST /v1/users' do
	it 'creates a new user' do
		device_token = '123abcd456xyz'
		post '/v1/users', {}, set_headers(device_token)

    	user = User.last
    	expect(JSON.parse(response.body)).to eq(
      	{
        	'device_token' => user.device_token,
        	'id' => user.id
       	}
    )
    end
end