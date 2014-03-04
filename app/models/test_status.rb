class TestStatus
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :organization_id, Integer
  property :test_name, String
  property :outcome_reason, Json
  property :test_status, Json
end