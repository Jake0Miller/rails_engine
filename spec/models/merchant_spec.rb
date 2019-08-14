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
      @invoice = create(:invoice)
      @invoice.update_attributes(merchant_id: @josh.id)
    end

    it '.random' do
      merchant = Merchant.random

      expect([@josh.id, @alex.id]).to include(merchant.id)
      expect([@josh.name, @alex.name]).to include(merchant.name)
    end

    it '.merchant_on_invoice' do
      expect(Merchant.merchant_on_invoice(@invoice.id)[0].name).to eq(@josh.name)
      expect(Merchant.merchant_on_invoice(@invoice.id)[0].id).to eq(@josh.id)
    end
  end
end
