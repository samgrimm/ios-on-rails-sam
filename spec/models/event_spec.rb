require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "Validations" do
  	it { should validate_presence_of(:lat) }
  	it { should validate_presence_of(:lon) }
  	it { should validate_presence_of(:name) }
  	it { should validate_presence_of(:started_at) }
  end
  describe "associations" do 
  	it { should have_many(:attendances) }
  	it { should belong_to(:owner).class_name('User') }
  end

end
