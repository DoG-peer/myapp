# coding : SJIS
#
#
#EXTS = %w{.exe .rb}
def read_config(config_file)
  File.open(config_file, "r") do |f|
    # line 1
    main_dir = File.expand_path( f.gets.chomp, File.dirname(__FILE__))

    # line 2
    case f.gets
    when /ignore/
      type = :ignore
    when /pickup/
      type = :pickup
    else
      raise "Format Error"
    end

    # other lines
    dirs = f.readlines.map(&:chomp).map{|x| File.expand_path(x, main_dir)}

    files = Dir["#{main_dir}/**/*"].select do |x|
      (File.ftype(x) != "directory") && (EXTS.include? File.extname(x))
    end

    files.map!{|x|[x, type == :ignore ]}

    dirs.each do |dir|
      files.map! do |file, flag|
        if /#{dir}/ =~ file
          if type == :ignore
            [file, false]
          else
            [file, true]
          end
        else
          [file, flag]
        end
      end
    end 

    return {files: files.select(&:last).map(&:first), type: type, dir: main_dir}
  end
end

def pass_through_configs!(files)
  configs = Dir["#{ File.dirname(__FILE__)}/*_config.txt"].map do |target|
    read_config(target)
  end

  configs.each do |con|
    files.select! do |file|
      if file =~ /^#{con[:dir]}/
        con[:files].include? file
      else
        true
      end
    end
  end
  files
end

=begin
# use_case

files = Dir["#{app_dir}/**/*"].select do 
  |x| (File::ftype(x) != "directory") && (EXTS.include? File.extname(x))
end
pass_through_configs!(files)

=end
