require 'formula'

class Libsylph < Formula
  homepage 'http://libsylph.sourceforge.net'
  url 'https://github.com/SeySayux/libsylph.git'
  head 'https://github.com/SeySayux/libsylph.git'
  version '0.2'

  depends_on 'cmake' => :build
  depends_on 'icu4c'
  depends_on 'bdw-gc'
  depends_on 'gettext'

  def install
    system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    system "make test"
  end
end
