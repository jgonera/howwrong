class QuizQuestionsController < BaseQuestionsController
  def show
    @quiz = Quiz.friendly.find(params[:quiz_id])

    @question =
      if params[:id]
        @quiz.questions.friendly.find(params[:id])
      else
        @quiz.questions.first
      end
  end
end
