module Serel
  class Base
    # Dummy class used to make our attributes clearer.
    class Boolean; end

    class_attribute :all_finder_methods, :api_key, :associations, :attributes, :finder_methods, :logger, :network, :site
    self.all_finder_methods = %w(find get all)

    def initialize(data)
      @data = {}
      attributes.each { |k,v| @data[k] = data[k.to_s] }
      if associations
        associations.each do |k,v|
          if data[k.to_s]
            @data[k] = Serel.const_get(v.to_s.classify).new(data[k.to_s])
          end
        end
      end
    end

    # Internal: Provides access to the internal data
    # Rather than store data using attr_writers (problems) we use a hash.
    def [](attr)
      format_attribute(attr)
    end

    def []=(attr, value)
      @data[attr] = value
    end

    # Public: Sets the global configuration values.
    #
    # site - The API site parameter that represents the site you wish to query.
    # api_key - Your API key.
    #
    # Returns nothing.
    def self.config(site, api_key = nil)
      self.site = site.to_sym
      self.api_key = api_key
      self.logger = Logger.new(STDOUT)
      self.logger.formatter = proc { |severity, datetime, progname, msg|
        %([#{severity}][#{datetime.strftime("%Y-%m-%d %H:%M:%S")}] #{msg}\n)
      }
      nil # Return nothing, rather than that proc
    end

    # Public: Provides a nice and quick way to inspec the properties of a
    #         Serel instance inheriting from Serel::Base
    #
    # Returns a String representation of the class
    def inspect
      attribute_collector = {}
      self.class.attributes.each { |attr, type| attribute_collector[attr] = self.send(attr) }
      inspected_attributes = attribute_collector.select { |k,v| v != nil }.collect { |k,v| "@#{k}=#{v}" }.join(", ")
      association_collector = {}
      self.class.associations.each { |name, type| association_collector[name] = self[name] }
      inspected_associations = association_collector.select { |k, v| v != nil }.collect { |k, v| "@#{k}=#<#{v.class}:#{v.object_id}>" }.join(", ")
      "#<#{self.class}:#{self.object_id} #{inspected_attributes} #{inspected_associations}>"
    end
    alias :to_s :inspect

    # Defines an attribute on a subclass of Serel::Base
    # @param [Symbol] name The name of the attribute
    # @param [Class] klass The type of the returned attributed
    # @return Nothing of value
    def self.attribute(name, klass)
      self.attributes = {} unless self.attributes
      self.attributes[name] = klass
      define_method(name) { self[name.to_sym] }
      define_method("#{name}=") { |val| self[name.to_sym] = val }
    end

    # Internal: Defines the associations for a subclass of Serel::Base
    #
    # options - The Hash options used to define associations
    #            { :name => :type }
    #            :name - The Symbol name that this association will be found as in the data
    #            :type - The Symbol type that this association should be parsed as
    #
    # Returns nothing.
    def self.associations(options = {})
      self.associations = options
      options.each do |meth, type|
        unless self.respond_to?(meth)
          define_method(meth) { self[meth.to_sym] }
        end
        define_method("#{meth}=") { |val| self[meth.to_sym] = val }
      end
    end

    # Public: Creates a new relation scoped to the class
    #
    # klass - the name of the class to scope the relation to
    #
    # Returns an instance of Serel::Relation
    def self.new_relation(klass = nil, qty = :singular)
      klass = name.split('::').last.underscore unless klass
      Serel::Relation.new(klass.to_s, qty)
    end


    # Public: Sets the finder methods available to this type
    #
    # *splat - The Array of methods this class accepts. Also accepts :every,
    #          which indicates that all finder methods are valid
    #
    # Returns nothing of value
    def self.finder_methods(*splat)
      self.finder_methods = splat
    end

    # Denotes that a class does not need the site parameter
    def self.network_wide
      self.network = true
    end

    # Create an 'shallow' instance with multiple IDs. Used for vectorized requests
    def self.with_ids(*ids)
      idstr = ids.join(";")
      n = name.split('::').last.underscore
      new({"#{n}_id".to_s => idstr})
    end

    # Public: Provides an interface to show which methods this class responds to
    #
    # method_sym - The Symbol representation of the method you are interested in
    # include_private - Whether to include private methods. We ignore this, but
    #                   it is part of how the core library handles respond_to
    #
    # Returns Boolean indicating whether the class responds to it or not
    def self.respond_to?(method_sym, include_private = true)
      if self.all_finder_methods.include?(method_sym.to_s)
        if (self.finder_methods.include?(:every)) || (self.finder_methods.include?(method_sym))
          true
        else
          false
        end
      else
        super(method_sym, include_private)
      end
    end

    def all
      if self.respond_to?(:all)
        new_relation.all
      else
        raise NoMethodError
      end
    end

    def find(id)
      if self.respond_to?(:find)
        new_relation.find(id)
      else
        raise NoMethodError
      end
    end

    def get
      if self.respond_to?(:get)
        new_relation(name.split('::').last.underscore, :plural).get
      else
        raise NoMethodError
      end
    end

    ## Pass these methods direct to a new Relation, which should *not* be singular. >:
    # TODO: clean these up
    %w(access_token filter fromdate inname intitle min max nottagged order page pagesize since sort tagged title todate url).each do |meth|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.#{meth}(val)
          new_relation(name.split('::').last.underscore, :plural).#{meth}(val)
        end
      RUBY
    end
    def network; self.class.new_relation.network; end
    def self.request(path, type = nil); new_relation.request(path, type); end
    def type(klass, qty = :plural)
      self.class.new_relation(klass, qty)
    end

    def self.method_missing(sym, *attrs, &block)
      # TODO: see if the new_relation responds to the method being called
      #       requires a rewrite of how method_missing works on the
      #       relation side.
      new_relation.send(sym, *attrs, &block)
    end

    private

    # Returns a formatted attribute. Used interally to cast attributes into their appropriate types.
    # Currently only handles DateTime attributes, since Ruby automatically handles all other known
    # types for us.
    def format_attribute(attribute)
      # Handle nil values
      if @data[attribute] == nil
        nil
      else
        # Use class names as types otherwise case will look at the type of the
        # arg, which would otherwise always be Class.
        type = self.attributes[attribute].to_s
        case type
        when "DateTime"
          Time.at(@data[attribute])
        else
          @data[attribute]
        end
      end
    end
  end
end