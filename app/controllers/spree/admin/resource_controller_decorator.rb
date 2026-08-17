module Spree
  module Admin
    module ResourceControllerDecorator
      protected

      # @gem-override spree_admin-5.3.6/app/controllers/spree/admin/resource_controller.rb#parent
      # @see https://github.com/be-agile/giga-repeat/commit/7c6b01c098e0003527926b1c221d4a586fe76a23
      def parent
        if parent_data.is_a?(Hash) && parent_data[:model_class].present?
          @parent ||= parent_data[:model_class].send("find_by_#{parent_data[:find_by]}", params["#{resource.model_name}_id"])
          raise ActiveRecord::RecordNotFound unless @parent
          instance_variable_set("@#{resource.model_name}", @parent)
        else
          nil
        end
      end

      # @gem-override spree_admin-5.3.6/app/controllers/spree/admin/resource_controller.rb#resource_not_found
      # @see https://github.com/be-agile/giga-repeat/commit/7c6b01c098e0003527926b1c221d4a586fe76a23
      def resource_not_found
        flash[:error] = flash_message_for(model_class.new, :not_found)
        flash[:error] = flash_message_for(parent_data[:model_class].new, :not_found) if parent_data.present? && @parent.nil?
        redirect_to collection_url
      end
    end
  end
end

Spree::Admin::ResourceController.prepend(Spree::Admin::ResourceControllerDecorator)
