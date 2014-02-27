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

  def get_latest_test_results_per_organization(organization_id)
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

  def get_test_completion_count_by_organization(organization_id)
    results = get_latest_test_results_per_organization(organization_id)

    number_of_tests = 15
    #number_of_tests_with_information = results.size
    number_of_tests_passed = results.select { |e| e[:test_results].has_value?("pass") }.size

    return { :number_of_tests => number_of_tests, :number_of_tests_passed => number_of_tests_passed }

  end

  def get_latest_result_for_test_by_organization(organization_id, test_name)

    results = get_latest_test_results_per_organization(organization_id)

    if results.empty? # the organization has no test results stored yet
      return [:no_results]
    else
      if results.select { |h| h.has_value? test_name }[0].nil? # the organization has test results but not for this test
        return [:no_results]
      else
        return results.select { |h| h.has_value? test_name }[0][:test_results]
      end

    end

    # example, TestSession.new.get_latest_test_result_for_test(1042, 'organization_key_counts')
    # returns a hash of the results
  end

  def get_latest_reason_for_test_status_by_organization(organization_id, test_name)
    test_result = get_latest_result_for_test_by_organization(organization_id, test_name)

    if test_result == [:no_results]
      return ''
    else
      if test_result.has_key? 'outcome_reason'
        return test_result['outcome_reason']
      else
        return ''
      end
    end
  end

  def get_latest_status_for_test_by_organization(organization_id, test_name)
    test_result = get_latest_result_for_test_by_organization(organization_id, test_name)

    if test_result == [:no_results]
      return 'uncollected'
    else
      if test_result.has_key? 'outcome'
        return test_result['outcome']
      else
        return 'undetermined'
      end
    end


    # final result will be UNCOLLECTED (test not yet run), PASS , FAIL or UNDETERMINED

  end

  def organization_has_test_results?(organization_id, test_name)
    if get_latest_result_for_test_by_organization(organization_id, test_name)[0] == :no_results
      return false
    else
      return true
    end
  end

end