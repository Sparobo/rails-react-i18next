class HomeController < ApplicationController
  def index
    # 実際はDBから取得
    @lang = params[:lang]
  end
end
