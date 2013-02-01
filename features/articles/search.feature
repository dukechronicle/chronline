@wip
Feature: Article Search
  As a user
  I want to search for articles

  Scenario: Empty search query
    Given PENDING there exist 10 articles
    When PENDING I search for ""
    Then PENDING I should see 0 articles listed

  Scenario: Search by title
    Given PENDING an exists an with the title "Gotta Catch Em All"
    And PENDING there exist 10 articles without the words "Gotta Catch Em All"
    When PENDING I search for "Gotta Catch"
    Then PENDING I should see 1 article listed
    And PENDING it should have the title "Gotta Catch Em All"
