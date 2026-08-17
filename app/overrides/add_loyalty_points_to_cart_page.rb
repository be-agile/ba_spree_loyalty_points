Deface::Override.new(
  virtual_path: 'spree/orders/_summary',
  name: 'add_loyalty_points_to_cart_page',
  insert_before: "erb[loud]:contains('link_to Spree.t(:checkout)')",
  text: "
    <% if LoyaltyPointsService.enabled? && order.loyalty_points_for(order.item_total) > 0 %>
      <div class='text-center lg:text-right my-4 text-sm'>
        <%= Spree.t(:loyalty_points_earnable, quantity: \"<span class='font-medium'>\#{order.loyalty_points_for(order.item_total)}</span>\").html_safe %>
      </div>
    <% end %>
  "
)
