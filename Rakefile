# WIDTH = "100%"
# HEIGHT = "60%"
# WIDTH = 212 # lacoctelera.com
# The wonderfull, do-it-all, Ruby script for WannaWidget
require "rubygems"
require "sinatra"
require "rake"
require "erb"
require "rdiscount"

WIDTH = 230
HEIGHT = 300
FPS = 31
PLAYER = 8
BGCOLOR = "#CDE988"
APP = "WannaWidget"
USER = "limalimon"

configure do
  # Rake tasks...
  def render_template(file)
    filename = File.basename(file).split(".")[0]
    case File.basename(file).split(".")[1]
    when "rhtml"
      extension = "html"
    when "rxml"
      extension = "xml"
    end
    to_file = filename + "." + extension
    puts "Rendering #{file}"
    open(to_file,"w") do |f|
      f << ERB.new(IO.read(file)).result
    end
  end

  task :compile do
    if @nodebug
      puts "Trace disabled"
      trace = " -trace no"
    else
      trace = ""
    end
    @start = Time.now
    ["*.rhtml","*.rxml"].each do |list|
      Dir[list].each do |tpl|
        render_template(tpl)
      end
    end
    puts %x(swfmill simple #{APP}.xml #{APP}.swf)
    rm "#{APP}.xml"
    puts %x(mtasc -swf #{APP}.swf -main -mx -version #{PLAYER} #{trace} #{APP}.as)
    @end = Time.now

    ["*.html","*.swf"].each do |list|
      Dir[list].each do |file|
        mv file, "deploy/#{file}"
      end
    end
    # Move things from 'assets' to 'deploy'
    Dir["assets/*.xml"].each do |f|
      cp f, "deploy/#{File.basename(f)}"
    end
  end

  task :notify do
    msg = "Finished compiling in #{@end - @start}s."
    if @nodebug
      msg += "\ntrace() disabled"
    end
    %x(growlnotify --name Rake -m '#{msg}' 'Rake')
  end

  task :nodebug do
    @nodebug = true
  end

  task :doc do
    require "rdiscount"
    File.open("deploy/readme.html","w") do |f|
      f << RDiscount.new(File.read("README")).to_html
    end
  end

  task :exit do
    exit
  end

  task :release => [:nodebug,:compile,:doc,:notify,:exit]

  task :default => [:compile,:exit]
end

def swf_helper
  return "<embed src=\"#{@server_path}swf/#{USER}\" width=\"#{WIDTH}\" height=\"#{HEIGHT}\" type=\"application/x-shockwave-flash\"></embed>"
end

before do
  @server_path = "http://" + request.env["HTTP_HOST"] + request.env["REQUEST_PATH"]
end

get "/" do
  Rake::Task[:compile].execute
  erb swf_helper
end
get "/swf/:username" do
  send_file 'deploy/WannaWidget.swf', :type => 'application/x-shockwave-flash', :disposition => 'inline'
end
get "/xml/:username" do
  send_file "deploy/test.xml", :disposition => "inline"
end
get "/favicon.ico" do
  send_file "assets/favicon.ico", :disposition => "inline"
end