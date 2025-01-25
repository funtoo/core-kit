# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Family of powerful x86 virtualization products for enterprise and home use"
HOMEPAGE="https://www.virtualbox.org/"

LICENSE="GPL-2 PUEL"
SLOT="0"
KEYWORDS="*"
IUSE="+additions doc headless python vboxwebsrv rdesktop-vrdp sdk"

RDEPEND="=app-emulation/virtualbox-bin-7.1.6.167084[additions?,doc?,headless?,python?,vboxwebsrv?,rdesktop-vrdp?,sdk?]"
