# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Initially written by Mattéo Rossillol‑‑Laruelle (@beatussum)
# Modified by Matteo Salonia (@saloniamatteo)

EAPI=8

DISTUTILS_SINGLE_IMPL=true
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 systemd udev

DESCRIPTION="Validity fingerprint sensor prototype"
HOMEPAGE="https://github.com/uunicorn/python-validity"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/uunicorn/python-validity.git"
else
	SRC_URI="https://github.com/uunicorn/python-validity/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="binchecks strip test"

RDEPEND="
	>=app-arch/innoextract-1.6
	$(python_gen_cond_dep '>=dev-python/cryptography-2.1.4[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep 'dev-python/dbus-python[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep '>=dev-python/pyusb-1.0.0[${PYTHON_USEDEP}]')
	$(python_gen_cond_dep '>=dev-python/pyyaml-3.12[${PYTHON_USEDEP}]')
	sys-apps/dbus
	>=sys-auth/open-fprintd-0.6[${PYTHON_SINGLE_USEDEP}]
"

DOCS=(
	debian/changelog
	debian/copyright
	README.md
)

src_install() {
	# Install files
	distutils-r1_src_install

	# Install udev rules
	udev_dorules debian/python3-validity.udev

	# Install OpenRC service
	newinitd "${FILESDIR}"/python-validity.initd-r0 python-validity

	# Install systemd unit
	systemd_dounit debian/python3-validity.service

	# Copy files into /etc
	doins -r etc
}

pkg_postinst() {
	# Reload udev rules
	udev_reload

	# First steps
	elog "Download the firmware with the following command (as root):"
	elog ""
	elog "validity-sensors-firmware"
	elog ""
	elog "After that, you can now start enrolling fingerprints:"
	elog ""
	elog "fprintd-enroll <your-user> -f <your-finger>"

	elog ""
	elog "---"
	elog ""

	# Potential issues
	elog "If you have any issues with the fingerprint reader,"
	elog "try to reset it with the following command (run as root):"
	elog ""
	elog "python /usr/share/python-validity/playground/factory-reset.py"
	elog ""
	elog "Wait a minute or so before trying the device again."

	elog ""
	elog "---"
	elog ""

	# QoL
	elog "If you want to login using your fingerprint,"
	elog "modify /etc/pam.d/login and prepend the following line:"
	elog ""
	elog "auth	sufficient	pam_fprintd.so"
	elog ""
	elog "Users that do not have a configured fingerprint will login normally."
}

pkg_postrm() {
	# Reload udev rules
	udev_reload

	# Post-removal message
	elog "If you do not want to login using your fingerprint anymore,"
	elog "modify /etc/pam.d/login and remove the following line:"
	elog ""
	elog "auth	sufficient	pam_fprintd.so"
}
