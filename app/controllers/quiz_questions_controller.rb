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
      @next_path = quiz_question_path(@quiz, @question_number + 1)
    else
      @next_label = "Done"
      @next_path = quiz_results_path(@quiz)
    end

    super
  end

  # Move this to a separate QuizController?
  def quiz_results
    questions_count = @quiz.questions.count

    if session[:quizzes][@quiz.id][:voted].length < questions_count
      redirect_to action: 'show'
      return
    end

    @score = session[:quizzes][@quiz.id][:correct_count] / questions_count.to_f
    @score = (@score * 100).round
  end
end
