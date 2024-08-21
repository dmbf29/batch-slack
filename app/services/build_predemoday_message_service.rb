class BuildPredemodayMessageService
  attr_reader :results, :batch

  def initialize(batch, results)
    @results = results
    @batch = batch
  end

  def call
    top = get_top(results[:ranking])

    build_message(top)
  end

  private

  def get_top(rankings)
    rankings.sort_by! { |student| student[:last_14_days_activity] }.reverse!
    # harded coded top 10 for now
    top = rankings[0..10]
    top.map.with_index do |student, index|
      alumnus = student[:alumnus]
      "#{index + 1}. #{alumnus[:first_name]} #{alumnus[:last_name]} - #{student[:last_14_days_activity]} commits"
    end
  end

  def build_message(top)
    [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "*Top :github: contributors from the last two weeks*"
        }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": top.join("\n")
        }
      }
    ]
  end
end
