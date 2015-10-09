describe 'Map' do
  beforeEach do
    @map = new Map
  end

  describe 'intialize map' do
    it 'new map should have the expected attibutes' do
      expect(@map.keys).to include(overpassPrefix)
    end

  end
end
