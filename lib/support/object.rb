class Object

  # Probably there's a better way to verify if a model responds to an STI
  # pattern.
  def self.is_sti?
    superclass.superclass == ActiveRecord::Base
  end

end
