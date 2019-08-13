require 'csv'

task :import => [:environment] do
  customer_file = "db/csv/customers.csv"
  invoice_item_file = "db/csv/invoice_items.csv"
  invoice_file = "db/csv/invoices.csv"
  item_file = "db/csv/items.csv"
  merchant_file = "db/csv/merchants.csv"
  transaction_file = "db/csv/transactions.csv"

  CSV.foreach(customer_file, :headers => true) do |row|
    Customer.create!(row.to_hash)
  end
  p "Customers imported"

  CSV.foreach(merchant_file, :headers => true) do |row|
    Merchant.create!(row.to_hash)
  end
  p "Merchants imported"

  CSV.foreach(invoice_file, :headers => true) do |row|
    Invoice.create!(row.to_hash)
  end
  p "Invoices imported"

  CSV.foreach(item_file, :headers => true) do |row|
    Item.create!(row.to_hash)
  end
  p "Items imported"

  CSV.foreach(invoice_item_file, :headers => true) do |row|
    InvoiceItem.create!(row.to_hash)
  end
  p "Invoice items imported"

  CSV.foreach(transaction_file, :headers => true) do |row|
    Transaction.create!(row.to_hash)
  end
  p "Transactions imported"
end
