# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit linux-info systemd

DESCRIPTION="TensorZero is an open-source stack for industrial-grade LLM applications"
HOMEPAGE="https://www.tensorzero.com/"
LICENSE="Apache-2.0"
SLOT="0"

IUSE="examples +gateway systemd"

DEPEND="gateway? ( app-containers/docker-compose:2 )"
RDEPEND="${DEPEND}"

case ${PV} in
9999)
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/${PN}/tensorzero.git"
	EGIT_BRANCH="main"
	inherit git-r3
	;;
*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz"
	RESTRICT="mirror"
	;;
esac

pkg_setup() {
	einfo "do self-tests for Docker, please wait..."
}

src_install() {
	dodir /usr/share/${PN} || die "dodir failed !"
	insinto /usr/share/${PN}
	if [ -d "${S}/examples/quickstart" ]; then
		doins -r ${S}/examples/quickstart/* || die "doins failed !"
	else
		eerror "Quickstart examples directory not found!"
		die "Installation failed: Quickstart examples directory missing."
	fi

	if use systemd; then
	      systemd_dounit "${FILESDIR}"/tensorzero.service
	else
                doinitd "${FILESDIR}"/tensorzero
        fi

	if use examples; then
		dodoc -r examples || die "Examples install failed !"
	fi

	dodoc AGENTS.md CLA.md CONTRIBUTING.md LICENSE README.md RELEASE_GUIDE.md || die "dodoc failed !"
}

pkg_postinst() {
	einfo
	einfo "After starting service, TensorZero UI is available at : http://localhost:4000"
	einfo
	einfo "To install TensorZero Python client, you should run :"
	einfo "# pip install -r requirements.txt"
	einfo "into /usr/share/tensorzero workdir."
	einfo
	einfo "For more information, visit: ${HOMEPAGE}"
	einfo
}
