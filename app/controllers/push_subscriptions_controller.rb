class PushSubscriptionsController < ApplicationController
  def create
    push_subscription = current_customer.build_push_subscription(push_subscription_params)
    
    if push_subscription.save
      render json: { message: 'Push Subscription created sucessfully.' }, status: :ok
    else
      render json: push_subscription.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def push_subscription_params
    params.require(:push_subscription).permit(:endpoint, :p256dh, :auth)
  end
end
