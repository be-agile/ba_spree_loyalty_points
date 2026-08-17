require "spec_helper"

describe Spree.user_class, type: :model do

  let(:user) { FactoryBot.build(:user_with_loyalty_points) }

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it { is_expected.to have_many :loyalty_points_transactions }
  it { is_expected.to have_many :loyalty_points_credit_transactions }
  it { is_expected.to have_many :loyalty_points_debit_transactions }

  it "is invalid without numeric loyalty_points_balance" do
    is_expected.to validate_numericality_of(:loyalty_points_balance).only_integer
  end

  it "is invalid for negative integer loyalty_points_balance" do
    is_expected.to validate_numericality_of(:loyalty_points_balance).is_greater_than_or_equal_to(0)
  end

  describe 'loyalty_points_balance_sufficient?' do
    let!(:spree_country) { Spree::Country.first || Spree::Country.create!(name: 'Japan', iso_name: 'JAPAN', iso: 'JP', iso3: 'JPN', numcode: 392) }
    let!(:spree_store) { Spree::Store.create!(name: 'Test Store', code: 'test', url: 'test.com', mail_from_address: 'test@test.com', default: true, default_currency: 'JPY', default_country: spree_country) }

    before :each do
      allow(Spree::Store).to receive(:default).and_return(spree_store)
      spree_store.define_singleton_method(:preferred_loyalty_points_redeeming_balance) { 30 }
    end

    context "when loyalty_points_balance greater than redeeming balance" do

      before :each do
        user.loyalty_points_balance = 40
      end

      it "should return true" do
        expect(user).to be_loyalty_points_balance_sufficient
      end

    end

    context "when loyalty_points_balance equal to redeeming balance" do

      before :each do
        user.loyalty_points_balance = 30
      end

      it "should return true" do
        expect(user).to be_loyalty_points_balance_sufficient
      end

    end

    context "when loyalty_points_balance less than redeeming balance" do

      before :each do
        user.loyalty_points_balance = 20
      end

      it "should return false" do
        expect(user).not_to be_loyalty_points_balance_sufficient
      end

    end

  end

  describe 'has_sufficient_loyalty_points?' do
    let(:order) { create(:order_with_loyalty_points) }

    before :each do
      order.total = BigDecimal('30.0')
    end

    context "when loyalty_points_equivalent_currency greater than order total" do

      before :each do
        allow(user).to receive(:loyalty_points_equivalent_currency).and_return(40)
      end

      it "should return true" do
        expect(user.has_sufficient_loyalty_points?(order)).to eq(true)
      end

    end

    context "when loyalty_points_equivalent_currency equal to order total" do

      before :each do
        allow(user).to receive(:loyalty_points_equivalent_currency).and_return(30)
      end

      it "should return true" do
        expect(user.has_sufficient_loyalty_points?(order)).to eq(true)
      end

    end

    context "when loyalty_points_equivalent_currency less than order total" do

      before :each do
        allow(user).to receive(:loyalty_points_equivalent_currency).and_return(20)
      end

      it "should return false" do
        expect(user.has_sufficient_loyalty_points?(order)).to eq(false)
      end

    end

  end

  describe 'loyalty_points_equivalent_currency' do

    let (:conversion_rate) { 5.0 }
    let!(:spree_country) { Spree::Country.first || Spree::Country.create!(name: 'Japan', iso_name: 'JAPAN', iso: 'JP', iso3: 'JPN', numcode: 392) }
    let!(:store) { Spree::Store.create!(name: 'Test Store', code: 'test2', url: 'test2.com', mail_from_address: 'test@test.com', default: true, default_currency: 'JPY', default_country: spree_country) }

    before :each do
      rate = conversion_rate
      allow(Spree::Store).to receive(:default).and_return(store)
      store.define_singleton_method(:preferred_loyalty_points_conversion_rate) { rate }
    end

    it "should return balance * conversion_rate" do
      expect(user.loyalty_points_equivalent_currency).to eq(user.loyalty_points_balance * conversion_rate)
    end

  end

end
