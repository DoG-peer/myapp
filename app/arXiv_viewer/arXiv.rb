# coding : UTF-8

require 'net/http'
require 'uri'
#require 'rexml/document'
#require 'active_record'
require 'nokogiri'

module ArXiv
  
  class Request

    PARAM = %w{search_query start max_results id_list sort_by sort_order}


    def initialize(hash={})
      hash.each do |key, val|
        if PARAM.include?(key.to_s)
          sym = "@#{key}".to_sym
          instance_variable_set(sym, val)
        end
      end
    
      # [[x,y],[xx,yy]] の形もしくは
      # 直接文字列
      @search_query ||= []

    end

    def s_que
      if @search_query.is_a? String
        @search_query
      else
        @search_query.map{|key,val|"#{key}:#{val}"}.join('+AND+')
      end

    end

    def url
      x = "http://export.arxiv.org/api/query?search_query=#{s_que}"
      
      instance_variables.each do |var|
        case var
        when :@search_query
        when :@sort_by
          x += "&sortBy=#{instance_variable_get(var)}"
        when :@sort_order
          x += "&sortOrder=#{instance_variable_get(var)}"
        else
          x += "&#{var.to_s[1..-1]}=#{instance_variable_get(var)}"
        end
      end
      
      URI.parse(x)

    end

    def get
      req = Net::HTTP.get_response(url)
      Document.new(req.body)

    end

    def method_missing(method, *val, &block)
      if method[-1] == '=' && PARAM.include?(method[0...-1])
        name = "@#{method[0...-1]}".to_sym
        instance_variable_set(name, val.first)
      else
        super
      end

    end

  end


  # xml
  class Document

    def initialize(xml)
      @noko_xml = Nokogiri.XML(xml)

    end

    def method_missing(method, *args, &block)
      @noko_xml.send(method, *args, &block)

    end

    def entries
      css('entry').map{|e|Entry.new(e)}

    end

  end

  # それぞれのエントリーの処理
  class Entry
    attr_accessor :xml
    
    def initialize(xml)
      @xml = xml
    end

    def it
      self
    end

    def self.get_uniq(*ar)
      ar.each do |x|
        define_method x do
          @xml.css(x.to_s).text
        end
      end
    end

    get_uniq :id, :updated, :published, :title, :summary

    alias :old_title :title
    def title
      old_title.gsub(/\n/,' ').gsub(/\s+/,' ')

    end

    def authors
      @xml.css('author>name').map(&:text)
    end


    def link_pdf
      @xml.css('link[title="pdf"]').first['href']
    end
    def primary_category
      @xml.css('arxiv:primary_category').first['term']
    end

    def categories
      @xml.css('category').map{|x|x['term']}
    end

    def to_hash
      {
        title: title,
        authors: authors,
        abstract: summary,
        link_abs: id,
        link_pdf: link_pdf,
        updated: updated,
        published: published,
        categories: categories
      }
    end
  end

  def self.get(hash, sym=:to_hash)
    Request.new(hash).get.entries.map{|x|x.send(sym)}
  end

end


# only for me 
module ArXiv
  class Entry
    def dl_pdf
      filename = "#{authors.map{|au|au[0]}.join.upcase.strip}  #{title} #{File.basename link_pdf}"
      filename += '.pdf' unless filename =~ /\.pdf$/
      filename.gsub!(/[\\,\/,:,\*,\?,",<,>,\|]/, '_')
      # 使えない文字 \  / : * ? " < > |
      lk = link_pdf
      lk += '.pdf' unless lk =~ /\.pdf$/
      url = URI.parse lk
      File.open(filename, 'wb') do |f|
        f.write(Net::HTTP.get url)
      end
    end    
  end
end


module ArXiv
  def self.view
    hash = {
      search_query: 'cat:math.GT',
      start: 0,
      max_results: 25,
      sort_by: 'lastUpdatedDate',
      sort_order: 'descending' 
    }
    puts Request.new(hash).url
    puts
    l = '-'*80
    get(hash,:it).map{|x|[l,x.title, "  [#{x.link_pdf}]",x.updated,l, x.summary,l,'']}
  end
end


#puts ArXiv::view
