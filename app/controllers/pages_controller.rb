class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @batches = Batch.order(number: :desc)
  end
end
