class RevenueSerializer
  include FastJsonapi::ObjectSerializer
  attribute :revenue do |obj|
    sprintf('%.2f', obj.revenue.to_f/100)
  end
end
