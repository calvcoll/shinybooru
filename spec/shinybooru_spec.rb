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

  if online
    it 'should get a post' do
      expect(@booru.posts).not_to be nil
    end
  end
end
