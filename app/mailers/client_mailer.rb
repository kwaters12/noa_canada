class ClientMailer < ApplicationMailer
  default from: 'info@noacanada.ca'

  def dropbox_link(client, link)
    @client = client
    @link = link
    mail(to: @client.email, subject: 'Your NOA Shared Folder')
  end

  def contact_form(taxpayer)
    @taxpayer = taxpayer
    mail(to: 'info@noacanada.ca', subject: 'Contact Form Submission')
  end

end
