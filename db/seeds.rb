# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

question = Question.create text: "How many Iraqis, both combatants and civilians, do you think have died as a consequence of the war that began in Iraq in 2003?"
question.answers.create [
  { label: "Up to 5,000" },
  { label: "5,001 — 10,000" },
  { label: "10,001 — 20,000" },
  { label: "20,001 — 50,000" },
  { label: "100,001 — 500,000", is_correct: true },
  { label: "500,001 — 1,000,000" },
  { label: "1,000,001+" }
]
