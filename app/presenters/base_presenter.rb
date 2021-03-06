class BasePresenter
  
  def initialize(object, locals, template)
    @object = object
    @locals = locals
    @template = template
  end
  
  def favicon(host)
    begin
      host = URI::parse(host).host.parameterize
    rescue Exception => e
      host = nil
    end
    @template.content_tag :span, '', class: "favicon-wrap" do
      @template.content_tag(:span, '', class: "favicon-default") + 
      @template.content_tag(:span, '', class: "favicon favicon-#{host}")
    end
  end
  
  def favicon_url(host)
    verifier = ActiveSupport::MessageVerifier.new(ENV['FAVICON_KEY'] || 'secret')
    favicon = Base64.urlsafe_encode64(verifier.generate(host))
    uri = URI::HTTP.build(
      host: ENV["FAVICON_HOST"],
      path: "/favicon/#{favicon}"
    )
    uri.scheme = Feedbin::Application.config.force_ssl ? "https" : "http"
    uri.to_s
  end

  private

  def self.presents(name)
    define_method(name) do
      @object
    end
  end
  
end