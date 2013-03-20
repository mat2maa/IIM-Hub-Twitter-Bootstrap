module CategoriesHelper

  def category_options_for_select
    #testHash = Category.find(:all)
    #eachResults = testHash.each { |k,v| [k.id,v.name] }
    #collectResults = testHash.collect { |k,v| [k.id,v.name] }
    Category.order("name")
            .map { |e| [e.id, e.name] }
    #categories =  {"rock"=> 1,"jap pop"=> 2}
  end
end
