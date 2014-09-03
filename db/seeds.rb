# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

question = Question.create(
  text: "How many Iraqis, both combatants and civilians, do you think have died as a consequence of the war that began in Iraq in 2003?",
  topic: "Iraq War",
  source: "Iraq Body Count",
  source_url: "https://www.iraqbodycount.org/",
  is_featured: true
)

positive_feedback = Feedback.create(
  text: "Good job :*",
  is_positive: true
)

negative_feedback = Feedback.create(
  text: "You suck!",
  is_positive: false
)

question.answers.create [
  { label: "Up to 5,000", votes: 50, feedback: negative_feedback},
  { label: "5,001 — 10,000", votes: 59, feedback: negative_feedback},
  { label: "10,001 — 20,000", votes: 21, feedback: negative_feedback },
  { label: "20,001 — 50,000", votes: 0, feedback: negative_feedback },
  { label: "50,001 — 100,000", votes: 4, feedback: negative_feedback },
  { label: "100,001 — 500,000", votes: 45, is_correct: true, feedback: positive_feedback },
  { label: "500,001 — 1,000,000", votes: 3, feedback: negative_feedback},
  { label: "1,000,001+", votes: 32, feedback: negative_feedback}
]

question2 = Question.create(
  text: "How old is the known universe, in years?",
  topic: "age of the universe",
  source: "Wikipedia",
  source_url: "https://en.wikipedia.org/wiki/Age_of_the_universe",
  is_featured: true
)

question2.answers.create [
  { label: "~4 billion ", votes: 50, feedback: negative_feedback},
  { label: "~7000", votes: 590, feedback: negative_feedback},
  { label: "~2 million", votes: 121, feedback: negative_feedback },
  { label: "~20,000", votes: 40, feedback: negative_feedback },
  { label: "~14 billion", votes: 405, is_correct: true, feedback: positive_feedback }
]


question3 = Question.create(
  text: "What is the percentage of women holding CEOs roles at Fortune 500 companies?",
  topic: "women CEOs",
  source: "Wikipedia",
  source_url: "https://en.wikipedia.org/wiki/Women_CEOs_of_the_Fortune_500",
  is_featured: false
)

question3.answers.create [
  { label: "1%", votes: 50, feedback: negative_feedback},
  { label: "4.4%", votes: 590, is_correct: true, feedback: positive_feedback },
  { label: "23.2%", votes: 121, feedback: negative_feedback },
  { label: "30.9%", votes: 40, feedback: negative_feedback },
  { label: "50%", votes: 405, feedback: negative_feedback }
]

quiz = Quiz.create(title: "Awesome quiz")
quiz.questions << question2 << question3

