class ApplicationMailer < ActionMailer::Base
  default from: 'hello@affini.me',
          reply_to: 'dontillman@org'
  layout 'mailer'
end
