Feature: Image Update
  As an editor
  I want edit an image's information
  So that it is visible on the site

  Background:
    Given there exists an image
    And I am on the edit page for the image

  @mock_s3
  Scenario: Edit Page Display
    Then I should see the fields with image information
    And I should see a listing of the image styles

  @mock_s3
  Scenario: Valid Update
    When I make valid changes to the image
    And I click "Update Image"
    Then the image should have the correct properties

  @mock_s3
  Scenario: Image Deletion
    When I click "Delete Image"
    Then the image should no longer exist
    And I should be on the image manage page
    And I should see an image deletion success message
