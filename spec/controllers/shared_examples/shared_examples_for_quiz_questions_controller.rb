# Requires quiz, question, another_question and params to be defined in parent spec.

RSpec.shared_examples "quiz questions controller" do
  describe "GET show" do
    context "when question number is not specified" do
      before :each do
        get :show, quiz_id: quiz.slug
      end

      it "assigns question numbers" do
        expect(assigns(:question_number)).to eq 1
        expect(assigns(:question_index)).to eq 0
        expect(assigns(:questions_left)).to eq quiz.questions.length
        expect(assigns(:questions_count)).to eq quiz.questions.length
      end

      it "assigns quiz and its first question" do
        expect(assigns(:quiz)).to eq quiz
        expect(assigns(:question)).to eq quiz.questions.first
      end
    end

    context "when question number is specified" do
      before :each do
        get :show, another_params
      end

      it "assigns question numbers" do
        expect(assigns(:question_number)).to eq 2
        expect(assigns(:question_index)).to eq 1
        expect(assigns(:questions_left)).to eq quiz.questions.length - 1
        expect(assigns(:questions_count)).to eq quiz.questions.length
      end

      it "assigns quiz and given question" do
        expect(assigns(:quiz)).to eq quiz
        expect(assigns(:question)).to eq another_question
      end
    end
  end

  describe "POST vote" do
    it "increments correct answers for quiz in session if answer is correct" do
      post :vote, params.merge(answer_id: question.answers.correct.id)

      expect(session[:quizzes][quiz.id][:correct_count]).to eq 1
    end

    it "doesn't increment correct answers for quiz if question already voted on" do
      post :vote, params.merge(answer_id: question.answers.wrong.first.id)
      post :vote, params.merge(answer_id: question.answers.correct.id)

      expect(session[:quizzes][quiz.id][:correct_count]).to eq 0
    end

    it "doesn't register score if quiz not finished" do
      expect_any_instance_of(Quiz).not_to receive(:register_score!)

      post :vote, params.merge(answer_id: question.answers.correct.id)
    end

    context "when voting on the last question" do
      before :each do
        post :vote, params.merge(answer_id: question.answers.wrong.first.id)
      end

      it "updaes quiz's average_score" do
        expect {
          post :vote, another_params.merge(answer_id: another_question.answers.correct.id)
          quiz.reload
        }.to change { quiz.average_score }
      end

      it "updaes quiz's times_taken" do
        expect {
          post :vote, another_params.merge(answer_id: another_question.answers.correct.id)
          quiz.reload
        }.to change { quiz.times_taken }
      end
    end
  end

  describe "GET results" do
    context "when vote made" do
      before :each do
        session[:voted] = { question.id => answer.id }
      end

      it "assigns question numbers" do
        get :results, params
        expect(assigns(:question_number)).to eq 1
        expect(assigns(:question_index)).to eq 0
        expect(assigns(:questions_left)).to eq quiz.questions.length - 1
      end

      it "assigns link to next question" do
        get :results, params
        expect(assigns[:next_label]).to eq "Next"
        expect(assigns[:next_path]).to eq path_to_next_question
      end

      it "assigns link to quiz results if it's the last question" do
        get :results, quiz_id: quiz.slug, n: quiz.questions.count
        expect(assigns[:next_label]).to eq "Done"
        expect(assigns[:next_path]).to eq path_to_quiz_results
      end
    end
  end

  describe "GET quiz_results" do
    let(:quiz_store) { instance_double("QuizStore") }

    before :each do
      allow(QuizStore).to receive(:new).with({}, quiz) { quiz_store }
    end

    context "when all questions answered" do
      let(:score) { 56 }
      let(:other_quizzes) do
        [
          double("Quiz"),
          double("Quiz"),
          double("Quiz"),
        ]
      end

      before :each do
        allow(quiz_store).to receive(:all_voted?) { true }
        allow(quiz_store).to receive(:score) { score }
        allow(Quiz).to receive(:random).with(exclude: quiz) { other_quizzes }
      end

      it "assigns score" do
        get :quiz_results, quiz_id: quiz.slug

        expect(assigns[:score]).to eq score
      end

      it "assigns average_score" do
        get :quiz_results, quiz_id: quiz.slug

        expect(assigns[:average_score]).to eq quiz.average_score.round
      end

      it "assigns other_quizzes" do
        get :quiz_results, quiz_id: quiz.slug

        expect(assigns[:other_quizzes]).to match_array other_quizzes
      end

      context "when score lower than average_score by > 5% points" do
        let(:score) { quiz.average_score - 6 }

        it "assigns below average how_wrong" do
          get :quiz_results, quiz_id: quiz.slug

          expect(assigns[:how_wrong]).to eq "You're way below average"
        end
      end

      context "when score within 5% points of average_score" do
        let(:score) { quiz.average_score - 3 }

        it "assigns below average how_wrong" do
          get :quiz_results, quiz_id: quiz.slug

          expect(assigns[:how_wrong]).to eq "You're average"
        end
      end

      context "score higher than average_score by > 5% points" do
        let(:score) { quiz.average_score + 6 }

        it "assigns above average how_wrong" do
          get :quiz_results, quiz_id: quiz.slug

          expect(assigns[:how_wrong]).to eq "You're better than average"
        end
      end
    end

    context "when not all questions answered" do
      before :each do
        allow(quiz_store).to receive(:all_voted?) { false }
      end

      it "redirects to the quiz" do
        get :quiz_results, quiz_id: quiz.slug

        expect(response).to redirect_to action: :show
      end
    end
  end
end
