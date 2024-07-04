# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
PYTHON_REQ_USE="ncurses"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 eutils linux-info

DESCRIPTION="CLI curses based monitoring tool"
HOMEPAGE="https://github.com/nicolargo/glances"
SRC_URI="https://github.com/nicolargo/glances/archive/v4.1.2.1.tar.gz -> glances-4.1.2.1.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.6.7[${PYTHON_USEDEP}]
	>=dev-python/ujson-5.4.0[${PYTHON_USEDEP}]
"

# PYTHON_USEDEP omitted on purpose
BDEPEND="doc? ( dev-python/sphinx_rtd_theme )"

CONFIG_CHECK="~TASK_IO_ACCOUNTING ~TASK_DELAY_ACCT ~TASKSTATS"

distutils_enable_tests setup.py
distutils_enable_sphinx docs --no-autodoc

pkg_setup() {
	linux-info_pkg_setup
}

python_prepare_all() {
	# Remove duplicate entries of a prebuilt doc build and
	# ensure install of the file glances.conf in /etc/${PN}
	sed \
		-e '/share\/doc\/glances/d' \
		-e "s/'CONTRIBUTING.md',//" \
		-e "s:'conf/glances.conf':('${EPREFIX}/etc/glances', ['conf/glances.conf':g" \
		-i setup.py || die
	sed -i "s/, 'irq']/]/" unitest.py || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	# add an intended file from original data set from setup.py to DOCS
	local DOCS=( README.rst CONTRIBUTING.md conf/glances.conf )
	distutils-r1_python_install_all
}

pkg_postinst() {
	#optfeature "Action script feature" dev-python/pystache
	optfeature "Autodiscover mode" dev-python/zeroconf
	optfeature "Cloud support" dev-python/requests
	optfeature "Quicklook CPU info" dev-python/py-cpuinfo
	optfeature "Docker monitoring support" dev-python/docker-py
	#optfeature "Export module" \
	#	unpackaged/bernhard \
	#	unpackaged/cassandra-driver \
	#	unpackaged/potsdb \
	#	dev-python/couchdb-python \
	#	dev-python/elasticsearch-py \
	#	dev-python/influxdb \
	#	dev-python/kafka-python \
	#	dev-python/pika \
	#	dev-python/paho-mqtt \
	#	dev-python/prometheus_client \
	#	dev-python/pyzmq \
	#	dev-python/statsd
	#optfeature "Nvidia GPU monitoring" unpackaged/nvidia-ml-py3
	optfeature "SVG graph support" dev-python/pygal
	optfeature "IP plugin" dev-python/netifaces
	optfeature "RAID monitoring" dev-python/pymdstat
	#optfeature "SMART support" unpackaged/pySMART.smartx
	optfeature "RAID support" dev-python/pymdstat
	optfeature "SNMP support" dev-python/pysnmp
	#optfeature "sparklines plugin" unpackaged/sparklines
	optfeature "Web server mode" dev-python/bottle dev-python/requests
	optfeature "WIFI plugin" net-wireless/python-wifi
}