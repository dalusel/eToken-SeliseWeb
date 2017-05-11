class CreateEQuota < ActiveRecord::Migration[5.0]
  def change
    create_table :e_quota do |t|
      t.date :StartDate
      t.date :EndDate
      t.integer :TotalToken
      t.references :Places, foreign_key: true
      t.references :InstitutionTypes, foreign_key: true

      t.timestamps
    end
  end
end
