# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

class CreoleFilter < Nanoc3::Filter

  identifier :creole
  type :text

  def run(content, params={})
    require 'rubygems'
    require 'wiki_creole'
    WikiCreole.creole_parse(content)
  end

end
