Deface::Override.new(
  virtual_path: 'spree/admin/users/_form',
  name: 'add_loyalty_points_to_admin_user_show_page',
  insert_bottom: "div.card-body",
  text: <<-HTML
    <div class="form-group">
      <%= f.label :loyalty_points_balance, Spree.t(:loyalty_points_balance) %>
      <div>
        <% if @user.loyalty_points_balance.present? %>
          <%= link_to @user.loyalty_points_balance, spree.admin_user_loyalty_points_path(@user), class: 'btn btn-sm btn-outline-secondary' %>
        <% else %>
          <%= Spree.t(:no_loyalty_points_yet) %>
        <% end %>
      </div>
    </div>
  HTML
)
