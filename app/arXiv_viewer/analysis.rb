# coding : UTF-8
require 'active_record'
require './arXiv.rb'


ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: './arxiv.sqlite3'
)



ar = []

class Paper < ActiveRecord::Base
  validates :title, presence: true
  validates :abstract, presence: true
  validates :link_pdf, uniqueness: true

  def analysis
    tw = {}
    title.split.each do |w|
      if tw.key? w
        tw[w] += 1
      else
        tw[w] = 1
      end    
    end

    aw = {}
    abstract.split.each do |w|
      if aw.key? w
        aw[w] += 1
      else
        aw[w] = 1
      end    
    end
    ar = tw.keys.product(aw.keys).map do |t,a|
      [t,a,tw[t]*aw[a]]
    end
    ar.sort{|x,y| y.last <=> x.last}
  end
end

ha = {}
Paper.all.each do |pa|
  pa.analysis.each do |a,b,c|
    k = "#{a} #{b}"
    ha[k] ||= 0
    ha[k] += c
  end
end

x = ha.to_a.sort{|x,y|y.last <=> x.last}

puts x[-10000..-1]
# 単純に単語を数える
#

