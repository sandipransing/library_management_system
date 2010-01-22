require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/production_record_items_controller'

# Re-raise errors caught by the controller.
class Admin::ProductionRecordItemsController; def rescue_action(e) raise e end; end

class Admin::ProductionRecordItemsControllerTest < Test::Unit::TestCase
  fixtures :admin_production_record_items

  def setup
    @controller = Admin::ProductionRecordItemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = production_record_items(:first).id
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

    assert_not_nil assigns(:production_record_items)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:production_record_item)
    assert assigns(:production_record_item).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:production_record_item)
  end

  def test_create
    num_production_record_items = ProductionRecordItem.count

    post :create, :production_record_item => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_production_record_items + 1, ProductionRecordItem.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:production_record_item)
    assert assigns(:production_record_item).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ProductionRecordItem.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ProductionRecordItem.find(@first_id)
    }
  end
end
