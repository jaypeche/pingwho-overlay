#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <limits.h>
#include <libnotify/notify.h>

void show_notify_updating(void) {
    		static char *icon = "/usr/share/pixmaps/clamav-realtime.png";

	/* Send Updating notification */
    printf("\a");
    notify_init("ClamAV Realtime");
    NotifyNotification *updating = notify_notification_new("ClamAV Realtime", "Updating threats database", icon);
    notify_notification_show(updating, NULL);
}

void show_notify_loading(void) {
		static char *icon = "/usr/share/pixmaps/clamav-realtime.png";

	/* Send Loading Notification */
    printf("\a");
    notify_init("ClamAV Realtime loading...");
    NotifyNotification *loading = notify_notification_new("ClamAV Realtime", "Loading...", icon);
    notify_notification_show(loading, NULL);
}

void show_notify_nothreat(void) {
		static char *icon = "/usr/share/pixmaps/clamav-realtime.png";

	/* Send nothreat notification */
    printf("\a");
    notify_init("ClamAV Realtime");
    NotifyNotification *nothreat = notify_notification_new("ClamAV Realtime", "No threat found!", icon);
    notify_notification_show(nothreat, NULL);
}

void show_notify_threat(const char *threat_body) {
			static char *icon = "/usr/share/pixmaps/clamav-realtime.png";

	/* Send Threat Notification */
    printf("\a");
    notify_init("ClamAV Realtime");
    NotifyNotification *threat = notify_notification_new("ClamAV Realtime", threat_body, icon);
    notify_notification_set_urgency(threat, NOTIFY_URGENCY_CRITICAL);
    notify_notification_show(threat, NULL);
}

