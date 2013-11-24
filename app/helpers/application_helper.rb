module ApplicationHelper

  def datetime_tag(datetime, format, options = {})
    data = { format: format }
    data[:timestamp] = 'true' if options[:timestamp]
    content_tag(
      :time,
      nil,
      datetime: datetime.iso8601,
      class: options[:class],
      data: data
    )
  end

end
