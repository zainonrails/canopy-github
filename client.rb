require 'httparty'

module Github
  class Client
    # this class is responsible for making requests to the Github API
    # It accepts a personal access token and stores it as an instance variable.
    # It has a method called `get` that accepts a URL and returns the response
    # from the Github API

    def initialize(token, repo_url)
      # implement this method
      @token = token
      @repo_url = repo_url
    end

    def get(url)
      # this method generates the required headers that use the bearer token 
      # and makes a GET request to the Github API using the provided URL.
      # It returns the response from the Github API
      # It appends the path in the url argument to the repo_url instance variable
      # to form the full URL
      HTTParty.get("#{@repo_url}#{url}", headers: headers)
    end

    # This method handles pagination automatically and returns all results as an Array
    def get_all_paginated(path, query_params = {})
      all_items = []
      page = 1
      per_page = 100 # GitHub's max per page to minimize API calls
      
      loop do
        # Build URL with pagination parameters
        current_params = query_params.merge(page: page, per_page: per_page)
        query_string = build_query_string(current_params)
        url = "#{path}#{query_string}"
        
        response = get(url)
        
        # Handle API errors
        unless response.success?
          raise "GitHub API error: #{response.code} - #{response.body}"
        end
        
        items = JSON.parse(response.body)

        # Break if no more items
        break if items.empty?
        
        all_items.concat(items)
        page += 1
        
        # GitHub returns less than per_page items on the last page
        break if items.size < per_page
      end
      
      all_items
    end

    private


    def headers
      # this method returns the headers required to make requests to the Github API using a personal access token
      # An API version is required
      {
        'Authorization' => "Bearer #{@token}",
        'User-Agent' => 'Github Client',
        "X-GitHub-Api-Version" => "2022-11-28"
      }
    end

    def build_query_string(params)
      return '' if params.empty?
      
      query_params = params.map { |k, v| "#{k}=#{URI.encode_www_form_component(v)}" }
      "?#{query_params.join('&')}"
    end
  end
end
