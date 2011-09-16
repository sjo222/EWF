note
	description: "[
			Summary description for REQUEST_HANDLER_ROUTES_RECORDER.
			
			You can inherit from this class from any REQUEST_HANDLER and redefine `on_handler_mapped'
			to record the available routes if your handler needs it.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REQUEST_HANDLER_ROUTES_RECORDER

feature {REQUEST_HANDLER} -- Routes access

	available_routes: detachable LIST [TUPLE [resource: READABLE_STRING_8; rqst_methods: detachable ARRAY [READABLE_STRING_8]]]
			-- Available routes

feature {REQUEST_ROUTER} -- Routes change

	on_handler_mapped (a_resource: READABLE_STRING_8; a_rqst_methods: detachable ARRAY [READABLE_STRING_8])
		local
			l_routes: like available_routes
		do
			l_routes := available_routes
			if l_routes = Void then
				create {ARRAYED_LIST [like available_routes.item]} l_routes.make (3)
				available_routes := l_routes
			end
			l_routes.force ([a_resource, a_rqst_methods])
		end

note
	copyright: "2011-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
