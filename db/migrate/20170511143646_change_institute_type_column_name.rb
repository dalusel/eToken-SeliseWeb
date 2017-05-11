class ChangeInstituteTypeColumnName < ActiveRecord::Migration[5.0]
  def change
  	rename_column :institution_types, :Institutions_id, :Institution_id
  end
end
