module Serel
  class Relation
    include Serel::FinderMethods

    def initialize(type)
      @type = type
      @klass = Serel.const_get(type.to_s.capitalize)
      @scope = {
        api_key: Serel::Base.api_key,
        site: Serel::Base.site
      }
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

    # Request stuff
    def request
      Serel::Request.new(@type, scoping).execute
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