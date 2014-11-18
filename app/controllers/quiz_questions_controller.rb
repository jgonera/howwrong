class QuizQuestionsController < BaseQuestionsController
  before_action do
    # Use Integer instead of #to_i to raise an exception if string is not a
    # number
    @question_number = params[:n] ? Integer(params[:n]) : 1
    @question_index = @question_number - 1
  end

  def show
    @quiz = Quiz.friendly.find(params[:quiz_id])

    @question =
      if @question_index
        @quiz.questions[@question_index]
      else
        @quiz.questions.first
      end

    # Specify n in case it's not there (default quiz route)
    redirect_to action: 'results', n: @question_number if session[:voted].has_key? @question.id
  end

  def vote
    @quiz = Quiz.friendly.find(params[:quiz_id])
    @question = @quiz.questions[@question_index]

    super
  end

  def results
    @quiz = Quiz.friendly.find(params[:quiz_id])
    @question = @quiz.questions[@question_index]

    # This is more efficient than questions.count because questions are already
    # cached after fetching the current question
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

  end
end
