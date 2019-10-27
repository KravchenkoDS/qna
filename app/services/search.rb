class Services::Search
  SEARCH_TYPES = {
      all: nil,
      question: Question,
      answer: Answer,
      comment: Comment,
      user: User
  }

  def initialize(params)
    @params = params
  end

  def call
    ThinkingSphinx.search @params[:search_string], classes: get_classes(@params[:search_type])
  end

  private

  def get_classes(search_type)
    return nil if search_type.empty?
    [search_type.capitalize.constantize]
  end
end
