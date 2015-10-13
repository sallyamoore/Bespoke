require 'rails_helper'

RSpec.describe "javascripts/map-render.js" do
  describe 'map renders on page', :js => true do
    it "displays the map div" do
      page.has_selector?(:map_path, "#map")
    end
  end

  # queries overpass api
  # renders cyclemap base layer

end
