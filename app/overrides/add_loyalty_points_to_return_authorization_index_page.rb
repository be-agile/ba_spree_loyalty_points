# Spree 5.2.0: return_authorizations/index now uses _table_header and _table_row partials
Deface::Override.new(
  virtual_path: 'spree/admin/return_authorizations/_table_header',
  name: 'add_loyalty_points_to_return_authorization_table_header',
  insert_before: "th:contains('Spree.t(:status)')",
  text: "
  <th scope=\"col\"><%= Spree.t(:loyalty_points) %></th>
"
)

Deface::Override.new(
  virtual_path: 'spree/admin/return_authorizations/_table_row',
  name: 'add_loyalty_points_to_return_authorization_table_row',
  insert_before: "td:contains('return_authorization.state')",
  text: "
  <td data-action=\"click->row-link#openLink\">
    <% if return_authorization.loyalty_points.present? %>
      <%= return_authorization.loyalty_points %> pts
      <% if return_authorization.loyalty_points_transaction_type.present? %>
        (<%= return_authorization.loyalty_points_transaction_type %>)
      <% end %>
    <% else %>
      -
    <% end %>
  </td>
"
)
