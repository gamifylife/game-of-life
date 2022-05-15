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
      print(session[:size])
      print(session[:grid_file])
      session[:error] = nil
      redirect_to "/grid/layout"
    rescue Exception => ex
      puts ex
      session[:error] = ex
      redirect_to "/grid/index", flash: { redirected_from: request.path }
    end
  end

  def compute(data)
    puts "Compute method"

    begin
      session[:matrix] = compute_next_gen(data[:matrix])
      session[:generation] = data[:generation] + 1
      session[:error] = nil
    rescue Exception => ex
      puts ex
      session[:error] = ex
    end
  end
  helper_method :compute
  
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
          size = line.split().map {|el| Integer(el)}
        else
          raise "Error at line #{index}: line '#{line}' does not match pattern '#{pattern}'"
        end
      else
        pattern = "^([\.\*])+$"
        line = line.strip
        if line.match(pattern)
          simbols = line.split("")
          grid.append(simbols.map {|x| x == "." ? 0 : 1})
        else
          raise "Error at line #{index}: line '#{line}' does not match pattern '#{pattern}'"
        end
      end
    end
    return Integer(generation), size, grid
  end

  def compute_next_gen(matrix)
    rows, cols = matrix.length, matrix[0].length
    matrix.each_index {|row|
      matrix[0].each_index {|col|
        neighbors = 0
        [row-1, row, row+1].each {|neigh_row|
          [col-1, col, col+1].each {|neigh_col|
            if neigh_row >= 0 && neigh_col >= 0 && neigh_row < rows && neigh_col < cols && (neigh_row != row || neigh_col != col)
              if [1, 3].include? matrix[neigh_row][neigh_col]
                neighbors += 1
              end
            end
          }
        }
        if matrix[row][col] > 0
          if [2, 3].include? neighbors
            matrix[row][col] = 3
          end
        elsif neighbors == 3
          matrix[row][col] = 2
        end
      }
    }
    mapped = matrix.map {|row| row.map {|el| 
      if [2, 3].include? el
        1
      elsif el == 1
        0
      else
        el
      end
    } }
    return mapped
  end

  def layout()
    puts "layout method"
    @generation = session[:generation]
    @size = session[:size]
    @matrix = session[:matrix]
  end
end
