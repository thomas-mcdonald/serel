module Serel
  # The Event class represents a Stack Exchange event.
  #
  # == Finding events
  #
  # You can use the +all+ and +get+ finder methods to retrieve events. Both of these require
  # authentication, so {Relation#access_token access_token} must be called before the finders.
  #
  # === all
  #   Serel::Event.access_token(token).all
  # 
  # Retrieves (by default) all the events on the site in the last 5 minutes. The +since+ method can
  # be called to change this return events upto 15 minutes ago. This method is safe to call, since even
  # on Stack Overflow only roughly 3 pages of events are generated every 5 minutes.
  #
  # == get
  #   Serel::Event.access_token(token).get
  #
  # Retrieves a page of Events. As per the +all+ method above, this defaults to events in the last 5
  # minutes.
  class Event < Base
    attribute :event_type, String
    attribute :event_id, Integer
    attribute :creation_date, DateTime
    attribute :link, String
    attribute :excerpt, String
    finder_methods :all, :get
  end
end