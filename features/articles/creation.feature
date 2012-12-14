Feature: Article Creation
  As an editor
  I want to create an article
  So that it can get displayed on the site

  @javascript
  Scenario: Invalid creation
    Given I am on the new article page
    When I fill in "Title" with "Ash defeats Gary in Indigo Plateau"
    And I click "Create Article"
    Then the "Title" field should be set to "Ash defeats Gary in Indigo Plateau"
    And the "Body" field should show an error

  @javascript
  Scenario: Valid creation
    Given I am on the new article page
    And an author "Hiker Martin" exists
    When I enter a valid article
    And I add author "Hiker Martin"
    And I click "Create Article"
    Then a new Article should be created
    And the article should have the correct properties
