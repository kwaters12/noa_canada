class Order < ActiveRecord::Base
  belongs_to :agent
  belongs_to :taxpayer

  has_attached_file :document, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment :document, :content_type => { :content_type => %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document) }
end
