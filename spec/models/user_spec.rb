require 'rails_helper'

RSpec.describe User, type: :model do
  describe "model validations" do
    it "must have a username" do
      user = build :user, username: nil

      expect(user).not_to be_valid
      expect(user.errors.keys).to include(:username)
    end

    it "username must be unique" do
      create :user
      user = build :user

      expect(user).not_to be_valid
      expect(user.errors.keys).to include(:username)
    end

    it "must have an email address" do
      user = build :user, email: nil

      expect(user).not_to be_valid
      expect(user.errors.keys).to include(:email)
    end

    it "email address must be unique" do
      create :user
      user = build :user

      expect(user).not_to be_valid
      expect(user.errors.keys).to include(:email)
    end

    context "email address must contain an '@' followed by a '.'" do

      it "does not validate invalid email addresses" do
        invalid_emails = ["hi@com", "hi.hi.com", "roundhouse"]
        invalid_emails.each do |email|
          user = build :user, username: email, email: email
          expect(user).not_to be_valid
          expect(user.errors.keys).to include(:email)
        end
      end

      it "accepts valid email addresses" do
        valid_emails = ["hi@hi.com",
                        "he110@hacker.net",
                        "hi.there@unigoats.edu",
                        "ada.rocks@rock.star"]
        valid_emails.each do |email|
          user = create :user, username: email, email: email
          expect(user).to be_valid
          expect(user.errors.keys).not_to include(:email)
        end
      end
    end

    it "can have a location" do
      location = create :location
      user = create :user
      user.locations << location

      expect(user.locations).to include(location)
      expect(user.locations.count).to be 1
    end

    it "can have multiple locations" do
      location1 = create :location
      location2 = create :location, latitude: 34.234, longitude: 4.343
      location3 = create :location, latitude: 54.323, longitude: 44.343

      user = create :user
      user.locations << [ location1, location2, location3 ]

      expect(user.locations).to include(location1)
      expect(user.locations).to include(location2)
      expect(user.locations).to include(location3)
      expect(user.locations.count).to be 3
    end
  end
end
