require 'rails_helper'

RSpec.describe "javascripts/map-render.js" do
  # NOTE: Marking passing tests with 'it' to avoid too many API calls.
  before :all do
    visit root_path
  end

  xdescribe 'map renders on page', :js => true do
    it "displays the map div" do
      page.has_selector?("#map")
    end
  end

  xdescribe 'shows login overlay', :js => true do
    it "displays the login div" do
      page.has_selector?(".login")
      page.has_selector?(".guest-user")
    end
  end

  xdescribe 'populates bike node icons (.css-icon) from overpass api', :js => true do
    it "shows bike nodes in map view" do
      page.has_selector?(:root_path, ".css-icon")
    end
  end

  xdescribe "register with email" do
    before :all do
      visit root_path
      within('.register') do
        click_link "Register with email"
      end
    end

    it "displays registration page" do
      expect(page).to have_content 'SIGN UP!'
    end
  end

  xdescribe "guest user", :js => true do
    before :each do
      visit root_path
      within('.register') do
        click_link "Continue without logging in"
      end
    end

    it "hides login overlay" do
      expect(page).to_not have_selector '.login'
    end

    it "does not display username or logout button" do
      expect(page).to_not have_selector '.logout'
    end

    it "displays 'login or register' button" do
      expect(page).to have_content 'Login or Register'
    end

    context "clicks 'login or register' button" do
      it "shows login overlay" do
        click_link 'Login or Register'
        expect(page).to have_selector '.login'
      end
    end
  end

  xdescribe "user login process", :type => :feature do
    before :each do
      @user = create :user
      within(".login") do
        fill_in 'Username', :with => @user.username
        fill_in 'Password', :with => @user.password
      end
      click_button 'Log In'
    end

    it "signs in the user" do
      expect(page).to_not have_content 'failed'
    end

    it "hides login overlay" do
      expect(page).to_not have_selector '.login'
    end

    it "shows username" do
      expect(page).to have_content @user.username
    end

    it "shows logout button" do
      expect(page).to have_content 'Logout'
    end

    it "shows nav-bar" do
      expect(page).to have_selector '.nav-bar'
    end
  end


end
