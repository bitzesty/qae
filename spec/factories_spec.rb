require "rails_helper"

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "#{factory_name} factory" do
    it "should be valid" do
      unless factory_name == :settings
        expect(build(factory_name)).to be_valid
      end
    end
  end
end
