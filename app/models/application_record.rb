class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.random
    id = self.pluck(:id).sample
    rand_record = self.find(id)
  end
end
