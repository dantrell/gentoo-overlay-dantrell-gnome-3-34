# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=( python{3_10,3_11,3_12,3_13} )
GNOME2_EAUTORECONF="yes"

inherit gnome2 python-any-r1 vala virtualx

DESCRIPTION="Libraries for cryptographic UIs and accessing PKCS#11 modules"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gcr"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0/1" # subslot = suffix of libgcr-3
KEYWORDS="*"

IUSE="debug gtk +introspection +vala"
REQUIRED_USE="vala? ( introspection )"

RESTRICT="!test? ( test )" # IUSE=test comes from virtualx.eclass

COMMON_DEPEND="
	>=app-crypt/p11-kit-0.19
	>=dev-libs/glib-2.38:2
	>=dev-libs/libgcrypt-1.2.2:0=
	>=dev-libs/libtasn1-1:=
	>=sys-apps/dbus-1
	gtk? ( >=x11-libs/gtk+-3.12:3[X,introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-1.34:= )
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	dev-libs/gobject-introspection-common
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-libs/vala-common
	dev-util/gdbus-codegen
	>=dev-build/gtk-doc-am-1.9
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"
# eautoreconf needs:
#	dev-libs/gobject-introspection-common
#	dev-libs/vala-common

PATCHES=(
	"${FILESDIR}"/${PN}-3.34.0-fix-desktop-files.patch
)

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	# Disable stupid flag changes
	sed -e 's/CFLAGS="$CFLAGS -g"//' \
		-e 's/CFLAGS="$CFLAGS -O0"//' \
		-i configure.ac configure || die

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_with gtk) \
		$(use_enable introspection) \
		$(use_enable vala) \
		$(usex debug --enable-debug=yes --enable-debug=default) \
		--disable-update-icon-cache \
		--disable-update-mime
}

src_test() {
	virtx emake check
}
