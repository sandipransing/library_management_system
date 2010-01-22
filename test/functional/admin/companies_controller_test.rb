require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/companies_controller'

# Re-raise errors caught by the controller.
class Admin::CompaniesController; def rescue_action(e) raise e end; end

class Admin::CompaniesControllerTest < Test::Unit::TestCase
  fixtures :admin_companies

  def setup
    @controller = Admin::CompaniesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = companies(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:companies)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:company)
    assert assigns(:company).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:company)
  end

  def test_create
    num_companies = Company.count

    post :create, :company => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_companies + 1, Company.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:company)
    assert assigns(:company).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Company.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Company.find(@first_id)
    }
  end
end
