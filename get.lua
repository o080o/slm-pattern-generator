return function(url)
	local xhr = js.new(window.XMLHttpRequest)
	xhr:open("GET", url, false) -- Synchronous
	-- Need to pcall xhr:send(), as it can throw a NetworkError if CORS fails
	local ok, err = pcall(xhr.send, xhr)
	if not ok then
		return nil, tostring(err)
	elseif xhr.status ~= 200 then
		return nil, "HTTP GET " ..  xhr.statusText .. ": " .. url
	end
	return xhr.responseText
end
