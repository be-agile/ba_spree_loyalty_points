# ba_spree_loyalty_points

This is a fork of [spree_loyalty_points](https://github.com/vinsol-spree-contrib/spree-loyalty-points) with additional features and improvements.

Loyalty Points extension allows customers to earn loyalty points on the basis of their purchases. Admin can also reward Loyalty Points to it's customers manually. Customer can use these loyalty points to pay for their future orders.

This extension allows admin to create a new payment method "Loyalty Points" in the system. Once this payment method is created and active, it would appear on checkout screen and customers can use this payment method for payments.

This extension also automates the awarding of loyalty points to customers based on the configuration done by admin and updating loyalty points based on the transactions on Spree Commerce platform.

This extension allows only Loyalty Points payment method for making a purchase and does not allow the payment through other payment modes like cash, check, credit card etc.

## Features

* Supports Ruby 3.1
* Supports Rails 7.1
* Supports Spree 5.3
* Japanese translations included
* Actively maintained with contributions back to the original project

## Installation

In your `Gemfile`, add:

```ruby
gem 'ba_spree_loyalty_points', github: 'your-github-username/ba_spree_loyalty_points'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g ba_spree_loyalty_points:install
```

## How it works

* To add loyalty point feature, Spree admin needs to create "Loyalty Points" payment method

    Configuration -> Payment Methods -> New payment Method

    You need to select "Spree::PaymentMethod::LoyaltyPoints" as a Provider

* Spree admin need to make following settings on Configuration page:

   - **Set minimum amount of an order that should be spent by the customer to earn loyalty points** - On the basis of this, it will be decided by the system whether loyalty points should be awarded for the order or not, based on the order value.

  - **Set number of loyalty points to be awarded per unit amount spent** - On the basis of this configuration, number of loyalty points to be awarded are calculated based on the order value and per unit value defined. The loyalty points get added to the customer's account which he can use in future purchases.

    Ex. Suppose Admin set this value this value to 1, it means, Customer will receive 1 Loyalty Point on spending every $1 on this site.

       In order to receive loyalty points the payment should be done through some other
     mode like Credit card, Debit card, Cash, Check etc.

     No loyalty points are awarded for purchase done through existing Loyalty point
    balance

  - **Set minimum loyalty points balance required for redeeming** - On the basis of this, Customer will be permitted to make a payment with Loyalty Points only if he/she has Loyalty Points balance more than the minimum loyalty points set by the Admin.

  - **Set Loyalty Point to Amount conversion rate** - This conversion rate converts the loyalty points into amount. This amount is displayed on the checkout screen with Loyalty Points balance.

  - **Set Time to award Loyalty Points after payment** - Loyalty Points will be credited to the Customer's account on the basis of this set time period. This time period will be considered only after Customer makes the payment and Admin marks this payment "Capture".

    **This field is provided to curb the misuse of the Loyalty Points by the customers. So, we suggest to set this time on the basis of the merchant's "Return Policy".**

[Rest of the content remains the same until the Credits section...]

## License

This extension is available as open source under the terms of either:
* [GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later)](https://www.gnu.org/licenses/agpl-3.0.en.html)
* [BSD 3-Clause License](https://opensource.org/licenses/BSD-3-Clause)

## Credits

Originally created by Vinsol.
Fork maintained by [be agile Co., Ltd.](https://be-agile.jp/).