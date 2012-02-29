$: << File.dirname(__FILE__)

# Utilities
require 'logger'
require 'serel/exts'
require 'serel/relation'
require 'serel/response'

# Types
require 'serel/base'
require 'serel/answer'
require 'serel/badge'
require 'serel/comment'
require 'serel/post'
require 'serel/privilege'
require 'serel/question'
require 'serel/reputation'
require 'serel/request'
require 'serel/revision'
require 'serel/site'
require 'serel/suggested_edit'
require 'serel/tag'
require 'serel/user'

# HTTP magic
require 'cgi'
require 'json'
require 'net/http'
require 'uri'
require 'zlib'

Serel::Base.config(:gaming, '0p65aJUHxHo0G19*YF272A((')

# a = Serel::Comment.get

# puts a
