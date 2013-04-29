note
	description: "Objects that represent a Web Browser"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEB_DRIVER

inherit {NONE}

	SE_JSON_WIRE_PROTOCOL
		rename
			back as se_back,
			forward as se_forward,
			refresh as se_refresh,
			window_position as se_window_position,
			window_maximize as se_window_maximize
		export
			{NONE} all
		end

create {SE_JSON_WIRE_PROTOCOL}
	make, make_with_host

feature -- Initialize Session

	start_session_firefox
		local
			l_capabilities: SE_CAPABILITIES
		do
			create l_capabilities.make
			l_capabilities.set_browser_name ("firefox")
			session := create_session_with_desired_capabilities (l_capabilities)
		end

	start_session_firefox_with_desired_capabilities (a_desired_capabilities: SE_CAPABILITIES)
		require
			browser_name_firefox: attached a_desired_capabilities.browser_name as l_browser_name and then l_browser_name ~ "firefox"
		do
			session := create_session_with_desired_capabilities (a_desired_capabilities)
		end

	start_session_chrome
		local
			l_capabilities: SE_CAPABILITIES
		do
			create l_capabilities.make
			l_capabilities.set_browser_name ("chrome")
			session := create_session_with_desired_capabilities (l_capabilities)
		end

	start_session_chrome_with_desired_capabilities (a_desired_capabilities: SE_CAPABILITIES)
		require
			browser_name_chrome: attached a_desired_capabilities.browser_name as l_browser_name and then l_browser_name ~ "chrome"
		do
			session := create_session_with_desired_capabilities (a_desired_capabilities)
		end

	start_session_ie
		local
			l_capabilities: SE_CAPABILITIES
		do
			create l_capabilities.make
			l_capabilities.set_browser_name ("internet explorer")
			session := create_session_with_desired_capabilities (l_capabilities)
		end

	start_session_ie_with_desired_capabilities (a_desired_capabilities: SE_CAPABILITIES)
		require
			browser_name_chrome: attached a_desired_capabilities.browser_name as l_browser_name and then l_browser_name ~ "internet explorer"
		do
			session := create_session_with_desired_capabilities (a_desired_capabilities)
		end

		--|TODO add create session with desired and required capabilities
		--|     add other drivers.
		--|     think about pre and postconditions

feature -- Query

	is_session_active: BOOLEAN
			-- exist a valid session?
		do
			Result := attached session
		end

feature -- Ime Handler

	activate_engine (engine: STRING_32)
			--	Make an engines that is available (appears on the list returned by getAvailableEngines) active.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				ime_activate (l_session.session_id, engine)
			end
		end

	deactivate
			--	De-activates the currently-active IME engine.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				ime_deactivate (l_session.session_id)
			end
		end

	available_engines: detachable LIST [STRING_32]
			-- List all available engines on the machine. To use an engine, it has to be present in this list.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				Result := ime_available_engines (l_session.session_id)
			end
		end

	is_activated: BOOLEAN
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				Result := ime_activated (l_session.session_id)
			end
		end

feature -- Navigation

	back
			-- Navigate backwards in the browser history, if possible.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				se_back (l_session.session_id)
			end
		end

	forward
			-- Navigate forwards in the browser history, if possible.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				se_forward (l_session.session_id)
			end
		end

	refresh
			--
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				se_refresh (l_session.session_id)
			end
		end

	to_url (an_url: STRING_32)
			-- Navigate to a new URL.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				navigate_to_url (l_session.session_id, an_url)
			end
		end

feature -- Options
	-- Stuff you would do in a browser menu

	add_cookie (cookie: SE_COOKIE)
			-- Set a cookie. If the cookie path is not specified, it should be set to "/".
			-- Likewise, if the domain is omitted, it should default to the current page's domain.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				set_cookie (l_session.session_id, cookie)
			end
		end

	delete_all_cookies
			-- Delete all cookies visible to the current page.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				delete_cookies (l_session.session_id)
			end
		end

	delete_cookie (cookie: SE_COOKIE)
			-- Delete the cookie with the given name.
			-- This command should be a no-op if there is no such cookie visible to the current page.
		require
			exist_session: is_session_active
		do
			if attached session as l_session and then attached cookie.name as l_name then
				delete_cookie_by_name (l_session.session_id, l_name)
			end
		end

	get_cookies: detachable LIST [SE_COOKIE]
			-- Retrieve all cookies visible to the current page.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				Result := retrieve_cookies (l_session.session_id)
			end
		end

	get_cookie (name: STRING_32): detachable SE_COOKIE
			-- Get a cookie with a given name
		require
			exist_session: is_session_active
		local
			found: BOOLEAN
		do
			if attached session as l_session then
				if attached retrieve_cookies (l_session.session_id) as l_list then
					from
						l_list.start
					until
						l_list.after or found
					loop
						if attached l_list.item.name as l_name and then l_name.is_case_insensitive_equal (name) then
							found := true
							Result := l_list.item
						end
						l_list.forth
					end
				end
			end
		end

