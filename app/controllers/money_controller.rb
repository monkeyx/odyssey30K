class MoneyController < ApplicationController
  def ledger
    @monies = Money.cash_log(current_user)
    render :layout => 'colorbox'
  end
end
