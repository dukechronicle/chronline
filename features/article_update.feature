Feature: Article Update
  As an editor
  I want to edit an article
  So that I can change incorrect information

  @javascript
  Scenario: Edit Page Display
    Given there exists an article
    And I am on the edit article page
    Then I should see the fields with article information
