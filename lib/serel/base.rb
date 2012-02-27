module Serel
  class Base
    class_attribute :attributes, :associations, :api_key, :site, :logger

    def initialize(data)
      @data = {}
      attributes.each { |k| @data[k] = data[k.to_s] }
      if associations
        associations.each do |k,v|
          if data[k.to_s]
            @data[k] = find_constant(v).new(data[k.to_s])
          end
        end
      end
    end

    # Internal: Provides access to the internal data
    # Rather than store data using attr_writers (problems) we use a hash.
    def [](attr)
      @data[attr]
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
    end

    # Public: Provides a nice and quick way to inspec the properties of a
    #         Serel instance inheriting from Serel::Base
    #
    # Returns a String representation of the class
    def inspect
      attribute_collector = {}
      self.class.attributes.each { |attr| attribute_collector[attr] = self.send(attr) }
      inspected_attributes = attribute_collector.select { |k,v| v != nil }.collect { |k,v| "@#{k}=#{v}" }.join(", ")
      association_collector = {}
      self.class.associations.each { |name, type| association_collector[name] = self[name] }
      inspected_associations = association_collector.select { |k, v| v != nil }.collect { |k, v| "@#{k}=#<#{v.class}:#{v.object_id}>" }.join(", ")
      "#<#{self.class}:#{self.object_id} #{inspected_attributes} #{inspected_associations}>"
    end
    alias :to_s :inspect

    # Internal: Defines the attributes for a subclass of Serel::Base
    #
    # *splat - The Array or List of attributes for the class
    #
    # Returns nothing.
    def self.attributes(*splat)
      self.attributes = splat
      splat.each do |meth|
        define_method(meth) { self[meth.to_sym] }
        define_method("#{meth}=") { |val| self[meth.to_sym] = val }
      end
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
      klass = name.split('::').last.to_snake unless klass
      Serel::Relation.new(klass.to_s, qty)
    end


    ## Pass these methods direct to a new Relation
    # TODO: clean these up
    %w(find filter per sort page url).each do |meth|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.#{meth}(val)
          new_relation.#{meth}(val)
        end
      RUBY
    end
    def self.get; new_relation.get; end
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
  end
end