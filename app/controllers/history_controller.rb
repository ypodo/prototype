class HistoryController < ApplicationController
  
  def history
  end

  def show
    @orders=current_user.orders
    #@inviteHistorys=current_user.inviteHistorys
  end

  def export
  end
  
  def ajax_history_invites_by_token
    if !current_user.orders.nil?
      @inviteHistorys=current_user.inviteHistorys.where(:token=>params[:id])
      render :partial => 'inviteHistorys'
    end
  end
end