feature -- Target Locator

	active_element: detachable WEB_ELEMENT
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				Result := element_active (l_session.session_id)
			end
		end

	default_content
			-- The server switch to the page's default content.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				frame (l_session.session_id, Void)
			end
		end

	frame_by_index (index: INTEGER)
			-- Select a frame by index `index'
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				frame (l_session.session_id, index.out)
			end
		end

	frame_by_name (name: STRING_32)
			-- Select a frame by name `name'
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				frame (l_session.session_id, name)
			end
		end

	frame_by_web_element (element: WEB_ELEMENT)
			-- Select a frame by name `name'
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				frame (l_session.session_id, element.element)
			end
		end

	window (name: STRING_32)
			-- Change focus to another window.
			-- The window to change focus to may be specified by its server assigned window handle, or by the value of its name attribute.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				change_focus_window (l_session.session_id, name)
			end
		end

feature -- Window

	window_position: SE_POINT
			-- Get the position of the current window.
		require
			exist_session: is_session_active
		do
			create Result
			if attached session as l_session then
				Result := se_window_position (l_session.session_id, "current")
			end
		end

	window_size: SE_DIMENSION
			--Get the size of the current window.
		require
			exist_session: is_session_active
		do
			create Result
			if attached session as l_session then
				Result := size_window (l_session.session_id, "current")
			end
		end

	window_maximize
			--Maximizes the current window if it is not already maximized
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				se_window_maximize (l_session.session_id, "current")
			end
		end

	set_window_position (target_position: SE_POINT)
			-- Set the position of the current window.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				change_window_position (l_session.session_id, "current", target_position.x, target_position.y)
			end
		end

	set_window_size (target_size: SE_DIMENSION)
			--Set the size of the current window.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				change_size_window (l_session.session_id, "current", target_size.width, target_size.height)
			end
		end

feature -- Common

	window_close
			--Close the current window, quitting the browser if it's the last window currently open.
		require
			exist_session: is_session_active
		do
			if attached session as l_session then
				close_window (l_session.session_id)
			end
		end

	find_element (by: SE_BY) : detachable WEB_ELEMENT
		-- Find the first WebElement using the given strategy.
		require
			exist_session : is_session_active
		do
			if attached session as l_session then

			end
		end

	find_elements (by: SE_BY) : detachable LIST[WEB_ELEMENT]
		-- Find all elements within the current page using the given mechanism..
		require
			exist_session : is_session_active
		do
			if attached session as l_session then

			end
		end


	get_current_url : detachable STRING_32
		-- Retrieve the URL of the current page.
		require
			exist_session : is_session_active
		do
			if attached session as l_session then
				Result := retrieve_url (l_session.session_id)
			end
		end

	get_page_source : detachable STRING_32
		-- Get the current page source.
		require
			exist_session : is_session_active
		do
			if attached session as l_session then
				Result := page_source (l_session.session_id)
			end
		end

	get_page_tile : detachable STRING_32
		--Get the current page title
		require
			exist_session : is_session_active
		do
			if attached session as l_session then
				Result := page_title (l_session.session_id)
			end
		end



	get_window_handle : detachable STRING_32
		require
			exist_session : is_session_active
		do
			if attached session as l_session then
				Result := retrieve_window_handle (l_session.session_id)
			end
		end

	get_window_handles : detachable LIST[STRING_32]
		require
			exist_session : is_session_active
		do
			if attached session as l_session then
				Result := retrieve_window_handles (l_session.session_id)
			end
		end


feature {NONE} -- Implementation

	session: detachable SE_SESSION

end
