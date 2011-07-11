# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils qt4

MY_P=${P/-/_}

DESCRIPTION="Q Light Controller is for controlling DMX or analog lighting systems like moving heads, dimmers, scanners etc."
HOMEPAGE="http://qlc.sourceforge.net/"
SRC_URI="mirror://sourceforge/qlc/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="test"

DEPEND=">x11-libs/qt-core-4.6
	x11-libs/qt-gui
	x11-libs/qt-test
	x11-libs/qt-dbus
	media-libs/alsa-lib
	dev-embedded/libftdi"

RDEPEND=${DEPEND} 

S="${WORKDIR}/${PN}"


src_configure() {
	eqmake4 || die "qmake failed"
}

src_compile() {
	emake || die "make failed"
}

src_test() {
	if emake -j1 check -n &> /dev/null; then
		vecho ">>> Test phase [check]: ${CATEGORY}/${PF}"
		
		# a few tests only work if compiled as user...
		if [ ${UID} = 0 ]; then
			sed -e '/USERFIXTUREDIR/d' -i ${S}/engine/test/qlcfixturedefcache_test.cpp || die "testdir sed failed"
			sed -e '/saveXML/d' -i ${S}/engine/test/qlcinputprofile_test.cpp || die "safexml sed failed"
			sed -e '/* prof = QLCInputProfile::loader(path)/{N;N;N;N;N;N;N;N;N;N;N;d}' -i ${S}/engine/test/qlcinputprofile_test.cpp || die "profile-sed failed"
			sed -e '/readXML(path)/{N;d}' -i ${S}/engine/test/qlcfile_test.cpp  || die "filetest sed failed"			
			sed -e '/InputMap::userProfileDirectory/{N;d}' -i ${S}/engine/test/inputmap_test.cpp || "stripping userprofiletest failed"
			sed -e '/contains(USERINPUTPROFILEDIR)/d' -i ${S}/engine/test/inputmap_test.cpp || die "stripping userprofiletest failed"
		fi
		# these tests need an X server...
		#this is on SVN
		sed -e '/cd plugins\/ewinginput\/test/{N;d}' -i ${S}/unittest.sh || die "disabling ewing-tests failed"
		#this is only on current stable 3.2.0
		sed -e '/test_ewing/d' -i ${S}/unittest.sh || die "disabling ewing-tests failed"

		sed -e 's/for test in ${TESTS}/for test in/g' -i ${S}/unittest.sh || die "disabling ui-tests failed"
		 
		if ! emake -j1 check; then
			hasq test $FEATURES && die "Make check failed. See above for details."
			hasq test $FEATURES || eerror "Make check failed. See above for details."
		fi
	else
		vecho ">>> Test phase [none]: ${CATEGORY}/${PF}"
	fi
}

src_install() {
	cd ${S}
	#these are only necessary in 3.2.0
	sed -e 's/\ \/usr\/share\/qlc/\ $(INSTALL_ROOT)\/usr\/share\/qlc/g' -i fixtureeditor/Makefile || die "sed failed"
	sed -e 's/\ \/usr\/share\/qlc/\ $(INSTALL_ROOT)\/usr\/share\/qlc/g' -i plugins/hidinput/Makefile || die "sed failed"
	sed -e 's/\ \/usr\/share\/qlc/\ $(INSTALL_ROOT)\/usr\/share\/qlc/g' -i plugins/dmx4linuxout/Makefile || die "sed failed"
	sed -e 's/\ \/usr\/share\/qlc/\ $(INSTALL_ROOT)\/usr\/share\/qlc/g' -i ui/src/Makefile || die "sed failed"
	sed -e 's/\ \/usr\/share\/qlc/\ $(INSTALL_ROOT)\/usr\/share\/qlc/g' -i plugins/peperoniout/unix//Makefile || die "sed failed"
	sed -e 's/\ \/usr\/share\/qlc/\ $(INSTALL_ROOT)\/usr\/share\/qlc/g' -i plugins/vellemanout/src/Makefile || die "sed failed"
	sed -e 's/\ \/usr\/share\/qlc/\ $(INSTALL_ROOT)\/usr\/share\/qlc/g' -i plugins/enttecdmxusbout/src/Makefile || die "sed failed"
	sed -e 's/\ \/usr\/share\/qlc/\ $(INSTALL_ROOT)\/usr\/share\/qlc/g' -i plugins/udmxout/src/Makefile || die "sed failed"
	sed -e 's/\ \/usr\/share\/qlc/\ $(INSTALL_ROOT)\/usr\/share\/qlc/g' -i plugins/midiinput/alsa/Makefile || die "sed failed"
	sed -e 's/\ \/usr\/share\/qlc/\ $(INSTALL_ROOT)\/usr\/share\/qlc/g' -i plugins/ewinginput/src/Makefile || die "sed failed"
	sed -e 's/\ \/usr\/share\/qlc/\ $(INSTALL_ROOT)\/usr\/share\/qlc/g' -i plugins/midiout/alsa/Makefile || die "sed failed"

	emake INSTALL_ROOT="${D}" install || die "intallation phase failed"
}
