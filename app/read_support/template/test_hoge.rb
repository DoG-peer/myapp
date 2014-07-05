# coding : SJIS

require 'minitest'
require './hoge.rb'

Minitest::autorun

class TestHoge < Minitest::Test

  def setup
  end

  def test_hoge
    assert_equal 'a', 'a'
  end

end




