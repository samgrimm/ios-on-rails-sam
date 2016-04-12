require 'spec_helper'
require 'rails_helper'

describe 'GET /v1/events/:id' do
	it 'returns an event by :id' do
		event = FactoryGirl.create(:event)

		get "/v1/events/#{event.id}"

		expect(JSON.parse(response.body)).to eq(
			{
			'address' => event.address,
			'ended_at' => event.ended_at,
			'id' => event.id,
			'lat' => event.lat,
			'lon' => event.lon,
			'name' => event.name,
			'started_at' => event.started_at.as_json,
			'owner' => {
				'id' => event.owner.id
				}
			}
		)
	end
end

describe 'POST /v1/events' do 
	it 'saves address, lat, lon, name, and started_at date'  do
		date = Time.zone.now
    	device_token = '123abcd456xyz'
    	owner = FactoryGirl.create(:user, device_token: device_token)
    	post '/v1/events', {
	      address: '123 Example St.',
	      ended_at: date,
	      lat: 1.0,
	      lon: 1.0,
	      name: 'Fun Place!!',
	      started_at: date,
	      owner: {
	        id: owner.id
      		}
    	}.to_json,
    	set_headers(device_token)
    	event = Event.last
	    expect(JSON.parse(response.body)).to eq({ 'id' => event.id })
	    expect(event.address).to eq '123 Example St.'
	    expect(event.ended_at.to_i).to eq date.to_i
	    expect(event.lat).to eq 1.0
	    expect(event.lon).to eq 1.0
	    expect(event.name).to eq 'Fun Place!!'
	    expect(event.started_at.to_i).to eq date.to_i
	    expect(event.owner).to eq owner
	end

	it 'returns an error message when invalid' do
		device_token = '123abcd456xyz'

    	post '/v1/events', {}.to_json, set_headers(device_token)
    	expect(JSON.parse(response.body)).to eq({
      		'message' => 'Validation Failed',
      		'errors' => [
        		"Lat can't be blank",
        		"Lon can't be blank",
        		"Name can't be blank",
        		"Started at can't be blank"
      		]
    	})
    	expect(response.code.to_i).to eq 422

	end
end

describe 'PATCH /v1/events/:id' do
	it 'updates the event attributes' do
		event = FactoryGirl.create(:event, name: "Old Name")
		new_name = 'New name'
		patch "/v1/events/#{event.id}", {
      		address: event.address,
      		ended_at: event.ended_at,
      		lat: event.lat,
      		lon: event.lon,
      		name: new_name,
      		owner: {
        		id: event.owner.id
      		},
      		started_at: event.started_at
    	}.to_json,
    	set_headers(event.owner.device_token)
    	event.reload
    	expect(event.name).to eq new_name
    	expect(JSON.parse(response.body)).to eq({ 'id' => event.id })

	end

	it 'returns an error message when invalid' do
		event = FactoryGirl.create(:event)
		patch "/v1/events/#{event.id}", {
      		address: event.address,
      		ended_at: event.ended_at,
      		lat: event.lat,
      		lon: event.lon,
      		name: nil,
      		owner: {
        		id: event.owner.id
      		},
      		started_at: event.started_at
    	}.to_json,
    	set_headers(event.owner.device_token)
    	event.reload
    	expect(event.name).to_not be nil
     	expect(JSON.parse(response.body)).to eq({
       		'message' => 'Validation Failed',
       		'errors' => [
         	"Name can't be blank"
       		]
     	})
     expect(response.code.to_i).to eq 422

	end
end
