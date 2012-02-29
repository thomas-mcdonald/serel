module Serel
  # The Badge class represents a Stack Exchange badge object.
  #
  # == Finding Badges
  #
  # Badges can be retrieved using any of the standard finder methods: +all+, +get+ & +find+.
  #
  # === all
  #   Serel::Badge.all
  #
  # Unlike several of the other classes ({Answer}, {Comment}, {Question} etc) where the usage of +all+
  # is recommended against, +all+ is probably the most useful finder method for retrieving badges, since
  # a partial set of badges is probably not useful, and only a few pages have to be retrieved each time
  # this is called. At the time of writing this, Stack Overflow required 17 pages to be retrieved,
  # Server Fault required 2, and Gaming required 1, and shouldn't make too much of a dent in your quota.
  #
  # ==find
  #   Serel::Badge.find(id)
  # 
  # Retrieves a badge or badges by ID.
  #
  # == get
  #   Serel::Badge.get
  #
  # Retrieves a page of badge results, applying any scopes that have previously been defined.
  #
  # == {named}
  #  Serel::Badge.named.request
  # 
  # See the documentation for {named} below.
  #
  # == {recipients}
  #   Serel::Badge.recipients.request
  #   Serel::Badge.recipients(1).request
  #   Serel::Badge.recipients(1,2,3).request
  #
  # See the documentation for {recipients} below.
  #
  # == {tags}
  #  Serel::Badge.tags.request
  #
  # See the documentation for {tags} below.
  class Badge < Base
    attributes :badge_id, :badge_type, :description, :link, :name, :rank
    alias :id :badge_id

    associations :user => :user
    finder_methods :every

    # Retrieves only badges that are explicitly defined.
    # This is a scoping method, meaning that it can be used around/with other scoping methods, for
    # example:
    #  Serel::Badge.pagesize(5).named.request
    #  Serel::Badge.named.sort('gold').request
    #
    # @return [Serel::Relation] A relation scoped to the named URL.
    def self.named
      url("badges/name")
    end

    # Retrieves recently awarded badges.
    #   Serel::Badge.recipients.request
    #   Serel::Badge.recipients(1).request
    #   Serel::Badge.recipients(1,2,3).request
    #
    # This is a scoping method and can be combined with other scoping methods.
    #
    # @param [Array] ids The ID or IDs of the badges you want information on. Not passing an ID means
    #                    all recently awarded badges will be returned.
    # @return [Serel::Relation] A relation scoped to the correct recipients URL
    def self.recipients(*ids)
      if ids.length > 0
        arg = ids.length > 1 ? ids.join(';') : ids.pop
        url("badges/#{arg}/recipients")
      else
        url("badges/recipients")
      end
    end

    # Retrieves only badges that have been awarded due to participation in a tag.
    #  Serel::Badge.tags.request
    #
    # This is a scoping method and can be combined with other scoping methods.
    # @return [Serel::Relation] A relation scoped to the tags URL.
    def self.tags
      url("badges/tags")
    end
  end
end