require_relative "./distill/version"
require_relative "./distill/cli"
require_relative "./distill/scraper"
require_relative "./distill/book"
require_relative "./distill/genre"

#we've decided to not put content here. this act as an "environment" files
#which does the job of requiring other files

require 'nokogiri'
require 'open-uri'
#we can't just put this here. we also have to "get" them in the .gemspec file.
#usually we do it in gemfile
#but here in gemspec. then re require them here.
#hopefully this will make the other .rb files in the lib folder be able to use nokogiri
#NO ONE COULD QUITE ARITCULATE THE EXACT RULES. very frustating
#therea rae many wyas and we're just like copying one bit from each source. tau hoa nhap ma!!!



#apprently when i disabled this module the Distill:CLI thing still works
#im gonna leave it here still, though commented

# module Distill
#   class Error < StandardError; end
#   # Your code goes here...
#
# end
