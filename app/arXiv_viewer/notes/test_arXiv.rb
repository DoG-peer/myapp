# coding : SJIS

require 'minitest'
require './arXiv.rb'

Minitest::autorun

class TestArXiv < Minitest::Test
  def setup
  end

  def test_hoge
    x = ArXiv::Document.new(open './test.xml')
  end

  def test_get_entries
=begin

    xx = ArXiv::Request.new
    xx.set!({
      search_query: "all:electron",
      start: 0,
      max_results: 10
    })
    puts xx.get.entries

=end
  end

  def test_main

=begin
ArXiv::get({
  #search_query: [["all","electron"],["ti","F"]],
  search_query: "all:electron+AND+ti:F",
  start: 0,
  max_results: 10
},:it).first.dl_pdf
=end
  end
end


# search_query start max_results id_list sort_by sort_order



