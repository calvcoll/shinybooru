require "shinybooru/version"
require "http_requestor"
require "nokogiri"

module Shinybooru
  class Booru
    attr_accessor :online

    def initialize
      @booru = HTTP::Requestor.new "gelbooru.com"
      checkConnection
    end

    def checkConnection
      conn = @booru.get 'index.php'
      if conn
        @online = true
      end
    rescue TimeoutError
      @online = false
    end

    def errors
      !@online
    end

    def booru_get (page)
      @booru.get '/index.php?page=dapi&s=post&q=index' + page
    end

    def posts (args=Hash.new)
      limit = args[:limit]
      limit = 1 if limit.nil?
      nsfw = args[:nsfw]
      nsfw = true if nsfw.nil?
      tags = args[:tags]
      tags = [] if tags.nil?
      if @online
        req = '&limit=' + limit.to_s
        if tags
          unless tags.is_a? String
            tags = tags.join('%20')
          end
          req += '&tags=' + tags
        end
        unless nsfw
          explicit_tags = '-rating%3aquestionable%20-rating%3explicit'
          unless tags
            req += '&tags=' + explicit_tags
          else
            req += '%20' + explicit_tags
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
      else
        raise Shinybooru::OfflineError
      end
    end
  end

  class OfflineError < StandardError
  end

  class Post
    attr_reader :data
    def initialize (nokogiri_data)
      @data = Hash.new
      nokogiri_data.attribute_nodes.each do |node|
        unless node.name == "tags"
          @data[node.name.to_sym] = node.value
        end
        if node.name == "tags" # so the tags are a list
          @data[node.name.to_sym] = node.value.split " "
        end
        data
      end
    end
  end
end
