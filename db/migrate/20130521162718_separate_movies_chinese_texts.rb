class SeparateMoviesChineseTexts < ActiveRecord::Migration
  def up
    Movie.all.each do |movie|

      if has_chinese_text?(movie, :movie_title)
        split_chinese_text(movie, :movie_title)

        movie.save(validate: false)
      end

      if has_chinese_text?(movie, :cast)
        split_chinese_text(movie, :cast)

        movie.save(validate: false)
      end

      if has_chinese_text?(movie, :director)
        split_chinese_text(movie, :director)

        movie.save(validate: false)
      end

      if has_chinese_text?(movie, :synopsis)
        split_chinese_text(movie, :synopsis)

        movie.save(validate: false)
      end

    end
  end

  def down
  end

  private

  def has_chinese_text?(object, attribute)
    contains_cjk?(object.send(attribute))
  end

  def split_chinese_text(object, attribute)
    text = object.send(attribute)

    english, chinese = split_it(text)

    object.send(:"#{attribute}=", english)
    object.send(:"chinese_#{attribute}=", chinese)
  end

  def split_it(string)
    words = string.split(/\s+/)
    english_words, chinese_words = words.partition { |word| contains_cjk?(word) }

    [english_words.join(" "),  chinese_words.join(" ")]
  end


  def contains_cjk?(string)
    !!(string =~ /\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/)
  end
end
