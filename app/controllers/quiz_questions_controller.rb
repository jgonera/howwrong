class QuizQuestionsController < BaseQuestionsController
  before_filter :set_question_number

  def show
    @quiz = Quiz.friendly.find(params[:quiz_id])

    @question =
      if @question_index
        @quiz.questions[@question_index]
      else
        @quiz.questions.first
      end
  end

  def vote
    @quiz = Quiz.friendly.find(params[:quiz_id])
    @question = @quiz.questions[@question_index]

    super
  end

  def results
    @quiz = Quiz.friendly.find(params[:quiz_id])
    @question = @quiz.questions[@question_index]
    @next_question_path = quiz_question_path(@quiz, @question_number + 1)

    super
  end

  protected

  def set_question_number
    # use Integer instead of #to_i to raise an exception if string is not a
    # number
    @question_number = params[:n] ? Integer(params[:n]) : 1
    @question_index = @question_number - 1
  end
end
