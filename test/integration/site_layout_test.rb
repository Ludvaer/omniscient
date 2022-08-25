require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "layout links" do
    get pseudo_root_path(default_test_url_options)
    assert_template 'pseudo_static/welcome'
    assert_select "a[href=?]", pseudo_root_path, count: 1
  end
end


