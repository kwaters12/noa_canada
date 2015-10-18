class ClientMailer < ApplicationMailer
  default from: 'info@noacanada.ca'

  def dropbox_link(order)
    @order = order
    mail(to: @order.agent.email, subject: 'Your NOA Shared Folder')
  end

  def order_notification(order)

  end

  def contact_form(taxpayer)
    @taxpayer = taxpayer
    mail(to: 'info@noacanada.ca', subject: 'Contact Form Submission')
  end

  def welcome_email(agent)
    @agent = agent
    mail(to: @agent.email, subject: 'Welcome to NOACanada.ca')
  end

end
