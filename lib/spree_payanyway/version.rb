module SpreePayanyway
  module_function

  def version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 3
    MINOR = 0
    TINY  = 1
    PRE   = 'beta'

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end
end
