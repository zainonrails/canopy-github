require_relative './client.rb'
require 'json'

module Github
  class Processor
    # This class is responsible for processing the response from the Github API.
    # It accepts a client object and stores it as an instance variable.
    # It has a method called `issues` that returns a list of issues from the Github API.
    def initialize(client)
      @client = client
    end

    def issues(open: true)
      # This method returns a list of issues from the Github API.
      # It accepts an optional argument called `open` that defaults to true.
      # If `open` is true, it returns only open issues.
      # If `open` is false, it returns only closed issues.
      # It makes a GET request to the Github API using the client object.
      # It returns the response from the Github API.

      state = open ? 'open' : 'closed'
      # Return a list of issues from the response, with each line showing the issue's title, whether it is open or closed,
      # and the date the issue was closed if it is closed, or the date the issue was created if it is open.
      # the issues are sorted by the date they were closed or created, from newest to oldest.
      
      issues = @client.get_all_paginated('/issues', { state: state })
      issues_count = issues.size
      puts "Total issues found: #{issues_count}"

      sorted_issues = issues.sort_by do |issue|
        if state == 'closed'
          issue['closed_at']
        else
          issue['created_at']
        end
      end.reverse
      
      sorted_issues.each do |issue|
        if issue['state'] == 'closed'
          puts "#{issue['title']} - #{issue['state']} - Closed at: #{issue['closed_at']}"
        else
          puts "#{issue['title']} - #{issue['state']} - Created at: #{issue['created_at']}"
        end
      end
    end
  end
end
# The URL to make API requests for the IBM organization and the jobs repository
# would be 'https://api.github.com/repos/ibm/jobs'.
Github::Processor.new(Github::Client.new(ENV['TOKEN'], ARGV[0])).issues(open: false)
