module Serel
  class Relation
    attr_reader :type, :klass, :qty

    def initialize(type, qty)
      @type = type
      @klass = find_constant(type)
      @scope = {
        api_key: Serel::Base.api_key,
        site: Serel::Base.site
      }
      @qty = qty
    end

    # Public: Merges two relation objects together. This is used in our awesome
    #         new scoping engine!
    #
    # relation - A Serel::Relation object with the same base class as the
    #            current relation
    #
    # Returns self
    def merge(relation)
      if relation.instance_variable_get(:@type) != @type
        raise ArgumentError, 'You cannot merge two relation objects based on different classes'
      end
      @scope.merge!(relation.scoping)
    end

    # Scoping returns our internal scope defition. Things like url etc.
    def scoping
      @scope
    end

    def new_relation
      self
    end

    def method_missing(sym, *attrs, &block)
      # If the base relation class responds to the method, call
      # it and merge in the resulting relation scope
      if @klass.respond_to?(sym)
        relation = @klass.send(sym, *attrs, &block)
        merge(relation)
        self
      end
      super(sym, *attrs, &block)
    end

    #
    #
    #
    # Scope methods
    def per(limit)
      @scope[:per] = limit
      self
    end

    def sort(by)
      @scope[:by] = by.to_s
      self
    end
    
    def url(url)
      @scope[:url] = url
      self
    end

    def page(number)
      @scope[:page] = number
      self
    end

    #
    #
    #
    # Finder methods
    def all
      # Actually paginate here
      url("#{@type}s").request
    end

    def find(id)
      url("#{@type}s/#{id}").request
    end

    def get
      url("#{@type}s").request
    end


    # Request stuff
    def request
      Serel::Request.new(@type, scoping, @qty).execute
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