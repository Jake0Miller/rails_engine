class TotalRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attribute :total_revenue do |obj|
    sprintf('%.2f', obj.revenue.to_f/100)
  end
end
