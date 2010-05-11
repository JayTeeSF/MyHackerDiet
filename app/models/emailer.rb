class Emailer < ActionMailer::Base

  def contact(recipient, subject, message, sent_at = Time.now)
    @subject = subject
    @recipients = recipient
    @from = 'no-reply@digital-drip.com'
    @sent_on = sent_at
    @body["title"] = 'MyHackerDiet.com Withings Event'
    @body["email"] = 'jon@digital-drip.com'
    @body["message"] = message
    @headers = {}
  end


end
