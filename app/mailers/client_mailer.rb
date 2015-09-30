class ClientMailer < ApplicationMailer
  default from: 'info@noacanada.ca'

  def dropbox_link(client, link)
    @client = client
    @link = link
    mail(to: @client.email, subject: 'Your NOA Shared Folder')
  end
end
