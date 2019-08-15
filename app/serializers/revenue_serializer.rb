class RevenueSerializer
  include FastJsonapi::ObjectSerializer
  attribute :total_revenue do |obj|
    obj.revenue.to_s
  end
end
