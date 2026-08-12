# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs systemd unpacker

DESCRIPTION="Get up and running with Llama 3, Mistral, Gemma, and other language models"
HOMEPAGE="https://ollama.com/"

S="${WORKDIR}"

LICENSE="MIT"

SLOT="0"

IUSE="cuda rocm systemd vulkan"

RESTRICT="mirror"

CHECKREQS_DISK_BUILD="5G"
QA_PREBUILT="*"

DEPEND="acct-group/ollama
	acct-group/render
	acct-group/video
	>=acct-user/ollama-2[cuda?]
	amd64? (
		cuda? ( dev-util/nvidia-cuda-toolkit )
		rocm? ( dev-libs/rocm-opencl-runtime
			sci-libs/clblast )
	)
	systemd? ( sys-apps/systemd )
	!!sci-ml/ollama"

BDEPEND="app-arch/zstd
	dev-util/patchelf"

RDEPEND="vulkan? (
	media-libs/vulkan-loader
	media-libs/shaderc
)"

case ${PV} in
9999)
	SRC_URI="
		amd64?	( https://ollama.com/download/ollama-linux-amd64.tar.zst )
		rocm?	( https://ollama.com/download/ollama-linux-amd64-rocm.tar.zst )
		arm64?	( https://ollama.com/download/ollama-linux-arm64.tar.zst )"
	einfo
        einfo "You are using 9999 live ebuild version,"
        einfo "It should be necessary to execute this command to refresh live ebuild checksum :"
        einfo
        einfo "# ebuild ollama-bin-9999.ebuild digest"
        einfo
	;;
*)
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="
		amd64? ( https://github.com/ollama/ollama/releases/download/v${PV}/ollama-linux-amd64.tar.zst \
		-> ollama-bin-amd64-${PV}.tar.zst )
		rocm? ( https://github.com/ollama/ollama/releases/download/v${PV}/ollama-linux-amd64-rocm.tar.zst \
		-> ollama-bin-rocm-${PV}.tar.zst )
		arm64? ( https://github.com/ollama/ollama/releases/download/v${PV}/ollama-linux-arm64.tar.zst \
		-> ollama-bin-arm64-${PV}.tar.zst )"
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

src_prepare() {
	default
	if ! use cuda; then
		rm -rf "${S}"/lib/ollama/{cuda_v12,cuda_v13} || die
	fi

	# Shipped upstream libraries come with '$ORIGIN:/build/llama-server-cpu/bin:' set in their RUNPATH
	# scanelf complains about it during install, and we only need $ORIGIN
	# (all libs are in the same folder), so we set it to that

	for so in "${S}"/lib/ollama/*.so; do
		patchelf --set-rpath '$ORIGIN' "${so}" || die
	done
}

src_install() {
	insinto "/opt/${PN}"
	insopts -m0755
	doins -r lib || die "doins failed !"
	doins -r bin || die "doins failed !"

	DISTRIBUTED_ATOM="/opt/${PN}/.ollama"

	einfo
	einfo "INFO: Models and checksums saved into ${DISTRIBUTED_ATOM} are preserved..."
	einfo

	# Since 0.30.x version, linking new llama-server
	dosym -r "/opt/${PN}/bin/ollama" "/usr/bin/ollama" || die "dosym failed !"
	dosym -r "/opt/${PN}/lib/ollama/llama-server" "/usr/bin/llama-server" || die "dosym failed !"
	dosym -r "/opt/${PN}/lib/ollama/llama-quantize" "/usr/bin/llama-quantize" || die "dosym failed !"

	if use systemd; then
		systemd_dounit "${FILESDIR}"/ollama.service || die "dounit failed !"
	else
		newinitd "${FILESDIR}"/ollama.initd ollama || die "newinitd failed !"
		newconfd "${FILESDIR}"/ollama.confd ollama || die "newconfd failed !"
	fi
}

pkg_preinst() {
	keepdir /var/log/ollama
	fperms 750 /var/log/ollama
	fowners ollama:ollama /var/log/ollama
}

pkg_postinst() {
	einfo
	einfo "Quick guide:"
	einfo
	einfo "Please, add your_user to ollama group,"
	einfo "# usermod -a -G ollama your_user"
	einfo "# usermod -a -G render,video ollama"
	einfo
	einfo "# ollama serve (standalone,systemd,openrc)"
	einfo "$ ollama run llama3:3b (client)"
	einfo
	einfo "Browse available models at: https://ollama.com/library/"
	einfo
	einfo "Ollama binds 127.0.0.1 port 11434 by default."
	einfo "Change the bind address with the OLLAMA_HOST environment variable."
	einfo "See https://docs.ollama.com/faq for more info"
	einfo
}
