module ProjectsHelper
  # Class Rollup
  def class_rollup(class_rows, class_descriptions = [])
    return class_rows if class_rows.length <= 1

    start = 0
    while start < class_rows.size
      main_class = class_rows[start].dup
      matched = start + 1
      while matched < class_rows.size
        match_class = class_rows[matched]
        diff_ids = main_class[:values].each_with_index.map { |v, i| v.try(:value) != match_class[:values][i].try(:value) ? i : nil }.compact
        same_class = diff_ids.size == 0 || diff_ids.all? do |ii|
          # check if Unstated class description is also Unstated
          match_class[:values][ii].try(:value).blank? &&
            (class_descriptions[matched].blank? || (class_descriptions[matched] && class_descriptions[matched][ii].try(:value).blank?))
        end
        if same_class
          matched = matched + 1
          next
        else
          matched = matched - 1
          break
        end
      end

      if matched > start # roll up start..matched
        main_class[:class] = class_rows[start..matched].map { |row| row[:class] }.sort
        class_rows[start..matched] = main_class
      end
      start = start + 1
    end
    class_rows
  end

  # format value
  def format_value(format, value)
    if format == :percent
      value.try(:extract_percent)
    elsif format == :float
      value.try(:extract_float)
    elsif format == :currency
      value.try(:extract_currency)
    else
      value
    end
  end

  def project_has_no_uploads
    return @project.policies.empty? && @project.proposals.empty?
  end

  def project_has_displayably_data
    return true if true_user.is_admin? # admins should see everything!

    columns = @project.policies + @project.proposals
    return columns.any?{ |column| column.state == 'finalized' && column.is_archived == false }
  end

  def sort_export_documents
    @documents.sort_by! do |d|
      index = @export_params[:sorting].index(d.id)
      [index.nil? ? 1 : 0, index || 0]
    end
  end

  # Per MS Excel
  # Make sure the name you entered does not exceed 31 characters.
  # Make sure the name does not contain any of the following characters: : \ / ? * [ or ]
  # Make sure you did not leave the name blank.
  def worksheet_safe_name(str)
    str = str.gsub(/\//, 'and')
    str.delete!("\/?*[]")
    str
  end

  def export_document_logos(documents)
    documents.map do |document|
      path = "#{Rails.root}/public#{document.carrier.logo_url}"
      if File.exists?(path)
        begin
          geo = Paperclip::Geometry.from_file(path)
          [document.carrier.logo_url, geo.width / geo.height]
        rescue => e
          [document.carrier.logo_url, -1]
        end
      else
        ['', -1]
      end
    end
  end

  # Excel cell defined name
  # [Project ID]_[Product Type]_[Attribute with Class]_[Document Carrier Name]
  def export_cell_name(project_id, product_type_name, attribute_name, carrier_name)
    str = "#{project_id} #{product_type_name} #{attribute_name} #{carrier_name}"
    str = str.gsub(/[^0-9a-z]/i, '')
    str = 'P' + str
    str
  end
end
