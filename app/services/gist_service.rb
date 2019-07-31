class GistService
  def initialize(link, client = default_client)
    @client = client
    @gist = @client.gist(link.url.split('/').last)
  end

  def content
    @gist.files.to_hash.each_with_object([]) do |file, string|
      string << { file_content_gist: file[1][:content] }
    end
  end

  private

  def default_client
    Octokit::Client.new
  end
end
