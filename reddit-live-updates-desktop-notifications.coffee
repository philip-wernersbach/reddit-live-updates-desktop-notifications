RedditLiveUpdatesDesktopNotifications =
	UPDATE_FREQUENCY: 10000

	init: () ->
		@liveupdate_title = $('#liveupdate-title').text()
		@liveupdate_initial_element = $('.liveupdate-listing .initial')
		@liveupdate_old_text = this.current_update()

		if !@liveupdate_initial_element
			alert "RedditLiveUpdatesDesktopNotifications can't find the initial element!"
			return false
		else if !@liveupdate_title
			alert "RedditLiveUpdatesDesktopNotifications can't find the title!"
			return false

		@liveupdate_title += " Live Updater"
		return true

	current_update: () ->
		return RedditLiveUpdatesDesktopNotifications.liveupdate_initial_element.next().find('p').text()

	check_for_updates: () ->
		liveupdate_new_text = RedditLiveUpdatesDesktopNotifications.current_update()

		if (liveupdate_new_text != RedditLiveUpdatesDesktopNotifications.liveupdate_old_text)
			notify.createNotification(RedditLiveUpdatesDesktopNotifications.liveupdate_title, { body: liveupdate_new_text, icon: '/favicon.ico' })
			RedditLiveUpdatesDesktopNotifications.liveupdate_old_text = liveupdate_new_text
			RedditLiveUpdatesDesktopNotifications.check_for_updates()
		else
			setTimeout(RedditLiveUpdatesDesktopNotifications.check_for_updates, RedditLiveUpdatesDesktopNotifications.UPDATE_FREQUENCY)

	start: () ->
		notifyPermissionLevel = notify.permissionLevel()

		if notifyPermissionLevel == notify.PERMISSION_GRANTED
			setTimeout(RedditLiveUpdatesDesktopNotifications.check_for_updates, RedditLiveUpdatesDesktopNotifications.UPDATE_FREQUENCY)
		else if notifyPermissionLevel == notify.PERMISSION_DEFAULT
			npla_div = $('<div class="npla" style="position:fixed; top: 0; left: 0; z-index: 254; width: 100%; height: 100%;"><input type="button" style="width: 100%; height: 100%;" value="Click To Activate Desktop Notifications!"></input></div>')
			
			npla_div.click () ->
				npla_div.remove()
				notify.requestPermission(RedditLiveUpdatesDesktopNotifications.start)

			npla_div.appendTo('body')
		else
			alert("RedditLiveUpdatesDesktopNotifications needs permission to post notifications!")

if RedditLiveUpdatesDesktopNotifications.init()
	RedditLiveUpdatesDesktopNotifications.start()