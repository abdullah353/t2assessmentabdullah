Feature: Ghana End To End
  In order to assess a Ghanaian child's reading abilities
  As an enumerator
  I want to do the Ghanaian assessment

@javascript
Scenario: Open page
  Given I am on http://localhost:5984/egra/_design/app/_rewrite
  Then I should see "Enumerator Name"
  When I fill in "name" with "jsmith"
  And I should see "Password"
  And I fill in "password" with "secret"
  And I touch "Login"
  Then I should see "Available Assessments"
  When I touch "The Gambia EGRA May 2011"
  Then I should see "Date Time"
  And I touch "Next"
  Then I should see "School"
  And I touch "Dedza"
  Then I should see "2742" in the ID field
  And I touch "Next"
  Then I should see "Enumerator Reminders"
  And I touch "Next"
  Then I should see "Enumerator Introduction"
  And I touch "Next"
  Then I should see "Student Consent"
  And I touch "Yes, continue"
  And I touch "Next"
  Then I should see "Student Information"
  And I touch "Full day"
  And I touch "No"
  And I touch "1st"
  And I touch "A"
  And I touch "1997"
  And I touch "January"
  And I touch "Female"
  And I touch "Next"
  Then I should see "Letters Instructions"
  And I touch "Next"
  Then I should see "Letters"
  And I touch "start"
  Then I should see "5"
  And I touch "stop"
  Then I should see "Select last item attempted"
  And I touch "E"
  Then I should not see "Select last item attempted"
  And I touch "Next"
  Then I should see "Phonemes Instructions"
  And I touch "Next"
  Then I should see "Phonemes"
  And I touch "Correct"
  And I touch "Next"
  Then I should see "Familiar Words Instructions"
  And I touch "Next"
  Then I should see "Familiar Words"
  And I touch "start"
  Then I should see "5"
  And I touch "stop"
  Then I should see "Select last item attempted"
  And I touch "walk"
  Then I should not see "Select last item attempted"
  And I touch "Next"
  Then I should see "Invented Words Instructions"
  And I touch "Next"
  Then I should see "Invented Words"
  And I touch "start"
  Then I should see "5"
  And I touch "stop"
  Then I should see "Select last item attempted"
  And I touch "nid"
  And I touch "Next"
  Then I should see "Oral Passage Reading Instructions"
  And I touch "Next"
  Then I should see "Oral Passage Reading"
  And I touch "start"
  Then I should see "5"
  And I touch "stop"
  Then I should see "Select last item attempted"
  And I touch "today."
  And I touch "Next"
  Then I should see "Reading Comprehension Instructions"
  And I touch "Next"
  Then I should see "Reading Comprehension"
  And I touch "Correct"
  And I touch "Next"
  Then I should see "Listening Comprehension Instructions"
  And I touch "Next"
  Then I should see "Listening Comprehension"
  And I touch "Correct"
  And I touch "Next"
  Then I should see "Dictation Instructions"
  And I touch "Next"
  Then I should see "Dictation"
  And I touch "Next"
  Then I should see "Pupil Context Interview Instructions"
  And I touch "Next"
  Then I should see "Pupil Context Interview"
  And I touch "Next"
  Then I should see "Results"
  And I should not see "Invalid results"
