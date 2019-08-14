class DateSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :day, :name, :qty
end
