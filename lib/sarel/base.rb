module Serel
  class Base
    class_attribute :attributes, :associations, :api_key, :site

    def initialize(context, data)
      @context = context
      @data = {}
      attributes.each { |k| @data[k] = data[k.to_s] }
      if associations
        associations.each do |k,v|
          if data[k.to_s]
            @data[k] = Serel.const_get(v.to_s.capitalize).new(@context, data[k.to_s])
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
    end

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

    def self.new_relation
      Serel::Relation.new(name.split('::').last.downcase)
    end

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

    # Internal: Defines a Relation scope for a subclass of Serel::Base
    #
    # name - The String used to refer to the scope
    # lam - The Lambda to be execute when the scope is called
    #
    # Returns nothing.
    def self.scope(name, lam)
      Serel::Relation.define_scope(self.name, name, lam)
    end

    ## Pass these methods direct to a new Relation
    # TODO: refactor with metaprogramming!
    def self.find(id); new_relation.find(id); end
    def self.per(limit); new_relation.per(limit); end
    def self.sort(by); new_relation.sort(by); end
    def self.get; new_relation.get; end
    def self.request(path, type = nil); new_relation.request(path, type); end
    # TODO: Need a way of defining scope here, since you may want to call answer.comments.page(x), for instance
    def request(path, type = nil); new_relation.request(path, type); end

    def self.method_missing(sym, *attrs, &block)
      # TODO: see if the new_relation responds to the method being called
      #       requires a rewrite of how method_missing works on the
      #       relation side.
      new_relation.send(sym, *attrs, &block)
    end
  end
end