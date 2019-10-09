class HomeController < ApplicationController
  def index
    # 実際はDBから取得
    @lang = params[:lang]
    I18n.locale = @lang
  end
end
