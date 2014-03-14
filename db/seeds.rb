# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

question = Question.create(
  text: "How many Iraqis, both combatants and civilians, do you think have died as a consequence of the war that began in Iraq in 2003?",
  source: "Iraq Body Count",
  source_url: "https://www.iraqbodycount.org/"
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
