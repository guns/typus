module Typus

  class Pagination < WillPaginate::ViewHelpers::LinkRenderer

    def to_html
      html = pagination.map do |item|
        (item.is_a? Fixnum) ? (page_number item) : (send item)
      end

      html[0]  = previous_or_next_page @collection.previous_page, ("&larr; " + _t("Previous")), 'left'
      html[-1] = previous_or_next_page @collection.next_page, (_t("Next") + " &rarr;"), 'right'

      html_container html.join(@options[:separator])
    end

  end

end
