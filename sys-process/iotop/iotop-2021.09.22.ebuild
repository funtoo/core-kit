# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
PYTHON_REQ_USE="ncurses(+)"

inherit distutils-r1 linux-info

DESCRIPTION="Top-like UI used to show which process is using the I/O"
HOMEPAGE="http://guichaz.free.fr/iotop/"
SRC_URI="https://repo.or.cz/iotop.git/snapshot/68be5e5c83e7ce5c0f2177f78d75c54f9d6bbd86.tar.gz -> iotop-2021.09.22.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}/${PN}-68be5e5"
CONFIG_CHECK="~TASK_IO_ACCOUNTING ~TASK_DELAY_ACCT ~TASKSTATS ~VM_EVENT_COUNTERS"

DOCS=( NEWS README THANKS )

pkg_setup() {
	linux-info_pkg_setup
}