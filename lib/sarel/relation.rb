module Serel
  class Relation
    include Serel::FinderMethods
    class_attribute :scopes
    self.scopes = {}

    def initialize(type)
      @type = type
      @klass = Serel.const_get(type.to_s.capitalize)
      @context = { 
        :api_key => Serel::Base.api_key,
        :site => Serel::Base.site
      }
    end

    # Public: Sets the pagesize of the request.
    #
    # limit - The Integer size of results to retrieve.
    #
    # Returns self.
    def per(limit)
      @per = limit
      self
    end

    # Public: Sets the sort parameter of the request.
    #
    # by - The String parameter to sort by.
    #
    # Returns self.
    def sort(by)
      @sort = by.to_s
      self
    end

    def self.define_scope(namespace, name, l)
      self.scopes[namespace] = {} unless self.scopes[namespace]
      self.scopes[namespace][name] = l
    end

    # Scopes!
    def method_missing(sym, *attrs, &block)
      if self.scopes[@klass.name][sym]
        puts *attrs
        return instance_exec(*attrs, &self.scopes[@klass.name][sym])
      end
      super(sym, *attrs, &block)
    end

    def new_relation
      self
    end

    private
    
    def build_options
      opt = {}
      opt[:sort] = @sort if @sort
      opt[:pagesize] = @per if @per
      opt[:type] = @type
      opt
    end
  end
end
