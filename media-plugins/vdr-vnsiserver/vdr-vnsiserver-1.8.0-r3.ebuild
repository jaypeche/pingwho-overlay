# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: VNSI Streamserver Plugin (FernetMenta branch)"
HOMEPAGE="https://github.com/FernetMenta/vdr-plugin-vnsiserver"

SRC_URI="https://github.com/FernetMenta/vdr-plugin-vnsiserver/archive/refs/tags/v${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~arm ~arm64"
IUSE=""

DEPEND=">=media-video/vdr-2.2.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/vdr-plugin-vnsiserver-${PV}"

src_unpack () {
	default
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
