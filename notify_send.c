#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <limits.h>
#include <libnotify/notify.h>

void show_notify_loading(void) {
		static char *icon = "/usr/share/pixmaps/clamav-realtime.png";

	/* Send Loading Notification */

                printf ("\a");
                notify_init ("ClamAV Realtime loading...");
                NotifyNotification * Loading = notify_notification_new("ClamAV Realtime\n", "Loading...", icon);
                notify_notification_show (Loading, NULL);
}

void show_notify_nothreat(void) {
		static char *icon = "/usr/share/pixmaps/clamav-realtime.png";

	/* Send nothreat notification */

		printf ("\a");
		notify_init ("ClamAV Realtime");
		NotifyNotification * nothreat = notify_notification_new ("Clam,AV Realtime", "No threat found !", icon);
		notify_notification_show (nothreat, NULL);
}

void show_notify_infected(void) {
			static char *icon = "/usr/share/pixmaps/clamav-realtime.png";

	/* Send Notification */

	        printf ("\a");
			notify_init ("ClamAV Realtime");
			NotifyNotification * threat = notify_notification_new ("ClamAV Realtime", alert_threat, icon);
			notify_notification_set_urgency (threat, NOTIFY_URGENCY_CRITICAL);
			notify_notification_show (threat, NULL);
}
