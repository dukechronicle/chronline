module ChronSlug
  def normalize_friendly_id(name, max_chars=100)
    return nil if name.nil?  # record won't save -- name presence is validated
    removelist = %w(a an as at before but by for from is in into like of off on
                    onto per since than the this that to up via with)
    r = /\b(#{removelist.join('|')})\b/i

    s = name.downcase  # convert to lowercase
    s.gsub!(r, '')
    s.strip!
    s.gsub!(/[^-\w\s]/, '')  # remove unneeded chars
    s.gsub!(/[-\s]+/, '-')   # convert spaces to hyphens
    s = s[0...max_chars].chomp('-')
  end
end
