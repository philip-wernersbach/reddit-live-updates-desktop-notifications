RedditLiveUpdatesDesktopNotifications =
	UPDATE_FREQUENCY: 10000

	init: () ->
		@liveupdate_title = $('#liveupdate-title').text()
		@liveupdate_initial_element = $('.liveupdate-listing .initial')
		@read_divider_element = $('<span style="width: 0; height: 0; display: none;"></span>')

		if !@liveupdate_initial_element
			alert "RedditLiveUpdatesDesktopNotifications can't find the initial element!"
			return false
		else if !@liveupdate_title
			alert "RedditLiveUpdatesDesktopNotifications can't find the title!"
			return false

		@liveupdate_title = "Live Updates: " + @liveupdate_title
		return true

	current_update: () ->
		current_update_element = RedditLiveUpdatesDesktopNotifications.read_divider_element.prev()

		if !current_update_element.hasClass('initial')
			RedditLiveUpdatesDesktopNotifications.read_divider_element.remove()
			current_update_element.before(RedditLiveUpdatesDesktopNotifications.read_divider_element)

			return current_update_element.find('p').text()
		else
			return null

	check_for_updates: () ->
		liveupdate_new_text = RedditLiveUpdatesDesktopNotifications.current_update()

		if liveupdate_new_text
			notify.createNotification(RedditLiveUpdatesDesktopNotifications.liveupdate_title, { body: liveupdate_new_text, icon: '/favicon.ico' })
			RedditLiveUpdatesDesktopNotifications.check_for_updates()
		else
			setTimeout(RedditLiveUpdatesDesktopNotifications.check_for_updates, RedditLiveUpdatesDesktopNotifications.UPDATE_FREQUENCY)

	start: () ->
		notifyPermissionLevel = notify.permissionLevel()

		if notifyPermissionLevel == notify.PERMISSION_GRANTED
			@liveupdate_initial_element.after(@read_divider_element)
			setTimeout(RedditLiveUpdatesDesktopNotifications.check_for_updates, RedditLiveUpdatesDesktopNotifications.UPDATE_FREQUENCY)
		else if notifyPermissionLevel == notify.PERMISSION_DEFAULT
			permissions_grant_div = $('<div style="position:fixed; top: 0; left: 0; z-index: 254; width: 100%; height: 100%;"><input type="button" style="width: 100%; height: 100%;" value="Click To Activate Desktop Notifications!"></input></div>')
			
			permissions_grant_div.click () ->
				permissions_grant_div.remove()
				notify.requestPermission(RedditLiveUpdatesDesktopNotifications.start)

			permissions_grant_div.appendTo('body')
		else
			alert("RedditLiveUpdatesDesktopNotifications needs permission to post notifications!")

if RedditLiveUpdatesDesktopNotifications.init()
	RedditLiveUpdatesDesktopNotifications.start()