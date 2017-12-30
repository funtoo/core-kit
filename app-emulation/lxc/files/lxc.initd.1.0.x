#!/sbin/openrc-run
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

CONTAINER=${SVCNAME#*.}

LXC_PATH=`lxc-config lxc.lxcpath`

lxc_get_configfile() {
	if [ -f "${LXC_PATH}/${CONTAINER}.conf" ]; then
		echo "${LXC_PATH}/${CONTAINER}.conf"
	elif [ -f "${LXC_PATH}/${CONTAINER}/config" ]; then
		echo "${LXC_PATH}/${CONTAINER}/config"
	else
		eerror "Unable to find a suitable configuration file."
		eerror "If you set up the container in a non-standard"
		eerror "location, please set the CONFIGFILE variable."
		return 1
	fi
}

[ $CONTAINER != $SVCNAME ] && CONFIGFILE=${CONFIGFILE:-$(lxc_get_configfile)}

lxc_get_var() {
	awk 'BEGIN { FS="[ \t]*=[ \t]*" } $1 == "'$1'" { print $2; exit }' ${CONFIGFILE}
}

lxc_get_net_link_type() {
	awk 'BEGIN { FS="[ \t]*=[ \t]*"; _link=""; _type="" }
		$1 == "lxc.network.type" {_type=$2;}
		$1 == "lxc.network.link" {_link=$2;}
		{if(_link != "" && _type != ""){
			printf("%s:%s\n", _link, _type );
			_link=""; _type="";
		}; }' <${CONFIGFILE}
}

checkconfig() {
	if [ ${CONTAINER} = ${SVCNAME} ]; then
		eerror "You have to create an init script for each container:"
		eerror " ln -s lxc /etc/init.d/lxc.container"
		return 1
	fi

	# no need to output anything, the function takes care of that.
	[ -z "${CONFIGFILE}" ] && return 1

	utsname=$(lxc_get_var lxc.utsname)
	if [ ${CONTAINER} != ${utsname} ]; then
	    eerror "You should use the same name for the service and the"
	    eerror "container. Right now the container is called ${utsname}"
	    return 1
	fi
}

depend() {
	# be quiet, since we have to run depend() also for the
	# non-muxed init script, unfortunately.
	checkconfig 2>/dev/null || return 0

	config ${CONFIGFILE}
	need localmount

	local _x _if
	for _x in $(lxc_get_net_link_type); do
		_if=${_x%:*}
		case "${_x##*:}" in
			# when the network type is set to phys, we can make use of a
			# network service (for instance to set it up before we disable
			# the net_admin capability), but we might also not set it up
			# at all on the host and leave the net_admin capable service
			# to take care of it.
			phys)	use net.${_if} ;;
			*)	need net.${_if} ;;
		esac
	done
}

start() {
	checkconfig || return 1
	rm -f /var/log/lxc/${CONTAINER}.log

	rootpath=$(lxc_get_var lxc.rootfs)

	# Check the format of our init and the chroot's init, to see
	# if we have to use linux32 or linux64; always use setarch
	# when required, as that makes it easier to deal with
	# x32-based containers.
	case $(scanelf -BF '%a#f' ${rootpath}/sbin/init) in
		EM_X86_64)	setarch=linux64;;
		EM_386)		setarch=linux32;;
	esac

	ebegin "Starting ${CONTAINER}"
	env -i ${setarch} $(type -p lxc-start) -l WARN -n ${CONTAINER} -f ${CONFIGFILE} -d -o /var/log/lxc/${CONTAINER}.log
	sleep 0.5

	# lxc-start -d will _always_ report a correct startup, even if it
	# failed, so rather than trust that, check that the cgroup exists.
	[ -d /sys/fs/cgroup/cpuset/lxc/${CONTAINER} ]
	eend $?
}

stop() {
	checkconfig || return 1


	if ! [ -d /sys/fs/cgroup/cpuset/lxc/${CONTAINER} ]; then
	    ewarn "${CONTAINER} doesn't seem to be started."
	    return 0
	fi

	# 10s should be enough to shut everything down
	ebegin "Stopping ${CONTAINER}"
	lxc-stop -t 10 -n ${CONTAINER}
	eend $?
}
