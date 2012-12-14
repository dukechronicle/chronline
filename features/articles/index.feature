Feature: Article Management
  As an editor
  I want to see a listing of all recent articles
  So that I can edit and delete them

  @javascript
  Scenario: Article listing
    Given there exist 10 articles
    And I am on the article index page
    Then I should see a listing of articles sorted by creation date
    And they should have links to edit pages
    And they should have links to delete them

  @javascript
  Scenario: Article deletion
    Given there exist 10 articles
    And I am on the article index page
    When I click "Delete"
    Then I should see 9 articles

  @javascript
  Scenario: Article pagination
    Given there exist 30 articles
    And I am on the article index page
    Then I should see 25 articles
    And it should have a link to the next page