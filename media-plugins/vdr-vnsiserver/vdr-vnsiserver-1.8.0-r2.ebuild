# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2 git-r3

DESCRIPTION="VDR Plugin: VNSI Streamserver Plugin (FernetMenta branch)"
HOMEPAGE="https://github.com/FernetMenta/vdr-plugin-vnsiserver"

EGIT_REPO_URI="https://github.com/FernetMenta/vdr-plugin-vnsiserver.git"
EGIT_BRANCH="master"
EGIT_COMMIT="49003f036609ee2a0b8d819979c063d8f8d348c8"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~arm ~arm64"
IUSE=""

DEPEND=">=media-video/vdr-2.2.0"
RDEPEND="${DEPEND}"

src_unpack () {
	git-r3_src_unpack
	cd "${WORKDIR}"
	S="${WORKDIR}/${PN}-${PV}/"
}

src_prepare() {
	vdr-plugin-2_src_prepare
	fix_vdr_libsi_include demuxer.c videoinput.c
}

src_install() {
	vdr-plugin-2_src_install
	insinto /etc/vdr/plugins/vnsiserver
	doins vnsiserver/allowed_hosts.conf
	diropts -gvdr -ovdr
}
