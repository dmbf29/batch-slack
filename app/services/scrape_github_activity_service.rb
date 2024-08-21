class ScrapeGithubActivityService
  attr_reader :username, :url, :activity, :today

  def initialize(username)
    @username = username
    @url = "https://github.com/#{username}"
    @activity = { contributions: [] }
    @today = Date.today
  end

  def call
    doc = get_doc
    # for the already loaded current year (this won't add empty dates for the future)
    get_year_info(doc)
    # Removed the additional years
    # doc.search('.contribution-activity .filter-list li').each do |element|
    #   year = element.text.strip
    #   next if year.to_i == Date.today.year # already added in hash
    #   sleep(1)

    #   puts "Year: #{year}"
    #   doc = get_doc(year)
    #   get_year_info(doc)
    # end
    # order by date?
    @activity
  end

  def get_year_info(doc)
    doc.search('.ContributionCalendar-day').reverse.each do |day|
      # skips extra spots with no date
      next unless day.attributes['data-date']
      # skips future dates
      next if Date.parse(day.attributes['data-date'].value) > today

      # OLD WAY that doesn't work 👇
      # count_match = day.text.strip.match(/\A\d+/)

      tooltip_id = day.attributes['id'].value
      tooltip_text = doc.search("tool-tip[for='#{tooltip_id}']").text
      count_match = tooltip_text.strip.match(/\A\d+/)
      day_hash = {
        date: day.attributes['data-date'].value,
        count: count_match ? count_match[0].to_i : 0,
        level: day.attributes['data-level'].value.to_i
      }
      @activity[:contributions] << day_hash
    end
  end

  def get_doc(year = Date.today.year)
    url = "https://github.com/#{@username}?tab=overview&from=#{year}-01-01&to=#{year}-12-31"
    browser = Watir::Browser.new :chrome, options: { args: ['--headless', '--disable-gpu', '--no-sandbox', '--disable-dev-shm-usage', '--disable-notifications', '--disable-extensions'] }
    browser.goto(url)
    # sleep(3)
    Nokogiri::HTML.parse(browser.html)
    # html = HTTParty.get(url)
    # Nokogiri::HTML(html, nil, 'utf-8')
  end
end
