class InvitationsController < ApplicationController

  def check
    invite = Invitation.where(:invite_code => params[:invite_code]).first
    if invite
      invite.destroy
      render 'valid'
    else
      render 'invalid'
    end
    
  end



end
