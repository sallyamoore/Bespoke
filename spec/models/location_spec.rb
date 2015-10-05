require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "model validations" do
    it "must have latitude" do
      location = build :location, latitude: nil

      expect(location).not_to be_valid
      expect(location.errors.keys).to include(:latitude)
    end

    it "requires latitude to be numeric" do
      location = build :location, latitude: "latitude!"

      expect(location).not_to be_valid
      expect(location.errors.keys).to include(:latitude)
    end

    it "must have longitude" do
      location = build :location, latitude: nil

      expect(location).not_to be_valid
      expect(location.errors.keys).to include(:latitude)
    end

    it "requires longitude to be numeric" do
      location = build :location, longitude: "longitude!"

      expect(location).not_to be_valid
      expect(location.errors.keys).to include(:longitude)
    end

    it "requires node_number to be an integer between 1 and 99" do
      invalid_node_numbers = [ "weee!", 193, 0, 100 ]
      invalid_node_numbers.each do |node_number|
        location = build :location, node_number: node_number
        expect(location).not_to be_valid
        expect(location.errors.keys).to include(:node_number)
      end
    end

  end


end
