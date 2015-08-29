require 'spec_helper'

online = Shinybooru::Booru.new.checkConnection

describe Shinybooru do
  before :each do
    @booru = Shinybooru::Booru.new
    @booru.checkConnection
  end

  it 'has a version number' do
    expect(Shinybooru::VERSION).not_to be nil
  end

  it 'should get a response or timeout' do
    expect(@booru.checkConnection).not_to be nil
  end

  it 'should alert the user if no connection' do
    @booru.online = false
    expect(@booru.errors).not_to be nil
  end

  it 'should raise error if offline' do
    @booru.online = false
    expect{@booru.posts}.to raise_error Shinybooru::OfflineError
  end

  if online
    it 'should get a post' do
      expect(@booru.posts).not_to be nil
    end

    it 'should separate post tags' do
      expect(@booru.posts(limit: 1).data[:tags]).to be_kind_of Array
    end

    it 'should return a Shinybooru::Post object if only one post requested' do
      expect(@booru.posts(limit: 1)).to be_kind_of Shinybooru::Post
    end

    it 'should return an array for multiple posts' do
      expect(@booru.posts(limit: 2)).to be_kind_of Array
    end

    it 'should return multiple posts if asked' do
      expect(@booru.posts(limit: 2).length).to be > 1
    end

    it 'should return post with tags asked for' do
      expect(@booru.posts(limit: 1, nsfw: false, tags: "highres").data[:tags].include? "highres").to be true
    end

    it 'should return post with multiple tags' do
      expect(@booru.posts(limit: 1, nsfw: false, tags: ["highres", "japanese_clothes"]))
    end

    # Currently not working, blame Gelbooru!
    # it 'should return safe post with nsfw turned off' do
    #   expect(@booru.posts(limit: 1, nsfw: false).data[:rating] == "s").to be true
    # end
  end
end
