require 'test_helper'

class SequencePresenterTest < ActiveSupport::TestCase
  def build_presenter(overrides = {})
    defaults = {
      id: '1',
      sequence_details: {
        sequence: 'true',
        sequence_value: 'CAGTCAGTCAGT',
        search: 'CAG',
        matches: [1, 5, 9]
      }
    }
    ::SequencePresenter.new(defaults.merge(overrides))
  end

  test 'initializes with sequence_id and sequence_details' do
    presenter = build_presenter(id: '2')
    assert_equal '2', presenter.sequence_id
    assert_kind_of Hash, presenter.sequence_details
  end

  test '#matches returns matches array when present' do
    presenter = build_presenter
    assert_equal [1, 5, 9], presenter.matches
  end

  test '#matches returns empty array when not present' do
    presenter = build_presenter(sequence_details: { sequence: 'true', sequence_value: 'CAGT', search: 'X' })
    assert_equal [], presenter.matches
  end

  test '#total_matches returns count of matches' do
    presenter = build_presenter
    assert_equal 3, presenter.total_matches
  end

  test '#total_matches returns 0 when no matches' do
    presenter = build_presenter(sequence_details: { sequence: 'true', sequence_value: 'CAGT', search: 'X' })
    assert_equal 0, presenter.total_matches
  end

  test '#search_query returns the search value' do
    presenter = build_presenter
    assert_equal 'CAG', presenter.search_query
  end

  test '#search_query returns nil when not present' do
    presenter = build_presenter(sequence_details: { sequence: 'true', sequence_value: 'CAGT' })
    assert_nil presenter.search_query
  end

  test '#sequence_input_present? returns true when sequence is "true"' do
    presenter = build_presenter
    assert presenter.sequence_input_present?
  end

  test '#sequence_input_present? returns false when sequence is "false"' do
    presenter = build_presenter(sequence_details: { sequence: 'false', search: 'CAG' })
    refute presenter.sequence_input_present?
  end

  test '#sequence_input returns the sequence value' do
    presenter = build_presenter
    assert_equal 'CAGTCAGTCAGT', presenter.sequence_input
  end

  test '#sequence_input returns empty string when sequence_value is absent' do
    presenter = build_presenter(sequence_details: { sequence: 'true' })
    assert_equal '', presenter.sequence_input
  end

  test '#display_sequence_title returns i18n title with index' do
    presenter = build_presenter(id: '3')
    assert_equal I18n.t('sequence_identifier.summary.sequence.title', index: '3'), presenter.display_sequence_title
  end

  test '#display_search_text returns search result text when search query present' do
    presenter = build_presenter
    expected = I18n.t('sequence_identifier.summary.sequence.search_result', count: 3, search_query: 'CAG', matches_count: 3)
    assert_equal expected, presenter.display_search_text
  end

  test '#display_search_text returns no search result text when search query absent' do
    presenter = build_presenter(sequence_details: { sequence: 'true', sequence_value: 'CAGT' })
    assert_equal I18n.t('sequence_identifier.summary.sequence.no_search_result'), presenter.display_search_text
  end

  test '#display_matches_text returns formatted match position text' do
    presenter = build_presenter
    expected = I18n.t('sequence_identifier.summary.sequence.match', index: 1, match_value: 5)
    assert_equal expected, presenter.display_matches_text(5, 0)
  end
end
