class SheetWrapper
  
  attr_accessor :index
  
  def initialize(worksheet)
    @sheet = worksheet
    @index = 0
  end

  def add_row(array)
    @sheet.row(@index).concat array
    @index += 1
  end 
  
  def add_lines(count)
    @index += count
  end 
end