DisqusRails.setup do |config|
	config::SHORT_NAME = "virt-u"
	config::SECRET_KEY = ENV["disqus_app_secret"]
	config::PUBLIC_KEY = ENV["disqus_app_key"]
	config::ACCESS_TOKEN = ENV["disqus_access_token"]
end