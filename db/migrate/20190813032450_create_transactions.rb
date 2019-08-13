class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :credit_card_number
      t.string :result
      t.string :credit_card_expiration_date

      t.timestamps
    end
  end
end
