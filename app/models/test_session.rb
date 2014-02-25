class TestSession
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :session_date, Date
  property :organizations_scheduled, String

  def session_date=date
    super Date.strptime(date, '%m/%d/%Y')
  end

  def scheduled_organization_list
    self.organizations_scheduled.split(' ')
  end

  def latest_test_results_per_organization(organization_id)
    categories = []
    latest_results = []

    # get all available categories for organization
    TestResult.all(:fields => [:test_name], :organization_id => organization_id, :unique => true).each do |test_name|
      categories << test_name[:test_name]
    end

    # find and add the most recent results per category to latest results
    categories.each do |category|
      current_full_result = TestResult.all(:organization_id => organization_id, :test_name => category, :order => [:created_at.desc] ).first

      #current_organization_id = current_full_result[:organization_id]
      current_test_name        = category
      current_test_results     = current_full_result[:test_results]

      latest_results << { :test_name => current_test_name, :test_results => current_test_results }
    end

    return latest_results
  end


end