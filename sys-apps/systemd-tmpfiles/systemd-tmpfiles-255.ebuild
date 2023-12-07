# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit flag-o-matic meson python-any-r1

DESCRIPTION="Creates, deletes and cleans up volatile and temporary files and directories"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"
SRC_URI="https://github.com/systemd/systemd-stable/tarball/db11bab38ccf1ed257f310d29070843d4c58ea01 -> systemd-stable-255-db11bab.tar.gz"

LICENSE="BSD-2 GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS="*"
IUSE="selinux"

RDEPEND="
	sys-apps/acl:0=
	sys-apps/util-linux
	sys-libs/libcap:0=
	selinux? ( sys-libs/libselinux:0= )
	sys-libs/libxcrypt
	!sys-apps/opentmpfiles
	!sys-apps/systemd
"

DEPEND="
	${RDEPEND}
	sys-kernel/linux-headers
"

BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/jinja[${PYTHON_USEDEP}]')
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gperf
	dev-util/meson
	sys-apps/coreutils
	sys-devel/gettext
	virtual/pkgconfig
"

python_check_deps() {
	has_version -b "dev-python/jinja[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	if [[ -n ${EPREFIX} ]]; then
		ewarn "systemd-tmpfiles uses un-prefixed paths at runtime.".
	fi
}

pkg_setup() {
	python-any-r1_pkg_setup
}

post_src_unpack() {
	mv "${WORKDIR}"/systemd-systemd-stable-* "${S}" || die
}

src_prepare() {
	default

	python_fix_shebang tools/*.py
}

src_configure() {
	local emesonargs=(
		-Dadm-group=false
		-Danalyze=false
		-Db_asneeded=false
		-Db_coverage=false
		-Db_lto=false
		-Db_lundef=false
		-Db_ndebug=false
		-Db_pch=false
		-Db_pie=false
		-Db_staticpic=false
		-Dbacklight=false
		-Dbinfmt=false
		-Dbump-proc-sys-fs-file-max=false
		-Dbump-proc-sys-fs-nr-open=false
		-Dcompat-mutable-uid-boundaries=false
		-Dcoredump=false
		-Dcpp_debugstl=false
		-Dcpp_rtti=false
		-Dcreate-log-dirs=false
		-Ddebug=false
		-Ddefault-kill-user-processes=false
		-Ddefault-network=false
		-Ddns-over-tls=false
		-Defi=false
		-Denvironment-d=false
		-Derrorlogs=false
		-Dfexecve=false
		-Dfirst-boot-full-preset=false
		-Dfirstboot=false
		-Dfuzz-tests=false
		-Dgshadow=false
		-Dhibernate=false
		-Dhostnamed=false
		-Dhwdb=false
		-Didn=false
		-Dima=false
		-Dinitrd=false
		-Dinstall-sysconfdir=false
		-Dinstall-tests=false
		-Dkernel-install=false
		-Dldconfig=false
		-Dlink-boot-shared=false
		-Dlink-journalctl-shared=false
		-Dlink-networkd-shared=false
		-Dlink-portabled-shared=false
		-Dlink-systemctl-shared=false
		-Dlink-timesyncd-shared=false
		-Dlink-udev-shared=false
		-Dllvm-fuzz=false
		-Dlocaled=false
		-Dlog-trace=false
		-Dlogind=false
		-Dmachined=false
		-Dmemory-accounting-default=false
		-Dnetworkd=false
		-Dnscd=false
		-Dnss-myhostname=false
		-Dnss-systemd=false
		-Doomd=false
		-Doss-fuzz=false
		-Dpkgconfig.relocatable=false
		-Dportabled=false
		-Dprefer_static=false
		-Dpstore=false
		-Dquotacheck=false
		-Drandomseed=false
		-Dresolve=false
		-Drfkill=false
		-Dslow-tests=false
		-Dsmack=false
		-Dsplit-bin=false
		-Dsplit-usr=false
		-Dstandalone-binaries=false
		-Dstatic-libsystemd=false
		-Dstatic-libudev=false
		-Dstdsplit=false
		-Dstoragetm=false
		-Dstrip=false
		-Dsysext=false
		-Dsysusers=false
		-Dtests=false
		-Dtimedated=false
		-Dtimesyncd=false
		-Dtmpfiles=false
		-Dtpm=false
		-Dtranslations=false
		-Durlify=false
		-Duserdb=false
		-Dutmp=false
		-Dvconsole=false
		-Dvsenv=false
		-Dwerror=false
		-Dwheel-group=false
		-Dxdg-autostart=false
		-Drootprefix="${EPREFIX:-/}"
		-Dacl=true
		-Db_staticpic=true
		-Dtmpfiles=true
		-Dstandalone-binaries=true # this and below option does the magic
		-Dstatic-libsystemd=true
		-Dsysvinit-path=''
		$(meson_use selinux)
	)
	meson_src_configure
}

src_compile() {
	# tmpfiles and sysusers can be built as standalone and link systemd-shared in statically.
	# https://github.com/systemd/systemd/pull/16061 original implementation
	# we just need to pass -Dstandalone-binaries=true and
	# use <name>.standalone target below.
	# check meson.build for if have_standalone_binaries condition per target.
	local mytargets=(
		systemd-tmpfiles.standalone
	)
	meson_src_compile "${mytargets[@]}"
}

src_install() {
	# lean and mean installation, single binary and man-pages
	pushd "${BUILD_DIR}" > /dev/null || die
	into /
	newbin systemd-tmpfiles.standalone systemd-tmpfiles

	popd > /dev/null || die

	# service files adapter from opentmpfiles
	newinitd "${FILESDIR}"/stmpfiles-dev.initd stmpfiles-dev
	newinitd "${FILESDIR}"/stmpfiles-setup.initd stmpfiles-setup

	# same content, but install as different file
	newconfd "${FILESDIR}"/stmpfiles.confd stmpfiles-dev
	newconfd "${FILESDIR}"/stmpfiles.confd stmpfiles-setup
}

# stolen from opentmpfiles ebuild
add_service() {
	local initd=$1
	local runlevel=$2

	elog "Auto-adding '${initd}' service to your ${runlevel} runlevel"
	mkdir -p "${EROOT}/etc/runlevels/${runlevel}"
	ln -snf "${EPREFIX}/etc/init.d/${initd}" "${EROOT}/etc/runlevels/${runlevel}/${initd}"
}

pkg_postinst() {
	if [[ -z $REPLACING_VERSIONS ]]; then
		add_service stmpfiles-dev sysinit
		add_service stmpfiles-setup boot
	fi
}