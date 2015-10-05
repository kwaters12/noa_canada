class Asset < ActiveRecord::Base
  belongs_to :order

  has_attached_file :document, default_url: "/images/:style/missing.png"
  validates_attachment :document, :content_type => { :content_type => %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document) }

end
