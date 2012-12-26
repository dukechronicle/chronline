Feature: Image Management
  As an editor
  I want to see a listing of all recent images
  So that I can edit and delete them

  Background:
    Given there exist 3 images
    And I am on the index images page

  @javascript @mock_s3
  Scenario: Image listing
    Then I should see a listing of images sorted by creation date
    And they should have the thumbnail versions
    And they should have links to image edit pages
    And they should have links to delete images

  @javascript @mock_s3
  Scenario: Image listing
    When I click an image delete link
    Then I should see 2 images listed
    And I should see an image deletion success message
