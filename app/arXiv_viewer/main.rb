# coding : UTF-8
require 'active_record'
require './arXiv.rb'


ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "./arxiv.sqlite3"
)
I18n.enforce_available_locales = false

class Paper < ActiveRecord::Base
  validates :title, presence: true
  validates :link_pdf, uniqueness: true
  #self.table_name = "papers"
end


module ArXiv
  class Entry
    def add_to_db
      Paper.create(
        title: title,
        abstract: summary,
        link_pdf: link_pdf,
        published: published      
      )
    end
    # uniqueness
  end
end

hash = {
  search_query: 'cat:math.GT',
  start: 0,
  max_results: 1000,
  sort_by: 'lastUpdatedDate',
  sort_order: 'descending' 
}

ArXiv::get(hash, :it).each(&:add_to_db)

=begin
`
sqlite3 arxiv.sqlite3
.read imoprt.sql

`



=end
