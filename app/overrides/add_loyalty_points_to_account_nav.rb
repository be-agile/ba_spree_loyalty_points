Deface::Override.new(
  virtual_path: "spree/account/_account_nav",
  name: "add_loyalty_points_to_account_nav",
  insert_after: "erb[loud]:contains('account_wishlist_path')",
  text: <<-HTML
  <% if LoyaltyPointsService.enabled? %>
  <%= link_to Spree.t(:loyalty_points), spree.loyalty_points_path,
    data: { active: current == "loyalty_points" },
    class: "shrink-0 block lg:px-4 lg:py-3 px-3 py-4 border-b lg:border-b-0 text-neutral-700 hover:border-accent-100 hover:bg-accent-100 hover:text-black \#{current == "loyalty_points" ? "lg:bg-accent border-text lg:border-b-0 lg:border-l-[1.5px]" : "border-accrent lg:border-l"}"
  %>
  <% end %>
  HTML
)
