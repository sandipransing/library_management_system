require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/formula_records_controller'

# Re-raise errors caught by the controller.
class Admin::FormulaRecordsController; def rescue_action(e) raise e end; end

class Admin::FormulaRecordsControllerTest < Test::Unit::TestCase
  fixtures :admin_formula_records

  def setup
    @controller = Admin::FormulaRecordsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = formula_records(:first).id
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

    assert_not_nil assigns(:formula_records)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:formula_record)
    assert assigns(:formula_record).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:formula_record)
  end

  def test_create
    num_formula_records = FormulaRecord.count

    post :create, :formula_record => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_formula_records + 1, FormulaRecord.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:formula_record)
    assert assigns(:formula_record).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      FormulaRecord.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      FormulaRecord.find(@first_id)
    }
  end
end
