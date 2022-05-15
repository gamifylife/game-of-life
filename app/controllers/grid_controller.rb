class GridController < ApplicationController
  def index
    puts "index controller"
    
    if flash[:redirected_from] != "/grid/upload"
      session[:error] = nil
    end

    @error = session[:error]
  end

  def upload
    puts "Upload method"

    begin
      session[:generation], session[:size], session[:matrix] = validate_file(params[:grid_file])
      session[:error] = nil
      redirect_to "/grid/layout"
    rescue Exception => ex
      puts ex
      session[:error] = ex
      redirect_to "/grid/index", flash: { redirected_from: request.path }
    end
  end

  def validate_file(file)
    puts "Validate method"
    
    generation = ""
    size = []
    grid = []
    File.foreach(file).each_with_index do |line, index|
      if index == 0
        pattern = "^Generation [0-9]+:$"
        if line.delete("\r\n\\").match(pattern)
          generation = line.split()[1].chomp(":")
        else
          raise "Error at line #{index}: line '#{line}' does not match pattern '#{pattern}'"
        end
      elsif index == 1
        pattern = "^[0-9]+ [0-9]+$"
        if line.delete("\r\n\\").match(pattern)
          size = line.split()
        else
          raise "Error at line #{index}: line '#{line}' does not match pattern '#{pattern}'"
        end
      else
        pattern = "^([\.\*])+$"
        line = line.strip
        if line.match(pattern)
          simbols = line.split("")
          grid.append(simbols.map{ |x| x == "." ? 0 : 1 })
        else
          raise "Error at line #{index}: line '#{line}' does not match pattern '#{pattern}'"
        end
      end
    end
    return generation, size, grid
  end

  def layout()
    puts "layout method"
    @generation = session[:generation]
    @size = session[:size]
    @matrix = session[:matrix]
  end
end
