Deface::Override.new(virtual_path: 'spree/admin/orders/return_authorizations/_form',
  name: 'add_loyalty_points_transaction_table_to_return_authorization_form',
  insert_after: "div.card.mb-6:contains('spree_text_area :memo')",
  text: "

  <div class=\"card mb-6\">
    <div class=\"card-header\">
      <h5 class=\"card-title\">
        <%= Spree.t(:loyalty_points_transactions) %>
      </h5>
    </div>
    <div class=\"card-body\">
      <%= render partial: 'spree/loyalty_points/transaction_table' %>
    </div>
  </div>
  ")
