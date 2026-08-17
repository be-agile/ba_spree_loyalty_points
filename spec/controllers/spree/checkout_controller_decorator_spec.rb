require 'spec_helper'

describe Spree::CheckoutController, type: :controller do

  let(:user) { mock_model(Spree.user_class, has_sufficient_loyalty_points?: true).as_null_object }
  let(:order) { mock_model(Spree::Order, token: 'test_token', state: 'payment', user: user).as_null_object }
  let(:payment) { Spree::Payment.new(amount: 50.0) }

  before(:each) do
    @routes = Spree::Core::Engine.routes
    @store = Spree::Store.first_or_create!(
      name: 'Test Store',
      code: 'test',
      url: 'test.example.com',
      mail_from_address: 'test@example.com',
      default_currency: 'USD',
      default_country_id: Spree::Country.first_or_create!(iso: 'US', iso3: 'USA', iso_name: 'UNITED STATES', name: 'United States').id
    )
    @loyalty_points_payment_method = Spree::PaymentMethod::LoyaltyPoints.create!(
      active: true,
      name: 'Loyalty_Points',
      stores: [@store]
    )
    allow(controller).to receive(:spree_current_user).and_return(user)
    allow(user).to receive(:generate_spree_api_key!).and_return(true)
    allow(controller).to receive(:authorize!).and_return(true)
    allow(controller).to receive(:load_order).and_return(true)
  end

  describe "#sufficient_loyalty_points (decorator method)" do
    before :each do
      controller.instance_variable_set(:@order, order)
      controller.params[:state] = 'payment'
      controller.request = ActionDispatch::TestRequest.create
      controller.response = ActionDispatch::TestResponse.new
    end

    context "when loyalty points payment method is used" do
      before do
        controller.params[:order] = { payments_attributes: [{ payment_method_id: @loyalty_points_payment_method.id.to_s }] }
      end

      context "when user has sufficient loyalty points" do
        before do
          allow(order.user).to receive(:has_sufficient_loyalty_points?).and_return(true)
        end

        it "does not set flash error" do
          controller.send(:sufficient_loyalty_points)
          expect(controller.flash[:error]).to be_nil
        end

        it "does not redirect" do
          result = controller.send(:sufficient_loyalty_points)
          expect(result).to be_nil
        end
      end

      context "when user does not have sufficient loyalty points" do
        before do
          allow(order.user).to receive(:has_sufficient_loyalty_points?).and_return(false)
        end

        it "sets flash error message" do
          allow(controller).to receive(:redirect_to)
          controller.send(:sufficient_loyalty_points)
          expect(controller.flash[:error]).to eq(Spree.t(:insufficient_loyalty_points))
        end

        it "redirects to checkout payment page" do
          expect(controller).to receive(:redirect_to).with(Spree::Core::Engine.routes.url_helpers.checkout_state_path(order.token, order.state))
          controller.send(:sufficient_loyalty_points)
        end
      end
    end

    context "when loyalty points payment method is not used" do
      before do
        check_payment_method = Spree::PaymentMethod::Check.create!(active: true, name: 'Check', stores: [@store])
        controller.params[:order] = { payments_attributes: [{ payment_method_id: check_payment_method.id.to_s }] }
      end

      it "does not set flash error" do
        controller.send(:sufficient_loyalty_points)
        expect(controller.flash[:error]).to be_nil
      end

      it "does not redirect" do
        result = controller.send(:sufficient_loyalty_points)
        expect(result).to be_nil
      end
    end
  end

end
