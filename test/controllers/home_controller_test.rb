require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'GET / renders index' do
    get root_path
    assert_response :success
  end

  test 'GET /add_dna_sequence renders dna_sequence partial without layout' do
    get add_dna_sequence_path, params: { cardNumber: 1 }
    assert_response :success
    assert_select '#card-1'
  end

  test 'GET /add_summary_details with no sequence matches renders summary partial' do
    summary_details = {
      totalSearches: '0',
      sequenceSummaryMatches: {}
    }
    get add_summary_details_path, params: { summaryDetails: summary_details }
    assert_response :success
  end

  test 'GET /add_summary_details with sequence matches renders summary partial' do
    summary_details = {
      totalSearches: '1',
      sequenceSummaryMatches: {
        '1' => {
          sequence: 'true',
          sequence_value: 'CAGTCAGT',
          search: 'CAG',
          matches: [1, 5]
        }
      }
    }
    get add_summary_details_path, params: { summaryDetails: summary_details }
    assert_response :success
  end

  test 'GET /save_sequence_details with no valid data returns bad_request' do
    summary_details = {
      totalSearches: '0',
      sequenceSummaryMatches: {
        '1' => {
          sequence: 'false',
          sequence_value: '',
          search: 'CAG',
          matches: []
        }
      }
    }
    get save_sequence_details_path, params: { summaryDetails: summary_details }
    assert_response :bad_request
  end
end
