module Tumblr
  class TumblrPost < Tumblr::BaseModel
    lazy_attr_reader :id, :post_url, :type, :timestamp, :date, :reblog_key, :liked,
                     :photos, :text, :title, :link

    def photos
      @photos ||= @attrs["photos"].present? ? @attrs["photos"].map{|p| p["alt_sizes"].first.try(:fetch, "url", nil)} : []
    end

    def text
      @text ||= case @attrs["type"]
          when "photo" then @attrs["caption"]
          when "quote" then "#{@attrs["text"]} <br/> #{@attrs["source"]}"
          when "link" then @attrs["description"]
          when "audio", "video" then @attrs["caption"]
          when "answer" then question_text(@attrs)

          else @attrs["body"]
      end
    end

    def title
      @title ||= (@attrs["title"] || @atrs["source_title"])
    end

    def link
      @link ||= (@attrs["url"] || @attrs["source_url"])
    end



    protected
      def question_text attr
        "<p class='question'>#{attr["question"]} <br/> Asked by <a href='#{attr["asking_url"]}' target='_blank'>#{attr["asking_name"]}</a></p> #{attr["answer"]}"
      end


  end
end