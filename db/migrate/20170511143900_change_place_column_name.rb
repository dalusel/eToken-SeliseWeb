class ChangePlaceColumnName < ActiveRecord::Migration[5.0]
  def change
  		rename_column :places, :InstitutionTypes_id, :Institution_Type_id
  end
end
