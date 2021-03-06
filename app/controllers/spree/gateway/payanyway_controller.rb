class Spree::Gateway::PayanywayController < Spree::BaseController
  skip_before_filter :verify_authenticity_token, :only => [:result, :success, :fail]

  before_filter :load_gateway, :only => [:result, :success, :fail]

  include Spree::Core::ControllerHelpers::Order

  helper 'spree/orders'
  helper 'spree/store'

  def result
    @order = Spree::Order.find_by_id(params['MNT_TRANSACTION_ID'])
    if complete_or_create_payment(@order, @gateway)
      complete_order
      render :text => 'SUCCESS'
    else
      render :text => 'FAIL'
    end
  end

  def success
    @order = Spree::Order.find_by_id(params['order_id'])
    if @order && @gateway && @order.complete?
      session[:order_id] = nil
      flash.notice = Spree.t(:order_processed_successfully)
      flash['order_completed'] = true
      redirect_to completion_route(@order), turbolinks: false
    else
      flash[:error] = Spree.t(:payment_fail)
      redirect_to root_url
    end
  end
  
  def fail
    @order = Spree::Order.find_by_id(params['order_id'])
    flash[:error] = Spree.t(:payment_fail)
    redirect_to @order.blank? ? root_url : checkout_state_path('payment')
  end

  private

  def valid_signature?
    Digest::MD5.hexdigest([ params['MNT_ID'], params['MNT_TRANSACTION_ID'], params['MNT_OPERATION_ID'],
      params['MNT_AMOUNT'], params['MNT_CURRENCY_CODE'], params['MNT_SUBSCRIBER_ID'], params['MNT_TEST_MODE'],
      @gateway.options[:payanyway_signature] ].join).downcase == params['MNT_SIGNATURE'].downcase
  end

  def load_gateway
    @gateway = Spree::Gateway::Payanyway.current
  end
  
  def complete_or_create_payment(order, gateway)
    return unless order && gateway && valid_signature?

    payment = order.payments.where( payment_method: gateway, response_code: params['MNT_OPERATION_ID'], state:'completed' )
    unless payment.any?
      order.payments.create! do |p|
        p.payment_method = gateway
        p.amount = params['MNT_AMOUNT'].to_f
        p.response_code = params['MNT_OPERATION_ID']
        p.state = 'completed'
      end
      order.update!
    end
  end

  def complete_order
    @order.next! until @order.state == "complete"
    @order.update!
  end

end
