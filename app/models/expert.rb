class Expert < ApplicationRecord
  # Validations for databse attributes
  validates_presence_of :first_name, :license_number, :specialty, :last_name, :website
  validates :phone, presence: {message: 'Enter valid Mobile Number'},
                      numericality: true,
                      length: { minimum: 10, maximum: 15 }
  # validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, :presence => true, :uniqueness => true, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}

  has_attached_file :image, styles: { tiny: "25x25#",medium: "300x300>", thumb: "100x100>" }, default_url: "/images/noimage.png"
  # validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :image, content_type: [/\Aimage\/.*\z/,'application/txt','application/rtf','application/pdf', 'application/doc','application/docx']

  attr_writer :remove_image           #Attribute writer for image remove

  before_save :before_save_callback   #Callback to perform remove image

  def remove_image                    #function for attr_writer
    @remove_image || false
  end

  def before_save_callback            #function for before_save Callback
      self.image.clear if self.remove_image == '1'
  end
end
