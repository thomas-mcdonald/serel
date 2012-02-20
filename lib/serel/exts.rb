# TODO: make file less ugly.

def remove_possible_method(method)
  if method_defined?(method) || private_method_defined?(method)
    remove_method(method)
  end
rescue NameError
  # If the requested method is defined on a superclass or included module,
  # method_defined? returns true but remove_method throws a NameError.
  # Ignore this.
end

def singleton_class?
  !name || '' == name
end

def singleton_class
  class << self
    self
  end
end

def class_attribute(*attrs)
  if attrs.last.is_a?(Hash)
    options = attrs.pop
  else
    options = {}
  end
  instance_reader = options.fetch(:instance_reader, true)
  instance_writer = options.fetch(:instance_writer, true)

    attrs.each do |name|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.#{name}() nil end
        def self.#{name}?() !!#{name} end

        def self.#{name}=(val)
          singleton_class.class_eval do
            remove_possible_method(:#{name})
            define_method(:#{name}) { val }
          end

          if singleton_class?
            class_eval do
              remove_possible_method(:#{name})
              def #{name}
                defined?(@#{name}) ? @#{name} : singleton_class.#{name}
              end
            end
          end
          val
        end

        if instance_reader
          remove_possible_method :#{name}
          def #{name}
            defined?(@#{name}) ? @#{name} : self.class.#{name}
          end

          def #{name}?
            !!#{name}
          end
        end
      RUBY

      attr_writer name if instance_writer
  end
end

def find_constant(symbol)
  str = symbol.to_s.dup
  match = /_([a-z])/.match(str)
  if match
    str.gsub!(match[0], match[1].upcase)
  end
  str[0] = str[0].upcase
  Serel.const_get(str)
end

class String
  # Yeah, it's #underscore in Rails, but that's not half as fun.
  def to_snake
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end