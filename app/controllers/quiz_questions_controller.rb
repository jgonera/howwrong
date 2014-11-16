class QuizQuestionsController < BaseQuestionsController
  before_filter :set_question_number

  def show
    @quiz = Quiz.friendly.find(params[:quiz_id])

    @question =
      if @n
        @quiz.questions[@n]
      else
        @quiz.questions.first
      end
  end

  def vote
    @quiz = Quiz.friendly.find(params[:quiz_id])
    @question = @quiz.questions[@n]

    super
  end

  def results
    @quiz = Quiz.friendly.find(params[:quiz_id])
    @question = @quiz.questions[@n]
    @next_question_path = quiz_question_path(@quiz, @n + 1)

    super
  end

  protected

  def set_question_number
    # use Integer instead of #to_i to raise an exception if string is not a
    # number
    @n = params[:n] ? Integer(params[:n]) : 0
  end
end
