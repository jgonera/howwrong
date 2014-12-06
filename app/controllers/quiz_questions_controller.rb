class QuizQuestionsController < BaseQuestionsController
  before_action do
    @quiz = Quiz.friendly.find(params[:quiz_id])
    @title = @quiz.title

    # Use Integer instead of #to_i to raise an exception if string is not a
    # number
    @question_number = params[:n] ? Integer(params[:n]) : 1
    @question_index = @question_number - 1

    session[:quizzes] ||= {}
    session[:quizzes][@quiz.id] ||= { correct_count: 0, voted: {} }
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
    @questions_left = @quiz.questions.length - @question_index

    # Specify n in case it's not there (default quiz route)
    if session[:quizzes][@quiz.id][:voted].has_key?(@question.id)
      redirect_to action: 'results', n: @question_number
    end
  end

  def vote
    @question = @quiz.questions[@question_index]
    answer_id = params[:answer_id].to_i

    unless session[:quizzes][@quiz.id][:voted].has_key?(@question.id)
      session[:quizzes][@quiz.id][:voted][@question.id] = true
      session[:quizzes][@quiz.id][:correct_count] += 1 if answer_id == @question.answers.correct.id

      if session[:quizzes][@quiz.id][:voted].length == @quiz.questions.length
        @quiz.register_score!(get_score)
      end
    end

    super
  end

  def results
    @question = @quiz.questions[@question_index]

    # Use #length because questions are already fetched and #count would run
    # a separate SQL query
    @questions_left = @quiz.questions.length - @question_number

    @next_question = @quiz.questions[@question_index + 1]
    if @next_question
      @next_label = "Next question"
      @next_path = path_for(action: "show", quiz_id: @quiz, n: @question_number + 1)
    else
      @next_label = "Done"
      @next_path = path_for(action: "quiz_results", quiz_id: @quiz)
    end

    super
  end

  # Move this to a separate QuizController?
  def quiz_results
    if session[:quizzes][@quiz.id][:voted].length < @quiz.questions.count
      redirect_to action: 'show'
      return
    end

    @score = get_score.round
    @average_score = @quiz.average_score.round
    @how_wrong =
      if (@score - @average_score).abs <= 5
        "You're average"
      elsif @score < @average_score
        "You're way below average"
      elsif @score > @average_score
        "You're better than average"
      end
  end

  private

  def get_score
    session[:quizzes][@quiz.id][:correct_count].to_f / @quiz.questions.count * 100
  end
end
