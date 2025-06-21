# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:


EAPI="8"

inherit linux-info git-r3 xdg-utils

DESCRIPTION="clamav-realtime: ClamAV realtime scanner"
HOMEPAGE="http://www.pingwho.org"

EGIT_REPO_URI="https://gitlab.com/jaypeche/Clamav-realtime.git"
EGIT_BRANCH="master"
EGIT_COMMIT="master"

S="${S}/${PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE="+X +gtk"

DEPEND="sys-libs/glibc
	x11-libs/gtk+
        >=x11-libs/libnotify-0.8.2
        >=app-antivirus/clamav-1.1.0
        >=sys-fs/inotify-tools-3.22.6.0-r1"
RDEPEND="${DEPEND}"


src_unpack() {
	git-r3_src_unpack ${A}
	cd ${S}
	eapply "${FILESDIR}/${PN}-gentoo.patch" || die "epatch failed !"
	eapply "${FILESDIR}/${PN}_quarantine_mountpoint_fix.patch" || die "epatch failed"
	eapply "${FILESDIR}/${PN}_desktop_categories_launcher_fix.patch" || die "epatch failed !"
	eapply "${FILESDIR}/${PN}_fhs_docdir_gentoo_4Q2018_policy_fix.patch" || die "epatch failed !"
}

pkg_setup() {
	if ! linux_config_exists; then
		eerror "Kernel configuration file doesn't exist."
	elif ! linux_chkconfig_present INOTIFY_USER; then
		eerror "WARNING : CONFIG_INOTIFY_USER not enabled in kernel."
	fi
}

pkg_postinst() {
    einfo
    xdg_desktop_database_update || die "Update .desktop database failed !"

    einfo
    einfo "NOTE: clamav-realtime was installed in /usr/bin"
    einfo "      For security, and for a better graphical integration,"
    einfo "      it must be run as user !"
    einfo
}
