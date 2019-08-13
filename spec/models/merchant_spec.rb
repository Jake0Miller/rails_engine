require 'rails_helper'

RSpec.describe Merchant do
  describe 'Relationships' do
    it {should have_many :items}
    it {should have_many :invoices}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
  end

  describe 'Instance Methods' do
    before :each do

    end

    it '.item_count' do

    end
  end
end
