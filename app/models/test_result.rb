class TestResult
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :organization_id, Integer
  property :test_name, String
  property :test_results, String
end