require "test_helper"

=begin

  What's being tested here?

    - Invoice belongs_to Order

=end

class Admin::InvoicesControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id
  end

  ##
  # Here we are using the create_with_back_to method.
  #
  #   /admin/invoices/new?back_to=&order_id=4&resource=Order&resource_id=4
  #
  context "Create an invoice from an Order" do

    setup do
      @order = Factory(:order)
      @back_to = "/admin/orders/edit/#{@order.id}"
      @invoice = { :number => "Invoice#0000001" }
    end

    should "create new invoice assign it to order and redirect to order" do
      post :create, { :invoice => @invoice,
                      :back_to => @back_to,
                      :resource => "Order", :resource_id => @order.id, :order_id => @order.id }
      assert_response :redirect
      assert_redirected_to @back_to
    end

    should "raise an error if we try to add an invoice to an order which already has an invoice" do
      @invoice = Factory(:invoice)
      post :new, { :back_to => @back_to,
                   :resource => "Order", :resource_id => @invoice.order.id, :order_id => @invoice.order.id }
      assert_response :unprocessable_entity
    end

    should "raise an error if we try to create an invoice to an order which already has an invoice" do
      @invoice = Factory(:invoice)
      post :create, { :invoice => { :number => "Invoice#0000001" },
                      :back_to => @back_to,
                      :resource => "Order", :resource_id => @invoice.order.id, :order_id => @invoice.order.id }
      assert_response :unprocessable_entity
    end

  end

  context "Unrelate" do

    setup do
      @invoice = Factory(:invoice)
      @order = @invoice.order
    end

    should "work for unrelate Invoice from Order" do
      post :unrelate, { :id => @invoice.id, :resource => 'Order', :resource_id => @order.id }
      assert @order.reload.invoice.nil?
      assert_equal "Order successfully updated.", flash[:notice]
    end

  end

end
