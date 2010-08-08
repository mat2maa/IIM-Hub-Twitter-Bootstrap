# Email settings
ActionMailer::Base.delivery_method = :smtp  # or :sendmail
ActionMailer::Base.smtp_settings = {
:tls => "true", 
:address => "mail.iim.com.sg",
#:port => 587,
:domain => "iim.com.sg",
:authentication => :plain,
:user_name => "hub@iim.com.sg",
:password => "audio01hu02b"
}