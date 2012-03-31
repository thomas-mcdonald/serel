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
    # 'Standard' methods. These should not need coercing.
    %w(access_token filter inname intitle min max nottagged order page pagesize sort tagged title url).each do |meth|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{meth}(val)
          @scope[:#{meth}] = val.to_s
          self
        end
      RUBY
    end
    # These methods are for dates. They can take all sorts of values. Time, DateTime, Integer. The whole kaboodle.
    # Unfortunately there's no easy cross class method to go from Time/DateTime -> Integer,
    # so we must convert DateTime into Time before converting to Integer.
    %w(fromdate since todate).each do |meth|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{meth}(val)
          if val.is_a?(DateTime)
            val = val.to_time
          end
          @scope[:#{meth}] = val.to_i
        end
      RUBY
    end

    def network
      @network = true
      self
    end

    #
    #
    #
    # Finder methods
    def all
      if klass.respond_to?(:all)
        all_helper(1)
      else
        raise NoMethodError
      end
    end

    # Finds an object by an ID or list of IDs. For example:
    #   Serel::Answer.find(1) # Find the answer with an ID of 1
    #   Serel::Answer.find(1, 2, 3) # Find the answers with IDs of 1, 2 & 3
    #
    # @param [Array] ids The ID or IDs of the objects you want returning.
    # @return [Serel::Response] The data returned by the Stack Exchange API, parsed and pushed into our
    #                           handy response wrapper.
    def find(*ids)
      if klass.respond_to?(:find)
        arg = ids.length > 1 ? ids.join(';') : ids.pop
        url("#{@type}s/#{arg}").request
      else
        raise NoMethodError
      end
    end

    # Makes a request. If the URL is already set we just call {request}, else
    # we set the URL to the plural of the type and make the request.
    def get
      if scoping[:url]
        request
      else
        # Best check that the generic page getter is enabled here.
        if klass.respond_to?(:get)
          url("#{@type}s").request
        else
          raise NoMethodError
        end
      end
    end

    # Request stuff
    def request
      if (klass.network || @network)
        @scope[:network] = true
      end
      Serel::Request.new(@type, scoping, @qty).execute
    end

    private

    def all_helper(page)
      response = page(page).pagesize(100).url("#{@type}s").request
      # TODO: find a query that triggers backoff.
      # if response.backoff
      #   Serel::Base.warn response.backoff
      # end
      if response.has_more
        response.concat all_helper(page+1)
      end
      response
    end
  end
end