require "rails_helper"

FactoryBot.factories.map(&:name).each do |factory_name|
  describe "#{factory_name} factory" do
    it "should be valid" do
      expect(build(factory_name)).to be_valid unless factory_name == :settings
    end
  end
end
