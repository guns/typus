module Typus

  module Filters

    def add_predefined_filter(filter, action, scope)
      @predefined_filters ||= [["All", "index", "unscoped"]]
      @predefined_filters << [filter, action, scope]
    end

  end

end
