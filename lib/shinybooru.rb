require 'shinybooru/version'
require 'http_requestor'
require 'nokogiri'

module Shinybooru
  # A gem which returns an easy to use object for Gelbooru requests
  class Booru
    attr_accessor :online, :url

    def initialize(site = nil)
      good_sites = %w(gelbooru.com safebooru.org)
      # Default to safebooru
      @url = if good_sites.include? site
               site
             else
               'safebooru.org'
             end
      @booru = HTTP::Requestor.new @url
      check_connection
    end

    def check_connection
      begin
        conn = @booru.get 'index.php'
        @online = true if conn
      rescue TimeoutError
        @online = false
      end
    end

    def errors
      !@online
    end

    def booru_get(page)
      @booru.get '/index.php?page=dapi&s=post&q=index' + page
    end

    def posts(args = {})
      limit = args[:limit].nil? ? 10 : args[:limit]
      tags = args[:tags].nil? ? [] : args[:tags]
      sfw = args[:sfw] == true
      # Always sfw if safebooru, so no need for rating tags
      sfw = false if @url == 'safebooru.org'

      raise Shinybooru::OfflineError unless @online

      req = '&limit=' + limit.to_s

      if tags
        tags = tags.join('%20') unless tags.is_a? String
        req += '&tags=' + tags
      end

      if sfw
        explicit_tags = '-rating%3aquestionable%20-rating%3explicit'
        req += if tags
                 '%20' + explicit_tags
               else
                 '&tags=' + explicit_tags
               end
      end

      data = Nokogiri::Slop((booru_get req).body)
      posts = []

      data.posts.children.each do |post|
        if post.is_a? Nokogiri::XML::Element
          posts.push Shinybooru::Post.new(post)
        end
      end

      if posts.length > 1
        posts
      else
        posts[0]
      end
    end
  end

  class OfflineError < StandardError
  end

  # Used internally
  class Post
    attr_reader :data
    def initialize(nokogiri_data)
      @data = {}
      nokogiri_data.attribute_nodes.each do |node|
        @data[node.name.to_sym] = if node.name == 'tags'
                                    # so that the tags are a list
                                    node.value.split ' '
                                  else
                                    node.value
                                  end
        data
      end
    end
  end
end

# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2 smarttab foldmethod=syntax:
