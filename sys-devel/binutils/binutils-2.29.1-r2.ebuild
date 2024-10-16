# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCHVER="3"
ELF2FLT_VER=""
inherit toolchain-binutils

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd -sparc-fbsd ~x86-fbsd"
BINUTILS_ENABLE_LIBRARIES_SONAMES_EXTRA_SUFFIX=1
PATCHES=( "${FILESDIR}/${P}-nogoldtest.patch" "${FILESDIR}/0098-Gentoo-add-with-extra-soversion-suffix-option.patch" )
