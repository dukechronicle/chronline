Feature: Staff Creation
  As an editorial user
  I want to create a staff member
  So that his/her profile appears on the site

  @javascript
  Scenario: Creation without specifiying type
    Given I am on the new staff page
    When I fill in "Name" with "Ash Ketchum"
    And I click "Create Staff"
    Then the "Name" field should be set to "Ash Ketchum"
    And the "Type" field should show an error
