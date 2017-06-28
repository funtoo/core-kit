#!/bin/bash
#  Copyright (C) 2000-2009, Parallels, Inc. All rights reserved.
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#
# This script sets hostname inside Funtoo based CT.
#
# Some parameters are passed in environment variables.
# Required parameters:
# Optional parameters:
#   HOSTNM
#       Sets host name for this CT. Modifies /etc/conf.d/hostname

function set_hostname()
{
	local cfgfile=$1
	local hostname=$2

	[ -z "${hostname}" ] && return 0

	if grep -qe "^HOSTNAME=" ${cfgfile} >/dev/null 2>&1; then
		del_param ${cfgfile} "HOSTNAME"
	fi
	put_param "${cfgfile}" "hostname" "${hostname}"
	hostname ${hostname}
}

change_hostname /etc/hosts "${HOSTNM}" "${IP_ADDR}"
set_hostname /etc/conf.d/hostname "${HOSTNM}"

exit 0
