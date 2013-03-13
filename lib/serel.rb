# Utilities
require 'date'
require 'logger'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'
require 'serel/relation'
require 'serel/response'

# Types
require 'serel/base'
require 'serel/access_token'
require 'serel/answer'
require 'serel/badge'
require 'serel/comment'
require 'serel/event'
require 'serel/inbox'
require 'serel/info'
require 'serel/post'
require 'serel/privilege'
require 'serel/question'
require 'serel/reputation'
require 'serel/request'
require 'serel/revision'
require 'serel/site'
require 'serel/suggested_edit'
require 'serel/tag'
require 'serel/tag_score'
require 'serel/tag_synonym'
require 'serel/tag_wiki'
require 'serel/user'

# HTTP magic
require 'cgi'
require 'json'
require 'net/http'
require 'uri'
require 'zlib'

class Serel::NoAPIKeyError < StandardError; end
