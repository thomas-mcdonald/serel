module Serel
  class Tag < Base
    attribute :name, String
    attribute :count, Integer
    attribute :is_required, Boolean
    attribute :is_moderator_only, Boolean
    attribute :user_id, Integer
    attribute :has_synonyms, Boolean
    attribute :last_activity_date, DateTime

    finder_methods :all, :get

    # Finds a tag by name
    # @param [String] name The name of the tag you wish to find
    # @return [Serel::Tag] The tag returned by the Stack Exchange API
    def self.find_by_name(name)
      new_relation('tag', :singular).url("tags/#{name}/info").request
    end

    # Retrieves tags which can only be added or removed by a moderator
    #  Serel::Tag.moderator_only.request
    #
    # This is a scoping method and can be combined with other scoping methods
    # @return [Serel::Relation] A relation scoped to the moderator only URL.
    def self.moderator_only
      url("tags/moderator-only")
    end

    # Retrieves tags that are required on the site
    #   Serel::Tag.required.request
    #
    # This is a scoping method and can be combined with other scoping methods.
    # @return [Serel::Relation] A relation scoped to the required URL.
    def self.required
      url("tags/required")
    end

    # Retrieves all the tag synonyms on the site
    #   Serel::Tag.synonyms.request
    #
    # This is a scoping method and can be combined with other scoping methods.
    # @return [Serel::Relation] A relation scoped to {Serel::TagSynonym TagSynonym} and the synonym URL.
    def self.synonyms
      new_relation(:tag_synonym).url("tags/synonyms")
    end

    def faq
      type(:tag).url("tags/#{name}/faq")
    end

    # Retrieves related tags.
    #   Serel::Tag.find(1).related.request
    #
    # This is a scoping method and can be combined with other scoping methods.
    # @return [Serel::Relation] A relation scoped to the related URL
    def related
      type(:tag).url("tags/#{name}/related")
    end

    def top_answerers(period)
      raise ArgumentError, 'period must be :all_time or :month' unless [:all_time, :month].include? period
      type(:tag_score).url("tags/#{name}/top-answerers/#{period}")
    end

    def top_askers(period)
      raise ArgumentError, 'period must be :all_time or :month' unless [:all_time, :month].include? period
      type(:tag_score).url("tags/#{name}/top-askers/#{period}")
    end

    def wiki
      type(:tag_wiki, :singular).url("tags/#{name}/wikis").request
    end
  end
end