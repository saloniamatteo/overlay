# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Initially written by Mattéo Rossillol‑‑Laruelle (@beatussum)
# Modified by Matteo Salonia (@saloniamatteo)

EAPI=8

DISTUTILS_SINGLE_IMPL=true
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=(python3_{11..13})

inherit distutils-r1 systemd

DESCRIPTION="fprintd replacement which allows you to have your own backend"
HOMEPAGE="https://github.com/uunicorn/open-fprintd"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/uunicorn/open-fprintd.git"
else
	SRC_URI="https://github.com/uunicorn/open-fprintd/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="binchecks strip test"

RDEPEND="
	dev-libs/gobject-introspection[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep 'dev-python/dbus-python[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/pygobject[${PYTHON_USEDEP}]')
	sys-apps/dbus
"

DOCS=(
	debian/changelog
	debian/copyright
	README.md
)

src_prepare() {
	# Apply user patches
	eapply_user
}

src_install() {
	# Install files
	distutils-r1_src_install

	# Install OpenRC service
	newinitd "${FILESDIR}"/open-fprintd.initd-r0 open-fprintd

	# Install systemd unit
	systemd_dounit debian/open-fprintd{,-resume,-suspend}.service
}
