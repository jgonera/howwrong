require "quiz_store"

class QuizQuestionsController < BaseQuestionsController
  before_action do
    @quiz = Quiz.friendly.find(params[:quiz_id])
    @title = @quiz.title

    # Use Integer instead of #to_i to raise an exception if string is not a
    # number
    @question_number = params[:n] ? Integer(params[:n]) : 1
    @question_index = @question_number - 1

    session[:quizzes] ||= {}
    @quiz_store = QuizStore.new(session[:quizzes], @quiz)
  end

  def show
    @question =
      if @question_index
        @quiz.questions[@question_index]
      else
        @quiz.questions.first
      end

    # Use #length because questions are already fetched and #count would run
    # a separate SQL query
    @questions_count = @quiz.questions.length
    @questions_left = @questions_count - @question_index

    set_share_urls

    # Specify n in case it's not there (default quiz route)
    if @quiz_store.voted_for?(@question.id)
      redirect_to action: 'results', n: @question_number
    end
  end

  def vote
    @question = @quiz.questions[@question_index]
    answer_id = params[:answer_id].to_i

    unless @quiz_store.voted_for?(@question.id)
      is_correct = answer_id == @question.answers.correct.id
      @quiz_store.vote(@question.id, is_correct)

      if @quiz_store.all_voted?
        @quiz.register_score!(@quiz_store.score)
      end
    end

    super
  end

  def results
    @question = @quiz.questions[@question_index]

    # Use #length because questions are already fetched and #count would run
    # a separate SQL query
    @questions_count = @quiz.questions.length
    @questions_left = @questions_count - @question_number

    @next_question = @quiz.questions[@question_index + 1]
    if @next_question
      @next_label = "Next question"
      @next_path = path_for(action: "show", quiz_id: @quiz, n: @question_number + 1)
    else
      @next_label = "Done"
      @next_path = path_for(action: "quiz_results", quiz_id: @quiz)
    end

    set_share_urls

    super
  end

  # Move this to a separate QuizController?
  def quiz_results
    return redirect_to(action: 'show') unless @quiz_store.all_voted?

    @score = @quiz_store.score.round
    @average_score = @quiz.average_score.round
    @how_wrong =
      if (@score - @average_score).abs <= 5
        "You're average"
      elsif @score < @average_score
        "You're way below average"
      elsif @score > @average_score
        "You're better than average"
      end

    set_share_urls
  end

  private

  def set_share_urls
    @share_url = url_for(action: "show", quiz_id: @quiz.slug)
    @share_twitter_url = "https://twitter.com/intent/tweet?" + {
      url: @share_url,
      via: "howwrongyouare"
    }.to_query
    @share_facebook_url = "https://www.facebook.com/share.php?" + {
      u: @share_url
    }.to_query
  end
end
