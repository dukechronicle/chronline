Feature: Image Management
  As an editor
  I want to see a listing of all recent images
  So that I can edit and delete them

  @javascript
  Scenario: Image listing
    Given there exist 3 images
    And I am on the index images page
    Then I should see a listing of images sorted by creation date
    And they should have the thumbnail versions
    And they should have links to image edit pages
    And they should have links to delete images

  @javascript
  Scenario: Image listing
    Given there exist 3 images
    And I am on the index images page
    When I click "Delete"
    Then I should see 2 images listed
