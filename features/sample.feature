Feature: Durt provided sample
  Scenario: Typing your input
    Given I run `bin/durt` interactively
    When I type "Name"
    Then I close the stdin stream
    Then output should contain exactly:
    """
    0.1.0
    Hey, let us know your name:
    Hello, Name!
    """
  Scenario: File passed as argument
    Given a file named "file.txt" with:
    """
    Name
    """
    When I run `bin/durt file.txt`
    Then output should contain exactly:
    """
    0.1.0
    Hey, let us know your name:
    Hello, Name!
    """
  Scenario: File passed via STDIN
    Given a file named "file.txt" with:
    """
    Name
    """
    When I run `bin/durt` interactively
    And I pipe in the file "file.txt"
    Then output should contain exactly:
    """
    0.1.0
    Hey, let us know your name:
    Hello, Name!
    """
