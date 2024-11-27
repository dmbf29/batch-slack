class CreateGithubMessageService
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
    top = rankings[0...10]
    top.map.with_index do |student, index|
      "#{student[:github_username]} - #{student[:last_14_days_activity]} commits"
    end
  end

  def build_message(top)
    content =
      "<h3><i class='fa-brands fa-github'></i> Top Github contributors from the last two weeks</h3>
      <ol>
      #{ top.map { |msg| "<li>#{msg}</li>" }.join }
      </ol>"

    Message.create(content: content, batch: batch, user: User.first)
  end
end
