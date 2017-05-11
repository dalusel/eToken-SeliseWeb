class CreateETokenDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :e_token_details do |t|
      t.date :RequestDate
      t.string :Name
      t.integer :PhoneNo
      t.integer :TokenNo
      t.references :Institutions, foreign_key: true    
      t.references :InstitutionTypes, foreign_key: true
      t.references :Places, foreign_key: true

      t.timestamps
    end
  end
end
