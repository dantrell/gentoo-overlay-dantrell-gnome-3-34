# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python{3_10,3_11,3_12,3_13} )
PYTHON_REQ_USE="xml(+)"

inherit gnome.org meson python-single-r1 toolchain-funcs xdg

DESCRIPTION="Introspection system for GObject-based libraries"
HOMEPAGE="https://wiki.gnome.org/Projects/GObjectIntrospection"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="doctool gtk-doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

# virtual/pkgconfig needed at runtime, bug #505408
RDEPEND="
	>=dev-libs/gobject-introspection-common-${PV}
	>=dev-libs/glib-2.58.0:2
	dev-libs/libffi:=
	doctool? (
		$(python_gen_cond_dep '
			dev-python/mako[${PYTHON_USEDEP}]
			dev-python/markdown[${PYTHON_USEDEP}]
		')
	)
	virtual/pkgconfig
	${PYTHON_DEPS}
"
# Wants real bison, not app-alternatives/yacc
DEPEND="${RDEPEND}
	gtk-doc? ( >=dev-util/gtk-doc-1.19
		app-text/docbook-xml-dtd:4.3
		app-text/docbook-xml-dtd:4.5
	)
	sys-devel/bison
	sys-devel/flex
	test? ( x11-libs/cairo[glib] )
"

PATCHES=(
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gobject-introspection/-/commit/1f9284228092b2a7200e8a78bc0ea6702231c6db
	"${FILESDIR}"/${PN}-1.63.2-drop-deprecated-xml-etree-elementtree-element-getchildren-calls.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use test cairo)
		$(meson_use doctool)
		$(meson_use gtk-doc gtk_doc)
		-Dpython="${PYTHON}"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/bin/
	python_optimize "${ED}"/usr/$(get_libdir)/gobject-introspection/giscanner

	# Prevent collision with gobject-introspection-common
	rm -v "${ED}"/usr/share/aclocal/introspection.m4 \
		"${ED}"/usr/share/gobject-introspection-1.0/Makefile.introspection || die
	rmdir "${ED}"/usr/share/aclocal || die
}
