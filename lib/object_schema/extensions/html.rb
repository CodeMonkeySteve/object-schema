class Schema
  def html_form_for( obj )

  end

protected
  def html_field( name, value )
    html = ''
    unless self.name
      html += hidden_field_tag( name, value )  if value
      return html
    end

    html += label_tag( name, self.name )
    if self.readonly?
      html += label_tag( name, value )  if value
      return html
    end

    value ||= self.default
    if self.enum
      optinos = if self.options
        self.options.map { |h| [ h['label'], h['value'] ]  }
      else
        self.enum.map { |val|  [ val.to_s.titleize, vals ]  }
      end
      html += select_tag( name, options_for_select(options, value), :include_blank => self.optional? )
      return html
    end

    if self.format
      case self.format
        # Any valid MIME media type may be used as a format value, in which case the instance property value must be a string, representing the contents of the MIME file.
        # attachment

        # date-time
        # date
        # time
        # utc-millisec

        # regex
        # color
        # style
        # phone
        # email

        # uri
        # url
        # urn
        # image
        # image-ref
        # image-attachment
        # ip-address
        # ipv6
        # street-address
        # locality
        # region
        # postal-code
        # country
        # Additional custom formats may be defined with a URL to a definition of the format.
      end
    end

#requires
#optional
#disallow
#extends

    case self.type
      when :nil
        return

      when :any
        # TO-DO

      when String
        opt = {}
        opts[:maxlength] = self.maxLength.to_i  if self.maxLength && !self.maxLength.zero?
        return html + text_field_tag( name, value, opts )

      when Numeric
        # minimuim, maximum, maxDecimal
        return html + text_field_tag( name, value )

      when Integer
        # minimuim, maximum
        return html + text_field_tag( name, value )

      when :boolean
        return html + check_box_tag( name, '1', !!value )

      when Object
#properties

      when Array
        # items, minItems, maxItems
    end

    # unused:
    #additionalProperties
    #identity
  end

end
