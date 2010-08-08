module MoviesHelper
  def movie_release_years
    require 'date'
    
    years = Array.new
    i = 0    
    end_year = DateTime.now.year + 2

    #1900.upto(end_year) do |x|
    end_year.downto(1900) do |x|
      years[i] = x.to_s
      i = i + 1
    end
    years
  end
  
end
