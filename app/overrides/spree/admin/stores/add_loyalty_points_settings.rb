# Updated for Spree 5.2.0 - form split into multiple partials
# Now targeting spree/admin/stores/form/_basic instead of _form
# Using render_admin_partials hook for reliable insertion
Deface::Override.new(
  virtual_path: "spree/admin/stores/form/_basic",
  name: "add_loyalty_points_settings",
  insert_before: "erb[loud]:contains('render_admin_partials')",
  partial: "spree/admin/stores/loyalty_points_settings"
)