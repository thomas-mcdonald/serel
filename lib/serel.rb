$: << File.dirname(__FILE__)

require 'serel/exts'
require 'serel/finder_methods'
require 'serel/relation'
require 'serel/base'
require 'serel/answer'
require 'serel/badge'
require 'serel/comment'
require 'serel/question'
require 'serel/request'
require 'serel/user'

require 'cgi'
require 'json'
require 'net/http'
require 'uri'
require 'zlib'

Serel::Base.config(:gaming, '0p65aJUHxHo0G19*YF272A((')

# a = Serel::Comment.get

# puts a
