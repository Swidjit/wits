class ContactFormsController < ApplicationController


  def create
    c = ContactForm.new(:name => params[:name], :email => params[:email], :message => params[:message])
    c.deliver
    respond_to do |format|
      format.js {render 'create'}
    end
  end

end
