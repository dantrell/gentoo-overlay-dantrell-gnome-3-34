# Distributed under the terms of the GNU General Public License v2

EAPI="7"
VALA_MAX_API_VERSION="0.48"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Move tiles so that they reach their places"
HOMEPAGE="https://wiki.gnome.org/Apps/Taquin"

LICENSE="GPL-3+ CC-BY-SA-3.0 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=x11-libs/gtk+-3.22.23:3
	>=gnome-base/librsvg-2.32.0:2
	>=media-libs/libcanberra-0.26[gtk3]
"
# libxml2+gdk-pixbuf required for glib-compile-resources (xml-stripblanks and to-pixdata)
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	gnome-base/librsvg:2[vala]
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	x11-libs/gdk-pixbuf:2
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
