class ChargesController < ApplicationController

  def new
  end

  def create(order)
    # Amount in cents
    @amount = 5000
    @order = order

    customer = Stripe::Customer.create(
      :email => order.taxpayer.email,
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'cad'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end

  def paypal(order)
    redirect_to order.paypal_url(order_url(order))
  end
end
