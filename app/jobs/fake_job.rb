class FakeJob < ApplicationJob
  queue_as :default

  def perform(*args)

    puts 'Hello'
    puts 'Hello'
    puts 'Hello'
    puts 'Hello'
    puts 'Hello'
    puts 'Hello'
    puts 'Hello'
    puts 'Hello'
    puts 'Hello'
    puts 'Hello'
    puts 'Hello'
    puts 'Hello'
  end
end
