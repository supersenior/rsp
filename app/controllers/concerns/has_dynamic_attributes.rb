module HasDynamicAttributes
  extend ActiveSupport::Concern

  def update_dynamic_attribute(obj)
    if params[:attribute_id] && params[:attribute_value]
      column = params[:column_name] || :value
      da = DynamicAttribute.find(params[:attribute_id])

      if column == 'is_atp_rate'
        params[:attribute_value] = params[:attribute_value] == 'true'
      end

      obj.dynamic_values.find_or_initialize_by(dynamic_attribute_id: da.id, type: da.value_type)
         .update(column => params[:attribute_value], :selector => params[:selector])
    end
  end
end
