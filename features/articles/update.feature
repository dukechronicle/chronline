Feature: Article Update
  As an editor
  I want to edit an article
  So that I can change incorrect information

  Background:
    Given there exists an article with authors
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
  Scenario: Valid Update
    When I make valid changes
    And I click "Update Article"
    Then the article should have the correct properties

  @javascript
  Scenario: Article Deletion
    When I click "Delete Article"
    Then article should no longer exist
    And I should be on the article manage page
    And I should see a deletion success message

  @javascript
  Scenario: Title Update
    When I fill in "Title" with "New title"
    And I click "Update Article"
    And I go to the original edit article path
    Then I should be on the edit article page
