module Typus

  class Pagination < WillPaginate::ViewHelpers::LinkRenderer

    def to_html
      previous_label = "&larr; " + _t("Previous")
      next_label = _t("Next") + " &rarr;"

      html = []
      html << previous_or_next_page(@collection.previous_page, previous_label, 'left')
      html << previous_or_next_page(@collection.next_page, next_label, 'right')

      html_container(html)
    end

  end

end
