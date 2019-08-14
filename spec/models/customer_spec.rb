require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'Relationships' do
    it {should have_many :invoices}
  end

  describe 'Validations' do
    it {should validate_presence_of :first_name}
    it {should validate_presence_of :last_name}
  end

  it '.customer_on_invoice' do
    josh = create(:customer)
    invoice = create(:invoice)
    invoice.update_attributes(customer_id: josh.id)
    expect(Customer.customer_on_invoice(invoice.id)[0].first_name).to eq(josh.first_name)
    expect(Customer.customer_on_invoice(invoice.id)[0].last_name).to eq(josh.last_name)
    expect(Customer.customer_on_invoice(invoice.id)[0].id).to eq(josh.id)
  end
end
