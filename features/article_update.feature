Feature: Article Update
  As an editor
  I want to edit an article
  So that I can change incorrect information

  Background:
    Given there exists an article
    And I am on the edit article page

  @javascript
  Scenario: Edit Page Display
    Then I should see the fields with article information

  @javascript
  Scenario: Invalid Update
    When I leave "Title" empty
    And I click "Update Article"
    Then the "Title" field should show an error

  @javascript
  Scenario: Invalid Update
    When I make valid changes
    And I click "Update Article"
    Then the article should have the correct properties
