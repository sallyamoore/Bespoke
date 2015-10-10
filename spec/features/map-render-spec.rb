RSpec.describe "javascripts/map-render.js" do
  describe 'some stuff which requires js', :js => true do
    it 'will use the default js driver'
    it 'will switch to one specific driver', :driver => :webkit
  end
end
