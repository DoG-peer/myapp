# coding : SJIS
require 'fileutils'

THIS_DIR = File::dirname __FILE__
TEMPLATE_DIR = File::expand_path('template', THIS_DIR)

# Input filename
if ARGV.join(' ') == ""
  filename = gets.chomp
else
  filename = ARGV.join(' ')
end

name = File.basename(filename, '.*')
file = File.basename(filename)
file = file[0..-2] if file[-1] == "\""
filename = filename[1..-2] if filename[-1] == "\""

def create_dir(dir)
  Dir.mkdir dir unless Dir.exist? dir
end

def create_file(file)
  File.open file, "w" unless File.exist? file
end

begin
  top ="./#{name}"

  create_dir top
  # readme
  create_file "#{top}/readme.txt"
  
  # make, rake
  create_file "#{top}/Makefile"
  create_file "#{top}/Rakefile"
  
  # ref
  create_dir "./#{name}/ref"
  
  # notes
  create_dir "./#{name}/notes"
  
  # tests
  create_dir "./#{name}/test"
  
  #system 'pause'
  %w{.rb .cpp .tex}.each do |ext|
    Dir.glob("#{TEMPLATE_DIR}/*#{ext}").each do |file|
      test_file = "./#{name}/test/#{File.basename file}"
      FileUtils.copy_file(file, test_file)
    end
  end

  # concerns
  create_dir "./#{name}/concerns"
  
  if (File.exist? filename) && !(File.exist? "./#{name}/#{file}") && (filename != name)
    FileUtils.move(filename, "./#{name}/#{file}")
  end
rescue => exc
  puts exc
  system 'pause'

end
