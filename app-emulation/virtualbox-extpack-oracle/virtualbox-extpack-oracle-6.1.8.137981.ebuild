# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="PUEL extensions for VirtualBox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://download.virtualbox.org/virtualbox/6.1.8/Oracle_VM_VirtualBox_Extension_Pack-6.1.8-137981.vbox-extpack -> Oracle_VM_VirtualBox_Extension_Pack-6.1.8-137981.tar.gz"

LICENSE="PUEL"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="|| (
	~app-emulation/virtualbox-6.1.8
	~app-emulation/virtualbox-bin-6.1.8.137981 )"

S="${WORKDIR}"

QA_PREBUILT="/usr/lib*/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack/.*"

src_install() {
	insinto /usr/$(get_libdir)/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack
	doins -r linux.${ARCH}
	doins ExtPack* PXE-Intel.rom
}