class CreateInstitutionTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :institution_types do |t|
      t.string :InstitutionTypeName
      t.references :Institutions, foreign_key: true

      t.timestamps
    end
  end
end
