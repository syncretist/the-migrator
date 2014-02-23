class TestSession
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :session_date, Date
  property :organizations_scheduled, String

  def session_date=date
    super Date.strptime(date, '%m/%d/%Y')
  end

  def organization_list
    self.organizations_scheduled.split(' ')
  end
end