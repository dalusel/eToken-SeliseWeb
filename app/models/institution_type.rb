class InstitutionType < ApplicationRecord
	  belongs_to :Institutions, optional: true
      has_many :Place
end
