module Serel
  # AccessToken is a special helper class designed to make it easier to use access tokens.
  #
  # It doesn't handle the retrieval of the token, merely provides a way to get it into Serel.
  # Creating a new AccessToken provides a couple of helper methods to access authorized methods and
  # identify who a user is.
  class AccessToken < Base
    attribute :token, String

    finder_methods :none

    # Create a new instance of AccessToken.
    # @param [String] token The access token you wish to use.
    # @return [Serel::AccessToken] An AccessToken intialized with the token.
    def initialize(token)
      @data = {}
      @data[:token] = token
    end

    # Retrieve the users' inbox items.
    #  Serel::AccessToken.new(token).inbox.request
    #  Serel::AccessToken.new(token).scoping_methods.inbox.request
    #
    # This is a scoping method and can be combined with other scoping methods.
    # @return [Serel::Response] A list of {Serel::Inbox Inbox} items wrapped in our Response wrapper.
    def inbox
      type(:inbox).access_token(self.token).url("me/inbox")
    end

    # Retrieve the users' unread inbox items.
    #  Serel::AccessToken.new(token).unread_inbox.request
    #
    # This is a scoping method and can be combined with other scoping methods.
    # @return [Serel::Response] A list of {Serel::Inbox Inbox} wrapped in our Response wrapper.
    def unread_inbox
      type(:inbox).access_token(self.token).url("me/inbox/unread")
    end

    # Invalidates the access token
    #   Serel::AccessToken.new(token).invalidate
    def invalidate
      network.url("access-tokens/#{token}/invalidate").request
    end

    # Retrieve the user associated with this access token.
    #  Serel::AccessToken.new(token).user
    #
    # This does not return a {Response} object, rather it directly returns the User.
    #
    # @return [Serel::User] The user associated with the access token.
    def user
      type(:user, :singular).access_token(self.token).url("me").request
    end
  end
end