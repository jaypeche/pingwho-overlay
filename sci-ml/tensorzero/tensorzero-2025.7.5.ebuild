# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit linux-info systemd

DESCRIPTION="TensorZero is an open-source stack for industrial-grade LLM applications"
HOMEPAGE="https://www.tensorzero.com/"
LICENSE="Apache-2.0"
SLOT="0"

IUSE="client examples +gateway systemd"

DEPEND="client? ( dev-python/pip )
	gateway? ( app-containers/docker
		app-containers/docker-cli
		app-containers/docker-compose:2 )"
RDEPEND="${DEPEND}"

case ${PV} in
9999)
	DEPEND+=" dev-vcs/git"
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/tensorzero.git"
	EGIT_BRANCH="main"
	;;
*)
	KEYWORDS="amd64"
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
	RESTRICT="mirror"
	;;
esac

pkg_setup() {
	if [ -x "/usr/share/docker/contrib/check-config.sh" ]; then
		einfo "Docker check-config present !"
	else
		eerror "Docker service seems not to be installated !"
		eerror "Please make your checks..."
	fi
}

src_install() {
	dodir /usr/share/${PN} || die "dodir failed !"
	if [ -d "${S}/examples/quickstart" ]; then
		insinto /usr/share/${PN}
		doins -r examples/quickstart/* || die "doins failed !"
	else
		eerror "Quickstart examples directory not found!"
		die "Installation failed: Quickstart examples directory missing."
	fi

	if use systemd; then
		systemd_dounit "${FILESDIR}"/tensorzero.service
	else
		doinitd "${FILESDIR}"/tensorzero || die "doinitd failed !"
	fi

	if use examples; then
		dodoc -r examples || die "Examples install failed !"
	fi

	dodoc AGENTS.md CLA.md CONTRIBUTING.md LICENSE README.md RELEASE_GUIDE.md || die "dodoc failed !"
}

pkg_postinst() {
	einfo
	einfo "By default, define an OPENAI_API_KEY variable, in /usr/share/tensorzero/.env"
	einfo "After starting service, TensorZero UI is available at : http://localhost:4000"
	einfo
	if use client; then
		einfo "To install TensorZero Python client and dependencies, you should run :"
		einfo "# pip install tensorzero"
		einfo
	fi
	einfo "For more information, visit: ${HOMEPAGE}"
	einfo
}
