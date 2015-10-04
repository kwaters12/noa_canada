class StaticPagesController < ApplicationController
  def faqs
  end

  def contact
    @message = Message.new
    @taxpayer = Taxpayer.new
  end

  def contact_agent(taxpayer)
    @taxpayer = taxpayer
  end
end