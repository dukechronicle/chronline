Feature: Image Upload
  As a photo editor
  I want to upload an image
  So that it can be attached to an article

  @javascript
  Scenario: Single Upload
    Given I am on the image upload page
    When I attach an image file
    And I start the upload
    Then a new Image should be created
    And it should contain the file
    And the image file should be uploaded to S3
    And it should not show an upload error
