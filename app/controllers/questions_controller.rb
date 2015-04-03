class QuestionsController < BaseQuestionsController
  def index
    @question = Question.featured.where.not(id: @vote_store.voted_questions).last

    if @question.nil?
      @questions = Question.all
      render 'archive'
    else
      @other_questions = Question.random(exclude: @question.id)
      set_next_path
      set_share_urls
      render 'show'
    end
  end

  def archive
    @questions = Question.all
  end

  def show
    @question = Question.friendly.find params[:id]
    redirect_to action: 'results' if @vote_store.has_answer_for?(@question.id)
    @title = @question.text
    @other_questions = Question.random(exclude: @question.id)
    set_next_path
    set_share_urls
  end

  def vote
    @question = Question.friendly.find(params[:id])

    super
  end

  def results
    @question = Question.friendly.find(params[:id])
    @title = @question.text

    super

    set_next_path

    share_text =
      if @is_wrong
        "I was wrong about #{@question.topic}"
      else
        "I was right about #{@question.topic}"
      end
    set_share_urls("Share your score", share_text)
  end

  def short
    redirect_to action: 'show', id: Question.find(params[:id]).slug
  end

  private

  def set_next_path
    exclude = @vote_store.voted_questions + [@question.id]
    next_question = Question.random(1, exclude: exclude).first
    @next_path = next_question.nil? ? "/archive" : question_path(next_question)
  end

  def set_share_urls(title = "Share", text = "")
    @share_title = title
    @share_url = url_for(action: "show", id: @question.slug)
    @embed_url = url_for(
      controller: "embedded_questions",
      action: "show",
      id: @question.slug
    )
    @share_twitter_url = "https://twitter.com/intent/tweet?" + {
      text: text,
      url: @share_url,
      via: "howwrongyouare"
    }.to_query
    @share_facebook_url = "https://www.facebook.com/share.php?" + {
      u: @share_url
    }.to_query
  end
end
