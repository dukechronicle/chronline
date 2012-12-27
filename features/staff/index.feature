Feature: Staff Search
  As an editorial user
  I want to search for staff members
  So that I can edit and delete them

  Scenario: Search Autocomplete
    Given an author "Gentleman Ralph" exists
    And an author "Lass Charlotte" exists
    And I am on the index staff page
    When I fill in the search box with "L"
    Then I should see the typeahead suggestion "Lass Charlotte"

  Scenario: Search Success
    Given an author "Gambler Gordon" exists
    And I am on the index staff page
    When I fill in the search box with "Gambler Gordon"
    And I click "Search"
    Then I should be on the edit staff page for "Gambler Gordon"
