require 'rails_helper'

RSpec.describe Merchant do
  describe 'Relationships' do
    it {should have_many :items}
    it {should have_many :invoices}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
  end

  describe 'Methods' do
    before :each do
      @josh = Merchant.create!(name: 'Josh')
      @alex = Merchant.create!(name: 'Alex')
    end

    it '.random' do
      merchant = Merchant.random

      expect([@josh.id, @alex.id]).to include(merchant.id)
      expect([@josh.name, @alex.name]).to include(merchant.name)
    end
  end
end
