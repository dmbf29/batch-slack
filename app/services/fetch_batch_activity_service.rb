class FetchBatchActivityService
  attr_reader :batch, :date, :response

  def initialize(batch, date = Date.today)
    @batch = batch
    @date = date
  end

  def call
    student_activity = batch.github_usernames.map do |github_username|

      puts "Scraping Github activity for:"
      puts github_username
      puts
      @response = ScrapeGithubActivityService.new(github_username).call
      today = get_todays_activity
      week = get_activity(6)
      # puts "Week activity: #{week}"
      two_week = get_activity(13)
      # puts "2 Week activity: #{two_week}"
      month = get_month_activity
      # puts "Month activity: #{month}"

      {
        github_username: github_username,
        today_activity: today,
        last_7_days_activity: week,
        last_14_days_activity: two_week,
        last_month_activity: month,
        last_year_activity: get_year_activity
      }
    end

    {
      batch: batch.number,
      day: date.strftime('%Y-%m-%d'),
      students_of_the_day: [
        student_activity.max_by { |student| student[:today_activity] }
      ],
      ranking: student_activity.sort_by { |student| student[:last_14_days_activity] }
    }
  end

  def get_todays_activity
    today = response[:contributions].find { |day| day[:date] == date.to_s }
    today ? today[:count] : 0
  end

  def get_activity(num_days)
    start_index = get_index(date)
    unless start_index
      puts "Cant find dates - #{date}"
      puts
    end
    start_index ? get_score(start_index, start_index + num_days) : 0
  end

  def get_month_activity
    start_index = get_index(date)
    end_index = get_index(date - 1.month)
    get_score(start_index, end_index)
  end

  def get_year_activity
    start_index = get_index(date)
    end_index = get_index(date - 1.year)
    get_score(start_index, end_index)
  end

  def get_index(given_date)
    start_date = response[:contributions].find { |day| day[:date] == given_date.to_s }
    response[:contributions].index(start_date)
  end

  def get_score(start_index, end_index)
    return 0 unless start_index && end_index
    # puts "Get Score... start_index: #{start_index} | end_index: #{end_index}  "

    (start_index..end_index).sum do |day_index|
      response[:contributions][day_index] ? response[:contributions][day_index][:count] : 0
    end
  end
end
