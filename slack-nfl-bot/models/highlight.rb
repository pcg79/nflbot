class Highlight
  attr_reader :brief_headline, :video_detail_page_url

  def initialize(highlight_params)
    @brief_headline = highlight_params["briefHeadline"]
    @video_detail_page_url = highlight_params["videoDetailPageUrl"]
  end

  def to_s
    <<~TEXT
    #{brief_headline}
    #{video_detail_page_url}
    TEXT
  end
end
