require 'csv'

task :import => [:environment] do
  merchant_file = "db/csv/customers.csv"
  merchant_file = "db/csv/invoice_items.csv"
  merchant_file = "db/csv/invoices.csv"
  merchant_file = "db/csv/items.csv"
  merchant_file = "db/csv/merchants.csv"
  merchant_file = "db/csv/transactions.csv"

  CSV.foreach(merchant_file, :headers => true) do |row|
    Merchant.create!(row.to_hash)
  end
end
