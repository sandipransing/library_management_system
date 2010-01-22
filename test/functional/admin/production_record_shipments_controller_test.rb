require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/production_record_shipments_controller'

# Re-raise errors caught by the controller.
class Admin::ProductionRecordShipmentsController; def rescue_action(e) raise e end; end

class Admin::ProductionRecordShipmentsControllerTest < Test::Unit::TestCase
  fixtures :admin_production_record_shipments

  def setup
    @controller = Admin::ProductionRecordShipmentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = production_record_shipments(:first).id
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

    assert_not_nil assigns(:production_record_shipments)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:production_record_shipment)
    assert assigns(:production_record_shipment).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:production_record_shipment)
  end

  def test_create
    num_production_record_shipments = ProductionRecordShipment.count

    post :create, :production_record_shipment => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_production_record_shipments + 1, ProductionRecordShipment.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:production_record_shipment)
    assert assigns(:production_record_shipment).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ProductionRecordShipment.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ProductionRecordShipment.find(@first_id)
    }
  end
end
