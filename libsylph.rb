require 'formula'

class Libsylph < Formula
  homepage 'http://libsylph.sourceforge.net'
  head 'https://github.com/SeySayux/libsylph.git'
  version '0.2'

  depends_on 'cmake' => :build
  depends_on 'gcc47' => :build
  depends_on 'icu4c'
  depends_on 'bdw-gc'
  depends_on 'gettext'

  fails_with :clang do
    cause <<-EOS.undent
      There are still a few issues with compiling LibSylph using clang, 
      therefore we disabled it for your safety.%

      Please build this formula with gcc (--use-gcc)
      EOS
  end

  def install
    system "cmake", "-DCMAKE_CXX_COMPILER=/usr/local/bin/g++-4.7", 
        "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    system "make test"
  end
end
