Feature: Staff Update
  As an editorial user
  I want to edit a staff profile
  So that the correct information will appear on the site

  Background:
    Given there exists an author staff member
    And I am on the edit page for the staff

  Scenario: Edit Page Display
    Then I should see the fields with staff information

  Scenario: Valid Update
    When I make valid changes to the author
    And I click "Update Staff"
    Then the author should have the correct properties

  Scenario: Staff Deletion
    When I click "Delete Staff"
    Then the staff should no longer exist
    And I should be on the staff manage page
    And I should see a staff deletion success message