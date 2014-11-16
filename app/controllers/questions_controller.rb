class QuestionsController < BaseQuestionsController
  # FIXME: this needs tests/refactoring
  def render(*args)
    if @question
      exclude = session[:voted].keys
      exclude << @question.id
      next_question = Question.random(1, exclude: exclude).first
      @next_question_path = next_question.nil? ? "/archive" : question_path(next_question)
    end

    super
  end

  def index
    @question = Question.featured.where.not(id: session[:voted].keys).last

    if @question.nil?
      @questions = Question.all
      render 'archive'
    else
      @other_questions = Question.random(exclude: @question.id)
      render 'show'
    end
  end

  def archive
    @questions = Question.all
  end

  def show
    @question = Question.friendly.find params[:id]
    redirect_to action: 'results' if session[:voted].has_key? @question.id
    @title = @question.text
    @other_questions = Question.random(exclude: @question.id)
  end

  def results
    super

    short_url = short_question_url @question.id
    @twitter_url = "https://twitter.com/intent/tweet?" + {
      text: @is_wrong ? "I was wrong about #{@question.topic}" : "I was right about #{@question.topic}",
      url: short_url,
      via: "howwrongyouare"
    }.to_query
    @facebook_url = "https://www.facebook.com/share.php?" + {
      u: short_url
    }.to_query
    @other_questions = Question.random(exclude: @question.id)
  end

  def short
    redirect_to action: 'show', id: Question.find(params[:id]).slug
  end
end
