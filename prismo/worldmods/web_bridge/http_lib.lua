-- In http_lib.lua

return function(http)
    -- Create a new table to hold our functions
    local http_lib = {}

    -- Function to make an HTTP GET request
    function http_lib.request_http_get(url)
        -- Use http.fetch to make the HTTP request
        http.fetch({url = url}, function(res)
            if res.succeeded then
                print("HTTP GET request succeeded with code " .. res.code)
                print("Response body: " .. res.data)
            else
                print("HTTP GET request failed with message: " .. res.error_message)
            end
        end)
    end

    return http_lib
end