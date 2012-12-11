Feature: Article Creation

  @javascript
  Scenario: Invalid creation
    Given I am on the new article page
    When I fill in "Subtitle" with "Oak arrives just in time"
    And I click "Create Article"
    Then the "Title" field should show an error
    And the "Body" field should show an error
    And the "Subtitle" field should be set to "Oak arrives just in time"
