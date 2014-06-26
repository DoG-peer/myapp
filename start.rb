# coding : SJIS


EXTS = %w{.exe .rb}

puts "�A�v����I��ł�������"


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
  puts "���l�őI��ł�������"
  parameter = gets.chomp
  
  case parameter
  when "help", "h"
    puts <<-EOS
      help, h       : �w���v
      dir, d        : #{__FILE__}�̂���f�B���N�g�����J��
      edit, e       : #{__FILE__}��gvim�ŊJ��
      ���l          : �I�����̃t�@�C�������s
      q, quit, exit : �I��

      ���݂̃f�B���N�g����#{Dir.pwd}�ł�
    EOS

  when "dir", "d"
    `Explorer #{File.dirname(__FILE__).gsub("/", "\\")}`
  
  when "edit", "e"
    system "gvim #{__FILE__.gsub("/", "\\")}"
  when "q", "quit", "exit"
    exit

  when /\d+/
    # �l���傫���Ƃ�
    num = parameter.to_i
    unless num < files.length
      puts "�l���傫�����܂�"
      next
    end
    # ���C���̏���
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
