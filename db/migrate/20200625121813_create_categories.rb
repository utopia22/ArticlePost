class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
    t.string :name, null: false # stringはVARCHAR(255), null: falseでNOT NULL制約
  end
end
end
