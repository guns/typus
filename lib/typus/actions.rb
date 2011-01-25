module Typus

  module Actions

    protected

    def add_action(*args)
      options = args.extract_options!
      @actions ||= []
      @actions << options
    end

    def prepend_action(*args)
      options = args.extract_options!
      @actions ||= []
      @actions = @actions.unshift(options)
    end

    def append_action(*args)
      options = args.extract_options!
      @actions ||= []
      @actions = @actions.concat([options])
    end

  end

end
