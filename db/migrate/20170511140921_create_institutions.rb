class CreateInstitutions < ActiveRecord::Migration[5.0]
  def change
    create_table :institutions do |t|
      t.string :InstitutionName

      t.timestamps
    end
  end
end
