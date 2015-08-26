require "shinybooru/version"
require "http_requestor"

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
      @booru.get 'index.php' + page
    end

    def index
      if @online
        (booru_get 'posts').message
      end
    end

  end
end
