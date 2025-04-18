# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit gnome2 meson

DESCRIPTION="The Eye of GNOME image viewer"
HOMEPAGE="https://wiki.gnome.org/Apps/EyeOfGnome https://gitlab.gnome.org/GNOME/eog"

LICENSE="GPL-2+"
SLOT="1"
KEYWORDS="*"

IUSE="+exif +introspection +jpeg lcms +svg tiff xmp"
REQUIRED_USE="exif? ( jpeg )"

RDEPEND="
	>=dev-libs/glib-2.42.0:2[dbus]
	>=dev-libs/libpeas-0.7.4:=[gtk]
	>=gnome-base/gnome-desktop-2.91.2:3=
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=x11-libs/gtk+-3.22.0:3[introspection,X]
	>=x11-misc/shared-mime-info-0.20

	>=x11-libs/gdk-pixbuf-2.36.5:2[jpeg?,tiff?]
	x11-libs/libX11

	exif? ( >=media-libs/libexif-0.6.14 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	jpeg? ( media-libs/libjpeg-turbo:0= )
	lcms? ( media-libs/lcms:2 )
	svg? ( >=gnome-base/librsvg-2.44.0:2 )
	xmp? ( media-libs/exempi:2= )
"
# libxml2 required for glib-compile-resources
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	>=dev-build/gtk-doc-am-1.16
	dev-util/itstool
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dintrospection=$(usex introspection true false)
		-Dinstalled_tests=false
		-Dlibrsvg=$(usex svg true false)
		-Dlibjpeg=$(usex jpeg true false)
		-Dlibexif=$(usex exif true false)
		-Dcms=$(usex lcms true false)
		-Dxmp=$(usex xmp true false)
	)
	meson_src_configure
}
