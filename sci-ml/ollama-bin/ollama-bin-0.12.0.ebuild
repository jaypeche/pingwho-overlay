# Copyriht 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs systemd

DESCRIPTION="Local runner for LLMs"
HOMEPAGE="https://ollama.com/"
LICENSE="MIT"

S="${WORKDIR}"

IUSE="cuda rocm systemd"

RESTRICT="mirror"
SLOT="0"

CHECKREQS_DISK_BUILD="4G"
QA_PREBUILT="*"

DEPEND="
	acct-group/ollama
	=acct-user/ollama-0-r1
	rocm? ( sci-libs/clblast
		dev-libs/rocm-opencl-runtime )
	cuda? ( dev-util/nvidia-cuda-toolkit )
        systemd? ( sys-apps/systemd )"

case ${PV} in
9999)
	SRC_URI="
		amd64?	( https://ollama.com/download/ollama-linux-amd64.tgz -> ollama-linux-amd64-latest.tgz )
		rocm?	( https://ollama.com/download/ollama-linux-amd64-rocm.tgz -> ollama-linux-amd64-rocm-latest.tgz )
		arm64?	( https://ollama.com/download/ollama-linux-arm64.tgz -> ollama-linux-arm64-latest.tgz )"
	;;
*)
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
		amd64? ( https://github.com/ollama/ollama/releases/download/v${PV}/ollama-linux-amd64.tgz -> ollama-bin-amd64-${PV}.tgz )
		rocm? ( https://github.com/ollama/ollama/releases/download/v${PV}/ollama-linux-amd64-rocm.tgz -> ollama-bin-rocm-${PV}.tgz )
		arm64? ( https://github.com/ollama/ollama/releases/download/v${PV}/ollama-linux-arm64.tgz -> ollama-bin-arm64-${PV}.tgz )"
	;;
esac

pkg_setup() {
	check-reqs_pkg_setup
}

pkg_pretend() {
	if use rocm; then
		ewarn "WARNING: AMD & Nvidia support in this ebuild are experimental"
		einfo "If you run into issues, especially compiling dev-libs/rocm-opencl-runtime"
		einfo "you may try the docker image here https://github.com/ROCm/ROCm-docker"
		einfo "and follow instructions here"
		einfo "https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/docker.html"
	fi
}

src_install() {
	insinto "/opt/${PN}"
	insopts -m0755
	doins -r lib
	doins -r bin

	DISTRIBUTED_ATOM="/opt/${PN}/.ollama"

	ewarn
	ewarn "INFO: Models and checksums saved into ${DISTRIBUTED_ATOM} are preserved..."
	ewarn

	dosym -r "/opt/${PN}/bin/ollama" "/usr/bin/ollama"

	if use systemd; then
                systemd_dounit "${FILESDIR}"/ollama.service
        else
                doinitd "${FILESDIR}"/ollama
        fi
}

pkg_preinst() {
        keepdir /var/log/ollama
        fowners ollama:ollama /var/log/ollama
}

pkg_postinst() {
	einfo
	einfo "Quick guide:"
	einfo
	einfo "Please, add your_user to ollama group,"
	einfo "# usermod -a -G ollama your_user"
	einfo
	einfo "# ollama serve (standalone,systemd,openrc)"
	einfo "$ ollama run llama3:3b (client)"
	einfo
	einfo "Browse available models at: https://ollama.com/library/"
	einfo
}
