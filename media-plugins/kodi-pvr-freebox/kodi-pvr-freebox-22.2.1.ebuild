# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Kodi PVR addon Freebox TV"
HOMEPAGE="https://github.com/aassif/pvr.freebox"

case ${PV} in
9999)
	EGIT_REPO_URI="https://github.com/aassif/pvr.freebox.git"
	EGIT_BRANCH="Piers"
	inherit git-r3
	;;
*)
	CODENAME="Piers"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/aassif/pvr.freebox/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.freebox-${PV}-${CODENAME}"
	;;
esac

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-22*
	dev-libs/tinyxml
	dev-cpp/nlohmann_json
	"

RDEPEND="
	${DEPEND}
	"
