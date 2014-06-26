# coding : SJIS


EXTS = %w{.exe .rb}

puts "アプリを選んでください"


dir = File.dirname __FILE__
require "#{dir}/helper.rb"
app_dir = "#{dir}/app"
files_dir = "#{dir}/files"
loop do
  puts "-"*20
  files = Dir["#{app_dir}/**/*"].select do 
    |x| (File::ftype(x) != "directory") && (EXTS.include? File.extname(x))
  end
  pass_through_configs!(files)

  puts files.map.with_index{|file,i|"[#{i}] : #{File.basename file}"}
  puts "数値で選んでください"
  parameter = gets.chomp
  
  case parameter
  when "help", "h"
    puts <<-EOS
      help, h       : ヘルプ
      dir, d        : #{__FILE__}のあるディレクトリを開く
      edit, e       : #{__FILE__}をgvimで開く
      数値          : 選択肢のファイルを実行
      q, quit, exit : 終了

      現在のディレクトリは#{Dir.pwd}です
    EOS

  when "dir", "d"
    `Explorer #{File.dirname(__FILE__).gsub("/", "\\")}`
  
  when "edit", "e"
    system "gvim #{__FILE__.gsub("/", "\\")}"
  when "q", "quit", "exit"
    exit

  when /\d+/
    # 値が大きいとき
    num = parameter.to_i
    unless num < files.length
      puts "値が大きすぎます"
      next
    end
    # メインの処理
    file = files[num]
    case File.extname(file)
    when '.rb'
      `START ruby #{file}`
    else
      `START #{file}`
    end

  else 
    next
  end


end
