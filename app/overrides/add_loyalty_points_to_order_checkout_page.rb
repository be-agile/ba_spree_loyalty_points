Deface::Override.new(
  virtual_path: 'spree/shared/_order_details',
  name: 'add_loyalty_points_to_order_checkout_page',
  insert_bottom: "div.bg-accent.mb-24",
  text: "
    <% if LoyaltyPointsService.enabled? %>
    <div class='p-4 lg:p-6 text-sm border-t border-default'>
    <% if order.loyalty_points_awarded? %>
      <span class='font-medium'><%= order.loyalty_points_for(order.item_total) %></span> <b><%= Spree.t(:loyalty_points) %></b> <%= Spree.t('loyalty_points.have_been_credited') %>
    <% else %>
      <span class='font-medium'><%= order.loyalty_points_for(order.item_total) %></span> <b><%= Spree.t(:loyalty_points) %></b> <%= Spree.t('loyalty_points.will_be_credited_soon') %>
    <% end %>
    </div>
    <% end %>
  "
)