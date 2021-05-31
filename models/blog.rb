class Blog
  class Item
    attr_accessor :title, :content
    def initialize(title, author, content, date)
      @title, @author, @content = title, author, content
      @date = Time.now
    end

    def save

      File.open("./data/blogs/#{date}_#{author.name}", 'w') do |file|
        file.write(content)
      end
    end
  end
end