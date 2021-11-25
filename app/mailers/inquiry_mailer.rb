class InquiryMailer < ActionMailer::Base
  default from: "anthony@billgood.co.uk"
  default to:   "good.anthony@gmail.com, hayley.k.sothinathan@gmail.com"

  def notification(inquiry)
    @inquiry = inquiry

    mail(subject: 'New Inquiry at billgood.co.uk')
  end
end
